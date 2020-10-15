Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B20DAC4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 03:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6782322241
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 03:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgJOD3h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 23:29:37 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59009 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726869AbgJOD3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 23:29:36 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 382B83AB3FF
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 14:29:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kStxF-000ecy-WE
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 14:29:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kStxF-006bfy-Oi
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 14:29:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] mkfs: document config files in mkfs.xfs(8)
Date:   Thu, 15 Oct 2020 14:29:25 +1100
Message-Id: <20201015032925.1574739-6-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015032925.1574739-1-david@fromorbit.com>
References: <20201015032925.1574739-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=WTW2C1-nxof8fN0EWrAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So people know it exists.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 man/man8/mkfs.xfs.8 | 113 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 106 insertions(+), 7 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 0a7858748457..f70d91d994fa 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -122,8 +122,46 @@ If the size of the block or sector is not specified, the default sizes
 Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
 .SH OPTIONS
+Options may be specified either on the command line or in a configuration file.
+Not all command line options can be specified in configuration files; only the
+command line options followed by a
+.B [section]
+label can be used in a configuration file.
+.PP
+Options that can be used in configuration files are grouped into related
+sections containing multiple options.
+Both the command line and configuration file formats use the same section and
+option grouping.
+Configuration file section names are described command line options in the list
+below.
+Option names and values are the same for both command line
+and configuration file specification.
+.PP
+Options specified are the combined set of command line parameters and
+configuration file parameters.
+Duplicated options will result in a respecification error, regardless of the
+location they were specified at.
+.TP
+.BI \-c " configuration_file_option"
+This option specifies the files that mkfs configuration will be obtained from.
+The valid
+.I configuration_file_option
+is:
+.RS 1.2i
 .TP
+.BI options= name
+The configuration options will be sourced from the file specified by the
+.I name
+option string.
+This option can be use either an absolute or relative path to the configuration
+file to be read.
+.RE
+.PP
+.PD 0
 .BI \-b " block_size_options"
+.TP
+.BI [block]
+.PD
 This option specifies the fundamental block size of the filesystem.
 The valid
 .I block_size_option
@@ -141,8 +179,12 @@ Although
 will accept any of these values and create a valid filesystem,
 XFS on Linux can only mount filesystems with pagesize or smaller blocks.
 .RE
-.TP
+.PP
+.PD 0
 .BI \-m " global_metadata_options"
+.TP
+.BI [metadata]
+.PD
 These options specify metadata format options that either apply to the entire
 filesystem or aren't easily characterised by a specific functionality group. The
 valid
@@ -243,8 +285,12 @@ reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
 .B \-m reflink=0
 option to mkfs.xfs to disable the reflink feature.
 .RE
-.TP
+.PP
+.PD 0
 .BI \-d " data_section_options"
+.TP
+.BI [data]
+.PD
 These options specify the location, size, and other parameters of the
 data section of the filesystem. The valid
 .I data_section_options
@@ -416,8 +462,12 @@ By default,
 .B mkfs.xfs
 will not write to the device if it suspects that there is a filesystem
 or partition table on the device already.
-.TP
+.PP
+.PD 0
 .BI \-i " inode_options"
+.TP
+.BI [inode]
+.PD
 This option specifies the inode size of the filesystem, and other
 inode allocation parameters.
 The XFS inode contains a fixed-size part and a variable-size part.
@@ -537,8 +587,12 @@ accommodate a chunk of 64 inodes. Without this feature enabled, inode
 allocations can fail with out of space errors under severe fragmented
 free space conditions.
 .RE
-.TP
+.PP
+.PD 0
 .BI \-l " log_section_options"
+.TP
+.BI [log]
+.PD
 These options specify the location, size, and other parameters of the
 log section of the filesystem. The valid
 .I log_section_options
@@ -651,8 +705,12 @@ is 1 (on) so you must specify
 if you want to disable this feature for older kernels which don't support
 it.
 .RE
-.TP
+.PP
+.PD 0
 .BI \-n " naming_options"
+.TP
+.BI [naming]
+.PD
 These options specify the version and size parameters for the naming
 (directory) area of the filesystem. The valid
 .I naming_options
@@ -858,8 +916,12 @@ to be constructed;
 the
 .B \-q
 flag suppresses this.
-.TP
+.PP
+.PD 0
 .BI \-r " realtime_section_options"
+.TP
+.BI [realtime]
+.PD
 These options specify the location, size, and other parameters of the
 real-time section of the filesystem. The valid
 .I realtime_section_options
@@ -893,8 +955,12 @@ or logical volume containing the section.
 This option disables stripe size detection, enforcing a realtime device with no
 stripe geometry.
 .RE
-.TP
+.PP
+.PD 0
 .BI \-s " sector_size_options"
+.TP
+.BI [sector]
+.PD
 This option specifies the fundamental sector size of the filesystem.
 The valid
 .I sector_size_option
@@ -933,6 +999,39 @@ Do not attempt to discard blocks at mkfs time.
 .TP
 .B \-V
 Prints the version number and exits.
+.SH Configuration File Format
+The configuration file uses a basic INI format to specify sections and options
+within a section.
+Section and option names are case sensitive.
+Section names must not contain whitespace.
+Options are name-value pairs, ended by the first whitespace in the line.
+Option names cannot contain whitespace.
+Full line comments can be added by starting a line with a # symbol.
+If values contain whitespace, then it must be quoted.
+.PP
+The following example configuration file sets the block size to 4096 bytes,
+turns on reverse mapping btrees and sets the inode size to 2048 bytes.
+.PP
+.PD 0
+# Example mkfs.xfs configuration file
+.HP
+.HP
+[block]
+.HP
+size=4k
+.HP
+.HP
+[metadata]
+.HP
+rmapbt=1
+.HP
+.HP
+[inode]
+.HP
+size=2048
+.HP
+.PD
+.PP
 .SH SEE ALSO
 .BR xfs (5),
 .BR mkfs (8),
-- 
2.28.0

