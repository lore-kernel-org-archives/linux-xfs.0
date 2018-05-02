Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35450 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750948AbeEBT4Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 May 2018 15:56:24 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0D2864C1518
        for <linux-xfs@vger.kernel.org>; Wed,  2 May 2018 14:55:09 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH] xfsprogs: be careful about what we stat in
 platform_check_mount
Message-ID: <92bcf603-5106-9fa0-1b48-0d13ff0608c8@sandeen.net>
Date: Wed, 2 May 2018 14:56:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

After we lost ustat(2) in commit 4e7a824, we ended up with a slightly
bonkers method to determine if our target block device was mounted:
it goes through every entry returned by getmntent and stats the dir
to see if its underlying device matches ours.

Unfortunately that dir might be a hung nfs server and sadness ensues.

So do some pre-checks; can we stat the mounted "device?"  If so is
it really a block device?  If not, skip it.

Fixes: 4e7a824 ("libxfs/linux.c: Replace use of ustat by stat")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 0bace3e..7350fa7 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -77,7 +77,21 @@ platform_check_mount(char *name, char *block, struct stat *s, int flags)
 		    progname, name);
 		return 1;
 	}
+	/*
+	 * This whole business is to work out if our block device is mounted
+	 * after we lost ustat(2), see:
+	 * 	4e7a824 libxfs/linux.c: Replace use of ustat by stat
+	 * We don't really want to stat every single mounted directory,
+	 * as that may include tmpfs, cgroups, procfs or - worst - hung nfs
+	 * servers.  So we check the "device" before going after the mountpoint.
+	 */
 	while ((mnt = getmntent(f)) != NULL) {
+		/* If the "fsname" is't a stat-able device, skip it */
+		if (stat(mnt->mnt_fsname, &mst) < 0)
+			continue;
+		if (!S_ISBLK(mst.st_mode))
+			continue;
+		/* Ok, this entry does seem to be a mounted block device */
 		if (stat(mnt->mnt_dir, &mst) < 0)
 			continue;
 		if (mst.st_dev != s->st_rdev)

