Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 23:06:23 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6O65dDW017893
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 23:05:52 -0700
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6O5vfnx029358
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 00:57:41 -0500
Received: from omx2.sgi.com ([198.149.32.25])
	by imr2.americas.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id k6O678Du42435685
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 23:07:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with SMTP id k6O8P6JQ023948
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 01:25:07 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA27287 for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 15:57:34 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k6O5vWgw2093802
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 15:57:33 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k6O5vVaq2094825
	for xfs@oss.sgi.com; Mon, 24 Jul 2006 15:57:31 +1000 (EST)
Date: Mon, 24 Jul 2006 15:57:30 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: bump up xlog_state_do_callback loop checking
Message-ID: <20060724155730.A2090627@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I started running the QA tests with an external log on a ramdisk &
now constantly see situations where xlog_state_so_callback reports:

    Filesystem "sda2": xlog_state_do_callback: looping 10
    Filesystem "sda2": xlog_state_do_callback: looping 20
    Filesystem "sda2": xlog_state_do_callback: looping 10
    Filesystem "sda2": xlog_state_do_callback: looping 10
    Filesystem "sda2": xlog_state_do_callback: looping 10
    Filesystem "sda2": xlog_state_do_callback: looping 20

on the system console.  Tim and I looked into this further, and remembered
long ago list discussion on the topic, after others reported this too (also
on ramdisks interestingly):
http://oss.sgi.com/archives/xfs/2005-02/msg00108.html
http://oss.sgi.com/archives/xfs/2005-02/msg00109.html

So, it seems Glen added this to try detect infinte loops on systems where
we do log callback processing in interrupt context (i.e. IRIX).  It seems
that with ramdisks its causing spurious warnings due to how quickly the
completion handlers will be run (immediate, sync) though.  We can quite
easily still keep the same infinite loop check but bump up the reporting
threshold to something that wont happen for ramdisks/raid caches ... and
report each several-thousand iterations instead of each tenth one.  It
does still seems worthwhile to keep the infinte loop detection though, so
at this stage I've left that in there.

Tim also insisted I optimise away the modulo operation that we do in the
callback processing loop, while I was fixing this other issue, and he's
pointed out an easy way to do that...

cheers.

-- 
Nathan


Index: xfs-linux/xfs_log.c
===================================================================
--- xfs-linux.orig/xfs_log.c	2006-07-20 12:06:56.455633750 +1000
+++ xfs-linux/xfs_log.c	2006-07-20 12:17:19.819492000 +1000
@@ -2243,9 +2243,13 @@ xlog_state_do_callback(
 
 			iclog = iclog->ic_next;
 		} while (first_iclog != iclog);
-		if (repeats && (repeats % 10) == 0) {
+
+		if (repeats > 5000) {
+			flushcnt += repeats;
+			repeats = 0;
 			xfs_fs_cmn_err(CE_WARN, log->l_mp,
-				"xlog_state_do_callback: looping %d", repeats);
+				"%s: possible infinite loop (%d iterations)",
+				__FUNCTION__, flushcnt);
 		}
 	} while (!ioerrors && loopdidcallbacks);
 
@@ -2277,6 +2281,7 @@ xlog_state_do_callback(
 	}
 #endif
 
+	flushcnt = 0;
 	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR)) {
 		flushcnt = log->l_flushcnt;
 		log->l_flushcnt = 0;
