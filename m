Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 17:25:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6Q0OiDW012178
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 17:24:56 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA14970 for <xfs@oss.sgi.com>; Wed, 26 Jul 2006 10:24:10 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k6Q0O7gw2141410
	for <xfs@oss.sgi.com>; Wed, 26 Jul 2006 10:24:08 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k6Q0O6Yw2141785
	for xfs@oss.sgi.com; Wed, 26 Jul 2006 10:24:06 +1000 (EST)
Date: Wed, 26 Jul 2006 10:24:06 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: fix bulkstat error detection logic
Message-ID: <20060726102406.I2118045@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

An earlier patch to remove bulkstat verbosity in debug kernels
changed the xfs_itobp logic slightly, such that we no longer do
the first stage of buffer checking there.  Turns out this isn't
the right fix, we need to do that check still, and pass out the
error code to bulkstat still, otherwise we either trip up logic
in later debug code, or pass out success incorrectly.

This fixes that up, and is the last bulkstat change I have for
awhile. :)  Its error handling is correct once more, its a fair
bit quicker, and no more debug-kernel console spam - hooray!

cheers.

-- 
Nathan


Index: xfs-linux/xfs_inode.c
===================================================================
--- xfs-linux.orig/xfs_inode.c	2006-07-25 12:02:05.787585750 +1000
+++ xfs-linux/xfs_inode.c	2006-07-25 13:04:58.941286750 +1000
@@ -335,10 +335,9 @@ xfs_itobp(
 #if !defined(__KERNEL__)
 	ni = 0;
 #elif defined(DEBUG)
-	ni = (imap_flags & XFS_IMAP_BULKSTAT) ? 0 :
-		(BBTOB(imap.im_len) >> mp->m_sb.sb_inodelog);
+	ni = BBTOB(imap.im_len) >> mp->m_sb.sb_inodelog;
 #else	/* usual case */
-	ni = (imap_flags & XFS_IMAP_BULKSTAT) ? 0 : 1;
+	ni = 1;
 #endif
 
 	for (i = 0; i < ni; i++) {
@@ -349,11 +348,15 @@ xfs_itobp(
 					(i << mp->m_sb.sb_inodelog));
 		di_ok = INT_GET(dip->di_core.di_magic, ARCH_CONVERT) == XFS_DINODE_MAGIC &&
 			    XFS_DINODE_GOOD_VERSION(INT_GET(dip->di_core.di_version, ARCH_CONVERT));
-		if (unlikely(XFS_TEST_ERROR(!di_ok, mp, XFS_ERRTAG_ITOBP_INOTOBP,
-				 XFS_RANDOM_ITOBP_INOTOBP))) {
+		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
+						XFS_ERRTAG_ITOBP_INOTOBP,
+						XFS_RANDOM_ITOBP_INOTOBP))) {
+			if (imap_flags & XFS_IMAP_BULKSTAT) {
+				xfs_trans_brelse(tp, bp);
+				return XFS_ERROR(EINVAL);
+			}
 #ifdef DEBUG
-			if (!(imap_flags & XFS_IMAP_BULKSTAT))
-				cmn_err(CE_ALERT,
+			cmn_err(CE_ALERT,
 					"Device %s - bad inode magic/vsn "
 					"daddr %lld #%d (magic=%x)",
 				XFS_BUFTARG_NAME(mp->m_ddev_targp),
