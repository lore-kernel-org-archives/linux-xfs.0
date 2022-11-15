Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7935C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 01:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiKOBaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 20:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbiKOBau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 20:30:50 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D276143
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 17:30:49 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h14so11949032pjv.4
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 17:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RAlz7tqq0QNaEwK87s1iuzIYezDUz9kvZQYKXkSLXDo=;
        b=sd9UI1HlQaNvLFt5yYvNRsOv7VflJP4IAUrhnHE7flexeeuoQ5hP8TKmCc+BaiIfMP
         ZiRGlgPAXhmbHSKa7yVy2L3lIOlPynkkJEHtQmdc7TRdfpUE6pywh2aPcPiv4GoVLz0Q
         zd0iww4tAvO4mJl3M8G/RaiY6Ava/FpH3GuKDApgHTJPoSxt/5F8/qZBvVpNgq1A8Prs
         fHl1IL0/KmUzftODKT8X6Jm4m4ecva0wyKgRR8mwwBU4D5J7BY/i/6NoDYqBkj3VD1qD
         r5la6S0xsiSZSjAQpJVXSlemhOX2B55pAvdhXhpwAkHkFieaYn2mwZYDwfepK+WLZrd3
         Y0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RAlz7tqq0QNaEwK87s1iuzIYezDUz9kvZQYKXkSLXDo=;
        b=FTPTsPNUyvnBM5xfgs0XUL4Oxxj5QkOG4xi7XBJt6FgptZn/uTfgNZxvo1/jHYjSJW
         s/kWzR3ICPngJifsuGSOWqtHi6i4EUFYMRPJvxIFXEly+7gBSaQkLw+jhFX86vLmAr1w
         uVoNgGuTpoLsHBywvUbgCDu5+msObrkuyJSs1o5N/CKR4qHTP1q1p+R/myxlZmlpd35p
         VdGEJZMWlp0zW/XIq2DcOL0q80afPfh441utuwiEpGCqJz9OWTo9bbRwzXBDktt6CH9l
         k2+nv8L0M1VifTpxOunmahFP77bVMGpWeDMBOOz6cRrHUXudTysRh1fKFD4c9fnsFVTD
         1Pmg==
X-Gm-Message-State: ANoB5pmg4Tj0deb1q4EvAydA53xi8b98BwmtcYNeJTlY4/X5FRS1R/BI
        kZ7Hzk3QzzdOacFzQkTbs/rxTJnJEjAcGg==
X-Google-Smtp-Source: AA0mqf7VUafnzdFgsn+0nyI7dq9zs5JPeB8q0hRVxivQdDOKjWJ/q10BkeaEXZRzwUNmnCwRvxAnNQ==
X-Received: by 2002:a17:90b:4b4b:b0:213:2262:e3f8 with SMTP id mi11-20020a17090b4b4b00b002132262e3f8mr16127935pjb.82.1668475849114;
        Mon, 14 Nov 2022 17:30:49 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id w3-20020a626203000000b0056bc31f4f9fsm7390484pfb.65.2022.11.14.17.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 17:30:47 -0800 (PST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oukmj-00EKFu-9H; Tue, 15 Nov 2022 12:30:45 +1100
Received: from dave by discord.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1oukmj-001VpE-0o;
        Tue, 15 Nov 2022 12:30:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/9] mm: export mapping_seek_hole_data()
Date:   Tue, 15 Nov 2022 12:30:35 +1100
Message-Id: <20221115013043.360610-2-david@fromorbit.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221115013043.360610-1-david@fromorbit.com>
References: <20221115013043.360610-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

XFS needs this for finding cached dirty data regions when cleaning
up short writes, so it needs to be exported as XFS can be built as a
module.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mm/filemap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 08341616ae7a..07d255c41c43 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2925,6 +2925,7 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
 		return end;
 	return start;
 }
+EXPORT_SYMBOL_GPL(mapping_seek_hole_data);
 
 #ifdef CONFIG_MMU
 #define MMAP_LOTSAMISS  (100)
-- 
2.37.2

