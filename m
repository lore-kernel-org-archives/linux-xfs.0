Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF10CC77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 00:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjEQAFA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 20:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjEQAFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 20:05:00 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695962728
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 17:04:56 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64ab2a37812so9291659b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 17:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684281896; x=1686873896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OiarNXqyDgLGSnRLOjyy6hOBRyGSov5m5WRXGui+eQc=;
        b=OG68P7K7bHf3WsCfxVcJ+OpH5Wxvvk6h9fA3iDsHC1ix7SM8JeULZYY/K06OVVaMhK
         sJ47TGQk9HtdVxgUP5sDh9l7yCHanu1toQe7KZLvlQUphFZfVptaHOBz43oaqDkz+6xf
         j6DT+lOTJERuq8JQal7DXyUnb1ItZLeLwfnS4w+z8HVss0ps0Yb9U1kvWSryz24cap/Z
         uaL/Ho8GClj2ZxqXTNTXRTllGZHq4Vvxsgwi4Lo2Y9DhIwjZ5juHlTeK/0vSDD+Q7Szo
         Icg1kSDs9cJS2HaEfG0GX2xHjsa7dyaEhyyb97mT6t/np2fF+ZUUH0axpyaIC0k5DSSF
         sMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684281896; x=1686873896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OiarNXqyDgLGSnRLOjyy6hOBRyGSov5m5WRXGui+eQc=;
        b=l9JPbmb9W0TsAt2590WhKjZKpp4/2FOeW8+CK/IlRrNuqBVTy0CsQ7dnjiR9Z/0ZBl
         4gZflOan2aYabjWLbvmDSRPK/fr6UIAivXzLlaAtHS14Oak1mGuGdCSaaB84mG3SKn4M
         DNSTCVuWy+9S+yepJDT3b5affdOAvTHKCapSBDvwRea62FEatoA990d5/5fbe+X+PmCc
         JzMyRRHoKaAVj6juVhqR5Hw4i+fLF/an0LOs6ZIVdcP+2Gzi6B6mTQrg5DQzmYpzDQoe
         sko1xf9hQFWRDnc572aiJqb5MuH3nDbXbZc8nikX9n6N+NlAlIobv4xk77RziCNWfIpu
         +/Cg==
X-Gm-Message-State: AC+VfDwGQTrLWd/tCPINhNdTuwpiIysBotHgm8hrVGT0zSL3ZjIP41Dk
        sB2bHvNOh57qhroKVqVVWTL3PlcC637FqsbdWE4=
X-Google-Smtp-Source: ACHHUZ6nSozRzNxlPwgSZGhVCuglf9m61nBwK8P5Y6RkDTsjX2gJE/2sEyhZXYPoCW2NkvqC8BEw1g==
X-Received: by 2002:a17:902:c106:b0:1a9:a032:3844 with SMTP id 6-20020a170902c10600b001a9a0323844mr479568pli.16.1684281895912;
        Tue, 16 May 2023 17:04:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id iw5-20020a170903044500b001ae44e2f425sm1292928plb.223.2023.05.16.17.04.55
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 17:04:55 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1pz4ez-000Lbs-00
        for linux-xfs@vger.kernel.org;
        Wed, 17 May 2023 10:04:52 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pz4ey-00Gu89-1e
        for linux-xfs@vger.kernel.org;
        Wed, 17 May 2023 10:04:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: restore allocation trylock iteration
Date:   Wed, 17 May 2023 10:04:47 +1000
Message-Id: <20230517000449.3997582-3-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517000449.3997582-1-david@fromorbit.com>
References: <20230517000449.3997582-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It was accidentally dropped when refactoring the allocation code,
resulting in the AG iteration always doing blocking AG iteration.
This results in a small performance regression for a specific fsmark
test that runs more user data writer threads than there are AGs.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 2edf06a50f5b ("xfs: factor xfs_alloc_vextent_this_ag() for _iterate_ags()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fdfa08cbf4db..61eb65be17f3 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3187,7 +3187,8 @@ xfs_alloc_vextent_check_args(
  */
 static int
 xfs_alloc_vextent_prepare_ag(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	uint32_t		flags)
 {
 	bool			need_pag = !args->pag;
 	int			error;
@@ -3196,7 +3197,7 @@ xfs_alloc_vextent_prepare_ag(
 		args->pag = xfs_perag_get(args->mp, args->agno);
 
 	args->agbp = NULL;
-	error = xfs_alloc_fix_freelist(args, 0);
+	error = xfs_alloc_fix_freelist(args, flags);
 	if (error) {
 		trace_xfs_alloc_vextent_nofix(args);
 		if (need_pag)
@@ -3336,7 +3337,7 @@ xfs_alloc_vextent_this_ag(
 		return error;
 	}
 
-	error = xfs_alloc_vextent_prepare_ag(args);
+	error = xfs_alloc_vextent_prepare_ag(args, 0);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_size(args);
 
@@ -3380,7 +3381,7 @@ xfs_alloc_vextent_iterate_ags(
 	for_each_perag_wrap_range(mp, start_agno, restart_agno,
 			mp->m_sb.sb_agcount, agno, args->pag) {
 		args->agno = agno;
-		error = xfs_alloc_vextent_prepare_ag(args);
+		error = xfs_alloc_vextent_prepare_ag(args, flags);
 		if (error)
 			break;
 		if (!args->agbp) {
@@ -3546,7 +3547,7 @@ xfs_alloc_vextent_exact_bno(
 		return error;
 	}
 
-	error = xfs_alloc_vextent_prepare_ag(args);
+	error = xfs_alloc_vextent_prepare_ag(args, 0);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_exact(args);
 
@@ -3587,7 +3588,7 @@ xfs_alloc_vextent_near_bno(
 	if (needs_perag)
 		args->pag = xfs_perag_grab(mp, args->agno);
 
-	error = xfs_alloc_vextent_prepare_ag(args);
+	error = xfs_alloc_vextent_prepare_ag(args, 0);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_near(args);
 
-- 
2.40.1

