Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34258 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751290AbdHVVMt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 17:12:49 -0400
Subject: [PATCH 1/3] libxfs: handle 0 blocksize or sectorsize in cvtnum
References: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2e0acf4a-a863-8304-65d3-5027368c69e2@sandeen.net>
Date: Tue, 22 Aug 2017 16:12:48 -0500
MIME-Version: 1.0
In-Reply-To: <2b5a5742-5343-671f-8b89-9d1dc9841c17@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Blocksize and sectorsize are unique in that they must
be provided, unlike every other suffix which can be
calculated from constants.

Nothing protects against unspecified block & sector size,
so catch it if it happens and return a parsing error.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxcmd/input.c b/libxcmd/input.c
index 7a69dc1..7b86225 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -330,8 +330,12 @@ cvtnum(
 	c = tolower(*sp);
 	switch (c) {
 	case 'b':
+		if (!blocksize)
+			return -1LL;
 		return i * blocksize;
 	case 's':
+		if (!sectorsize)
+			return -1LL;
 		return i * sectorsize;
 	case 'k':
 		return KILOBYTES(i);
