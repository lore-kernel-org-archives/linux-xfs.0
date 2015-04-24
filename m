Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F32F97F50
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 09:15:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6F2C304053
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 07:15:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pDByi1yVozNxoJBQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Apr 2015 07:14:59 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id D02118EAF3
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 14:14:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t3OEEwFb026292
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 10:14:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3] xfs: always log the inode on unwritten extent conversion
Date: Fri, 24 Apr 2015 10:14:57 -0400
Message-Id: <1429884897-28015-1-git-send-email-bfoster@redhat.com>
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
shutdown. Note that this is impossible to reproduce on v5 supers due to
unconditional time callbacks for di_changecount and highly difficult to
reproduce on CONFIG_HZ=1000 kernels due to those same callbacks
frequently updating cmtime prior to the bmap update. CONFIG_HZ=100
reduces timer granularity enough to increase the odds that time updates
are skipped and allows this to reproduce within a handful of attempts.

To deal with this problem, unconditionally log the core in the unwritten
extent conversion path. Fix up logflags after the extent conversion to
keep the extent update code consistent with the other extent update
helpers. This fixup is not necessary for the other (hole, delay) extent
helpers because they execute in the block allocation codepath, which
already logs the inode for other reasons (e.g., for di_nblocks).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v3:
- Apply XFS_ILOG_CORE unconditionally rather than only in the unchanged
  case.
v2: http://oss.sgi.com/pipermail/xfs/2015-April/041486.html
- Log inode unconditionally on unwritten extent conversion and retain
  the fsync pincount check.
v1: http://oss.sgi.com/pipermail/xfs/2015-April/041468.html

 fs/xfs/libxfs/xfs_bmap.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aeffeaa..68e9e23 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4417,7 +4417,15 @@ xfs_bmapi_convert_unwritten(
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
 			&bma->cur, mval, bma->firstblock, bma->flist,
 			&tmp_logflags);
-	bma->logflags |= tmp_logflags;
+	/*
+	 * Log the inode core unconditionally in the unwritten extent conversion
+	 * path because the conversion might not have done so (e.g., if the
+	 * extent count hasn't changed). We need to make sure the inode is dirty
+	 * in the transaction for the sake of fsync(), even if nothing has
+	 * changed, because fsync() will not force the log for this transaction
+	 * unless it sees the inode pinned.
+	 */
+	bma->logflags |= tmp_logflags | XFS_ILOG_CORE;
 	if (error)
 		return error;
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
