Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55095 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753129AbeENRfW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 13:35:22 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2A0630C1E34
        for <linux-xfs@vger.kernel.org>; Mon, 14 May 2018 17:35:21 +0000 (UTC)
Subject: [PATCH V2 1/5] fs: copy BTRFS_IOC_[SG]ET_FSLABEL to vfs
References: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <4d21659d-5b21-81ff-e759-b1f1519f526c@redhat.com>
Date: Mon, 14 May 2018 12:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <5957a0ff-0fd7-c1f3-2d44-86b825c2eb3b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

This retains 256 chars as the maximum size through the interface, which
is the btrfs limit and AFAIK exceeds any other filesystem's maximum
label size.

This just copies the ioctl for now and leaves it in place for btrfs
for the time being.  A later patch will allow btrfs to use the new
common ioctl definition, but it may be sent after this is merged.

(Note, Reviewed-by's were originally given for the combined vfs+btrfs
patch, some license taken here.)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: David Sterba <dsterba@suse.com>
---
 Documentation/ioctl/ioctl-number.txt | 3 ++-
 include/uapi/linux/fs.h              | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 7f7413e597f3..27c1b7b78504 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -296,7 +296,8 @@ Code  Seq#(hex)	Include File		Comments
 0x90	00	drivers/cdrom/sbpcd.h
 0x92	00-0F	drivers/usb/mon/mon_bin.c
 0x93	60-7F	linux/auto_fs.h
-0x94	all	fs/btrfs/ioctl.h
+0x94	all	fs/btrfs/ioctl.h	Btrfs filesystem
+		and linux/fs.h		some lifted to vfs/generic
 0x97	00-7F	fs/ceph/ioctl.h		Ceph file system
 0x99	00-0F				537-Addinboard driver
 					<mailto:buk@buks.ipn.de>
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index d2a8313fabd7..9d132f8f2df8 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -242,6 +242,8 @@ struct fsxattr {
 #define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
 #define FIDEDUPERANGE	_IOWR(0x94, 54, struct file_dedupe_range)
 
+#define FSLABEL_MAX 256	/* Max chars for the interface; each fs may differ */
+
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
@@ -251,8 +253,10 @@ struct fsxattr {
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
 #define FS_IOC32_SETVERSION		_IOW('v', 2, int)
-#define FS_IOC_FSGETXATTR		_IOR ('X', 31, struct fsxattr)
-#define FS_IOC_FSSETXATTR		_IOW ('X', 32, struct fsxattr)
+#define FS_IOC_FSGETXATTR		_IOR('X', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR		_IOW('X', 32, struct fsxattr)
+#define FS_IOC_GETFSLABEL		_IOR(0x94, 49, char[FSLABEL_MAX])
+#define FS_IOC_SETFSLABEL		_IOW(0x94, 50, char[FSLABEL_MAX])
 
 /*
  * File system encryption support
-- 
2.17.0

