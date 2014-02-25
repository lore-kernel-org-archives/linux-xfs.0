Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 65AB97F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 23:27:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5BCB78F806F
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 21:27:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3ehHn1wDJsxD6CdV for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 21:27:37 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1P5RauD021493
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 00:27:37 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1P5RZmn011020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 00:27:36 -0500
Message-ID: <530C29C7.90001@redhat.com>
Date: Mon, 24 Feb 2014 23:27:35 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: clean up xfs_set_maxicount & use in growfs
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

xfs_set_maxicount() overflowed fairly easily for large filesystems
and large maxicount; we started out by multiplying dblocks by
the percentage, *then* dividing by 100, and never checked for
an overflow.  The calculations were also, IMHO, a little hard
to follow.

I rewrote it using mult_frac (so handy!) and rounddown, to
do a nice no-overflow, no-precision-loss multiplication by
(%/100), then round down to the inode allocation unit.
Then check to see if we've overflowed the u64, and set to
XFS_MAXINUMBER if so.

Also, growfs open-coded the setting of maxicount; call the
handy helper instead.

This slightly changes growfs behavior, because we weren't
rounding to the allocation multiple in that code.  I checked
that we get the same answers for non-growfs cases by running
100 mkfs.xfs's with imaxpct from 1 to 100, and it gives the
same inode count in all cases.

Thanks to dchinner for pointing out that this could use fixing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Ok Brian, have at it.  ;)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 02fb943..867e476 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -471,12 +471,7 @@ xfs_growfs_data_private(
 	/* New allocation groups fully initialized, so update mount struct */
 	if (nagimax)
 		mp->m_maxagi = nagimax;
-	if (mp->m_sb.sb_imax_pct) {
-		__uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
-		do_div(icount, 100);
-		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
-	} else
-		mp->m_maxicount = 0;
+	xfs_set_maxicount(mp);
 	xfs_set_low_space_thresholds(mp);
 
 	/* update secondary superblocks. */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 02df7b4..0ec2b19 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -419,24 +419,24 @@ xfs_update_alignment(xfs_mount_t *mp)
 }
 
 /*
- * Set the maximum inode count for this filesystem
+ * Set the maximum inode count for this filesystem based on sb_imax_pct
  */
-STATIC void
+void
 xfs_set_maxicount(xfs_mount_t *mp)
 {
 	xfs_sb_t	*sbp = &(mp->m_sb);
-	__uint64_t	icount;
+	__uint64_t	iblocks;
 
 	if (sbp->sb_imax_pct) {
 		/*
 		 * Make sure the maximum inode count is a multiple
 		 * of the units we allocate inodes in.
 		 */
-		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
-		do_div(icount, 100);
-		do_div(icount, mp->m_ialloc_blks);
-		mp->m_maxicount = (icount * mp->m_ialloc_blks)  <<
-				   sbp->sb_inopblog;
+		iblocks = mult_frac(sbp->sb_dblocks, sbp->sb_imax_pct, 100);
+		iblocks = rounddown(iblocks, mp->m_ialloc_blks);
+		mp->m_maxicount = iblocks << sbp->sb_inopblog;
+		if (mp->m_maxicount < iblocks)
+			mp->m_maxicount = XFS_MAXINUMBER;
 	} else {
 		mp->m_maxicount = 0;
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a466c5e..6288a56 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -388,6 +388,7 @@ extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
 extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
 extern int	xfs_readsb(xfs_mount_t *, int);
+void		xfs_set_maxicount(xfs_mount_t *mp);
 extern void	xfs_freesb(xfs_mount_t *);
 extern int	xfs_fs_writable(xfs_mount_t *);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
