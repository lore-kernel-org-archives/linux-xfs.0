Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52136 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753155AbeEVV6V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 17:58:21 -0400
Subject: [PATCH V2] xfsprogs: be careful about what we stat in
 platform_check_mount
From: Eric Sandeen <sandeen@sandeen.net>
References: <92bcf603-5106-9fa0-1b48-0d13ff0608c8@sandeen.net>
Message-ID: <998e7209-d700-5006-a2a0-e4c37ef0c024@sandeen.net>
Date: Tue, 22 May 2018 16:58:20 -0500
MIME-Version: 1.0
In-Reply-To: <92bcf603-5106-9fa0-1b48-0d13ff0608c8@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>

After we lost ustat(2) in commit 4e7a824, we ended up with a slightly
bonkers method to determine if our target block device was mounted:
it goes through every entry returned by getmntent and stats the dir
to see if its underlying device matches ours.

Unfortunately that dir might be a hung nfs server and sadness ensues.

So just do a really simple sanity check before we try to stat the
mountpoint: does its device start with a / ?  If not, skip it.

Fixes: 4e7a824 ("libxfs/linux.c: Replace use of ustat by stat")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: just look for fully-qualified device paths vs expecting an actual
block device.

diff --git a/libxfs/linux.c b/libxfs/linux.c
index 0bace3e..5c8602e 100644
--- a/libxfs/linux.c
+++ b/libxfs/linux.c
@@ -77,7 +77,17 @@ platform_check_mount(char *name, char *block, struct stat *s, int flags)
  		    progname, name);
  		return 1;
  	}
+	/*
+	 * This whole business is to work out if our block device is mounted
+	 * after we lost ustat(2), see:
+	 * 	4e7a824 libxfs/linux.c: Replace use of ustat by stat
+	 * We don't really want to stat every single mounted directory,
+	 * as that may include tmpfs, cgroups, procfs or - worst - hung nfs
+	 * servers.  So first, a simple check: does the "dev" start with "/" ?
+	 */
  	while ((mnt = getmntent(f)) != NULL) {
+		if (mnt->mnt_fsname[0] != '/')
+			continue;
  		if (stat(mnt->mnt_dir, &mst) < 0)
  			continue;
  		if (mst.st_dev != s->st_rdev)

