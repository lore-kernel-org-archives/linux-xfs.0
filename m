Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754076AbdCOQBB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:01:01 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 45E4688E60
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2017 16:01:01 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 20/22] mkfs: move uuid empty string test to getstr()
Date: Wed, 15 Mar 2017 17:00:15 +0100
Message-Id: <20170315160017.27805-21-jtulak@redhat.com>
In-Reply-To: <20170315160017.27805-1-jtulak@redhat.com>
References: <20170315160017.27805-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

No need for this separate check, when we can use getstr() for opts.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 914af9d3..865bd389 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2569,11 +2569,10 @@ main(
 						value, &opts[OPT_M], M_FINOBT);
 					break;
 				case M_UUID:
-					if (!value || *value == '\0')
-						reqval('m', subopts, M_UUID);
+					opts[OPT_M].subopt_params[M_UUID].value.s =
+						getstr(value, &opts[OPT_M], M_UUID);
 					if (platform_uuid_parse(value, &uuid))
 						illegal(optarg, "m uuid");
-					opts[OPT_M].subopt_params[M_UUID].value.s = value;
 					break;
 				case M_RMAPBT:
 					sb_feat.rmapbt = getnum(
-- 
2.11.0

