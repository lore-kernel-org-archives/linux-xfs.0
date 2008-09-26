Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 20:17:31 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q3HT7r027611
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 20:17:29 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id BC35690887
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 20:18:58 -0700 (PDT)
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id NAA22758 for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 13:18:57 +1000
Date: Fri, 26 Sep 2008 13:23:35 +1000
Subject: [REVIEW] Show pointer address for mem dump with corruption error
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uh2jplxz3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

When XFS detects corruption, it prints a message and a small hex dump
of the offending code.

The first value in this hexdump currently is "0000000:" which is just
the offset into the pointer being passed to print_hex_dump().

The following patch changes this to display the address of the memory
dump:

--- a/fs/xfs/support/debug.c    2008-09-26 13:15:02.000000000 +1000
+++ b/fs/xfs/support/debug.c    2008-09-26 12:53:50.765134441 +1000
@@ -84,5 +84,5 @@ assfail(char *expr, char *file, int line
  void
  xfs_hex_dump(void *p, int length)
  {
-       print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p,  
length, 1);
+       print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_ADDRESS, 16, 1, p,  
length, 1);
  }
