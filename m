Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D7BC636CC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Feb 2023 06:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBGGXP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Feb 2023 01:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBGGXN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2023 01:23:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E05510276
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 22:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675750939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+3Peyg9V5aMrEBqE8o9iVN99L97bYBB9HTgYW8stFQk=;
        b=Z0lJ5JSJQ53R1ku89QfWRcToFJp7y8FFjhlK1RzgugxQwyec5+qK0k572mAUJquuCfKF6Y
        QKcbykU7JM6G+JootbPfz7xYooeBrEcxMrdggyAngAg4uO5bMyCWKlY75MGVA8kauAxaGK
        aviDS39ew/94ShVHDTymFjrJPOR10uc=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-iXiRytfvM2Wc910HYAh5_g-1; Tue, 07 Feb 2023 01:22:19 -0500
X-MC-Unique: iXiRytfvM2Wc910HYAh5_g-1
Received: by mail-pf1-f197.google.com with SMTP id u18-20020a62ed12000000b00593cc641da4so7576456pfh.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2023 22:22:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3Peyg9V5aMrEBqE8o9iVN99L97bYBB9HTgYW8stFQk=;
        b=34s3vktWvPCLDQAkt/EiO581c7Da27rveF4JL51/Oh+lJRI1Lb0jT2CR3QVUaZcWqs
         Mfa8gfHkDCAqSWMtEbdjqkj2Jx8DFvJA7qrcbuG9tjLiqylg4kYmg0aVL1+LR7V/iyAI
         3h7qympcpj4PkqbC6OrCc2HG3OVso1brko75JriBRiPX/f3p+wvXXPchQ68cJZMPFiwc
         IqxokMjbtfxXkiMlaqfONZmZjsWMIYJZJpZjDnNumKtnXKYCv5UVsS2cAmefk8AvCKAj
         ccreWlhejP22clF/JRHlr1tiunYPV7FOczEIHL5scXB+v0JOGjwdjIEqqGDx2JkU/SvT
         DDVg==
X-Gm-Message-State: AO0yUKVhXc7QOwSYX+pzZtLscH/vYZf0v7RqEyRD+nT7ETt5BP/vS36w
        B9LP1d1Tx9mxZfrdXaVLC2XSyELPNtEbAaCM1oNlVatJincEVIztppRJCeWl8HKv2ALyp5QJF3z
        5OC1AkKQ56qX+4mayMKEtp5W0SmzwvVPks6np8I1oYEdDUbQHOUjjoNqTcaQOIQM37jIaVbi78M
        i8Bw==
X-Received: by 2002:a17:90b:4a8e:b0:22b:f780:d346 with SMTP id lp14-20020a17090b4a8e00b0022bf780d346mr2765206pjb.1.1675750937485;
        Mon, 06 Feb 2023 22:22:17 -0800 (PST)
X-Google-Smtp-Source: AK7set/dIKt0FIe34TW17PLsLtUAqFdsqH1983hEbikPLzi8djGyNMqzNVuEEQgAdoDrHYppxBVNJw==
X-Received: by 2002:a17:90b:4a8e:b0:22b:f780:d346 with SMTP id lp14-20020a17090b4a8e00b0022bf780d346mr2765182pjb.1.1675750937000;
        Mon, 06 Feb 2023 22:22:17 -0800 (PST)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a1d4c00b0022c90b7e3efsm10434865pju.50.2023.02.06.22.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 22:22:16 -0800 (PST)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v3] xfs: allow setting full range of panic tags
Date:   Tue,  7 Feb 2023 17:22:09 +1100
Message-Id: <20230207062209.1806104-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs will not allow combining other panic masks with
XFS_PTAG_VERIFIER_ERROR.

 # sysctl fs.xfs.panic_mask=511
 sysctl: setting key "fs.xfs.panic_mask": Invalid argument
 fs.xfs.panic_mask = 511

Update to the maximum value that can be set to allow the full range of
masks. Do this using a mask of possible values to prevent this happening
again as suggested by Darrick.

Fixes: d519da41e2b7 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 Documentation/admin-guide/xfs.rst |  2 +-
 fs/xfs/xfs_error.h                | 12 +++++++++++-
 fs/xfs/xfs_globals.c              |  3 ++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 8de008c0c5ad..e2561416391c 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -296,7 +296,7 @@ The following sysctls are available for the XFS filesystem:
 		XFS_ERRLEVEL_LOW:       1
 		XFS_ERRLEVEL_HIGH:      5
 
-  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 256)
+  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 511)
 	Causes certain error conditions to call BUG(). Value is a bitmask;
 	OR together the tags which represent errors which should cause panics:
 
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index dbe6c37dc697..0b9c5ba8a598 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -75,7 +75,7 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
 
 /*
  * XFS panic tags -- allow a call to xfs_alert_tag() be turned into
- *			a panic by setting xfs_panic_mask in a sysctl.
+ *			a panic by setting fs.xfs.panic_mask in a sysctl.
  */
 #define		XFS_NO_PTAG			0u
 #define		XFS_PTAG_IFLUSH			(1u << 0)
@@ -88,6 +88,16 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
 #define		XFS_PTAG_FSBLOCK_ZERO		(1u << 7)
 #define		XFS_PTAG_VERIFIER_ERROR		(1u << 8)
 
+#define		XFS_PTAG_MASK	(XFS_PTAG_IFLUSH | \
+				 XFS_PTAG_LOGRES | \
+				 XFS_PTAG_AILDELETE | \
+				 XFS_PTAG_ERROR_REPORT | \
+				 XFS_PTAG_SHUTDOWN_CORRUPT | \
+				 XFS_PTAG_SHUTDOWN_IOERROR | \
+				 XFS_PTAG_SHUTDOWN_LOGERROR | \
+				 XFS_PTAG_FSBLOCK_ZERO | \
+				 XFS_PTAG_VERIFIER_ERROR)
+
 #define XFS_PTAG_STRINGS \
 	{ XFS_NO_PTAG,			"none" }, \
 	{ XFS_PTAG_IFLUSH,		"iflush" }, \
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 4d0a98f920ca..9edc1f2bc939 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
+#include "xfs_error.h"
 
 /*
  * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
@@ -15,7 +16,7 @@ xfs_param_t xfs_params = {
 			  /*	MIN		DFLT		MAX	*/
 	.sgid_inherit	= {	0,		0,		1	},
 	.symlink_mode	= {	0,		0,		1	},
-	.panic_mask	= {	0,		0,		256	},
+	.panic_mask	= {	0,		0,		XFS_PTAG_MASK},
 	.error_level	= {	0,		3,		11	},
 	.syncd_timer	= {	1*100,		30*100,		7200*100},
 	.stats_clear	= {	0,		0,		1	},
-- 
2.31.1

