Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58E9C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 20:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF7464EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 20:35:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbhBESxA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 13:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbhBESwf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Feb 2021 13:52:35 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D84C061786
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 12:34:20 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j21so4200123wmj.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Feb 2021 12:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v3e8Q9mjzetuic2cu0oDsGVJ6Rqh1ie+dw/kMuozkhM=;
        b=mMRvEIrEGZZItouSquE8cuTwFnmdNPMJk8xpOyUkuvH4tH8DeKE8ApmGFrS9sS8OE5
         iU177ReLE0+05N2EfBHDTwUGKK44GOS6wU0ccBY7V88WIugZ6wU8AEZfKMV1i0bde70r
         4yW/l01s2nECXXdHyxyJxnu+DLacM7mN6/OT+TlQ5zHE5hxZYluNFd2O2uQUMGh2hwNC
         YxGx+a7I25doAo23z2Cb1tmOxNgQXQ/vJRjfRln0kJT600Wx595FSnU6u1RJhgtgCGOw
         DYzLIiejHbVZwwmYfLRDmu8YJUli/uRBHNJwkq/TR+zMuRdtJPKlZOe4988PolG8p/10
         m9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v3e8Q9mjzetuic2cu0oDsGVJ6Rqh1ie+dw/kMuozkhM=;
        b=Ync2nzwxQdMsY5zplNhtVQwce2kZxuknhDyG+Rer0RKfol8Jxm3AvzO1oEEqIxMgwe
         sR8LfCxJLBp8H/FGek+kLVAzglKsAoTfifaE4LzGJqdoJf2cJMjFkDUeiL55QkyC0aLf
         o25D4kEm0segIbY3UsBQIxp/uOqeSUd2OQoo8VqitYSlvFnJVRJp2rzC0IFiUblJZmTm
         VJXtk1+1K6xA+5eRB5OVdtvIUhkXY3pGKIef5o2oMj9o8TlZ5GRkg8A99SCnT0nc8t78
         5z3s3i0XBlWA4kI07+cVHQk3/HfxlLzimNySX/8/6tvZdrXk5humbOtZ5wHZfeOAktdm
         I2/w==
X-Gm-Message-State: AOAM53140gpknhC4QPzq7yK6fJJHQmU8TJCPxsXUnazPUEAMlMbtfzaK
        fCa+Rhwv8JJ9nP5lvJgZTJPZ9da/srp/Z3RrBBM=
X-Google-Smtp-Source: ABdhPJw/UttWmStjAYZnDoRvCU+LUr04cN//XJJ2mE00YXZa8Z6SxbV/87xfVWVRwWmEEcZlnyzP4w==
X-Received: by 2002:a1c:8083:: with SMTP id b125mr4973123wmd.188.1612557259175;
        Fri, 05 Feb 2021 12:34:19 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f2cdf002a7b928337dce408.dip0.t-ipconnect.de. [2003:d0:6f2c:df00:2a7b:9283:37dc:e408])
        by smtp.gmail.com with ESMTPSA id j14sm15664985wrd.36.2021.02.05.12.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 12:34:18 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 3/3] debian: Prevent installing duplicate changelog
Date:   Fri,  5 Feb 2021 21:34:05 +0100
Message-Id: <20210205203405.1955-4-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205203405.1955-1-bastiangermann@fishpost.de>
References: <20210205203405.1955-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The doc/CHANGES file is both processed by dh_installdocs and
dh_installchangelogs. So it ends up as changelog.gz and CHANGES.gz.
Prevent that by excluding it from dh_installdocs.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/changelog | 1 +
 debian/rules     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/debian/changelog b/debian/changelog
index 2da58f30..5421aed6 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -2,6 +2,7 @@ xfsprogs (5.10.0-3) unstable; urgency=medium
 
   * Drop unused dh-python from Build-Depends (Closes: #981361)
   * Only build for Linux
+  * Prevent installing duplicate changelog (Closes: #570704)
 
  -- Bastian Germann <bastiangermann@fishpost.de>  Fri, 05 Feb 2021 00:18:31 +0100
 
diff --git a/debian/rules b/debian/rules
index 7304222c..c6ca5491 100755
--- a/debian/rules
+++ b/debian/rules
@@ -87,7 +87,7 @@ binary-arch: checkroot built
 	rm -f debian/xfslibs-dev/lib/libhandle.la
 	rm -f debian/xfslibs-dev/lib/libhandle.a
 	rm -fr debian/xfslibs-dev/usr/lib
-	dh_installdocs
+	dh_installdocs -XCHANGES
 	dh_installchangelogs
 	dh_strip
 	dh_compress
-- 
2.30.0

