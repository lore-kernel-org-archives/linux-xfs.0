Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D146DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 23:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiF2X4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiF2X4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 19:56:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBE126AC3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 16:56:01 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h192so16845263pgc.4
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 16:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IAj4NdWFknlo+kxec3gjgChbQ7ClhCosfaATaGmqsIs=;
        b=NC2U1IOgt3Y7Q+v3Ly2Nkn5NpnoZFdRqmMyGmMuuAIzkLwq3zc4QVbyL3DxoWdnd9C
         ldq+1mR/RZo2qGJf7e7tE/f6A4+Xc9M9ZmI9poFuHdl5oPzAffdfPEr21ZeapM/XvGvB
         mjXBBUWj9Tml5PwVzuV09zuRGifojNA0WWoOpX6r5+ZNFJlmcErEOs6+KjLV+p0ZDqP+
         CP2Dv5WO9els7OC6hTYVNaeeIJlEykW8V08UgCTHbSER5m1D+YOdDpK0xoKSkrcvEJM6
         hZeHmhk07dc9anV0SrIEtra6lOqbKSv8q4SsUH4ClOueK4mu7Bk0k7EgIdgY3tsd7RSa
         N9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IAj4NdWFknlo+kxec3gjgChbQ7ClhCosfaATaGmqsIs=;
        b=OHlWnG3SVRKNuIBE1RGtP8Vox5uxCtfUAgTd6NKBL3XpXcxj1hBV45+TJXOyiXmYT8
         7QQx7As0N/V3V7DyDtDdIesfuQ9a+xaqO89cleE95HSVtClBpI8TYstrxCvWE+TLuqaF
         lG7ma5HOABNfcaz/IFyKfpfzSK54AYiVJHTLF1vC0x9LHwDbGJEycPpohxZRozTzizlj
         U1BO2t3Xbse9nJGbckAJCG3iieVuukdj5zMhfj/B9N9BGQJkN8+Q1WVOsLE0D6E6sgym
         PBTC3YKJSAnLMS1PhGxPa+rrUD3rO05WwtTOIZ+ByPoOo8a9wdfEOL73kpRVVgMpxTTc
         82NQ==
X-Gm-Message-State: AJIora/Fcv7/BFKX3m6s/jxjGtHlncwxUT5Rq85otxi/iIlGYxRhPOZS
        dI08+1SBp8k3O7MUDDWqm0CSa4oAeLs=
X-Google-Smtp-Source: AGRyM1sUdoAGE3mW0/PDahRYnMTNdkaXfn0bjo5mXs/UZPXHMS0G1+AJK3hEhrwJzxc93Ne0+Myqgw==
X-Received: by 2002:a63:9d41:0:b0:40c:67af:1fed with SMTP id i62-20020a639d41000000b0040c67af1fedmr4890244pgd.185.1656546960818;
        Wed, 29 Jun 2022 16:56:00 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:cf91:455:e9ca:1ec9])
        by smtp.gmail.com with ESMTPSA id md4-20020a17090b23c400b001ecb5602944sm263562pjb.28.2022.06.29.16.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 16:56:00 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, Leah Rumancik <leah.rumancik@gmail.com>
Subject: [5.15] MAINTAINERS: add Leah as xfs maintainer for 5.15.y
Date:   Wed, 29 Jun 2022 16:55:46 -0700
Message-Id: <20220629235546.3843096-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Update MAINTAINERS for xfs in an effort to help direct bots/questions
about xfs in 5.15.y.

Note: 5.10.y [1] and 5.4.y will have different updates to their
respective MAINTAINERS files for this effort.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>

[1] https://lore.kernel.org/linux-xfs/20220629213236.495647-1-amir73il@gmail.com/
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 393706e85ba2..a60d7e0466af 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20579,6 +20579,7 @@ F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
 C:	irc://irc.oftc.net/xfs
+M:	Leah Rumancik <leah.rumancik@gmail.com>
 M:	Darrick J. Wong <djwong@kernel.org>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
-- 
2.37.0.rc0.161.g10f37bed90-goog

