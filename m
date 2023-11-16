Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AC7C2BB3F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 02:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344463AbjKPC2y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344536AbjKPC2x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2023 21:28:53 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CE318D;
        Wed, 15 Nov 2023 18:28:49 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1cc9b626a96so3068985ad.2;
        Wed, 15 Nov 2023 18:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700101729; x=1700706529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QkmRHkitMpyBnHPWSnYYN6nx7Pzs3ClDYHao5nyQTyc=;
        b=UGiFgfDSeXQebvSfPR3oL8uWu2csWWStVc22xyhm1l3J6OV5YhovRo41WKkM48yAh1
         YkTdtqrIUBpxoNq/HVgnAVV5uboKBjgVKoKhzBF02JtPZ5KnGW09R2yBYsBJb+iwzXuT
         xoJjpis4PZOexjS8SutgDDd85Fo1vGkGzO2O7luNwDXHX4azKy2tg21KdTMpBzwULJLR
         er3iPobKNlmjyRLoh4bue/BMi1He9SlOlHYc3CuPY477p7r2EXbv0y9x2Mgv97aU7rSk
         /B4Du18fa25T9BwGA7/6Xuk/EUAiP+XwdNlBa/e/GMVY0+m2AF+KKVee2EbpysdZzgod
         NWcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700101729; x=1700706529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QkmRHkitMpyBnHPWSnYYN6nx7Pzs3ClDYHao5nyQTyc=;
        b=nNM2dfLgELulVakYwz8vwE6HdX0cN261pAzWwZ2uYUfOvxrHj4Gih6IH4DwGRMvGhl
         BPYbOcZmXECnGknBlFteRzlqgT0/f0zHSBZSMCU7CO5i3F58TIZ7vJ9n2+T438bQ0ILZ
         ReXV+A5I6Ly6jdMIYPLnF8KcCJXdbLnatxnVfju2uVsuSXvTXB9yRNkt/7dtfILTnBMY
         e/oc3WhgUej1uCQ34umMrpq93qNiy5oErDfl82ifMQuM7pjOwC3iUfc1vF1cJLKJPzMd
         7gVZmVD3CvqXeDI/CtN8Gj4ZkdsHOVQh2E3mGVtudJBGi6WjQzamPMqbaTYprK02+4Kg
         Blag==
X-Gm-Message-State: AOJu0Yy4Ir5YIpnzNZckmVyJQ1kAs1+mUWrcuRs9lOt51+cqW8/j3xHB
        1+aqe2fd0QQMDJnG5wn7uPJemD6Xp+r7Zg==
X-Google-Smtp-Source: AGHT+IF41CqzwmXwKnkb/imGiGEs9CI+Ad7Bx2dudNBMV6v9+yFdmTanPzU3id8QNlQP+VOa1Y4HhA==
X-Received: by 2002:a17:902:ce86:b0:1b5:561a:5ca9 with SMTP id f6-20020a170902ce8600b001b5561a5ca9mr8986454plg.50.1700101729005;
        Wed, 15 Nov 2023 18:28:49 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:25ea:d6bb:623c:d6a0])
        by smtp.gmail.com with ESMTPSA id j9-20020a170903024900b001b8b1f6619asm8087072plh.75.2023.11.15.18.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 18:28:48 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, fred@cloudflare.com,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 11/17] xfs: add missing cmap->br_state = XFS_EXT_NORM update
Date:   Wed, 15 Nov 2023 18:28:27 -0800
Message-ID: <20231116022833.121551-11-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231116022833.121551-1-leah.rumancik@gmail.com>
References: <20231116022833.121551-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 1a39ae415c1be1e46f5b3f97d438c7c4adc22b63 ]

COW extents are already converted into written real extents after
xfs_reflink_convert_cow_locked(), therefore cmap->br_state should
reflect it.

Otherwise, there is another necessary unwritten convertion
triggered in xfs_dio_write_end_io() for direct I/O cases.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_reflink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 36832e4bc803..628ce65d02bb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -425,7 +425,10 @@ xfs_reflink_allocate_cow(
 	if (!convert_now || cmap->br_state == XFS_EXT_NORM)
 		return 0;
 	trace_xfs_reflink_convert_cow(ip, cmap);
-	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
+	if (!error)
+		cmap->br_state = XFS_EXT_NORM;
+	return error;
 
 out_trans_cancel:
 	xfs_trans_cancel(tp);
-- 
2.43.0.rc0.421.g78406f8d94-goog

