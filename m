Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754138AbeFTCys (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 22:54:48 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C650AC04F4CD
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jun 2018 02:54:48 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97B762010CD0
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jun 2018 02:54:48 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: remove unused iolock arg from xfs_break_dax_layouts
Message-ID: <81e4bec1-e555-a351-444d-d7d69a2bf557@redhat.com>
Date: Tue, 19 Jun 2018 21:54:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

For The Tidiness.

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a3e7767..6b31f41 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -735,7 +735,6 @@
 static int
 xfs_break_dax_layouts(
 	struct inode		*inode,
-	uint			iolock,
 	bool			*did_unlock)
 {
 	struct page		*page;
@@ -766,7 +765,7 @@
 		retry = false;
 		switch (reason) {
 		case BREAK_UNMAP:
-			error = xfs_break_dax_layouts(inode, *iolock, &retry);
+			error = xfs_break_dax_layouts(inode, &retry);
 			if (error || retry)
 				break;
 			/* fall through */

