Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbeJYGuC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Oct 2018 02:50:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0FF81C0293BE
        for <linux-xfs@vger.kernel.org>; Wed, 24 Oct 2018 22:20:10 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA3E410018F9
        for <linux-xfs@vger.kernel.org>; Wed, 24 Oct 2018 22:20:09 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: print freecount in xfs_inobt_rec as unsigned
Message-ID: <3fb12611-2ce0-7e8d-0c65-dcbddf5e55b7@redhat.com>
Date: Wed, 24 Oct 2018 17:20:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

"freecount" in the xfs_inobt_rec is unsigned, so xfs_db should
print it as such.

Not doing so tickles a bug in getbitval() where we try to handle
sign extension for signed fields and fail badly on big endian
machines, causing us to incorrectly report negative numbers when
printing structures even when the number is nowhere near the
signed maximum value.

So this fix works around that bug by properly marking this field
as unsigned, because I have yet to convince myself of the proper
fix for the underlying bug.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201453
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/btblock.c b/db/btblock.c
index cbd2990..5a5b061 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -513,7 +513,7 @@ const field_t	inobt_sprec_flds[] = {
 	{ "holemask", FLDT_UINT16X, OI(ROFF(ir_u.sp.ir_holemask)), C1, 0,
 	  TYP_NONE },
 	{ "count", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_count)), C1, 0, TYP_NONE },
-	{ "freecount", FLDT_INT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
+	{ "freecount", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
 	  TYP_NONE },
 	{ "free", FLDT_INOFREE, OI(ROFF(ir_free)), C1, 0, TYP_NONE },
 	{ NULL }
