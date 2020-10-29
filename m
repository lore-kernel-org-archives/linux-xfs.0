Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCC1C55179
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7DB4206BE
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 10:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f/FEsP0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgJ2KPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 06:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgJ2KO7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:14:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACC0C0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:58 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x13so1928887pfa.9
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fYn4Dk1EXYBsRc4PsiEBtvGWQor3CttFr0ltlRTYZIQ=;
        b=f/FEsP0BwX6WSDSV4/u4MBAQ+Xm3DcAhnxFtXkmK9/C6p/oLs6pmD3zVIdERI5WU1z
         3FJbc1f6LeMPOjp78fjjY2s+XIqT5ICRaU6jepBL7mAsSDmTf5p9j18tFI5pn6IOMwzw
         zTl1SLp2TepBqXHQyCCCe4Xghz/N4kS0q43Od6nEzCatlNjBWsT+btZLOCg/h+aQRgHP
         OCS/lyzAizizIY4m8+kHjhASR0GsQqrDuBLuyYp/GsRfvZDM78WaPatjGThgh6EdS0ix
         jYnBwQioJDD2LmXx+Lnmn19lttyO/fGVLlBibxHFC8R5rrWSlVJb/5qmnpvDQerY/V6g
         2T8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fYn4Dk1EXYBsRc4PsiEBtvGWQor3CttFr0ltlRTYZIQ=;
        b=S9fFsM19tqonweCnvIS6BciYam882pKpEGB+x/bePzQMLt3bgesgNAWeWvQpYc3kCL
         Nyvlp7vrUIy4Udu50tbAIyxu76W22K7lEJoDuQ03RHoutDGXH7Ash3Erp+OYa3FDDcej
         W4sZlAwS2b3PyrxyVo4kdg6Q7HdJA4vQkkTYicTdNiAZKl/xEpt96Z3NmHmDaPjPPIOB
         anLtUGmBdVQsnRkxHPbax+ums3VM7yEgpYqE9nQMUlt1JU5e2y/p3jla4f6j6Tf6Nki9
         mBHz91xQQy97KNolGsTfF6H9/A6FuONgGykcVu3iO1VIcxfK5YJEwNybAVrkxuccrczB
         CcKQ==
X-Gm-Message-State: AOAM531XgYlW93Uus0UVWbaDe0umZ5BxIr1f+yPmHc0ARPOTkYk6kttk
        R0TpHDi2lql0l0QKfwKrKAVM+yvQGe4=
X-Google-Smtp-Source: ABdhPJyu0f0mcyauyKZ+YpQVGuP1zakf1Xg7BKlmvPUrU37CX80N7hfhM5BysCBHBgZwIXbDsU7Wqw==
X-Received: by 2002:a17:90b:797:: with SMTP id l23mr3679054pjz.136.1603966497715;
        Thu, 29 Oct 2020 03:14:57 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:14:57 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V8 11/14] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Thu, 29 Oct 2020 15:43:45 +0530
Message-Id: <20201029101348.4442-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The check for verifying if the allocated extent is from an AG whose
index is greater than or equal to that of tp->t_firstblock is already
done a couple of statements earlier in the same function. Hence this
commit removes the redundant assert statement.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 505358839d2f..64c4d0e384a5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3699,7 +3699,6 @@ xfs_bmap_btalloc(
 		ap->blkno = args.fsbno;
 		if (ap->tp->t_firstblock == NULLFSBLOCK)
 			ap->tp->t_firstblock = args.fsbno;
-		ASSERT(nullfb || fb_agno <= args.agno);
 		ap->length = args.len;
 		/*
 		 * If the extent size hint is active, we tried to round the
-- 
2.28.0

