Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 23:19:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA16JBgw002495
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 23:19:14 -0700
Message-ID: <47296FF7.8080607@sgi.com>
Date: Thu, 01 Nov 2007 17:19:35 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Turn off XBF_READ_AHEAD in io completion
Content-Type: multipart/mixed;
 boundary="------------070101030407090105070907"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------070101030407090105070907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Read-ahead of an inode cluster will set XBF_READ_AHEAD in the buffer.
If we don't remove the flag it will still be set when we flush the
buffer back to disk.  Not sure if leaving this flag set causes any
serious problems but it does trigger an assert.

--------------070101030407090105070907
Content-Type: text/x-patch;
 name="readahead.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="readahead.diff"

--- fs/xfs/linux-2.6/xfs_buf.c_1.247	2007-10-29 16:01:29.000000000 +1100
+++ fs/xfs/linux-2.6/xfs_buf.c	2007-10-29 14:00:53.000000000 +1100
@@ -1032,7 +1032,7 @@ xfs_buf_ioend(
 	xfs_buf_t		*bp,
 	int			schedule)
 {
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE);
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 	if (bp->b_error == 0)
 		bp->b_flags |= XBF_DONE;
 

--------------070101030407090105070907--
