Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0B2C433E9
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2244823AC1
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Jan 2021 09:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbhAPJYi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 04:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbhAPJYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Jan 2021 04:24:36 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349E8C061793
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:56 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id b5so291279ejv.4
        for <linux-xfs@vger.kernel.org>; Sat, 16 Jan 2021 01:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0GNxhDPcdqFlwhKT3GOf3pxhYRVavZb39uUB5ql+2X0=;
        b=K++DUdaD+P24iIUQL0QuQPv4TpPD2YV7HyHldjuDBXGm35Q6WSL8wXJRjRIo09HefR
         EAKnHhKJ1rtetHrZUhfZDEQnHZgD8AdJQhEvjshbW5/1tFleZ2FS+pjxwEmN10h7SI07
         pHrFive0S3zg6UOs6TOb8DJToQdGQjeeQSWKV76O+M3+bHg9x/0jAcvw5NskaPanKtzj
         H2TYNuUVsc7EppO+YajyihYUhL09Gh1OfCYVqf4kMC4/Db9RaqRaC2+PLfxpGE365axB
         jIUH036gdGR3f7xJZz2/AtyCqNBVnMZcpe91/DcuFJtDdPVZJu8W8rFEqGTsonaGSF3Y
         0MrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0GNxhDPcdqFlwhKT3GOf3pxhYRVavZb39uUB5ql+2X0=;
        b=LzZQ2Ru4wmC2oJfLAo55DrMjo+4+K91BiMyXlPjYLddNJ6sttGKNpKfED3y3brV+qQ
         NbkkPy2bAM0pDIagJYwJyOLPm8YdfRiwXhhN3n2wUzkWuB2sjPRtMr6MBQ8BVN68LVSj
         A56sYFJNulGaZ1XXFHxOyLyIG71wLRerNW2U6bS1VZnf4/CXb4WrzeEZlL6n1dhMgsNT
         0UUi/0V2Yz6zB8CVqbGGRh+rz+XIO+6allGsENs2enFAOHRaYHrexJ2UnjiCQpj2qeGI
         w8Hb4TeNs4WSS7kizyfYVAJDFWVImgFZwgegxVOyqLWO2wLkOjTnfiHxl9CJyQ2u+oLV
         gjjw==
X-Gm-Message-State: AOAM533u2sCCPQgC91xaW+vf7oSEEedx7+pD4iDHcSRYEZAuESjnZ1Db
        SnrqXU351Qymh+taZYfRDKaml58lKWVD9fwwYEg=
X-Google-Smtp-Source: ABdhPJyygK2oz6FQNCDuBI/yScuzTpooFrecQkA4+wp11OI6eL7TOjyUDbfbwKPFJAi74v5MysBGEA==
X-Received: by 2002:a17:906:65a:: with SMTP id t26mr11266005ejb.394.1610789034600;
        Sat, 16 Jan 2021 01:23:54 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id j25sm6166851edy.13.2021.01.16.01.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 01:23:53 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Nathan Scott <nathans@debian.org>
Subject: [PATCH v2 2/6] debian: remove dependency on essential util-linux
Date:   Sat, 16 Jan 2021 10:23:24 +0100
Message-Id: <20210116092328.2667-3-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210116092328.2667-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <20210116092328.2667-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Essential packages must not be part of Depends.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Nathan Scott <nathans@debian.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 49ffd340..34dce4d5 100644
--- a/debian/control
+++ b/debian/control
@@ -8,7 +8,7 @@ Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 
 Package: xfsprogs
-Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any, util-linux
+Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any
 Provides: fsck-backend
 Suggests: xfsdump, acl, attr, quota
 Breaks: xfsdump (<< 3.0.0)
-- 
2.30.0

