Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC39C388F7
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F335E221FB
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 15:07:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZbG5+ayK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgKCPHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbgKCPH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:07:27 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EEBC0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 07:07:27 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id g12so13889756pgm.8
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fYn4Dk1EXYBsRc4PsiEBtvGWQor3CttFr0ltlRTYZIQ=;
        b=ZbG5+ayKvNvQkxVWfCxyyYPevxHR5nJTAZzGISu/jrMeQbC9jb6Nhl0lHynoF6UuxO
         2J/Dvew7JnR53FT0UzSLveLmahHTYavLvn7aUyjt4RBKkDF8nM8WWfcY65SUYhnvQ5PB
         VWUyKhzYqUyjm3hD8XbURomMJSC7u7P/2rjH7XPE/wOoquxnKlneDl7WvIZBexnnIglF
         Ek+RvoPiIMBncECmX8bz4JwV5eb3UfMfLOGvSIdrEpOIQJJuohn0lLgDvqDOtK90S/ic
         NHckuG0Vg659C54Axborsbu/GoC6lFHdTsSzVXatKAu8lOqDrzeDv6NUt0DlovQJYosd
         IRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fYn4Dk1EXYBsRc4PsiEBtvGWQor3CttFr0ltlRTYZIQ=;
        b=OrfvLv6xd0XPAGt9nnwFKxmzyfSWyKsl493kytkmTmkyVFqrwEC6UJwQRNP5NN81zV
         POZQB9oAvynFnIwYQVx9wi6pkOsuwM+SLPnigl1vRm/QBfYEe0QHLqat8f8BPLuUdTNM
         FwJIl1kqm8lKOD4l8QLNDCjOQd2c+rRbhGq3FHE5Acg5EZjEmzTP0FdUrMe4v2Nd2mIi
         asmKuv+8rS8yH3JTMYj47T72Kh9AUcq52AzN/Lwh2gRzflgfbGYHxTkR0zm5Wn2Cr0Rd
         sd+UncCEZz29n6/SyS5OV5u986QkS9EF4BnB6Rz7FbrhOwlxlG9kP7T3Od7l4p3tysZ2
         Phuw==
X-Gm-Message-State: AOAM531U1Y+NIDjGbK93StWEAJWY4iU0L60g1OTTr308yx9gSCYNjZZE
        fRYXBB5o/x/lDuIvrbkG4NlyZ7tQJLyvsw==
X-Google-Smtp-Source: ABdhPJzdV7CAk6xV3edDHUPCLWtT/k0UmbVmEaASMsPtz6l1krHcnp+CGY/CGDfJT7Zcv7lgGree2A==
X-Received: by 2002:a17:90a:1b8a:: with SMTP id w10mr177425pjc.145.1604416046554;
        Tue, 03 Nov 2020 07:07:26 -0800 (PST)
Received: from localhost.localdomain ([122.179.48.228])
        by smtp.gmail.com with ESMTPSA id 15sm15936955pgs.52.2020.11.03.07.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:07:25 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V10 11/14] xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
Date:   Tue,  3 Nov 2020 20:36:39 +0530
Message-Id: <20201103150642.2032284-12-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103150642.2032284-1-chandanrlinux@gmail.com>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
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

