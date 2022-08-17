Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24990C32774
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbiHQA4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238085AbiHQA4h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:37 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DC080523
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o3so10704843ple.5
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=8x0W2mqGvd5EJbKKDmFhMzvn1ObNpDscBJNwevEe/ps=;
        b=JmelRDEpXSWp2dpR5HSUAYW0qWYc9hff5wdXHSwjkORqovPJeiQRwQ0w4kHsl3/ZQv
         xqm/lmx6kbwLv/VfaLaeb4uX0FNDyCasJDzFRXqRnuXxvoqjBF+lD28mi6s41vpQm3LB
         qPxtrw3obPAUA5GcqnDDtSN6WjjPAPF/InZl4O40VSSb2PSWBKlZxo6h7ZIqKokQzePp
         taTJcXLQbBaecR+b8mHPrmB8chhpAguxBwmSDJ2rVMHhAd9WCsNnCdjzx9s5sV4vadK0
         gFOe3sq92K7//KjMMSgsnj8EiL/UeYM67IAp6BJSEHQW8WPBT4hR6WnzOYewTIRf5lnp
         gduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=8x0W2mqGvd5EJbKKDmFhMzvn1ObNpDscBJNwevEe/ps=;
        b=n7PwUwLShh2bQmFjL446o6CattF5WvsPM4d17uTxVNh3Rpsm0jzdWC7Z4N9br9AhkH
         Cwy2CZQ2MtrzgrisDQ5L5FDnr0PBqhT+KCQhWWYpdzGuxtpAU82Yt0FknVRqn/cl7ug0
         kOww9b6/FdtwtWfVwe4ST7WUOAiGPmR+2DPJv8aJ1FebqaKK7uglT81RhBFh77mHYnSX
         LikMlMMS9nPuh0hL2lzEOhENA+RsJf0tHsmTp7NSTTsUYOxHiE0o2mK9F+I7dCLD8qCr
         gIV0ONs4W89ZLbMi/SB12LYQmAvSdlLQqMC4yCGH0Z/FFlGVECHo9/yqpVvHOxTUxtJJ
         ChHg==
X-Gm-Message-State: ACgBeo2+f9IYkBBOm0jBPIxnsom0mV4f3fnUV4Z+jIpjZklJDEy1NEML
        aWKXwlBaM3Jeqci92kMW1K91e0273Md5kQ==
X-Google-Smtp-Source: AA6agR6eMavZj+MUogq7cUoue6TI7h9irgxqIOZfn+aNJsgLVXypd3nAC7OSbYwRSs4n5jZIwfUdRA==
X-Received: by 2002:a17:902:f610:b0:172:990e:33cd with SMTP id n16-20020a170902f61000b00172990e33cdmr1094241plg.145.1660697796575;
        Tue, 16 Aug 2022 17:56:36 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:36 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 9/9] xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
Date:   Tue, 16 Aug 2022 17:56:10 -0700
Message-Id: <20220817005610.3170067-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 29d650f7e3ab55283b89c9f5883d0c256ce478b5 ]

Syzbot tripped over the following complaint from the kernel:

WARNING: CPU: 2 PID: 15402 at mm/util.c:597 kvmalloc_node+0x11e/0x125 mm/util.c:597

While trying to run XFS_IOC_GETBMAP against the following structure:

struct getbmap fubar = {
	.bmv_count	= 0x22dae649,
};

Obviously, this is a crazy huge value since the next thing that the
ioctl would do is allocate 37GB of memory.  This is enough to make
kvmalloc mad, but isn't large enough to trip the validation functions.
In other words, I'm fussing with checks that were **already sufficient**
because that's easier than dealing with 644 internal bug reports.  Yes,
that's right, six hundred and forty-four.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fba52e75e98b..bcc3c18c8080 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1545,7 +1545,7 @@ xfs_ioc_getbmap(
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
-	if (bmx.bmv_count > ULONG_MAX / recsize)
+	if (bmx.bmv_count >= INT_MAX / recsize)
 		return -ENOMEM;
 
 	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
-- 
2.37.1.595.g718a3a8f04-goog

