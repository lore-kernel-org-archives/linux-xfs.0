Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301E7C2BB3F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344540AbjKPC25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344547AbjKPC2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:55 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DF918D;
        Wed, 15 Nov 2023 18:28:52 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cc2575dfc7so2930765ad.1;
        Wed, 15 Nov 2023 18:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101731; x=1700706531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDxTHl/EqR78T/77ZIGbdPyN79LYr0Ry4s+OaavprZs=;
        b=SLAciXwKDRJCV1TEFiFEw9vZIVQGFz6pvupxqiRwTxJAb/s8/2lruHjhfYpjpdZfLA
         tMqo/G40g0jxmNP0ad2gRQ8C5soAFPuoiteHZ5l2UJXrtyJ3f0znhvCkP2Mx3jv25xzW
         N9KcjPR34kCuVELZ7RYakJo1nv7Sdw1IA+M9cey7nbY88NhwSprNYPsPH3rb04fOrGKs
         r8CXIxZeUBwoMVmZ687wx4G4EM0oD/7qFS919wJ6o9z+zH+dJ5U/ImddXdM8YXFeekpL
         PqUUSuf8btFV2b/Vube4uBOaayY7Yx0QzefyhOpcNSyLjXz5JxMzC01lKW3aI1nWTkMl
         rNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101731; x=1700706531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vDxTHl/EqR78T/77ZIGbdPyN79LYr0Ry4s+OaavprZs=;
        b=a3GmFm2G7X4v3VUddMKb4oE7UfmQ0lWe4yRNk/pjHFqOI0LmFLE/xDUTF1Reekd/y6
         2SxHEM/W4GnDlzwcXBfbHKtQ/JrgTSSQc+npKaMK3uPfPkQAo+QqZhH+bhB3ELL6h52D
         R1rhRvsurHLn6+J6swsu6ezMZIfkLSZuZgPR1+2KgRHjah0N3nXeP+/qJNQqgYDzqLpC
         C95jtCAYtfqurlCV0Xqrhm5993jY6XsFiqpbb/vHhzKpdDKUVg+/MoiSONESOxhR32Hv
         Q+wGU8Tf2//rk41TXZtHIboDZ+LluLKY+DkCF7zBWmfzRx7eaFzc40fR57UE1onGa+FZ
         CYTw==
X-Gm-Message-State: AOJu0YzUZOdw+TQLFgjeUraySqRnAM1N/j6TmF7CDx0Gqb6rwz02lLlL
        IdKaDm7iLePIJpASv89Oug8z0CBhc+w5aw==
X-Google-Smtp-Source: AGHT+IFsl560ParwyNpOktMetIkp8suejyDbHMBX4xxHxmiobPKRmd6kLVV7NC08ZDBcIWVJVf5zFw==
X-Received: by 2002:a17:902:ced0:b0:1cc:3bd3:73e4 with SMTP id d16-20020a170902ced000b001cc3bd373e4mr8353561plg.4.1700101730882;
        Wed, 15 Nov 2023 18:28:50 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:50 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        hexiaole <hexiaole@kylinos.cn>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 13/17] xfs: fix inode reservation space for removing transaction
Date:   Wed, 15 Nov 2023 18:28:29 -0800
Message-ID: <20231116022833.121551-13-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: hexiaole <hexiaole@kylinos.cn>

[ Upstream commit 031d166f968efba6e4f091ff75d0bb5206bb3918 ]

In 'fs/xfs/libxfs/xfs_trans_resv.c', the comment for transaction of removing a
directory entry writes:

/* fs/xfs/libxfs/xfs_trans_resv.c begin */
/*
 * For removing a directory entry we can modify:
 *    the parent directory inode: inode size
 *    the removed inode: inode size
...
xfs_calc_remove_reservation(
        struct xfs_mount        *mp)
{
        return XFS_DQUOT_LOGRES(mp) +
                xfs_calc_iunlink_add_reservation(mp) +
                max((xfs_calc_inode_res(mp, 1) +
...
/* fs/xfs/libxfs/xfs_trans_resv.c end */

There has 2 inode size of space to be reserverd, but the actual code
for inode reservation space writes.

There only count for 1 inode size to be reserved in
'xfs_calc_inode_res(mp, 1)', rather than 2.

Signed-off-by: hexiaole <hexiaole@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: remove redundant code citations]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5e300daa2559..2db9d9d12344 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -423,7 +423,7 @@ xfs_calc_remove_reservation(
 {
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 1) +
+		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-- 
2.43.0.rc0.421.g78406f8d94-goog

