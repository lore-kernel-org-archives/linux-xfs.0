Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38500 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752197AbeC0WdM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 18:33:12 -0400
Subject: [PATCH 3/3 V2] libfrog: handle NULL dir && blkdev in
 __fs_table_lookup_mount
References: <f7ab3da2-618c-dc1c-6d95-3890cdac2b43@redhat.com>
 <391d9faf-093f-24b7-9261-95feab18df51@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5b4e43a4-5090-0970-ef2c-20ad0df7a565@sandeen.net>
Date: Tue, 27 Mar 2018 17:33:11 -0500
MIME-Version: 1.0
In-Reply-To: <391d9faf-093f-24b7-9261-95feab18df51@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

If neither dir nor blkdev is set, dpath never gets set,
and then gets used (uninitalized) later on.

If we are asked where "nothing" is mounted, just return
"nowhere."

Fixes-coverity-id: 1433615
Fixes-coverity-id: 1433616
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: wrappers prevent (sic) both being set, gracefully
handle either of the sent-in paths being null.

diff --git a/libfrog/paths.c b/libfrog/paths.c
index 318b48f..c7895e9 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -98,6 +98,9 @@ __fs_table_lookup_mount(
 	char		rpath[PATH_MAX];
 	char		dpath[PATH_MAX];
 
+	if (!dir && !blkdev)
+		return NULL;
+
 	if (dir && !realpath(dir, dpath))
 		return NULL;
 	if (blkdev && !realpath(blkdev, dpath))

