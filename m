Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7325E7F78
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5258F8F8065
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:11 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id aOEn2sRBJOdCaWgy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:10 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] writeback: plug writeback at a high level
Date: Fri, 10 Oct 2014 16:23:41 +0200
Message-Id: <1412951028-4085-37-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

From: Dave Chinner <dchinner@redhat.com>

tl;dr: 3 lines of code, 86% better fsmark thoughput consuming 13%
less CPU and 43% lower runtime.

Doing writeback on lots of little files causes terrible IOPS storms
because of the per-mapping writeback plugging we do. This
essentially causes imeediate dispatch of IO for each mapping,
regardless of the context in which writeback is occurring.

IOWs, running a concurrent write-lots-of-small 4k files using fsmark
on XFS results in a huge number of IOPS being issued for data
writes.  Metadata writes are sorted and plugged at a high level by
XFS, so aggregate nicely into large IOs.

However, data writeback IOs are dispatched in individual 4k IOs -
even when the blocks of two consecutively written files are
adjacent - because the underlying block device is fast enough not to
congest on such IO. This behaviour is not SSD related - anything
with hardware caches is going to see the same benefits as the IO
rates are limited only by how fast adjacent IOs can be sent to the
hardware caches for aggregation.

Hence the speed of the physical device is irrelevant to this common
writeback workload (happens every time you untar a tarball!) -
performance is limited by the overhead of dispatching individual
IOs from a single writeback thread.

Test VM: 16p, 16GB RAM, 2xSSD in RAID0, 500TB sparse XFS filesystem,
metadata CRCs enabled.

Test:

$ ./fs_mark  -D  10000  -S0  -n  10000  -s  4096  -L  120  -d
/mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d
/mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d
/mnt/scratch/6  -d  /mnt/scratch/7

Result:
		wall	sys	create rate	Physical write IO
		time	CPU	(avg files/s)	 IOPS	Bandwidth
		-----	-----	-------------	------	---------
unpatched	5m54s	15m32s	32,500+/-2200	28,000	150MB/s
patched		3m19s	13m28s	52,900+/-1800	 1,500	280MB/s
improvement	-43.8%	-13.3%	  +62.7%	-94.6%	+86.6%

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 279292ba9403..d935fd3796ba 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -599,6 +599,9 @@ static long generic_writeback_inodes(struct wb_writeback_work *work)
 	unsigned long end_time = jiffies + HZ / 10;
 	long write_chunk;
 	long wrote = 0;  /* count both pages and inodes */
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
 
 	spin_lock(&wb->list_lock);
 	while (1) {
@@ -688,6 +691,8 @@ static long generic_writeback_inodes(struct wb_writeback_work *work)
 out:
 	spin_unlock(&wb->list_lock);
 
+	blk_finish_plug(&plug);
+
 	return wrote;
 }
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
