Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42129 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387479AbfCAOGi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 09:06:38 -0500
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH 2/2] statx.2: add project support update
Date: Fri,  1 Mar 2019 23:06:24 +0900
Message-Id: <1551449184-7942-3-git-send-email-wshilong1991@gmail.com>
In-Reply-To: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc: lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>, linux-man@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

Cc: linux-man@vger.kernel.org
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 man2/statx.2 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man2/statx.2 b/man2/statx.2
index 7265d8ace..6a9dede8b 100644
--- a/man2/statx.2
+++ b/man2/statx.2
@@ -82,6 +82,7 @@ struct statx {
        containing the filesystem where the file resides */
     __u32 stx_dev_major;   /* Major ID */
     __u32 stx_dev_minor;   /* Minor ID */
+    __u32 stx_projid;      /* Project ID of file */
 };
 .EE
 .in
@@ -261,6 +262,7 @@ STATX_SIZE	Want stx_size
 STATX_BLOCKS	Want stx_blocks
 STATX_BASIC_STATS	[All of the above]
 STATX_BTIME	Want stx_btime
+STATX_PROJID	Want stx_projid
 STATX_ALL	[All currently available fields]
 .TE
 .in
@@ -412,6 +414,9 @@ The device on which this file (inode) resides.
 .IR stx_rdev_major " and "  stx_rdev_minor
 The device that this file (inode) represents if the file is of block or
 character device type.
+.TP
+.I stx_projid
+The file's project ID.
 .PP
 For further information on the above fields, see
 .BR inode (7).
@@ -458,6 +463,9 @@ See
 .TP
 .B STATX_ATTR_ENCRYPTED
 A key is required for the file to be encrypted by the filesystem.
+.TP
+.B STATX_ATTR_PROJINHERIT
+Sub directories or files will inherit parent's project ID automatically.
 .SH RETURN VALUE
 On success, zero is returned.
 On error, \-1 is returned, and
-- 
2.19.1
