Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3230C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9574A23B76
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jan 2021 18:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbhANSim (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 13:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbhANSil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jan 2021 13:38:41 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9DEC0613CF
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:01 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id g24so6784247edw.9
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jan 2021 10:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YG2qOQEUCZqCD5HfBMqIaIA2TQcta7x3ZeF3efpx3R4=;
        b=hpsSfAQqSv4osphoD2R/Kl8d4MtQet1MsPc8obxh8kPOownbKNPidBvx9B/pAdOElN
         pEOFRHOgRbBdyTgScb2cu60zSQhplzsgGNLxjJE4XxQjpaFleROM6EmMEhqX2LcD9etc
         p7FOTqF0aPptPbUJp4n9wzNV7Pmtc6kTkSN1p5AZAtIf22ZpX9AboZE9GElduDTx2FU0
         4lEX9zM8uh+V3bhwwlehInXxXvhuCRJi3xBJnCbiPt47axWBIbTLqtmPkz/i8uY60mHT
         Z018jI2pPVX4Ewr0n6lwtgBFx9TO1d6r1ozCf2twHQYU0DODu+sNBGs4CaTXxrw8XjiS
         GMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YG2qOQEUCZqCD5HfBMqIaIA2TQcta7x3ZeF3efpx3R4=;
        b=IdDOiOm6yBBCPoQx2Ico4S3FvFeV3SYRSW6EOdVSKNe0BxPjckpGvy5eI5CupwmhOB
         LZLz0UCHNC/Ug4DSEIyRDiz1CrJRCLiy2nJQ0NIecWf6SW7Ir3Mpl7TsH783UWb/s0iV
         X+Yg3QeOqmYpPizMWW6h/QRNchno/lHuvxAki8yqMX+PYizW4gFniDlZPXBYnHBiix+q
         heH1gEGuItS3Ctda95X8Nv3HTFtkQcKps7mzSV1JHVcL5x0PJKmGJW3bsCMGr5Z16pFR
         3EIhZdhic8THNwJxGYj3lZb5BJqt0dgWOvVVigcl5VVf25bWRf0Ie5ylhfc75hx6fU0o
         KQsw==
X-Gm-Message-State: AOAM531nOc0BVMhpEspksCKhMszXjq7CUSLHTTEpH362ZQGl5yTXo+ff
        1cg3DQ9Dt5ULATRRTccz9dlncUly/Y2RY9VG
X-Google-Smtp-Source: ABdhPJww/waJGIE2GQ2jxqIYPhLXN0fFYVq8cvF7x/+JG4dgkId+fU2MeNjqUMMiamcwh0EptNiuCw==
X-Received: by 2002:a05:6402:1b1e:: with SMTP id by30mr6705421edb.75.1610649479796;
        Thu, 14 Jan 2021 10:37:59 -0800 (PST)
Received: from thinkbage.fritz.box (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id s19sm2540876edx.7.2021.01.14.10.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:37:59 -0800 (PST)
From:   Bastian Germann <bastiangermann@fishpost.de>
To:     linux-xfs@vger.kernel.org
Cc:     Bastian Germann <bastiangermann@fishpost.de>
Subject: [PATCH 2/6] debian: remove dependency on essential util-linux
Date:   Thu, 14 Jan 2021 19:37:43 +0100
Message-Id: <20210114183747.2507-3-bastiangermann@fishpost.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210114183747.2507-1-bastiangermann@fishpost.de>
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Essential packages must not be part of Depends.

Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
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

