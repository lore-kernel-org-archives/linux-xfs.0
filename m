Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C172CCA47E
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 07:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiF0Hd1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 03:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiF0HdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 03:33:25 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B535FDD;
        Mon, 27 Jun 2022 00:33:24 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r20so11735447wra.1;
        Mon, 27 Jun 2022 00:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q7+aaYxWvJpUUImyX0kEjqtoV/Ox5Gruzg85xMJV5V4=;
        b=Pn6917jxen0o/l0xLr9f+doO1T5Syz/mcSrATru2smz3xg/C/C+Mk+zpBIxzK9C3P9
         VKrmmq9q3dGATbrNRYDFvwQNPQAkoeCSSuLst1kKjZdnQEemVaWgT05fzHKabaKf9hYO
         S45oKbD/qMa+ffTQ4yetfkT39nXw4kxt/7juS7y9DoFivq3fZkkHXF/d2yfUKQ63z3jz
         Kw2nOdCdYRHhyz8fmtqP4caLV4Md3YnTzDV9BZV0EpiG2IsUjMnfWLQF+t4qrQRAbQuZ
         e+Pg0JalOyIaqLdEA2y/yHuEqJYcCkByW3Ktu08E2KZIZy/jsCkiltifi0z3JUdyeGMs
         6s2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q7+aaYxWvJpUUImyX0kEjqtoV/Ox5Gruzg85xMJV5V4=;
        b=j4hWVPxXrKA6SDufLvKDBVIlGfu12fg40PSWlNjLCVjxRktaJV89oA88tswPYplKR9
         l1C512fdw7PJqQkopT/K+flgQZnOrkXXwfqJfIToUjOuiOFJX0rsolKJT7E7aqtCIUIs
         k1Fp1HjYIzz/Hl0vYaeiGxMiFQzgbH/Af1fopl/mncJjfy8WSdvAp/3+1SruVTGg/mnT
         n1vIYJ1pWVa1mGu9Iv3aGENiydtWUuc3yib/NgzZ99Xl2W2z2uNFh2MSg+1J35eeYn7H
         H0nuobqojGhc8hB6qISBK6JEpQbUx4UxtkFRg3gLo1twJPBbqdShrAlcdmCoKch+bpQ3
         e2OA==
X-Gm-Message-State: AJIora821DCrANSAKAD7fF9PS417nF3xP9IuBd9tPGUDf2mMp7tww38G
        9pc43V2Eq+z+upJVGaXGmWI=
X-Google-Smtp-Source: AGRyM1tLNSS7392jFMSmzop0TFE+7gPAUJ0Nt74ylzmqyq3/s+T/nOXOJTquDkQnm95wVOxpNoSZlQ==
X-Received: by 2002:adf:e6d2:0:b0:21b:9580:8d8b with SMTP id y18-20020adfe6d2000000b0021b95808d8bmr10519597wrm.120.1656315204073;
        Mon, 27 Jun 2022 00:33:24 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id j20-20020a05600c2b9400b00397623ff335sm12070070wmc.10.2022.06.27.00.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 00:33:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Anthony Iliopoulos <ailiop@suse.com>
Subject: [PATCH 5.10 CANDIDATE v2 5/7] xfs: fix xfs_trans slab cache name
Date:   Mon, 27 Jun 2022 10:33:09 +0300
Message-Id: <20220627073311.2800330-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627073311.2800330-1-amir73il@gmail.com>
References: <20220627073311.2800330-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Anthony Iliopoulos <ailiop@suse.com>

commit 25dfa65f814951a33072bcbae795989d817858da upstream.

Removal of kmem_zone_init wrappers accidentally changed a slab cache
name from "xfs_trans" to "xf_trans". Fix this so that userspace
consumers of /proc/slabinfo and /sys/kernel/slab can find it again.

Fixes: b1231760e443 ("xfs: Remove slab init wrappers")
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 04af5d17abc7..6323974d6b3e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1934,7 +1934,7 @@ xfs_init_zones(void)
 	if (!xfs_ifork_zone)
 		goto out_destroy_da_state_zone;
 
-	xfs_trans_zone = kmem_cache_create("xf_trans",
+	xfs_trans_zone = kmem_cache_create("xfs_trans",
 					   sizeof(struct xfs_trans),
 					   0, 0, NULL);
 	if (!xfs_trans_zone)
-- 
2.25.1

