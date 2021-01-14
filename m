Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB5CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1740023A55
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbhANSjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 13:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727323AbhANSjK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 13:39:10 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A34AC0613ED
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:03 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id 6so9685064ejz.5
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uiWFF1WXxbuqatW55z1tGAg8+yFundsWs96AERqoFsw=;
        b=cN8EqZC0jutsoBp7u6OioSE0An31GtZe3FKX5QQgaJsn8vPf3z3UbUVuswXjYgk8v7
         ER6U0LlAnrV5D7/7r4s6ougX154NoEVAJ4WDAoyfkJKIj5tjGVz30vOepaoz7Irq/swm
         6N8AE/jFTDJOiOyXlQ9hp+DJ94Zff7Vz6Mj7bNu8CCgrvpJmrH/D92N2K01cqGmu2o/G
         Yaocovww9O8OqUeCB+aV1Ktz7EdxJoIPs0IXxfInLsrk2GVaeLIxJlOw/UbGMLwIxbV1
         H/3zRSt3c0caTCect4JDAn0+yRsiLJmjuNjODVwt4NaqYci9UewsM6nWC86GLRZHVIKt
         5IeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uiWFF1WXxbuqatW55z1tGAg8+yFundsWs96AERqoFsw=;
        b=AM4DS7YxmLyocJkFSnb/+Cwp02GsQ4H/zMyKpTyO66iEYm+39CEY+/9aLgLmkC8zQe
         hzM1SV21DK8J4WN/az4QhDxOLesuubvFx7PEKJpZUrYHS1ePdvzMq9yKrOr4OIKkYlqS
         +PeVn9Pmp7iNRFjEBPKeEBwvuW2YOUhTdxmYXY9/PRcZKuekJ76s2LtHoprslQ/vX4W3
         FNeofZWHL3OHYXOUyO5XHsSlrmJNplgPc/u2ZW760PlTR7AB2lCeKwIr2jWB5HyoUQH7
         yjmvsbIQHeU7Fe/NxYqmzLxWjYe5uIU4+1DsxrI5FCDnWb/4ZboFcc0YzBYZV30lE2Jr
         NURA==
X-Gm-Message-State: AOAM531UDsf0eBWXf9SouJFDXW7UPsW3xolXyY0O2ucpUnwKM9sm87Xm
        xyEznurkPTyJMlLX0RZpDK+BiKQuQe64vIyg
X-Google-Smtp-Source: ABdhPJyEKnlZwpHelbhQQHXFuZnPIj2pKX0vtOCaA5R1XrbfpVugtsGfSQwLaU3jKFs/r0l3Qd89yg==
X-Received: by 2002:a17:907:1701:: with SMTP id le1mr6380970ejc.68.1610649481723;
        Thu, 14 Jan 2021 10:38:01 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id s19sm2540876edx.7.2021.01.14.10.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:38:01 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 4/6] debian: use Package-Type over its predecessor
Date:   Thu, 14 Jan 2021 19:37:45 +0100
Message-Id: <20210114183747.2507-5-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210114183747.2507-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The debian/control file contains an XC-Package-Type field.
As of dpkg-dev 1.15.7, the dpkg development utilities recognize
Package-Type as an official field name.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 64e01f93..ceda0241 100644
--- a/debian/control
+++ b/debian/control
@@ -47,7 +47,7 @@ Description: XFS filesystem-specific static libraries and headers
  for complete details.
 
 Package: xfsprogs-udeb
-XC-Package-Type: udeb
+Package-Type: udeb
 Section: debian-installer
 Architecture: any
 Depends: ${shlibs:Depends}, ${misc:Depends}
-- 
2.30.0

