Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPiFr227560 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:45 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEFE41AE628B
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:44 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id tRR1oRBywNVrAQQT for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:44 -0700 (PDT)
Message-Id: <20100422190909.463653098@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:54 -0700
From: Greg KH <gregkh@suse.de>
Subject: [023/197] xfs: quota limit statvfs available blocks
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, xfs@oss.sgi.com, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Christoph Hellwig <hch@infradead.org>

commit 9b00f30762fe9f914eb6e03057a616ed63a4e8ca upstream

A "df" run on an NFS client of an exported XFS file system reports
the wrong information for "available" blocks.  When a block quota is
enforced, the amount reported as free is limited by the quota, but
the amount reported available is not (and should be).

Reported-by: Guk-Bong, Kwon <gbkwon@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/quota/xfs_qm_bhv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/quota/xfs_qm_bhv.c
+++ b/fs/xfs/quota/xfs_qm_bhv.c
@@ -59,7 +59,7 @@ xfs_fill_statvfs_from_dquot(
 		be64_to_cpu(dp->d_blk_hardlimit);
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
-		statp->f_bfree =
+		statp->f_bfree = statp->f_bavail =
 			(statp->f_blocks > be64_to_cpu(dp->d_bcount)) ?
 			 (statp->f_blocks - be64_to_cpu(dp->d_bcount)) : 0;
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
