Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B682C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 20:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E8522080F
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 20:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="ZwGIxL3b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfKZUNl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:13:41 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39578 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZUNl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 15:13:41 -0500
Received: by mail-pj1-f65.google.com with SMTP id v93so5535453pjb.6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 12:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iITRKF6mdM/SFMaDj+1Y9g7RFPYvZLoFeM/RhyNhdpQ=;
        b=ZwGIxL3bmNijWt5vPnQTAvuKA3wvYbig94+YDQbmnaE5v2MlZihcrrxZ7EP5LhqHgb
         58W4ECpKZw8BPziE+X07lHMst546+/zVsb3YoEZkIBiqP7Kj9Ho9X3ZxRj+02UkKqLOI
         FtJSh4T68BRdr5wImQVbRajc77K5zCvHv0CpZ6wfj3X6XEgdEfWep2JYKbEC13Qz99iI
         UFLYPEeTerjKTrj5wNG99GlajOWSpRj5scrPubMVFGNlngSfaEgjou4ClmpYDgIKxhMs
         pMwiPb+/LFKr+e5H/CF1gMHw7x+Df9lFqfC5p0Hmx7P7jniiwu9bDQvJ2H9dwhe16HSw
         RdYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iITRKF6mdM/SFMaDj+1Y9g7RFPYvZLoFeM/RhyNhdpQ=;
        b=uOQ7hvUQenz8jwbZpx3G1AjdRyEW/W6eFaxeBLptdcUl4CKYlS8juG+Gf5hwXcfcB2
         FLBDmJs2daHND7cDyjHSy1SmiuWx8e7fv5NFv01qqiPh6UFFFQodabKMRRR7eqO3VDg0
         YM4O2iZm7c09doa5YMzGeavzAjoMi0Nkc/9yuygniSJCRbNSZWfk9NTNtquZ9UeqNmwP
         G6XksY+GtKO6gH8mpWDk9jGz0K1xyIkWNFhpXwR7u9s/EByLJeBo/l5M/KWype4a0/Mh
         CIpA8kvVDUlJw9Cjfal2mqxTmSnyTdqalawEic8VwLMsHMebIP6FWcBq2Cw2Ddn+BDs2
         tEHA==
X-Gm-Message-State: APjAAAUJD6RxARf/cuupj/AIo29Ds+OMUJhtlAaXsza0znqUlbdjNclr
        YRQrqZrl4pCro09dkmK1UuaWpMtlb8pIAg==
X-Google-Smtp-Source: APXvYqwV0UVvBBwQ75ohF8bExIwfd2mmP+8uxBj8dRnMJQ57oALgpvi6HbpbqDB8tzO7JqkT1326ug==
X-Received: by 2002:a17:90a:cc18:: with SMTP id b24mr1062728pju.141.1574799220132;
        Tue, 26 Nov 2019 12:13:40 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:180::30de])
        by smtp.gmail.com with ESMTPSA id p123sm13802327pfg.30.2019.11.26.12.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:13:39 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH 2/2] xfs: don't check for AG deadlock for realtime files in bunmapi
Date:   Tue, 26 Nov 2019 12:13:29 -0800
Message-Id: <89ad24852d1d14fcf834a9551fec503c24d31b44.1574799066.git.osandov@fb.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1574799066.git.osandov@fb.com>
References: <cover.1574799066.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Commit 5b094d6dac04 ("xfs: fix multi-AG deadlock in xfs_bunmapi") added
a check in __xfs_bunmapi() to stop early if we would touch multiple AGs
in the wrong order. However, this check isn't applicable for realtime
files. In most cases, it just makes us do unnecessary commits. However,
without the fix from the previous commit ("xfs: fix realtime file data
space leak"), if the last and second-to-last extents also happen to have
different "AG numbers", then the break actually causes __xfs_bunmapi()
to return without making any progress, which sends
xfs_itruncate_extents_flags() into an infinite loop.

Fixes: 5b094d6dac04 ("xfs: fix multi-AG deadlock in xfs_bunmapi")
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6f8791a1e460..a11b6e7cb35f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5300,7 +5300,7 @@ __xfs_bunmapi(
 		 * Make sure we don't touch multiple AGF headers out of order
 		 * in a single transaction, as that could cause AB-BA deadlocks.
 		 */
-		if (!wasdel) {
+		if (!wasdel && !isrt) {
 			agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
 			if (prev_agno != NULLAGNUMBER && prev_agno > agno)
 				break;
-- 
2.24.0

