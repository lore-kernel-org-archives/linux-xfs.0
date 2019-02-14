Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36915 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438161AbfBNKBL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 05:01:11 -0500
Received: by mail-pl1-f193.google.com with SMTP id b5so2911156plr.4
        for <linux-xfs@vger.kernel.org>; Thu, 14 Feb 2019 02:01:10 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] utimensat2: document AT_UTIME_BTIME
Date: Thu, 14 Feb 2019 02:00:15 -0800
Message-Id: <4717a88b238f1f03272598295942ebe8f24c2939.1550138203.git.osandov@fb.com>
In-Reply-To: <cover.1550136164.git.osandov@fb.com>
References: <cover.1550136164.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 man2/utimensat.2 | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/man2/utimensat.2 b/man2/utimensat.2
index d61b43e96..3b7c62181 100644
--- a/man2/utimensat.2
+++ b/man2/utimensat.2
@@ -211,7 +211,7 @@ is ignored.
 .PP
 The
 .I flags
-field is a bit mask that may be 0, or include the following constant,
+field is a bit mask that may be 0, or include the following constants,
 defined in
 .IR <fcntl.h> :
 .TP
@@ -220,6 +220,36 @@ If
 .I pathname
 specifies a symbolic link, then update the timestamps of the link,
 rather than the file to which it refers.
+.TP
+.B AT_UTIME_BTIME
+Also update the file's "creation time" (\fIbtime\fP). If
+.I times
+is not NULL, then its length must be at least 3, and
+.IR times [2]
+specifies the new creation time. The
+.I tv_nsec
+field may be
+.BR UTIME_NOW
+or
+.BR UTIME_OMIT ;
+this has the same meaning as for the first two timestamps.
+If
+.I times
+is NULL, then the creation time is set to the current time.
+.IP
+Not all filesystems store the file creation time; if a filesystem does not, an
+error is returned. At least the following filesystems store the creation time:
+.RS
+.IP * 3
+Btrfs
+.IP *
+ext4, if the filesystem was created with an inode size of at least 256
+.IP *
+F2FS, if the filesystem was created with the inode_crtime feature
+.IP *
+XFS, if the filesystem was created with the v5 format (i.e., with CRCs enabled)
+.HP
+Support for this flag was added in Linux 5.2.
 .SH RETURN VALUE
 On success,
 .BR utimensat ()
@@ -359,6 +389,12 @@ or, one of the prefix components of
 .I pathname
 is not a directory.
 .TP
+.B EOPNOTSUPP
+.I flags
+contains
+.BR AT_UTIME_BTIME
+but the filesystem does not store the file creation time.
+.TP
 .B EPERM
 The caller attempted to change one or both timestamps to a value
 other than the current time,
-- 
2.20.1
