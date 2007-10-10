Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 01:33:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9A8XElM027531
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 01:33:17 -0700
Message-ID: <470C8F5B.90705@sgi.com>
Date: Wed, 10 Oct 2007 18:37:47 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: review: use correct buffer flags when reading superblock
Content-Type: multipart/mixed;
 boundary="------------060306000708010602050606"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------060306000708010602050606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

When reading the superblock during log recovery we are not setting
the correct buffer flags.  Specifically we are not turning off flags
we do not need such as XBF_ASYNC that is causing the synchronous
xfs_iowait() to hang.  We should also turn off XBF_WRITE and remove
the buffer from the delay write queue just to be safe.

Lachlan

--------------060306000708010602050606
Content-Type: text/x-patch;
 name="xfs_getsb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_getsb.diff"

--- fs/xfs/xfs_log_recover.c_1.329	2007-10-10 15:59:18.000000000 +1000
+++ fs/xfs/xfs_log_recover.c	2007-10-10 16:03:08.000000000 +1000
@@ -3824,7 +3824,10 @@ xlog_do_recover(
 	 */
 	bp = xfs_getsb(log->l_mp, 0);
 	XFS_BUF_UNDONE(bp);
+	XFS_BUF_UNWRITE(bp);
+	XFS_BUF_UNDELAYWRITE(bp);
 	XFS_BUF_READ(bp);
+	XFS_BUF_UNASYNC(bp);
 	xfsbdstrat(log->l_mp, bp);
 	if ((error = xfs_iowait(bp))) {
 		xfs_ioerror_alert("xlog_do_recover",

--------------060306000708010602050606--
