Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F638C433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E58F923A59
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbhAPJZR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 04:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbhAPJZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Jan 2021 04:25:15 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EACC061798
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:24:01 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b21so3389243edy.6
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fn5shVfYZvS8NJ4I525Fhfp2mkntPIvZjnS1hv6w66w=;
        b=I7KJCUsH7igPe1ZFnG3P/e2soJ1hCWoqPjqSMyq7ShTjrAH+Qy1QAOTblrX+3pdjzy
         lm0JaR488h818AT2/xSJ+2s87T9Row0MTpk6p85BrZCpXE4EboL1tPA/qnex5xAxxRkR
         3VLH9KZp1f60UUt7LbArdtCkzC0nsmVKWAfaxE3dLJ7vUVbGXHNdK2/19ebt0GqYABW7
         lCKU12SNSWKSykIKN3xYsoG987jLZvnXsFlYXbtlc7f6tzE0SUoJVqLxWuveQhIQ55en
         sufQbsUIm7WFMaQhqjp+Fv4eGGYlY9CYG4CQaws5SjKkKPJp2UiOuu2W1yFI6QiEKvRA
         t6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fn5shVfYZvS8NJ4I525Fhfp2mkntPIvZjnS1hv6w66w=;
        b=iJ4lDGnSKv6YEjcJ/Hxag2WC/QiQBGMiKsD+00Tiyku143b5P0PAKIqHV7nEHTDvca
         GeFJlTRYEM0MRT+eIVj0fbATf1nIbBYV0Uwuzndzlxqx6na3+I7bTEBOB/e0B0QV2xLA
         acZan8bbHHob9NxszR/c72JZ2I1cPsWQveG+aEw+Y4DrkULVD90+yNQdGlgTplJmUMP+
         cSPEGt/9qj4JzQxMFrVDX1myUwYv3ZlyUpzfpXmS49f3tSt7gJzJT9Y7Rhn+N7qb0Bn4
         Xp0XD5toOlbnxo3Zl2S5F8aYhLty/a69OREnwU9ZIRqQl55q3Gj+Hc8Rhb8jBrFyZAPy
         ZOIA==
X-Gm-Message-State: AOAM531+U5h3L1wOVpq/A5zMwddJe3ALUQwtsZLkpH/OChAPcXdrknVC
        fNkKOOHViU6n4HgoWYsTn+38F4jte7VJbGkg
X-Google-Smtp-Source: ABdhPJz3qLCVlRqaYjEvb7hbiBOgf9uKlEByu7cLtUJmjariaTja6tu1VNez+LJhHXNKTe2PBlDndg==
X-Received: by 2002:a05:6402:1a2f:: with SMTP id be15mr12900100edb.209.1610789039918;
        Sat, 16 Jan 2021 01:23:59 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id j25sm6166851edy.13.2021.01.16.01.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 01:23:59 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Nathan Scott <nathans@debian.org>
Subject: [PATCH v2 6/6] debian: new changelog entry
Date:   Sat, 16 Jan 2021 10:23:28 +0100
Message-Id: <20210116092328.2667-7-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210116092328.2667-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Nathan Scott <nathans@debian.org>
---
 debian/changelog | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/debian/changelog b/debian/changelog
index 5d46f0a3..ce4a224d 100644
--- a/debian/changelog
+++ b/debian/changelog
@@ -1,3 +1,14 @@
+xfsprogs (5.10.0-2) unstable; urgency=low
+
+  * Team upload
+  * debian: cryptographically verify upstream tarball (Closes: #979644)
+  * debian: remove dependency on essential util-linux
+  * debian: remove "Priority: extra"
+  * debian: use Package-Type over its predecessor
+  * debian: add missing copyright info (Closes: #979653)
+
+ -- Bastian Germann <bastiangermann@fishpost.de>  Thu, 14 Jan 2021 18:59:14 +0100
+
 xfsprogs (5.10.0-1) unstable; urgency=low
 
   * New upstream release
-- 
2.30.0

