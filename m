Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D70EB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 21:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjFTVca (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 17:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjFTVc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 17:32:29 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1FF170D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:28 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6687446eaccso2515601b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1687296748; x=1689888748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxPBD81xyWEubrJfd9aN+qxmAVvYSI724CWx+9oAagA=;
        b=mu4spGCJSXj4h7en49OUt++WLI2SMw2RPc9JdIcBfpiTdAuxlIvZCuTICRIdvjBZ6E
         Exr+8hoaNvzpZ2n5WqRi41ZsETC0BDP9kPqIcwmOcKN3WDbCArRkk+LFlh38F7ygHzl/
         2eRkFoDL9D+rwc6A+oK8XLqZkWvPvZR2m+3kt8NVrRsGw4D+cMEV+Qaqso17wBKM3pQ+
         HA2UCfUZyHDLdE7idVdbWzN9aThX5ibD+wNwg+EssIQdl7jKWSbBGschf1B9Q9PO/Y2C
         qXPavujX7vCzJ1Dm3D/AWAmRJOUCTGglpXQHYxtb6GeaZxBMVSHVNq9q1Yqv9LS0/HMM
         fSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687296748; x=1689888748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gxPBD81xyWEubrJfd9aN+qxmAVvYSI724CWx+9oAagA=;
        b=LY6A7hNPCl+6q6wLHSQWX17k0P96L7m+8gsCmwL2L+i2IMDJ6xZN1EGh6VMuxNBbvh
         JU9u6kKA54AhHxpGKzdDnIUMsAOYF3NjMW/sYVWrNPjXJ4bIOGJdmiB8ny1s0tOAaVGQ
         q27u2JT3O6dn29+uaaana7w5ssjCy4nFvgmIydp+CCc7SnedOHPqPkeqRllDuWMMkDtN
         tJImcfQqbXdU9IR+BJ9o8EHvOHOKaE/WYcO422hTtOPncGJ7MtP4NcdjbSO7v1Ndac+9
         Ym1HZbRsrlSslpLNuGrbkbTRdAQk1g9cFDr83MgJnQ2heJRjxd7xIR0AjSYba1iEd4s2
         K+aQ==
X-Gm-Message-State: AC+VfDz4fSKx9V8MqUraOlnVL6ea5Ch/r3wUoZkaCj0RYSOG05IK1LI7
        c/WWhrhVO19ldGjuY9k8LUl/9lbg/wKW2k4fssc=
X-Google-Smtp-Source: ACHHUZ5cVbBu2xZQeFAKrFHyiMERuRPn505QS08ntrJH+OThNtbex7fshjK2Oy13or+IJ+XbwMGEkA==
X-Received: by 2002:a05:6a00:182a:b0:668:6eed:7c18 with SMTP id y42-20020a056a00182a00b006686eed7c18mr13076237pfa.9.1687296747871;
        Tue, 20 Jun 2023 14:32:27 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:ea8e])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79205000000b0064d3a9def35sm1688188pfo.188.2023.06.20.14.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 14:32:27 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH 5/6] xfs: don't try redundant allocations in xfs_rtallocate_extent_near()
Date:   Tue, 20 Jun 2023 14:32:15 -0700
Message-ID: <a5bd4ca288dd1456f8c7aa5a1b7f3e1c2d9b511a.1687296675.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1687296675.git.osandov@osandov.com>
References: <cover.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

xfs_rtallocate_extent_near() tries to find a free extent as close to a
target bitmap block given by bbno as possible, which may be before or
after bbno. Searching backwards has a complication: the realtime summary
accounts for free space _starting_ in a bitmap block, but not straddling
or ending in a bitmap block. So, when the negative search finds a free
extent in the realtime summary, in order to end up closer to the target,
it looks for the end of the free extent. For example, if bbno - 2 has a
free extent, then it will check bbno - 1, then bbno - 2. But then if
bbno - 3 has a free extent, it will check bbno - 1 again, then bbno - 2
again, and then bbno - 3. This results in a quadratic loop, which is
completely pointless since the repeated checks won't find anything new.

Fix it by remembering where we last checked up to and continue from
there. This also obviates the need for a check of the realtime summary.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/xfs_rtalloc.c | 46 +++-----------------------------------------
 1 file changed, 3 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d079dfb77c73..4d9d0be2e616 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -468,6 +468,7 @@ xfs_rtallocate_extent_near(
 	}
 	bbno = XFS_BITTOBLOCK(mp, bno);
 	i = 0;
+	j = -1;
 	ASSERT(minlen != 0);
 	log2len = xfs_highbit32(minlen);
 	/*
@@ -518,31 +519,11 @@ xfs_rtallocate_extent_near(
 			else {		/* i < 0 */
 				/*
 				 * Loop backwards through the bitmap blocks from
-				 * the starting point-1 up to where we are now.
+				 * where we last checked up to where we are now.
 				 * There should be an extent which ends in this
 				 * bitmap block and is long enough.
 				 */
-				for (j = -1; j > i; j--) {
-					/*
-					 * Grab the summary information for
-					 * this bitmap block.
-					 */
-					error = xfs_rtany_summary(mp, tp,
-						log2len, mp->m_rsumlevels - 1,
-						bbno + j, rtbufc, &maxlog);
-					if (error) {
-						return error;
-					}
-					/*
-					 * If there's no extent given in the
-					 * summary that means the extent we
-					 * found must carry over from an
-					 * earlier block.  If there is an
-					 * extent given, we've already tried
-					 * that allocation, don't do it again.
-					 */
-					if (maxlog >= 0)
-						continue;
+				for (; j >= i; j--) {
 					error = xfs_rtallocate_extent_block(mp,
 						tp, bbno + j, minlen, maxavail,
 						len, &n, rtbufc, prod, &r);
@@ -557,27 +538,6 @@ xfs_rtallocate_extent_near(
 						return 0;
 					}
 				}
-				/*
-				 * There weren't intervening bitmap blocks
-				 * with a long enough extent, or the
-				 * allocation didn't work for some reason
-				 * (i.e. it's a little * too short).
-				 * Try to allocate from the summary block
-				 * that we found.
-				 */
-				error = xfs_rtallocate_extent_block(mp, tp,
-					bbno + i, minlen, maxavail, len, &n,
-					rtbufc, prod, &r);
-				if (error) {
-					return error;
-				}
-				/*
-				 * If it works, return the extent.
-				 */
-				if (r != NULLRTBLOCK) {
-					*rtblock = r;
-					return 0;
-				}
 			}
 		}
 		/*
-- 
2.41.0

