Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06029C43381
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D02CB64F39
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 00:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhBEAcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 19:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbhBEAcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 19:32:18 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81129C06178B
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 16:31:38 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id df22so6701894edb.1
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 16:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SuZhJG16Es9dOBi8ABFuE9AkbK96Su/H9DgXmSUItsU=;
        b=iriX5Z1eTM9m/ZGKCAWmV45LXQz4ujLjWqX9vvQhzJa305JsDCK8R/UXXTao80pfrh
         DjSP2FMa6rK4Dh1uDrN+S7l18lO3SF42nRnJ2c+AGBiQEGAjGUCqd6CA6QEmxwugbhIx
         WdGmMTijDyVYBglgK7MWmQGbkjclxsLd8S6mNhxq6noNDkQZ+kkHBh1mrDw0RwrQsEiJ
         v6QOQZz86usQioJ19X3RkJL9KAxpt3JkKiCYVa9nvWnGUh37BKHVN5S3kD1ZrryG133m
         OeG2U1XbKAK1EPI10HPf4hLxq3TE0MBi1MHr5NYInJgDMeF60gK/nMb+cc13w7egeu7P
         a4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SuZhJG16Es9dOBi8ABFuE9AkbK96Su/H9DgXmSUItsU=;
        b=bj4MVqlxlR61+eBMo57Ou1qS0E+ozGzznVpNpSB4Oc9DSgv3O3Fmw0H8L+yedd0JOW
         1K4+qdbngvNfhhsQBfmNWsbl9dhT5ZsT1KT09hMn7mibbILov28MGSavFzuNZowJTACZ
         lFGu3EcY7peWyaHPjpgINMqxzKQw4nG16GNEpGNtrtd0V48ywPeBdwB1ClvJZSz3EE2j
         6TDwBLX/OIXnVqL5LEklZzykmZ7keRKmPkfkM6QLZhi6cw8lISHb2Pq9TCT511wHp0Kv
         ZQxevCRLjgXvBEq7xdD6dlh1RY/q+0UsveNw42PkGTiFqDcDyLMSxzk2G+d/SQSE8viS
         WROQ==
X-Gm-Message-State: AOAM530oL3pLNEjfpgNSrgsFJ+/iOBhF9cDquy/RhmfwOKObSwYbHuox
        oEvAHmXH1iXM+VbLnj58HEpBhvQaOqMGABQz
X-Google-Smtp-Source: ABdhPJwfH/H5DAnGo4twulpEoQvcxdh2TrHFmLNhLYIJLd8RLLEhXzxivpbpxs8v0FGi0A3BFF8zOg==
X-Received: by 2002:a05:6402:1ad1:: with SMTP id ba17mr1104752edb.243.1612485097257;
        Thu, 04 Feb 2021 16:31:37 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id o10sm3202222eju.89.2021.02.04.16.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 16:31:36 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 3/3] debian: Prevent installing duplicate changelog
Date:   Fri,  5 Feb 2021 01:31:25 +0100
Message-Id: <20210205003125.24463-4-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205003125.24463-1-bastiangermann@fishpost.de>
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The doc/CHANGES file is both processed by dh_installdocs and
dh_installchangelogs. So it ends up as changelog.gz and CHANGES.gz.
Prevent that by excluding it from dh_installdocs.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
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

