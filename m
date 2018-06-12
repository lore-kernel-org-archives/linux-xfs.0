Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54610 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753645AbeFLTbt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 15:31:49 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 1/7] mkfs: document the config file option
Date: Tue, 12 Jun 2018 14:31:17 -0500
Message-Id: <1528831883-21879-2-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 man/man8/mkfs.xfs.8 | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4b8c78c..dcd95ad 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -4,6 +4,10 @@ mkfs.xfs \- construct an XFS filesystem
 .SH SYNOPSIS
 .B mkfs.xfs
 [
+.B \-c
+.I configuration
+] [
+[
 .B \-b
 .I block_size_options
 ] [
@@ -121,8 +125,40 @@ when parameters are quantified in those units.
 .PP
 Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
+.SH DEFAULT VALUES
+.BR mkfs.xfs (8)
+contains built-in default values for every option as described in the sections
+below.
+These built-in defaults may evolve over time as new capabilities are added.
+If the file
+.B /etc/xfs/mkfs/defaults
+exists, it will be parsed to override built-in defaults, and the defaults
+described in sections below may no longer apply.
+.PP
+The
+.B \-c
+option may also be used to specify an alternate configuration file
+as described in the OPTIONS section.
 .SH OPTIONS
 .TP
+.BI \-c " configuration"
+This option may be used to specify a configuration file other than
+.B /etc/xfs/mkfs/defaults
+to override selected built-in parameter defaults.
+If
+.B configuration
+is a full pathname or a relative pathname starting with
+.BR \'./\' " or " \'../\'
+then that explicit path to the configuration file will be used.
+Otherwise,
+.BR mkfs.xfs (8)
+will search for
+.B configuration
+first in the current working directory, and then in the
+.B /etc/xfs/mkfs/
+directory.
+See also the CONFIGURATION FILE FORMAT section below.
+.TP
 .BI \-b " block_size_options"
 This option specifies the fundamental block size of the filesystem.
 The valid
@@ -920,6 +956,55 @@ Do not attempt to discard blocks at mkfs time.
 .TP
 .B \-V
 Prints the version number and exits.
+.SH CONFIGURATION FILE FORMAT
+The optional default configuration file in
+.B /etc/xfs/mkfs/default
+as well as any alternate configuration file specified via the
+.B \-c
+option follow a simple ini-style format as shown below.
+Available options consist of a small subset of the parameters available
+via the
+.BR mkfs.xfs (8)
+command line.
+Currently all default parameters can only be either enabled or disabled,
+with a value of 1 to enable or 0 to disable.
+See below for a list of all supported configuration parameters and their
+current built-in default settings.
+.PP
+.BI [data]
+.br
+.BI noalign=0
+.PP
+.BI [inode]
+.br
+.BI align=1
+.br
+.BI projid32bit=1
+.br
+.BI sparse=0
+.PP
+.BI [log]
+.br
+.BI lazy-count=1
+.PP
+.BI [metadata]
+.br
+.BI crc=1
+.br
+.BI finobt=1
+.br
+.BI rmapbt=0
+.br
+.BI reflink=0
+.PP
+.BI [naming]
+.br
+.BI ftype=1
+.PP
+.BI [rtdev]
+.br
+.BI noalign=0
+.PP
 .SH SEE ALSO
 .BR xfs (5),
 .BR mkfs (8),
-- 
1.8.3.1

