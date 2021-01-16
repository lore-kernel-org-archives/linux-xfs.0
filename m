Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF3CC43381
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EBC123A56
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbhAPJYk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 04:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbhAPJYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Jan 2021 04:24:38 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5DFC061795
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:58 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id r5so12163362eda.12
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ULOH5s6dReLbr3HeSiFMXBhhLmhbzRkl1iTcb8z/TQ=;
        b=hP9g3csXLZF8Z8Ia9jPOmFA0a4nKxsduV2vsnbdSi3TNOcuWEbBflqsgpiQ1BPtsGU
         Tsf6kv35doBRu6QGYNBTrojRtpE5xF6iR+aYcarhA4iO5V+t5tj0I44u8q9ZbbP7ofuT
         wyxdNji5tIdFeIAIqIQ07u1/xsdErob2p6MJJLpXkodccgra79+WMqJBxpFk5m+0G3X2
         gQAmj3jkCT5rHEUV7OAykj3S23ochFQQL+ICUqDgtcHQdqaXZSfa08GyGwXHrCEqV+QU
         J1XMUHX0PpfN+Mkw/MbeoUoMQ7yfydhhRdcRFfU7g6nqW2xQP9MkEWqRHHJQf5wLiUVk
         ccng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ULOH5s6dReLbr3HeSiFMXBhhLmhbzRkl1iTcb8z/TQ=;
        b=PcsRvyI646rcJmwDZVyW0PGStk2c/JgAU6LuzG5eMRnc0cZpz/Km/YvHAPhyhUCnu3
         0uB3ZqCE9uyVsYKRZVXGOeNI7jlzTafLCt6+NSJ0QPGZUVHyPifbgXFJBnfrHzTWdTVm
         XPlD/9Kxp7SHaGThXFYeJLkC5fnEXxpZiinS4FgJCtqDZIGdLo1mKOMmQDDxdPCTLQnI
         yxqTH/sG5lartQ5SIccaQJ0aZG8+8wRwU4Q37OyS3zFS0LFVp+dV/CNlNiEKq7zcxs1Y
         h0L1arQu9U6XBR05H3n2Rg86oWmbhHGnp4hx9FAp0SsSvrGLYcC/Cj6I61DpsQuo4faf
         GKAg==
X-Gm-Message-State: AOAM533QPig3WM3yjI1fJDgACvEhCLxZc0zCjDthsWzXSQZkmnUr1Njl
        sMqVqqE/mTezLw6MWFkYMiLdLVlzqlDDNvQZHNc=
X-Google-Smtp-Source: ABdhPJzXSeDsU2mygzRwKTBGvJ5v6QAQyIdAV3Rmxezl39VEv4dsTynwqYSo8HkKkEvcNIQweOsC2A==
X-Received: by 2002:a50:fd88:: with SMTP id o8mr12750970edt.386.1610789036804;
        Sat, 16 Jan 2021 01:23:56 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id j25sm6166851edy.13.2021.01.16.01.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 01:23:56 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Nathan Scott <nathans@debian.org>
Subject: [PATCH v2 4/6] debian: use Package-Type over its predecessor
Date:   Sat, 16 Jan 2021 10:23:26 +0100
Message-Id: <20210116092328.2667-5-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210116092328.2667-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The debian/control file contains an XC-Package-Type field.
As of dpkg-dev 1.15.7, the dpkg development utilities recognize
Package-Type as an official field name.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Nathan Scott <nathans@debian.org>
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

