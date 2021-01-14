Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCD5C43381
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6715F23B6E
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbhANSin (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 13:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727622AbhANSim (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 13:38:42 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6681FC0613D6
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:02 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hs11so7338188ejc.1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SIvhgSiEwvXsUw1+Vr3445ssogV0LpFGNLT9ayjSu2c=;
        b=BPO4JTUteD/JZnaaJ414eHHHW4grcycX70JlnuCF5Yl3f3fMT5QO9w4o1Cm3Fe0KU5
         vzKEsxiqTJMJb7UyfN+c4aSI24rETh82YsSN6jni9t4qI82P859UHcDTzWjLyiZsZ6rG
         zACtVKrOvrnHh9EyT4YNUNi6gj37YQr763S76luVtsze+M/8S3hXE/+fHfMS1aZPFKup
         R6Ge6uromfoZS7B15IShDHO19J3RBIKw/yYDDPF3R8P3mLdkj9+E2RZxh6mlEokkx98t
         luS/tzX0YpAnPQVj8cSR+oe9acupmfxtylk2EZN62AEQIm3TOQvs3iReGo+fbBRwoBuC
         YNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SIvhgSiEwvXsUw1+Vr3445ssogV0LpFGNLT9ayjSu2c=;
        b=Hxce2xWkkAvCPdFyVOTP58AqBQHgR3BanvfREBx0b6hNFmeHmi/hMW95BC0GX/MF8N
         4FvCByeCTISHdPdAn9Nq7YL0RGkivRZO7w6L47E+/BX4XKCom7jDF0gTXC4ocpvplej2
         i/3VN4LHZW0p0DrswM1ewtbjG19QQRiApipSOdmVbEQId+yP9TNWYmW29bT1JHJbh8Yg
         oQEN6glAyBNgu6IEAJSGriemOFlm1EUTV2aOla1A3cdtKzUoIwtddpqTXstJr/s7ykFY
         vEMwQkgKRr9EbAFLtaV61Sue85rKFvsMdybNhRygWhz0AG4nrL9PF4xWYtEV6n1LQCxI
         tdpQ==
X-Gm-Message-State: AOAM5317wrLow9h+rG0plulhs2GxzcbT/9IW4D2/h6zc23c7rraSyRsc
        9AtwDyU0I8PurhakcniNp5RvxLbCqYvrSBfS
X-Google-Smtp-Source: ABdhPJxgnFx/p493JOJjDNQHwgOocCm3+fyojw/tU+S0olmJ2f/v5yTB8oC99SXoTicjxXYWDf4UmQ==
X-Received: by 2002:a17:906:c349:: with SMTP id ci9mr5036239ejb.198.1610649480829;
        Thu, 14 Jan 2021 10:38:00 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id s19sm2540876edx.7.2021.01.14.10.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:38:00 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 3/6] debian: remove "Priority: extra"
Date:   Thu, 14 Jan 2021 19:37:44 +0100
Message-Id: <20210114183747.2507-4-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210114183747.2507-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Priority "extra" was replaced by "optional" which is already used by the
package in general. There is one Priority extra left, so remove it.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
---
 debian/control | 1 -
 1 file changed, 1 deletion(-)

diff --git a/debian/control b/debian/control
index 34dce4d5..64e01f93 100644
--- a/debian/control
+++ b/debian/control
@@ -29,7 +29,6 @@ Description: Utilities for managing the XFS filesystem
 
 Package: xfslibs-dev
 Section: libdevel
-Priority: extra
 Depends: libc6-dev | libc-dev, uuid-dev, xfsprogs (>= 3.0.0), ${misc:Depends}
 Breaks: xfsprogs (<< 3.0.0)
 Architecture: any
-- 
2.30.0

