Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423E8C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 21:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiF2Vcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiF2Vcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:32:41 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6641FCC9
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:32:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o4so20406570wrh.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ejUlMEQAaK2PtbHTxcl0/2Iik8wEv2aPnWXFEjxPmyY=;
        b=CqEjJinDFlYpj/1MQ7IQL82IM/BK+HDGdmW/0g5zNB2v5/j3I105xSnhrUaJcf8dNw
         CI5mXZ93MNWWLzT89ndTXSSprSx0bVE13ZsXYIPAvykO3lcf/mzvIfb+asxsttIDYDOG
         7mR+PTDvu7V0B5h/LM4H42IiaEhiqkYOLiiB+w4Rdt2Q+qgJdBW1b28+akbSUpgl3RCv
         t5BLChdeaOPvLMvrIMt7KCRX5ZkJwoEEetTwajo5hGHkr2yMv0AoV8c9KmO8dn3jn6/w
         g0/SUua4K/r6YMH4phAGKvlsvWsu4UuBBNdmEoBDnGP4toou34qZCn8gA7LZPRgMW3wf
         qf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ejUlMEQAaK2PtbHTxcl0/2Iik8wEv2aPnWXFEjxPmyY=;
        b=WF2Swal9IkpVGgZ30oJQ/Pygulxsvaw95Pnuceg7NSyRfvmzSv3MVBWrRSgvxY+Ti1
         mHPLBTNPptcLfEdJb4S0Mqk0Dyi1MBQZ1hBSaNItzwg6VIgRcUkQiqfo9aJeX7E3/K2V
         P1r3Yz5bEUzxr0UAEqY7WVm/g4K4qp/ATC+sXUMHmf1lEwefWTmSjO1s53ZlJhcHe14v
         wrUGWjMP7KUCa309NOd/ROX1cuHR0ofiF/1vMul/Oa/Xya2MVPgKrVvkl012RT9Yoibf
         Tv/q/HNSKKqgyLBLZ0QObAW2OSO850qZA4ltGYF7N03OQpbunjMbWyPFE1jMwjSsTQLq
         7gng==
X-Gm-Message-State: AJIora+0WVJNUr+rqQAEwPNxrm4h7rrcj/xs+xfRR0nSPmn6+D6iKh1s
        VtFzjM5HxB+ObQQs8kgnMaA=
X-Google-Smtp-Source: AGRyM1tEQDDlkgvSq7cItfGNgiqNDMXUa6I9xS25bzAx/fcHLBg/uXhtEWqPyNCoOTNqww5do1fL8g==
X-Received: by 2002:a05:6000:1f19:b0:21b:98d6:3532 with SMTP id bv25-20020a0560001f1900b0021b98d63532mr5248182wrb.45.1656538359275;
        Wed, 29 Jun 2022 14:32:39 -0700 (PDT)
Received: from amir-VirtualBox.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id k5-20020a05600c1c8500b003a0fb88a197sm4124240wms.16.2022.06.29.14.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 14:32:38 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Theodore Tso <tytso@mit.edu>,
        Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH 5.10] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
Date:   Thu, 30 Jun 2022 00:32:36 +0300
Message-Id: <20220629213236.495647-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an attempt to direct the bots and human that are testing
LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.

This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
have their own LTS xfs maintainer entries.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/T/#t
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7c118b507912..574151230386 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19247,6 +19247,7 @@ F:	drivers/xen/*swiotlb*
 
 XFS FILESYSTEM
 M:	Darrick J. Wong <darrick.wong@oracle.com>
+M:	Amir Goldstein <amir73il@gmail.com>
 M:	linux-xfs@vger.kernel.org
 L:	linux-xfs@vger.kernel.org
 S:	Supported
-- 
2.36.1

