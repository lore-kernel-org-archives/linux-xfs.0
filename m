Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5309E94104
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233545AbjJFS4F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbjJFSz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:55:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E53123
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5rlF0oL9W0zNtBhbjMTbk37IJ/kLdlHiXudCvThRqlI=;
        b=funA6IMxyY3mnefPGXJhUsKdKC+bluMkANKD+EkcsX9CPppUhHyAgOMXpCAn6q2w/OnVpv
        VWMiq8x1PNJ29xSwdXNf1bHFK5zddls18J3rXMSkYIbly4Nnl2ziNvcOq0ld/OrjReGMTr
        wY2yfn2EnJrIRNKvHmFRXehoO27Pggc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-ZsFXvv4kOWKj4cURcg9tdQ-1; Fri, 06 Oct 2023 14:52:46 -0400
X-MC-Unique: ZsFXvv4kOWKj4cURcg9tdQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9b9ecd8c351so183825566b.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618364; x=1697223164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rlF0oL9W0zNtBhbjMTbk37IJ/kLdlHiXudCvThRqlI=;
        b=WwYqZkFby9ez7AhuPzKuX5HwwYyCpJ8vboxH+qgv+F1OYJ3zvyyOJjc4z9nr7xIXJT
         SkzqvP8kc373xHnt/ISNl1zjoAM5WOsxmpMR51lpmGJSx9ZE4rh0mdktKHqlQpouvXVA
         R7vYPlrvMG+PpgbTrpCejueSAQQmbqw+RN6pDb942tIZhQiL7hmoWLKxmT7rQUyvJpMP
         Ich0bR8Y6QPHucrwwUya+IEIxt/0DOHh3ReVgW/99BLawg90mCy67eNtBYYAXDr9xu6+
         l45kIxlimrS8oP5rOkdLdHHh6Us3v+MDb2R7oJkTCcybpVHOfjxh8YWNKB1c+H08dwxW
         dyuw==
X-Gm-Message-State: AOJu0YyufdN/Uuc84K3jfNO42nIw+I8d7eKJdIXG6yoO34hm06EcNCSi
        RpMc8sMaudJrLlC1utgj5QH3bIbHK6u4De6TbJ1Uz0ZXXhCiua8O0NgtGWWrTprMQV7M5MwMYPv
        AEJiMm57A7KcR0VIypUcK/2pFLt0z0GKbgOt1/iYVcZoB36IYkuer3OC7JHAZKtKaZ9evbfWIJT
        02Py4=
X-Received: by 2002:a17:906:3116:b0:9a9:e4ba:2da7 with SMTP id 22-20020a170906311600b009a9e4ba2da7mr8028685ejx.49.1696618364722;
        Fri, 06 Oct 2023 11:52:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb5yDWscYNSrW67kJ5zHPToh4J20qlMVNuAtELJzCJW/KwyTT1ZP+ogCVKItFg1sfFvDb1pA==
X-Received: by 2002:a17:906:3116:b0:9a9:e4ba:2da7 with SMTP id 22-20020a170906311600b009a9e4ba2da7mr8028667ejx.49.1696618364456;
        Fri, 06 Oct 2023 11:52:44 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:44 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 28/28] xfs: enable ro-compat fs-verity flag
Date:   Fri,  6 Oct 2023 20:49:22 +0200
Message-Id: <20231006184922.252188-29-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Finalize fs-verity integration in XFS by making kernel fs-verity
aware with ro-compat flag.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ccb2ae5c2c93..a21612319765 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -355,10 +355,11 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
 #define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
-		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
-		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
+		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
+		 XFS_SB_FEAT_RO_COMPAT_VERITY)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
-- 
2.40.1

