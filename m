Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45839 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfBSXXk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Feb 2019 18:23:40 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E24FF81DF9
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:23:39 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B5F59600C0
        for <linux-xfs@vger.kernel.org>; Tue, 19 Feb 2019 23:23:39 +0000 (UTC)
Subject: [PATCH 2/3] xfs_io: fix TOCTOU in openfile()
References: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <acf1deea-a637-571b-e501-c7cbcde95c38@redhat.com>
Date: Tue, 19 Feb 2019 17:23:38 -0600
MIME-Version: 1.0
In-Reply-To: <c4b7eff6-8395-3d01-eaaf-736e32e6e1dc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

openfile() stats a path to determine whether it is a pipe, and then
opens it with flags based on the type it saw during the stat.  It's
possible that the file at that path changes in between, and Coverity
points this out.

Instead, always open O_NONBLOCK, stat the fd we got, and turn the
flag back off via fcntl() if it's not a pipe.

Addresses-Coverity-ID: 1442788 ("Time of check time of use")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/open.c b/io/open.c
index f5fbd2c..856018b 100644
--- a/io/open.c
+++ b/io/open.c
@@ -62,6 +62,12 @@ openfile(
 	int		oflags;
 
 	oflags = flags & IO_READONLY ? O_RDONLY : O_RDWR;
+	/*
+	 * In case we've been passed a pipe to open, don't block waiting for a
+	 * reader or writer to appear. We want to either succeed or error out
+	 * immediately.  We'll clear O_NONBLOCK if it's not a pipe.
+	 */
+	oflags |= O_NONBLOCK;
 	if (flags & IO_APPEND)
 		oflags |= O_APPEND;
 	if (flags & IO_CREAT)
@@ -81,18 +87,6 @@ openfile(
 	if (flags & IO_NOFOLLOW)
 		oflags |= O_NOFOLLOW;
 
-	/*
-	 * if we've been passed a pipe to open, don't block waiting for a
-	 * reader or writer to appear. We want to either succeed or error out
-	 * immediately.
-	 */
-	if (stat(path, &st) < 0 && errno != ENOENT) {
-		perror("stat");
-		return -1;
-	}
-	if (S_ISFIFO(st.st_mode))
-		oflags |= O_NONBLOCK;
-
 	fd = open(path, oflags, mode);
 	if (fd < 0) {
 		if (errno == EISDIR &&
@@ -112,6 +106,22 @@ openfile(
 		}
 	}
 
+	if (fstat(fd, &st) < 0) {
+		perror("stat");
+		close(fd);
+		return -1;
+	}
+
+	/* We only want to keep nonblocking behavior for pipes */
+	if (!S_ISFIFO(st.st_mode)) {
+		oflags &= ~O_NONBLOCK;
+		if (fcntl(fd, F_SETFL, oflags) < 0) {
+			perror("fcntl");
+			close(fd);
+			return -1;
+		}
+	}
+
 	if (!geom || !platform_test_xfs_fd(fd))
 		return fd;
 
