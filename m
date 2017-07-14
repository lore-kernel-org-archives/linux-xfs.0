Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753175AbdGNPwW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jul 2017 11:52:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68FC01765E7
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2017 15:52:21 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EE3460604
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2017 15:52:21 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: associate proper type with free inode btree root
Message-ID: <e6056fa4-40c5-26ab-60f0-8d09d42010ce@redhat.com>
Date: Fri, 14 Jul 2017 10:52:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

When navigating to the free inode btree root, the wrong type
is set:

xfs_db> agi 0
xfs_db> addr free_root
xfs_db> type
current type is "inobt"

Change this to type finobt / TYP_FINOBT

(There seems to be no actual difference, but if we have an explicit type
name for the free inode btree, we should use it as appropriate)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/agi.c b/db/agi.c
index 285a3c5..fb69210 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -57,7 +57,7 @@ const field_t	agi_flds[] = {
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
-	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_INOBT },
+	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_FINOBT },
 	{ "free_level", FLDT_UINT32D, OI(OFF(free_level)), C1, 0, TYP_NONE },
 	{ NULL }
 };

