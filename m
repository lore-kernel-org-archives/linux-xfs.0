Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Nov 2007 01:35:08 -0800 (PST)
Received: from astoria.ccjclearline.com (astoria.ccjclearline.com [64.235.106.9])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAK9Z3GI006436
	for <xfs@oss.sgi.com>; Tue, 20 Nov 2007 01:35:04 -0800
Received: from [99.236.101.138] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1IuPVd-0007k0-KZ
	for xfs@oss.sgi.com; Tue, 20 Nov 2007 04:35:10 -0500
Date: Tue, 20 Nov 2007 04:33:17 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] XFS:  Replace deprecated "TOPDIR" with newer "src"
Message-ID: <alpine.LFD.0.9999.0711200431590.21514@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  given that TOPDIR is explicitly deprecated in favour of src, this
would seem to be an obvious change.


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 49e3e7e..e1b08b7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -1 +1 @@
-include $(TOPDIR)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)
+include $(src)/fs/xfs/Makefile-linux-$(VERSION).$(PATCHLEVEL)

rday
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
