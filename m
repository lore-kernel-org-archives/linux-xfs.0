Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Dec 2007 23:07:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBC76io0029881
	for <xfs@oss.sgi.com>; Tue, 11 Dec 2007 23:06:50 -0800
Message-ID: <475F88C3.709@sgi.com>
Date: Wed, 12 Dec 2007 18:07:47 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] prevent panic during log recovery due to bogus operation
 header length
Content-Type: multipart/mixed;
 boundary="------------070900080804020003090805"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------070900080804020003090805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

A problem was reported where a system panicked in log recovery due
to a corrupt log record.  The cause of the corruption is not known
but this change will at least prevent a crash for this specific
scenario.  Log recovery definitely needs some more work in this area.

Lachlan

--------------070900080804020003090805
Content-Type: text/x-patch;
 name="xfs_log_recover.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xfs_log_recover.diff"

--- fs/xfs/xfs_log_recover.c_1.332	2007-12-12 17:14:57.000000000 +1100
+++ fs/xfs/xfs_log_recover.c	2007-12-12 17:15:42.000000000 +1100
@@ -2912,7 +2912,12 @@ xlog_recover_process_data(
 				xlog_recover_new_tid(&rhash[hash], tid,
 					be64_to_cpu(rhead->h_lsn));
 		} else {
-			ASSERT(dp + be32_to_cpu(ohead->oh_len) <= lp);
+			if (dp + be32_to_cpu(ohead->oh_len) > lp) {
+				xlog_warn(
+			"XFS: xlog_recover_process_data: bad length");
+				ASSERT(0);
+				return (XFS_ERROR(EIO));
+			}
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
 			if (flags & XLOG_WAS_CONT_TRANS)
 				flags &= ~XLOG_CONTINUE_TRANS;

--------------070900080804020003090805--
