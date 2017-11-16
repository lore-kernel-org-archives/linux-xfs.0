Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47759 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935346AbdKPTNz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2017 14:13:55 -0500
Message-Id: <20171116184359.036955204@linutronix.de>
Date: Thu, 16 Nov 2017 19:33:15 +0100
From: Thomas Gleixner <tglx@linutronix.de>
Subject: [patch V2 09/11] LICENSES: Add Linux syscall note exception
References: <20171116183306.103584007@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=LICENSES--Add-Linux-syscall-note-exception.patch
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kate@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

Copied from the Linux kernel COPYING file.

Add the required tags for reference and tooling.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 LICENSES/exceptions/Linux-syscall-note |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- /dev/null
+++ b/LICENSES/exceptions/Linux-syscall-note
@@ -0,0 +1,25 @@
+SPDX-Exception-Identifier: Linux-syscall-note
+SPDX-URL: https://spdx.org/licenses/Linux-syscall-note.html
+SPDX-Licenses: GPL-2.0, GPL-2.0+, GPL-1.0+, LGPL-2.0, LGPL-2.0+, LGPL-2.1, LGPL-2.1+
+Usage-Guide:
+  This exception is used together with one of the above SPDX-Licenses
+  to mark user space API (uapi) header files so they can be included
+  into non GPL compliant user space application code.
+  To use this exception add it with the keyword WITH to one of the
+  identifiers in the SPDX-Licenses tag:
+    SPDX-License-Identifier: <SPDX-License> WITH Linux-syscall-note
+License-Text:
+
+   NOTE! This copyright does *not* cover user programs that use kernel
+ services by normal system calls - this is merely considered normal use
+ of the kernel, and does *not* fall under the heading of "derived work".
+ Also note that the GPL below is copyrighted by the Free Software
+ Foundation, but the instance of code that it refers to (the Linux
+ kernel) is copyrighted by me and others who actually wrote it.
+
+ Also note that the only valid version of the GPL as far as the kernel
+ is concerned is _this_ particular version of the license (ie v2, not
+ v2.2 or v3.x or whatever), unless explicitly otherwise stated.
+
+			Linus Torvalds
+


