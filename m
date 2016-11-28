Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:36823 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755788AbcK1WoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 17:44:00 -0500
Received: by mail-pg0-f53.google.com with SMTP id f188so61296677pgc.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:43:59 -0800 (PST)
From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] xfs_io.8: remove duplicate .TP commands
Date: Mon, 28 Nov 2016 14:43:16 -0800
Message-Id: <1480372996-41456-1-git-send-email-ebiggers@google.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Eric Biggers <ebiggers@google.com>

The right margin of the xfs_io man page was being pushed inwards due to
extra .TP commands, making all the text below hard to read.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 man/man8/xfs_io.8 | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 885df7f..efdba13 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -486,7 +486,6 @@ to read (in bytes)
 .RE
 .PD
 .TP
-.TP
 .BI "seek  \-a | \-d | \-h [ \-r ] [ \-s ] offset"
 On platforms that support the
 .BR lseek (2)
@@ -527,7 +526,6 @@ both data and holes are displayed together or performing a recusively display.
 .RE
 .PD
 .TP
-.TP
 .BI "reflink  [ \-C ] [ \-q ] src_file [src_offset dst_offset length]"
 On filesystems that support the
 .B XFS_IOC_CLONE_RANGE
@@ -557,7 +555,6 @@ Do not print timing statistics at all.
 .RE
 .PD
 .TP
-.TP
 .BI "dedupe  [ \-C ] [ \-q ] src_file src_offset dst_offset length"
 On filesystems that support the
 .B XFS_IOC_FILE_EXTENT_SAME
@@ -586,7 +583,6 @@ Do not print timing statistics at all.
 .RE
 .PD
 .TP
-.TP
 .BI "copy_range [ -s " src_offset " ] [ -d " dst_offset " ] [ -l " length " ] src_file"
 On filesystems that support the
 .BR copy_file_range (2)
-- 
2.8.0.rc3.226.g39d4020

