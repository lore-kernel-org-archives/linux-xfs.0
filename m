Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B0F997F50
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 09:37:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79BBD304039
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 07:37:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OPncuJaC2M63doD0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 07:37:48 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t3MEblof032687
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 10:37:48 -0400
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t3MEblQx004511
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 10:37:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: don't trigger fsync log force based on inode pin count
Date: Wed, 22 Apr 2015 10:37:46 -0400
Message-Id: <1429713466-22137-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

The fsync() requirements for crash consistency on XFS are to flush file
data and force any in-core inode updates to the log. We currently check
whether the inode is pinned to identify whether the log needs to be
forced, since a non-zero pin count generally represents an inode that
has transactions awaiting a flush to the on-disk log.

This is not sufficient in all cases, however. Reports of xfstests test
generic/311 failures on ppc64/s390x hosts have identified failures to
fsync outstanding inode modifications due to the inode not being pinned
at the time of the fsync. This occurs because certain bmap updates can
complete by logging bmapbt buffers but without ever dirtying (and thus
pinning) the core inode. The following is a specific incarnation of this
problem:

$ mount $dev /mnt -o noatime,nobarrier
$ for i in $(seq 0 2 31); do \
        xfs_io -f -c "falloc $((i * 32768)) 32k" -c fsync /mnt/file; \
	done
$ xfs_io -c "pwrite -S 0 80k 16k" -c fsync -c "pwrite 76k 4k" -c fsync /mnt/file; \
	hexdump /mnt/file; \
	./xfstests-dev/src/godown /mnt
...
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0013000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0014000 0000 0000 0000 0000 0000 0000 0000 0000
*
00f8000
$ umount /mnt; mount ...
$ hexdump /mnt/file
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00f8000

In short, the unwritten extent conversion for the last write is lost
despite the fact that an fsync executed before the filesystem was
shutdown. Note that this is significantly more difficult to reproduce on
CONFIG_HZ=1000 kernels because the problem is masked by the pre-write
cmtime updates committing a transaction against the inode. CONFIG_HZ=100
reduces timer granularity enough to increase the odds that time updates
are skipped and allows this to reproduce within a handful of attempts.

To deal with this problem, kill the xfs_ipincount() check in
xfs_file_fsync(). Make sure to check that the dynamically allocated
ip->i_itemp object exists as previously implied by a non-zero pincount.
The ili_last_lsn check is still safe because it is updated whenever the
inode is attached to a transaction, regardless of whether the inode is
ultimately dirtied. In conjunction, the xfs_bmapi_*() code
unconditionally expects the inode locked and joined to the transaction
on entry.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This is the most obvious fix for the problem described above. The
tradeoff is performance in the case when a log force is not necessary
because the log force unconditionally flushes on the workqueue before it
determines a force is not necessary. I can demonstrate this with a test
case to run 'xfs_io -f -c fsync <file>' in a 10k iteration loop with and
without a moderate fs_mark load running in the background.  The
following values are the time to complete for such an fsync loop:

		4.0.0-rc1+	4.0.0-rc1+ w/patch
loop		~39s		~39s
loop+fs_mark	~41s		~1m56s

There are probably a couple different ways to handle this. We could log
the inode in the bmap cases in order to preserve the pincount check.
Another option is to add a check down in xlog_cil_push_now() to avoid
the wq task wait when the push sequence has already been pushed beyond
push_seq. I'm testing something like the latter at the moment...
thoughts?

Brian

 fs/xfs/xfs_file.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3a5d305..2fe5421 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -233,15 +233,20 @@ xfs_file_fsync(
 	}
 
 	/*
-	 * All metadata updates are logged, which means that we just have
-	 * to flush the log up to the latest LSN that touched the inode.
+	 * All we need to do here is force pending inode updates into the log.
+	 * All metadata updates are logged, which means that we just have to
+	 * flush the log up to the latest LSN that touched the inode.
+	 *
+	 * Note that we cannot trigger the log force based on whether the inode
+	 * is pinned because some bmapbt updates can log bmap buffers without
+	 * having to dirty the core inode. The inode is never pinned in this
+	 * case, but ili_last_lsn is updated since the inode is always joined to
+	 * the transaction...
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip)) {
-		if (!datasync ||
-		    (ip->i_itemp->ili_fields & ~XFS_ILOG_TIMESTAMP))
-			lsn = ip->i_itemp->ili_last_lsn;
-	}
+	if (ip->i_itemp &&
+	    (!datasync || (ip->i_itemp->ili_fields & ~XFS_ILOG_TIMESTAMP)))
+		lsn = ip->i_itemp->ili_last_lsn;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (lsn)
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
