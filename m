Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECF0E94102
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 18:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbjJFSys (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjJFSyn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2E3FC
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/AveBNSqmjIJtYI3+6LuAlhQmhnFexTVHM7C0k2E9s=;
        b=UPbUIjzG4L4X2xewx1VlqnruYF5XtjLyIgvh97GaKoTHbwqi1Mfm3uZp8F9HInb2/Fo3mL
        6cqIQUzcMMvQMx+jboa9t5RD4HReTZWumnRbClUSUkIm43KvhG+mdBS2uTRQu16UwFmKRI
        rWbykWntnw73WTvRU8p1qsiUfLOUeh0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-hnkcwki0NUukrt2IPQox6A-1; Fri, 06 Oct 2023 14:52:36 -0400
X-MC-Unique: hnkcwki0NUukrt2IPQox6A-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9ae42088b4bso195975066b.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618355; x=1697223155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E/AveBNSqmjIJtYI3+6LuAlhQmhnFexTVHM7C0k2E9s=;
        b=Qpq4zmT8iCG+6Ur0hChD8CS0jmLLedYeDg+lfMQalr4mgq0+z4U1tohoFGqwybVB8T
         lENTQ/Zh384dy6c+sOFIXSaU4hK3eSsMSZ/L3+S1xRH2Nm0AGChWoNcNwaQnu49R/7vz
         /P77wL/DwrrlbI5aHg2IGUYOqpaZ3c3pDDBqYp21tRAtSnvXcMvN4EGOoA5u1W1WtwaJ
         OnSiUxfVrMZnyrMvVEdrVYXuwlp0o03IzveEOzrjvWxx+35C+HpysdF9jXy2Vbcq8ELq
         /1Wr7JLg396X3D34MfND3v3/JEvS6RM2SDvsOiK8V9BKMngwHAyJIjHBbiqNK+qIxEzJ
         JsXQ==
X-Gm-Message-State: AOJu0Yxrhzwe4/rhgDYsvriuz4DjxQA4o7iRyT6iQvxMp3wcRhr6NoJz
        zRUfJ5MK7YaKtaPvzlvtjDPsqGcERvBtWALjAvasj5ho8SwkBZ7dA+b00xFtkxZg3fxN56Pw3kU
        pmld/3WX0YKHKP8h9BNlrxDWF8jaPu+XXG8QcTCWLK3YxhkwR5fnyTuXnvfaksatiSyNK86IxSl
        h0Zkw=
X-Received: by 2002:a17:906:9c1:b0:9ae:5aa4:9fa with SMTP id r1-20020a17090609c100b009ae5aa409famr8090653eje.42.1696618355347;
        Fri, 06 Oct 2023 11:52:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOVx3rLvVBE5QUfisMFkx2Pla6kAmWa2HIAK3od296Wuq43rVklqeW33wJg0+k4bCeT0eC3A==
X-Received: by 2002:a17:906:9c1:b0:9ae:5aa4:9fa with SMTP id r1-20020a17090609c100b009ae5aa409famr8090638eje.42.1696618355160;
        Fri, 06 Oct 2023 11:52:35 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:34 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 18/28] xfs: make xfs_buf_get() to take XBF_* flags
Date:   Fri,  6 Oct 2023 20:49:12 +0200
Message-Id: <20231006184922.252188-19-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Allow passing XBF_* buffer flags from xfs_buf_get(). This will allow
fs-verity to specify flag for increased buffer size.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 fs/xfs/libxfs/xfs_sb.c          | 2 +-
 fs/xfs/xfs_buf.h                | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 72908e0e1c86..5762135dc2a6 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -521,7 +521,7 @@ xfs_attr_rmtval_set_value(
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, &bp);
+		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, 0, &bp);
 		if (error)
 			return error;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6264daaab37b..4191da4fb669 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1096,7 +1096,7 @@ xfs_update_secondary_sbs(
 
 		error = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
-				 XFS_FSS_TO_BB(mp, 1), &bp);
+				 XFS_FSS_TO_BB(mp, 1), 0, &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
 		 * continue.  xfs_repair chooses the "best" superblock based
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d0fadb6d4b59..e79bfe548952 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -243,11 +243,12 @@ xfs_buf_get(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
 	size_t			numblks,
+	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return xfs_buf_get_map(target, &map, 1, 0, bpp);
+	return xfs_buf_get_map(target, &map, 1, flags, bpp);
 }
 
 static inline int
-- 
2.40.1

