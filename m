Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA420C04A68
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jul 2022 08:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiG3IIE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Jul 2022 04:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiG3IID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Jul 2022 04:08:03 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A711275E
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 01:08:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o12so6438986pfp.5
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 01:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Wgt6oR4f2Adhpt1wzqnD0TYY5nDLYXUgNYQYuV2wvd8=;
        b=WRcI1yHSNsRrWg0shYrXzqNzNb+uz0tV407Ma7p2ClyvO9VBb+YQSRUpjdXwVdyeu7
         w6l8/Wtg+Zo7ObK0UOsAZV1v4v22W+vuQDfk5qCBYqwTB+oE9TDj9WMXQO8bLbKR2Zkp
         ToUXAI6/dgfSIl9wyiiOPD2a427wgLKF7k84OIRWdsz+q8kV/Idy3oZ63nkbytXfxhA6
         OudrmnklXGbnn0Jduo7ewIX3NJYI0kyVjPstVWMNy/3G8i3IH3laPxbc43KYYSOTd8bQ
         uScpqCVtySwk2RyjO7LObZppUgr1apfIa58yaUKwtL4LOOBJuh6Co/qj+0LyeeNJOmVK
         Z8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Wgt6oR4f2Adhpt1wzqnD0TYY5nDLYXUgNYQYuV2wvd8=;
        b=qSyz5k2aoOA5H0nRczgMST+PIE14Mes+FxX4vsJYvWERwhGjhxXtfbpU88sx2XERh8
         B/Y7daPeDT/gmdykryRjI094z/fmKtPMfYcxoReEmVZRMeLuoDUUA/uukmTgGbBBk100
         OE0AwhR25KDR8oVHCIbGsLiqwY5UjcrgmiRVOiQ9wbzEvzeU+AZKc3yOs/bDkSfY235O
         4ZZlYexp/sgSfKKMD2C+PiV53PM+8qM0J3dnPVCCD8oQKuf4TGwqa8L2U9gDGDnjSBRY
         eElrJB0dXTS0t/sVHXef4uDMKPqn3Z0iiRlM/sBh4zqi7jmuzKpyNf0Nw78gRd5wB6G9
         YSKw==
X-Gm-Message-State: AJIora+bCDKsPXlrvPyUy/VG8CCcrBD41qIk9tR5gTKORMMVocWc2IC0
        8W2orMXgUbdKqJrrgmDDlHXmcqANQncIBw==
X-Google-Smtp-Source: AGRyM1vfSZjteJkNibboBF4t7tZLzIajvcLBq304ZZLduDSDEwC9dBeAChQUaz+3Q1wMNs+WuDRxuw==
X-Received: by 2002:a05:6a00:1d26:b0:52b:fb6f:e44d with SMTP id a38-20020a056a001d2600b0052bfb6fe44dmr7056128pfx.6.1659168482113;
        Sat, 30 Jul 2022 01:08:02 -0700 (PDT)
Received: from localhost.localdomain ([165.154.253.46])
        by smtp.gmail.com with ESMTPSA id z3-20020a170903018300b0016cdefd5e95sm5207694plg.8.2022.07.30.01.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 01:08:01 -0700 (PDT)
From:   Stephen Zhang <starzhangzsd@gmail.com>
X-Google-Original-From: Stephen Zhang <zhangshida@kylinos.cn>
To:     sandeen@redhat.com, djwong@kernel.org, hch@lst.de
Cc:     zhangshida@kylinos.cn, starzhangzsd@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH RESEND] libfrog: fix the if condition in xfrog_bulk_req_v1_setup
Date:   Sat, 30 Jul 2022 16:07:53 +0800
Message-Id: <20220730080753.1963823-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

when scanning all inodes in each ag, hdr->ino serves as a iterator to
specify the ino to start scanning with.

After hdr->ino-- , we can get the last ino returned from the previous
iteration.

But there are cases that hdr->ino-- is pointless, that is,the case when
starting to scan inodes in each ag.

Hence the condition should be cvt_ino_to_agino(xfd, hdr->ino) ==0, which
represents the start of scan in each ag,
instead of hdr->ino ==0, which represents the start of scan in ag 0 only.

Signed-off-by: Stephen Zhang <zhangshida@kylinos.cn>
---
 libfrog/bulkstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 195f6ea0..8f403f1e 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -172,7 +172,7 @@ xfrog_bulk_req_v1_setup(
 	if (!buf)
 		return -errno;
 
-	if (hdr->ino)
+	if (cvt_ino_to_agino(xfd, hdr->ino))
 		hdr->ino--;
 	bulkreq->lastip = (__u64 *)&hdr->ino,
 	bulkreq->icount = hdr->icount,
-- 
2.25.1

