Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F833C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjBPVzI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbjBPVzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:55:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2505381C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:54:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6129FB829C4
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1B8C433D2;
        Thu, 16 Feb 2023 21:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676584385;
        bh=FVY71ycVl1HQg0aXR0FcDrJQ/i2iz6auVfd1LvnZmo8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=S+P+y+Qz7UQbtLMRAiyCE7VuV1WMUbFDPVhV6f5REpkEwaR4bqAJa2w2QGd73hlqA
         hX+oWouqBa939tQeFuo0ae1SIeBPNiSWzFmpU/l5R76pdBdrxetqVgqxFHgJsiHD1T
         wHHAwKMdT4l7mI9ZIOnMyGSqBFVzg/arSpJ5dpZzfDStsIKsXbfB6QHHXMaQsXJJPV
         hE+DDSHc+QZw+P5Q8kfXIUWepxrA7jJ3tg96Ghs4YYCG9InKEEkgb3BmIXdJK7dYDc
         L/qeLK8FtJbxIvSHBu5UpzynxQxuoI7lKxxyHcor6+Vm9sZZfxMywazLFa0sTX5g8g
         X7/qasC7+YdQg==
Subject: [PATCH 3/5] xfs_io: set fs_path when opening files on foreign
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     tytso@mit.edu, linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Date:   Thu, 16 Feb 2023 13:53:04 -0800
Message-ID: <167658438451.3590000.8820235517511814402.stgit@magnolia>
In-Reply-To: <167658436759.3590000.3700844510708970684.stgit@magnolia>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ted noticed that the following command:

$ xfs_io -c 'fsmap -d 0 0' /mnt
xfs_io: xfsctl(XFS_IOC_GETFSMAP) iflags=0x0 ["/mnt"]: Invalid argument

doesn't work on an ext4 filesystem.  The above command is supposed to
issue a GETFSMAP query against the "data" device.  Although the manpage
doesn't claim support for ext4, it turns out that this you get this
trace data:

          xfs_io-4144  [002]   210.965642: ext4_getfsmap_low_key: dev
7:0 keydev 163:2567 block 0 len 0 owner 0 flags 0x0
          xfs_io-4144  [002]   210.965645: ext4_getfsmap_high_key: dev
7:0 keydev 32:5277:0 block 0 len 0 owner -1 flags 0xffffffff

Notice the random garbage in the keydev field -- this happens because
openfile (in xfs_io) doesn't initialize *fs_path if the caller doesn't
supply a geometry structure or the opened file isn't on an XFS
filesystem.  IOWs, we feed random heap garbage to the kernel, and the
kernel rejects the call unnecessarily.

Fix this to set the fspath information even for foreign filesystems.

Reported-by: tytso@mit.edu
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/open.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/io/open.c b/io/open.c
index d8072664c16..15850b5557b 100644
--- a/io/open.c
+++ b/io/open.c
@@ -116,7 +116,7 @@ openfile(
 	}
 
 	if (!geom || !platform_test_xfs_fd(fd))
-		return fd;
+		goto set_fspath;
 
 	if (flags & IO_PATH) {
 		/* Can't call ioctl() on O_PATH fds */
@@ -150,6 +150,7 @@ openfile(
 		}
 	}
 
+set_fspath:
 	if (fs_path) {
 		fsp = fs_table_lookup(path, FS_MOUNT_POINT);
 		if (!fsp)

