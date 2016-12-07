Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752635AbcLGNfG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:35:06 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A378E7AEA2
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:28:01 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 20/22] mkfs: move uuid empty string test to getstr()
Date: Wed,  7 Dec 2016 14:27:27 +0100
Message-Id: <1481117249-21273-21-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
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
index 9e726f7..9c1ad11 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2560,11 +2560,10 @@ main(
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
2.8.1

