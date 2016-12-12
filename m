Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from forward12h.cmail.yandex.net ([87.250.230.154]:50751 "EHLO
        forward12h.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932227AbcLLLBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 06:01:20 -0500
From: Ozgur Karatas <okaratas@member.fsf.org>
Subject: [PATCH 1/1] Fixed to codestyle
MIME-Version: 1.0
Message-Id: <987271481540010@web27o.yandex.ru>
Date: Mon, 12 Dec 2016 12:53:30 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>


Hello,

I have error to use uuid and I think the functions should be used when -i'm eye-catching- "(* uuid)".
I tested it.

Regards,

Signed-off-by: Ozgur Karatas <okaratas@member.fsf.org>
---
diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index b83f76b..cd8bc8e 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -33,7 +33,7 @@ typedef struct {
  * it just something that's needed for user-level file handles.
  */
 void
-uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
+uuid_getnodeuniq(uuid_t (*uuid), int fsid [2])
 {
 	xfs_uu_t *uup = (xfs_uu_t *)uuid;
 
@@ -51,8 +51,8 @@ uuid_is_nil(uuid_t *uuid)
 	if (uuid == NULL)
 		return 0;
 	/* implied check of version number here... */
-	for (i = 0; i < sizeof *uuid; i++)
-		if (*cp++) return 0;	/* not nil */
+	for (i = 0; i < sizeof (*uuid); i++) 
+	if (*cp++) return 0;	/* not nil */
 	return 1;	/* is nil */
 }

-- 
2.1.4
