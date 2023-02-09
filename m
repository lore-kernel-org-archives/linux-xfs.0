Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C241C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 22:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjBIW0x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjBIW0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:26:50 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3414D5255
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:26:47 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o13so3456852pjg.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dn4rGozGwuyQwdlzxYL/1aJ/8rD3PwHb5frw6WYQNwg=;
        b=4zqYSw70H/tuyUK4rsn7Kf4xCqtW6+AVvrLeFEMNHW7wCnrBhctaQvjOzozv5xQeAa
         OSmcTrI+NvdZTDNwNAF/ELnM4Lbby+g+I3VD/6sTFdq3bgk73TGWLfJ70ZS3J1YtPO8t
         SHJfWgQ3Gtr22Z1jxQ9zqFuP/5t2MvLE5KbctfBNPKX2IAVJkdDPf31khVj1NkrjjW44
         ELgpFKLgQbj9YNa+NOfWT86hRRMALFaSfINoYGi6DHg7KtAxO6wysgk5OBlt9zRYPfcJ
         TcVc/r+70+3BksGO1vkbR0Ko23F2W5wCUfGME2IFggGoQ4JbfdnDgglYbXb8bE3rRPxX
         f8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dn4rGozGwuyQwdlzxYL/1aJ/8rD3PwHb5frw6WYQNwg=;
        b=6nAffbDNJUC2k9CP2LVf5YTDu2OSqte/Q79/ESb6/Dm9+cWHt89w2dJ8Y7ELv13vgf
         j50hMHvmU+zsIayOFFSw4szp+12Ab/7+K0VeWH4Gq/mUvQ6aK9NBDXmi32M3OR6uva5h
         DeVKdRu5IdjEIeu7LfFs7PZwKMMf+Yp+alFX3/PEsC0Q1jjRB3iI1QVrBDVGEyqyV/GL
         l49zbQ/I/9leEKT5eL5VxRlM4A10GJ5tsgPANmDC+8N80ao8aALyp1uAbhT0076ncess
         LRcjzIrd96k20IEN4QsIWshTDSM4uEECyBa2BYioVu7vnn55GIV8sNj3e9xu7mwnOeXi
         WD5w==
X-Gm-Message-State: AO0yUKVSNeiK8krLdo4IYyw+ZuloZlwfJuOSMaXo7XvDNwEM5SStHsNv
        aBe66uT2ElvjDZBK/3jrQBXs0n1wQZOBLzFK
X-Google-Smtp-Source: AK7set+RsSif4NLsCFdgh07qn0qpsBG0KzvmGicn8B0SuoQm9VfXJHCgi7zBxXznC1rwF4kmFsYY6g==
X-Received: by 2002:a17:902:e5c7:b0:196:8b36:d135 with SMTP id u7-20020a170902e5c700b001968b36d135mr13503577plf.62.1675981606717;
        Thu, 09 Feb 2023 14:26:46 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id a7-20020a1709027e4700b001943d58268csm2017179pln.55.2023.02.09.14.26.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:26:46 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOWM-Rp
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcOo-2k
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 36/42] xfs: remove xfs_filestream_select_ag() longest extent check
Date:   Fri, 10 Feb 2023 09:18:19 +1100
Message-Id: <20230209221825.3722244-37-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Picking a new AG checks the longest free extent in the AG is valid,
so there's no need to repeat the check in
xfs_filestream_select_ag(). Remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_filestream.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 713766729dcf..95e28aae35ab 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -276,7 +276,7 @@ xfs_filestream_select_ag(
 	xfs_agnumber_t		agno = NULLAGNUMBER;
 	struct xfs_mru_cache_elem *mru;
 	int			flags = 0;
-	int			error;
+	int			error = 0;
 
 	args->total = ap->total;
 	*blen = 0;
@@ -351,27 +351,11 @@ xfs_filestream_select_ag(
 		goto out_error;
 	if (agno == NULLAGNUMBER) {
 		agno = 0;
-		goto out_irele;
-	}
-
-	pag = xfs_perag_grab(mp, agno);
-	if (!pag)
-		goto out_irele;
-
-	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
-	xfs_perag_rele(pag);
-	if (error) {
-		if (error != -EAGAIN)
-			goto out_error;
 		*blen = 0;
 	}
 
-out_irele:
-	xfs_irele(pip);
 out_select:
 	ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
-	return 0;
-
 out_error:
 	xfs_irele(pip);
 	return error;
-- 
2.39.0

