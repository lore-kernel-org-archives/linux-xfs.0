Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1987C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 20:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7810664DE0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Feb 2021 20:49:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhBLUtq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Feb 2021 15:49:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhBLUtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Feb 2021 15:49:43 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C82C061786
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 12:49:03 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nm1so287594pjb.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Feb 2021 12:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NmQFrZlJfiXLBCpp9NV52peF7xoKxGjyr9s0m2wdiro=;
        b=gXLneOWIx7WQiB/0isB/IWhbzD48ZTWG7O5ExDx4qpMIeIdCr22v+wfWao8EmNa7kX
         BhdnK3lmGbWBcU5HI+4axrc5JqYe5kCVzF1C0JwVLUiHyt6FO+aLc30Rz6u9VWfRdHkU
         l4YnbxH/JnSTZK8HLGwTRm/UEjS3pzwA+i7QI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NmQFrZlJfiXLBCpp9NV52peF7xoKxGjyr9s0m2wdiro=;
        b=Ck7mNbWIXoBp3E6uBPZHMoj6G/8sobDTOCa+H4UTCfDTH0bPzCYkERhHNaQwJPiVOl
         6cA/ja/a8CZbyXCiTTVdYhJ+lHCuse4V0V2N3+dK3xk2DjJCiKtCkP0buOU8AYxXS0ti
         OG9gEp9twZYm/w0UJlhN+jqambIj3iZ+ytYGT8a6TO2nkfZbqD5PTxejd13t0yhmXi4l
         vtIbNg8hHoTP7qwBrWJNkFkDy5xKDUjs4zJsRLY4apmnSL5s9ars6A7FJmNo7lMZOBT/
         r1XOb6S4bkrcQVxmHqIwFCqlJJxZa0psoyPy0ipESdcu1dtYNUr/BBp9rMk1y+d7H7Bi
         movw==
X-Gm-Message-State: AOAM5325qV4Dzd6vrphPr3nUsT02gdbYAQ+bOzhsSOVc7ovOHJ2gknPI
        Pc9MFaMgg2HXWiTy9to5Wt1ia9scZU+PEWyQ
X-Google-Smtp-Source: ABdhPJzSxWSB/df28vh1idhrq2R0UOOaF6mM/e5QAk0yRIefcrahD4jb9fR/AK7NSqEkdt7Jv+GBFQ==
X-Received: by 2002:a17:90a:4f83:: with SMTP id q3mr3750003pjh.38.1613162937559;
        Fri, 12 Feb 2021 12:48:57 -0800 (PST)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id v126sm9933992pfv.163.2021.02.12.12.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 12:48:57 -0800 (PST)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
        id EC3D7250F5A2; Fri, 12 Feb 2021 12:48:55 -0800 (PST)
From:   Markus Mayer <mmayer@broadcom.com>
To:     Linux XFS <linux-xfs@vger.kernel.org>
Cc:     Markus Mayer <mmayer@broadcom.com>
Subject: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the very end
Date:   Fri, 12 Feb 2021 12:48:49 -0800
Message-Id: <20210212204849.1556406-1-mmayer@broadcom.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To prevent issues when the ".o" extension appears in a directory path,
ensure that the ".o" -> ".lo" substitution is only performed for the
final file extension.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
---

I ran into a build issue with our setup due to the original regex below.
It was mangling the path to header files by substituting ".o" with ".lo"
one too many times.

This patch resolves the issue. Also, it seems like the right thing to do
to limit substitutions to the final file extension in a path.

 include/buildrules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/buildrules b/include/buildrules
index 7a139ff07de8..357e0a18504f 100644
--- a/include/buildrules
+++ b/include/buildrules
@@ -133,7 +133,7 @@ rmltdep:
 	$(Q)rm -f .ltdep
 
 .ltdep: $(CFILES) $(HFILES)
-	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
+	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o$$,\1.lo,' > .ltdep
 
 depend: rmdep .dep
 
-- 
2.25.1

