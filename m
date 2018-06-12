Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54614 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754029AbeFLTbt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 15:31:49 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 3/7] mkfs: parameterize sysconfdir in mkfs.xfs.8
Date: Tue, 12 Jun 2018 14:31:19 -0500
Message-Id: <1528831883-21879-4-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 man/man8/mkfs.xfs.8.in | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index dcd95ad..8ea2fe9 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -131,7 +131,7 @@ contains built-in default values for every option as described in the sections
 below.
 These built-in defaults may evolve over time as new capabilities are added.
 If the file
-.B /etc/xfs/mkfs/defaults
+.B @sysconfdir@/xfs/mkfs/defaults
 exists, it will be parsed to override built-in defaults, and the defaults
 described in sections below may no longer apply.
 .PP
@@ -143,7 +143,7 @@ as described in the OPTIONS section.
 .TP
 .BI \-c " configuration"
 This option may be used to specify a configuration file other than
-.B /etc/xfs/mkfs/defaults
+.B @sysconfdir@/xfs/mkfs/defaults
 to override selected built-in parameter defaults.
 If
 .B configuration
@@ -155,7 +155,7 @@ Otherwise,
 will search for
 .B configuration
 first in the current working directory, and then in the
-.B /etc/xfs/mkfs/
+.B @sysconfdir@/xfs/mkfs/
 directory.
 See also the CONFIGURATION FILE FORMAT section below.
 .TP
@@ -958,7 +958,7 @@ Do not attempt to discard blocks at mkfs time.
 Prints the version number and exits.
 .SH CONFIGURATION FILE FORMAT
 The optional default configuration file in
-.B /etc/xfs/mkfs/default
+.B @sysconfdir@/xfs/mkfs/default
 as well as any alternate configuration file specified via the
 .B \-c
 option follow a simple ini-style format as shown below.
-- 
1.8.3.1

