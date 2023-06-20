Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A78EB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 21:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjFTVca (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 17:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjFTVc2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 17:32:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F80170F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-25ecc896007so3139312a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1687296746; x=1689888746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WboN94qfKzpU+jB/4h7hJR+vGuTsRfN/meMwasv9cLQ=;
        b=LQdUiATfIsdu5vGz/c2yElN90Yu0qMLIFDi4f5kH43o0Pg1kWrspIcVOJ5IbwqYGiq
         NnmgWp5WrnaTzSmvXVGR7F7pQANV6V9i81VRvHFuEItgzX/l6l0nOgZfKCFtw1fPqQdZ
         oQV57OLKNdl3UlO27XrHnf921kF2UDhMIFNtMVSTOMbvbZCoFm97s/VMw8hvA2KsnMyn
         T3duUVI342Xbzj2lMQU4GccKWFeiXVqvhZPU+uCAFN6a62yBtdpC0NoWPRoLqVauxB/Z
         AxbWSVtNbczj3gmEGTImVPLc9t4VD3qgREo+SxFrI2QOcDH5spfayjyQwfHsWcTHAaPz
         EMCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687296746; x=1689888746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WboN94qfKzpU+jB/4h7hJR+vGuTsRfN/meMwasv9cLQ=;
        b=V2mWUgBx9JpMRe/alSd3U20sdVt45fo/KuiRe6vuBsQY2Mx7oNBFSRwV7/FWOTX4A4
         A6yyEuz3aOfOcBV3yIt5t201y3WvICJEkcXvzcwXsGj+5UP78k79yqKprFEmf+BPEYEi
         FyFkK/GT6ZSm/rGhsu1K8PMYgMg5khzF4YuMPXDFV4ak8DWKyVXTazZKaPIqx4eGIwjj
         T/N36so8JHVZpJ4EFcigrzafDX3W+s4MF68mtvIk++akJNZAY+23/Cx/BC1fJOOd61v+
         eVoHjMYgpAEA2XAsdZL7YWWEcN9+6JdGJ+MgZpbqsWAVuizZoU501n1ZklWhBJPfcPGi
         4tWg==
X-Gm-Message-State: AC+VfDzgH4FCmdhtcwD7oA+i5CgmWMUAxZDn0IERcunxeG13L6KNIHhQ
        vygJLbd2vhDx5GDrEqUdHB3yRbtRGL/HRPM2Ebs=
X-Google-Smtp-Source: ACHHUZ46zMBIuHhbA1cHt4gmbhEPXfsXAtG4TKf1sfa8U3qwcyACCF32a6ngLyOif+03u3G88zfu5w==
X-Received: by 2002:a05:6a20:3c92:b0:122:60e8:10e1 with SMTP id b18-20020a056a203c9200b0012260e810e1mr4755641pzj.31.1687296746367;
        Tue, 20 Jun 2023 14:32:26 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:ea8e])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79205000000b0064d3a9def35sm1688188pfo.188.2023.06.20.14.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 14:32:25 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH 4/6] xfs: limit maxlen based on available space in xfs_rtallocate_extent_near()
Date:   Tue, 20 Jun 2023 14:32:14 -0700
Message-ID: <da373ada54c851b448cc7d41167458dc6bd6f8ea.1687296675.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1687296675.git.osandov@osandov.com>
References: <cover.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

xfs_rtallocate_extent_near() calls xfs_rtallocate_extent_block() with
the minlen and maxlen that were passed to it.
xfs_rtallocate_extent_block() then scans the bitmap block looking for a
free range of size maxlen. If there is none, it has to scan the whole
bitmap block before returning the largest range of at least size minlen.
For a fragmented realtime device and a large allocation request, it's
almost certain that this will have to search the whole bitmap block,
leading to high CPU usage.

However, the realtime summary tells us the maximum size available in the
bitmap block. We can limit the search in xfs_rtallocate_extent_block()
to that size and often stop before scanning the whole bitmap block.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/xfs_rtalloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ba7d42e0090f..d079dfb77c73 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -488,6 +488,8 @@ xfs_rtallocate_extent_near(
 		 * allocating one.
 		 */
 		if (maxlog >= 0) {
+			xfs_extlen_t maxavail =
+				min(maxlen, ((xfs_extlen_t)1 << (maxlog + 1)) - 1);
 			/*
 			 * On the positive side of the starting location.
 			 */
@@ -497,7 +499,7 @@ xfs_rtallocate_extent_near(
 				 * this block.
 				 */
 				error = xfs_rtallocate_extent_block(mp, tp,
-					bbno + i, minlen, maxlen, len, &n,
+					bbno + i, minlen, maxavail, len, &n,
 					rtbufc, prod, &r);
 				if (error) {
 					return error;
@@ -542,7 +544,7 @@ xfs_rtallocate_extent_near(
 					if (maxlog >= 0)
 						continue;
 					error = xfs_rtallocate_extent_block(mp,
-						tp, bbno + j, minlen, maxlen,
+						tp, bbno + j, minlen, maxavail,
 						len, &n, rtbufc, prod, &r);
 					if (error) {
 						return error;
@@ -564,7 +566,7 @@ xfs_rtallocate_extent_near(
 				 * that we found.
 				 */
 				error = xfs_rtallocate_extent_block(mp, tp,
-					bbno + i, minlen, maxlen, len, &n,
+					bbno + i, minlen, maxavail, len, &n,
 					rtbufc, prod, &r);
 				if (error) {
 					return error;
-- 
2.41.0

