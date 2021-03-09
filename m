Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25153C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C83346522D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhCISmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 13:42:31 -0500
Received: from sonic316-54.consmr.mail.gq1.yahoo.com ([98.137.69.30]:38359
        "EHLO sonic316-54.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230466AbhCISmU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 13:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1615315340; bh=09oFcKNuuyefeFXXP+xRkzXe4sgHlZ4A2vRgQOYpW2I=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=TEygyS0FxvRF8TiCw8oL0jvTuj8xtHF6RJAGYJ8p3yfWc8bA/JFLiWuwDgp53z9plvkKSbDk1GAmDdhTf5h5htFKwPuc25ZO6QifMBd1kzrBMqyKYYvsqqK9b5UV2LqB0ESYh6q24mXzjCH5jaMWyo1fVjlhIvYjvjk+gN4ESKvbsKPkLVhgbp6MNxrgB2Dm34HXr50E5sZ/Iirx8isz7r3PYUnrtfMeMCUaHMqQUH7KTnyuS4zcmrocIP4kTinh4JIq/Zh58DhF0gFTDxoPaEgEgTi7F8KvOG+YsIweTbmuHutI4sU6ecPw+PLmN4UNuqZL+ABOumaP290oclxyWg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615315340; bh=Ax5nw4znCdfep5Rh0/kBcah8gJbpXE+SSzkLvW4kKSF=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=DQI1ToxmDFWMbVy+/X2XgE+b5TEryuRDIBQiLrIUvuHuizZP8IeU5bZhzEcigI+EO42AOPph46JtXwd7sHLaEchsXpFdUWb2syq2D102SBEkOfFs9V/rOB68Nrnyf96G2dvXkEa3oEw5oRWgAj4Jl3bBCeOGIIyBFStVdVqtovwbtGkDV8XpVafKfqP0DpJe0tg+nQgoqJYZdV+GtQynsJ6qAe5B8P4wJooGlFiuFhjUQN7mEURHtJizFXQj8DltL6F3n323EY7vJ1pg+MVmbENs5lWp4aYhnht9w9MrcKpJQXnfR0BROdEIlGiiB/hVlfaqMHTv7uG3YKQ3WFVlKg==
X-YMail-OSG: Oz.BcQ8VM1lwCP9t3szjgxbN1vxzmqDl0D_OGWcFdm3GaGZ_zbqiDQWC5nIOGYe
 8e3aWTys1p.yNTwPfi27qkIpeb0EZIlsm03sW.3rw5w.q5hQMkxm20Xl1._7xlw4IT9QdFbv3D_M
 gXqWt7qDXrOlklCIdMVHdV24ybKND3ZW3ArqAYeRbYW8UJchyfwMpmYO433z.7.OC.UDt4C3hA.K
 y4SNJFiHScOAwQbzk1_oO2KT7Uxo5GukHUpx6RmknILWJ.yj_ij7lUmRMz_.tmi0fbpl2uwbASID
 CEF4RMViJb6MXRkl2x.KCDBQ43af1inut6aAAkPqeUBczEzrxqF0vBuOu_wV.fRc7539HNSV7AzO
 nk5zGxB3cOD45J6LULy8DKxYfHBJhs_jUoeYTOtX.zWc5XaI7pkgo68JWvYOFppND1cYGdKlIazx
 FWfJWN8pKVfp08TMM93OCC9igZlII4DQMhNGrtIoF6KgD63w..mETuD4f4jByplscr7_GXrn1VFT
 bndiPebAp8P5IlvHrfz_MDPFR68CGOmdidphz5R73lptk1NTRp0kxIeBtQl5tqZOGPtXSEx9OdOT
 jzNgfp5d6eLrXLTtFMWJztmQT2Ns0AyRo5C9n82eTMuhhpKeoETXILDxQ7C8avKeCoI0vOoQqRnL
 065fRf7I5y_oftC9TNgOuPQMKxqX3Pz05jQSNVlTK7DZfJCiOQZf0i.X9GoxvPBWiA1In9zJsf1a
 .ftnHlyyaBm0u3g9YlXNaR9_k.NsX6D30dzQCKlslKsnyC4AtnLYQndZNHS7zqdHemFPityyoy.Y
 4d02L4I418oQtxAukQjaP49QL66Qeqx.up8u0kRZy2k6YCUd9MQcQaF0bf_YKLIomH4TO.g2edfW
 5AdWh59w4fRNIYt5Cwm_kY2JF7wpLHYMekI12aWfHs81gkY8u2mjo5sV1TIWUPjuKggF9Naslx.A
 dViuy4_ls_oaF5AQj9QOPABRmEZA4EebgNuWExjsLX.kDjFG6V.lVpRE7qSMAosFnXur._IoXSAh
 3WG9lDR03O7Wiks9cuVfjTHNdQZJyANSQia9vknPJIxN6aSlwq3ujjLvsaXsi7uhIoy2chB20I21
 zm3YWD18X3W20kPWn9Uv3y_jyq24_3t.bUJ9NdNSIv1XPqqsIpjBhI1d362MkbX4O9Z00PwHsOjP
 LHjbYaE9EDoi_YH4SsLF_m9lYUSBRjGr.9Z4rt9MU0WaN_veBrpaRyI3hZGuApyZ48BaRInu7StY
 cBcDOqxf8oS2gzAu25_bL03QoJ4Zaaofuc188xJMAHZp1jy4wuSO_Q5GJd6NuYQcd40PNbAq7Tad
 DK80g3pHcuAgcLpYCnEb4D6FIu0uvr7dXcwAa7zCPMKK8_hp9MuPHHamk6UKRof49.jC4HCr2r_X
 HlCrFKf__xBj7VoYdUaoCwJlYceMQLPPy6MwI4adn5a.06lg3GvcNaQP5lqBFrcUuJs09OdGEKB8
 tlQH2PoHmOUo3GxSFWg3p0hfi6ZzXJPldro_WxjwrlLLhnPtLMY04FUqoTZ5Ho7uIFG5EkAflk_Q
 OUNCzfYRJs9Idvv7KwbvRmQBg6xH4t1ZYqCmZ30pwUgh_sSUrx2yBXXEikjc_Usky2T9Zn0.UA9B
 D.JpKNyRXrY50p9LlzvBUKXhX7AK0U8nDW18i44EloDeSnGG.5bPZ.TzKBKUoX2f6RNPPj_gTlfn
 8yCHiGVGO62MxMdMd0QtM6vBOIzeqW56WT_a0ELA4mvPNMQFwNiRACqBXLEM8fVLdPd_NkuxnM3k
 axgoSNd541qsA5tGmMnULhQeril7ThrX_CmxBnLk2arAjiWqFmgxQ1.BrLACyaKGnmjqYE4081fe
 p1k.HblQJq.Qw2tgY1MBIF84f0RJIQRy9KWRIFhe2NlqLS9c4C6v04BRWg4SwgRzGelPhFu797ta
 XdwdEmvfgohjClMIsR75t4AP4.VuIkU5Hy_JKjXd3Nd8KxuajmZvex3ZLlUld4NxyKHB7gshnxXE
 4C1vRgc1sWLs1AkUovsvEoVi7S8M8PBViKU5yPtxfXJduUzqQ37IX3uxCL21DAKG4nbTz7XeYMWs
 W1quLOmNrgOpeNxWIrjaDbhaDIMxVVCgyNd0XCxWSmdF5FvFGhDVbcTwhhiCR3aSeoeq08khV3Qx
 1peqC_DObT0rMqWMQjjfVYiCe2l8lItHInJoTKbsSPRHG9.8winNDpgqv0Oj7468rB6QcwxAuLm8
 EcRBL52rjzQihFlfSgrBPo3P2VdDXrUXiBwP5YgcwE2rXG5hjLCmIz9tnJdORAxV0ChsiQYUz8Iu
 J0AAH3jGvy5lQ.Udza80bfcETpG39sitCI2bTEwsCf0E.DEMgJaTKSu6XPPMFvByG.B1XS04W0eB
 _Cf1C5Fk2KTzYZ348Q2H8WRj_oWQtRtR4ZiDq9d2NjdDXQryCfEYaf0ZhNaaFEFIOMcx845kWyih
 3xGxKlVYca6ev9rWeOrJKrlyADpxKHpg9qOo6nHWHjepjX6k2COj4utzPJLfObiO9746oCkcSrX4
 w2DWb7cN.i7TFpck8JH.JbBkDfMzzARUi96rVQP.wKb1Vgy49CzooLQT1G_jiLjSBlvPD7WJieY6
 PMiikiDfpnmsI
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Tue, 9 Mar 2021 18:42:20 +0000
Received: by smtp411.mail.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 5800d7f3aa47ffab406bda4e3b6da104;
          Tue, 09 Mar 2021 18:42:16 +0000 (UTC)
From:   Gao Xiang <hsiangkao@aol.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH] xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
Date:   Wed, 10 Mar 2021 02:42:05 +0800
Message-Id: <20210309184205.18675-1-hsiangkao@aol.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20210309184205.18675-1-hsiangkao.ref@aol.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

Add the BUILD_BUG_ON to xfs_errortag_add() in order to make sure that
the length of xfs_errortag_random_default matches XFS_ERRTAG_MAX when
building.

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_error.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 185b4915b7bf..82425c9a623d 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -299,6 +299,7 @@ xfs_errortag_add(
 	struct xfs_mount	*mp,
 	unsigned int		error_tag)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
 	if (error_tag >= XFS_ERRTAG_MAX)
 		return -EINVAL;
 
-- 
2.20.1

