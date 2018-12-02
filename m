Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63558 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbeLBUx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 15:53:56 -0500
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gTYkM-0002gB-AA
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 07:53:46 +1100
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1gTYkM-0001s9-8O
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 07:53:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] io: open pipes in non-blocking mode
Date: Mon,  3 Dec 2018 07:53:42 +1100
Message-Id: <20181202205343.7104-2-david@fromorbit.com>
In-Reply-To: <20181202205343.7104-1-david@fromorbit.com>
References: <20181202205343.7104-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So that O_RDONLY open commands (such as from copy_range) do not
block forever waiting on a non-existent writer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 io/open.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/io/open.c b/io/open.c
index 6ea3e9a2019f..b1d9a0fa317c 100644
--- a/io/open.c
+++ b/io/open.c
@@ -56,6 +56,7 @@ openfile(
 	struct fs_path	*fs_path)
 {
 	struct fs_path	*fsp;
+	struct stat	st;
 	int		fd;
 	int		oflags;
 
@@ -79,6 +80,18 @@ openfile(
 	if (flags & IO_NOFOLLOW)
 		oflags |= O_NOFOLLOW;
 
+	/*
+	 * if we've been passed a pipe to open, don't block waiting for a
+	 * reader or writer to appear. We want to either succeed or error out
+	 * immediately.
+	 */
+	if (stat(path, &st) < 0 && errno != ENOENT) {
+		perror("stat");
+		return -1;
+	}
+	if (S_ISFIFO(st.st_mode))
+		oflags |= O_NONBLOCK;
+
 	fd = open(path, oflags, mode);
 	if (fd < 0) {
 		if (errno == EISDIR &&
-- 
2.19.1
