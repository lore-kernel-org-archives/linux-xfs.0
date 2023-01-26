Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65184C05027
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Jan 2023 05:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjAZFaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Jan 2023 00:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZFaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jan 2023 00:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD66D49973
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 21:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674710965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zeRhhjHIoh2C6rE9+EFkfB8fkRYuFLagzy5chfELj8g=;
        b=aygwNHxonboJPw76C7ka6YlzJOr4NXbzx1WMpn+03DRYNBmMvKGULpHF5sfbHhfsIGBb3r
        k2qs/LyVlM9kv3BEa6FVkLzJeU6jIxZnX7lrxEzR1n1UDbUSouNYmAthrrddp3fHglN4T4
        gazZL9rjdIoRXbl2Pps2CqD914cAsm8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-6bH-Wrj7N9OMEFKz79PvOg-1; Thu, 26 Jan 2023 00:29:24 -0500
X-MC-Unique: 6bH-Wrj7N9OMEFKz79PvOg-1
Received: by mail-pg1-f200.google.com with SMTP id r126-20020a632b84000000b004393806c06eso402644pgr.4
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 21:29:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zeRhhjHIoh2C6rE9+EFkfB8fkRYuFLagzy5chfELj8g=;
        b=tNreRGS8vBgQveRTdQFuAtzK3ifkUg1HARWuwL3C1aXjaQAvltjF6RJEmvll2xx9Pe
         CxTpYVAGOKpAi0OeaLmQ9Kjtsmgtstpy/vqTotAct+Obsk/YRw6rUMu38O0SMzzrPkJ/
         3B6g5Z3QiCgh3Q4p54p7qJgYddxtjCtBOvixt/9/WNIUWr29j8UHgFr7up4KEpz18DrY
         9PAsZE9FnUP3YzJfvQuKRzM5hgmTGOpmr8kYzccMqnqQYL/EaLABDyD9hMC4qCJ4f7KZ
         h7N4bS+OMNPAcqPOfWkJ4T+jzUSQBz28d8lV42gEhI0PUzlJBFmoNgvQW2w16A5wHYZR
         RitQ==
X-Gm-Message-State: AFqh2koRprrAtBQGEQl8sV5PcA2f4o38hPae5v/ZiVPNVqpU9PYhmfSz
        NlHyYXBHv7zDSg3K1rNudnAxJvNw1VTjp1lAwBM6PYok1MiJ/syn2UyCkpdyFILREJaWfh8mnyc
        6rmSoT3bWKnedqsVNLtO/W3yEzGekGXsu+uJ67B95e3OLKwGaOemxdkQhbJz/X0M2rGMY5nvN
X-Received: by 2002:a17:902:b60e:b0:192:8b0e:98e1 with SMTP id b14-20020a170902b60e00b001928b0e98e1mr30764225pls.54.1674710962284;
        Wed, 25 Jan 2023 21:29:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt1sBeU6vrAynQalIx5Lh1R9g7cMUECBRpRs1n7S4SbHTIuEsxpqxyU/fjtyoufMlrZshIKtA==
X-Received: by 2002:a17:902:b60e:b0:192:8b0e:98e1 with SMTP id b14-20020a170902b60e00b001928b0e98e1mr30764203pls.54.1674710961843;
        Wed, 25 Jan 2023 21:29:21 -0800 (PST)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id 5-20020a170902ee4500b00194b006b9aesm276981plo.242.2023.01.25.21.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 21:29:21 -0800 (PST)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH v2] xfs: allow setting full range of panic tags
Date:   Thu, 26 Jan 2023 16:29:10 +1100
Message-Id: <20230126052910.588098-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs will not allow combining other panic masks with
XFS_PTAG_VERIFIER_ERROR.

 sysctl fs.xfs.panic_mask=511
 sysctl: setting key "fs.xfs.panic_mask": Invalid argument
 fs.xfs.panic_mask = 511

Update to the maximum value that can be set to allow the full range of
masks.

Fixes: d519da41e2b7 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 Documentation/admin-guide/xfs.rst |  2 +-
 fs/xfs/xfs_error.h                | 13 ++++++++++++-
 fs/xfs/xfs_globals.c              |  3 ++-
 3 files changed, 15 insertions(+), 3 deletions(-)

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
index dbe6c37dc697..a015f7b370dc 100644
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
@@ -88,6 +88,17 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
 #define		XFS_PTAG_FSBLOCK_ZERO		(1u << 7)
 #define		XFS_PTAG_VERIFIER_ERROR		(1u << 8)
 
+#define		XFS_MAX_PTAG ( \
+			XFS_PTAG_IFLUSH | \
+			XFS_PTAG_LOGRES | \
+			XFS_PTAG_AILDELETE | \
+			XFS_PTAG_ERROR_REPORT | \
+			XFS_PTAG_SHUTDOWN_CORRUPT | \
+			XFS_PTAG_SHUTDOWN_IOERROR | \
+			XFS_PTAG_SHUTDOWN_LOGERROR | \
+			XFS_PTAG_FSBLOCK_ZERO | \
+			XFS_PTAG_VERIFIER_ERROR)
+
 #define XFS_PTAG_STRINGS \
 	{ XFS_NO_PTAG,			"none" }, \
 	{ XFS_PTAG_IFLUSH,		"iflush" }, \
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 4d0a98f920ca..ff129acce8e6 100644
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
+	.panic_mask	= {	0,		0,		XFS_MAX_PTAG},
 	.error_level	= {	0,		3,		11	},
 	.syncd_timer	= {	1*100,		30*100,		7200*100},
 	.stats_clear	= {	0,		0,		1	},
-- 
2.31.1

