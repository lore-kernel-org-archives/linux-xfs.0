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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA537C433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 11:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B12661A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 11:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhCZLdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 07:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhCZLd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Mar 2021 07:33:26 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E60BC0613AA
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 04:33:26 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so4097004pjb.4
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 04:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1cgrMeN5iKsPRXbu6/ydLfG/xTeC+RRkt1Jy99PvYe0=;
        b=diEjVzhUTXsFIEOFx/XGR1cxa2ZODtBgniYtNroMuChMfz+sR2hT1hI49+Ehk0+Mb/
         CzewzFgGxQeInQWj+47beKByqaH1YsyIfKThUNkq7J1J267d9gYbrrjcRa/yy0fEULgk
         0sO2ekoZ8fffNgRPJ/iyjd2XsObr4kQF9PEu9QiZOBGSmNsMShPEfyxH9KBMRMBIPJDr
         14XUE0lias59Q1HDV7DRbfzQpOR4VGuPoxjI3I/YCUkGsILXTcktbBPsCAoAU9JPZKDl
         meB7llV3dMIzeiHppvIY9OxXNkYQ8aeIiJpCc5C2w9pJeTSTgJ9dmTF5iEMzu9o3HAi8
         /Yhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1cgrMeN5iKsPRXbu6/ydLfG/xTeC+RRkt1Jy99PvYe0=;
        b=bjCgQYr8la/phCLMb6c38Ezpgg8hQK0Bth5nCkFSEQqc7Wsmpouvq16XYG0PblAWdA
         BwWHF2zLlKb6PFEjfhppaUZtwl6TyqrAdjIxi8LzbDYXXQszwTl2GG0O8M0hRFW8i4nu
         CHsj5F44Xuy5VuKLyyFlPROsqz0p8ofD/RAWXVIC22N7HbSWpMFNSO0GK9/K7AYxzsT6
         aGMy6eHISFu4hEElmg9s54SigzZbvdBC/fsxLnJTW9ABVK9nmpsv3p6zIZ5Y+X7oFPOY
         q/fRy9A7YW/AinJmx9ebEl29AHHuubZygyfpf99pkgYd9CeotLThW6V8zd35+UxcYjDP
         ckLg==
X-Gm-Message-State: AOAM530Ti5BMm0vVRQWh7RSDaivMPib4nVrrVk/1DcSRWIWAaN3w4fuo
        TBfrNFv43nFsDg/meNie327o55+4ftk=
X-Google-Smtp-Source: ABdhPJx8jJxKWs8VbvBF/XdbTQ8xrFJyB1ZdXaG42zNz0eiSTnYj1Mc2qTmspanGxkOX3m4HVzhaow==
X-Received: by 2002:a17:902:c317:b029:e4:aecd:8539 with SMTP id k23-20020a170902c317b02900e4aecd8539mr14843306plx.61.1616758406048;
        Fri, 26 Mar 2021 04:33:26 -0700 (PDT)
Received: from localhost.localdomain ([122.179.126.69])
        by smtp.gmail.com with ESMTPSA id v23sm8457625pfn.71.2021.03.26.04.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 04:33:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH] xfs: scrub: Remove incorrect check executed on block format directories
Date:   Fri, 26 Mar 2021 17:03:12 +0530
Message-Id: <20210326113312.983-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A directory with one directory block which in turns consists of two or more fs
blocks is incorrectly flagged as corrupt by scrub since it assumes that
"Block" format directories have a data fork single extent spanning the file
offset range of [0, Dir block size - 1].

This commit fixes the bug by removing the incorrect check.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/scrub/dir.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 178b3455a170..3ec6290c78bb 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -694,15 +694,6 @@ xchk_directory_blocks(
 	/* Iterate all the data extents in the directory... */
 	found = xfs_iext_lookup_extent(sc->ip, ifp, lblk, &icur, &got);
 	while (found && !(sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
-		/* Block directories only have a single block at offset 0. */
-		if (is_block &&
-		    (got.br_startoff > 0 ||
-		     got.br_blockcount != args.geo->fsbcount)) {
-			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
-					got.br_startoff);
-			break;
-		}
-
 		/* No more data blocks... */
 		if (got.br_startoff >= leaf_lblk)
 			break;
-- 
2.29.2

