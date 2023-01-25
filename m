Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4149CC27C76
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Jan 2023 05:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjAYFCi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 00:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYFCh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 00:02:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC0846156
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 21:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674622909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bk+kl20NQ+qOwz5FT8H4jLfWY22/JQFsQdu7k7N6mbY=;
        b=iRjq9z2vRfHY0l0UQwd593MjDMxesN9/UPmJAJkChb8gC6sElN+YQdM8IAL9D1Op6jXsHt
        uhjeMY5O1rNEltZL4nBH+JTYfnosICL3m0qOs226Ph9Ve8iLDB+PJB2MCJ67MO3QbUzUFS
        NLuxUaKzPiioU9IFTqhw5mUfIlVEAjY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-94-WgQMTwvrOpab9WCv1qNLgw-1; Wed, 25 Jan 2023 00:01:48 -0500
X-MC-Unique: WgQMTwvrOpab9WCv1qNLgw-1
Received: by mail-pg1-f197.google.com with SMTP id h69-20020a638348000000b004d08330e922so7799381pge.5
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 21:01:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bk+kl20NQ+qOwz5FT8H4jLfWY22/JQFsQdu7k7N6mbY=;
        b=p04mF7KKePKjexZjPkBTDUZgTlMkBB0Uw3Nyd++/mIx6ZJfmCZ7p9mvHriNYaqTuoA
         LdukRnU0sdJfYMIvLug35OoH20z6uMFySE2pZW//Ic8/OlvTOlXqPZSbwqCMhlzcb8W7
         Ket3HEbY2vsnqsmkOGyi8J65ZfODsmQ3plLvKs/9K8t/0MAGNzM+3ENxLdnNWNYMeKT/
         5em38jD89+9xD3CkkiEZvxTUiZcIn9RjtSmnYvcjLSm1/we1l7u49V0xFmOIkhF3ylMo
         Ccju8y2fCzUyXlcWkXGHrHJkSWAx8EtT6sBVC3dnXTx6akoVTpB9aYL0SQYhthLZvSgT
         2+Aw==
X-Gm-Message-State: AFqh2kryo6zPZmVII5R5ryRa1VDq3xVkhwq22D1blWYjbAzXvF9s5iiE
        g7uOfu4V/xhxyNOeSt9QUgbLEwGKkaVyk1WcnS+d0ZZ8U3mUxj5+6SonRbZ4NSpdalVNcUl52Ej
        9cUPpkr3ur7ZvBx5H5dMbzZVlIRVjWN+yn+FwXu6/ObO//6Ew9TpXz5Vunm9I0RpHG/SJdQtz
X-Received: by 2002:a17:903:1209:b0:189:6f76:9b61 with SMTP id l9-20020a170903120900b001896f769b61mr42370472plh.39.1674622906620;
        Tue, 24 Jan 2023 21:01:46 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuZoiU2sKt1ipGngfud/YNX11EvNhURNC0xwJQQdRdCcCRilrjXcJZJjKOR6JRvdhmKLbsw0g==
X-Received: by 2002:a17:903:1209:b0:189:6f76:9b61 with SMTP id l9-20020a170903120900b001896f769b61mr42370441plh.39.1674622906187;
        Tue, 24 Jan 2023 21:01:46 -0800 (PST)
Received: from snowcrash.redhat.com ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id bf2-20020a170902b90200b00196085e1bbdsm2563221plb.161.2023.01.24.21.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 21:01:45 -0800 (PST)
From:   Donald Douwsma <ddouwsma@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Donald Douwsma <ddouwsma@redhat.com>
Subject: [PATCH] xfs: allow setting full range of panic tags
Date:   Wed, 25 Jan 2023 16:01:38 +1100
Message-Id: <20230125050138.372749-1-ddouwsma@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs will not allow combining other panic values with XFS_PTAG_VERIFIER_ERROR.

 sysctl fs.xfs.panic_mask=511
 sysctl: setting key "fs.xfs.panic_mask": Invalid argument
 fs.xfs.panic_mask = 511

Update to the maximum value that can be set to allow the full range of masks.

Fixes: d519da41e2b78 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
---
 Documentation/admin-guide/xfs.rst | 2 +-
 fs/xfs/xfs_globals.c              | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
 
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 4d0a98f920ca..e0e9494a8251 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -15,7 +15,7 @@ xfs_param_t xfs_params = {
 			  /*	MIN		DFLT		MAX	*/
 	.sgid_inherit	= {	0,		0,		1	},
 	.symlink_mode	= {	0,		0,		1	},
-	.panic_mask	= {	0,		0,		256	},
+	.panic_mask	= {	0,		0,		511	},
 	.error_level	= {	0,		3,		11	},
 	.syncd_timer	= {	1*100,		30*100,		7200*100},
 	.stats_clear	= {	0,		0,		1	},
-- 
2.31.1

