Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753882AbeFOUuW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 16:50:22 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] libxfs: detect zoned disks and prevent their raw use
Date: Fri, 15 Jun 2018 13:50:11 -0700
Message-Id: <20180615205011.7728-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, snitzer@redhat.com, hare@suse.de, axboe@kernel.dk, mwilck@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Using raw zoned disks by filesystems requires special handling, only
f2fs currently supports this. All other filesystems do not support
dealing with zoned disks directly.

As such using raw zoned disks is not supported by XFS, to use them you
need to use dm-zoned-tools, format them with dzadm, set the scheduler to
deadline, and then setup a dmsetup with zoned type, and somehow set
this up on every boot to live a semi-happy life for now.

Even if you use dmsetup on every boot, the zoned disk is still exposed,
and a user may still think they have to run mkfs.xfs on it instead
of the /dev/mapper/ disk, and then mount it by mistake.

In either case you may seem to believe your disk works and only eventually
end up with alignmet issues and perhaps lose you data. For instance:

[10869.959501] device-mapper: zoned reclaim: (sda): Align zone 865 wp 28349 to 30842 (wp+2493) blocks failed -5
[10870.014488] sd 0:0:0:0: [sda] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[10870.016137] sd 0:0:0:0: [sda] tag#0 Sense Key : Illegal Request [current]
[10870.017696] sd 0:0:0:0: [sda] tag#0 Add. Sense: Unaligned write command

We have to prevent these mistakes by avoiding mkfs.xfs use on zoned disks.

Note that this not enough yet, if users are on old AHCI controllers,
the disks may not be detected as zoned. More work through udev may be
required to detect this situation old old parent PCI IDs for zoned
disks, and then prevent their use somehow.

If you are stuck on using XFS there a udev rule out there [0], this is
far from perfect, and not fully what we want done upstream on Linux
distributions long term but it should at least help developers for now
enjoy their shiny big fat zoned disks with XFS.

This check should help avoid having folks shoot themselves in the foot
for now with zoned disks. If you make the mistake to use mkfs.xfs
on a zoned disk, you will now get:

 # mkfs.xfs /dev/sda
/dev/sda: zoned disk detected, refer to dm-zoned-tools for how to use with XFS

[0] https://lkml.kernel.org/r/20180614001147.1545-1-mcgrof@kernel.org

Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 libxfs/init.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/libxfs/init.c b/libxfs/init.c
index a65c86c3..cca33ec7 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -98,6 +98,32 @@ libxfs_device_to_fd(dev_t device)
 	/* NOTREACHED */
 }
 
+static int
+is_zoned_disk(char *path)
+{
+	char str[PATH_MAX];
+	char *devname = basename(path);
+	FILE *file;
+	int len;
+
+
+	len = snprintf(str, sizeof(str), "/sys/block/%s/queue/zoned", devname);
+
+	/* Indicates truncation */
+	if (len >= PATH_MAX) {
+		errno = ENAMETOOLONG;
+		return -1;
+	}
+
+	file = fopen(str, "r");
+	if (!file)
+		return 0;
+
+	fclose(file);
+
+	return 1;
+}
+
 /* libxfs_device_open:
  *     open a device and return its device number
  */
@@ -108,6 +134,7 @@ libxfs_device_open(char *path, int creat, int xflags, int setblksize)
 	int		fd, d, flags;
 	int		readonly, dio, excl;
 	struct stat	statb;
+	int ret;
 
 	readonly = (xflags & LIBXFS_ISREADONLY);
 	excl = (xflags & LIBXFS_EXCLUSIVELY) && !creat;
@@ -119,6 +146,20 @@ retry:
 		(dio ? O_DIRECT : 0) | \
 		(excl ? O_EXCL : 0);
 
+	ret = is_zoned_disk(path);
+	if (ret < 0) {
+		fprintf(stderr, _("%s: error opening %s\n"),
+			path, strerror(errno));
+		exit(1);
+	}
+
+	if (ret == 1) {
+		fprintf(stderr,
+_("%s: zoned disk detected, refer to dm-zoned-tools for how to use with XFS\n"),
+			path);
+		exit(1);
+	}
+
 	if ((fd = open(path, flags, 0666)) < 0) {
 		if (errno == EINVAL && --dio == 0)
 			goto retry;
-- 
2.17.1

