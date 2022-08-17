Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0AE8C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238085AbiHQA4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238082AbiHQA4g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E4B80B49
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:36 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gp7so11152211pjb.4
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=EXwT7aU1M+aVRPwtJig37roVgnapOicHGN5d6rRSqt4=;
        b=IdL34L2XiKSz19jaICnLuDbItHqZMg8aroPC35Jsbqdiy/LxR63bPeWpWMMCaDsFUI
         IHdV+aUMeFuS7qaVzY49XvvZpGgKkj/tneRVEPgrdhm1oK5y2L0/+CRj4Ej9nSrUh/yb
         2WQoLmDfL+Pf3gNE4HyccHghk0IrpHlV6n9iHC57lCJyS/N9y4/tzBrh8gegmzICEHo1
         E5KLBtiZ1/tWvIzZhKQzU0Qxqa4ybMWAiRNXVGien1JymZ5y74+wRSoknv0YJVxGdIFR
         3k/UKLRhUQdYv/0qrml2SKO8vxRhEFNySPNsy5ZWmkcAbR2K4WbxYrj8G7t1kAUTYdDi
         ewTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=EXwT7aU1M+aVRPwtJig37roVgnapOicHGN5d6rRSqt4=;
        b=ZWGRuz4op8+qfNiwTi0eM/2eJp4JROaU9lmI5i360nUIFdflSFR3FVSDdgGdph58fK
         kwkiyAWR3rFPSGBjzcFSL6a0/DIJQW5d+N1omcpseWqLYTEwgHhh2a2ChIRC385/Pr4Z
         jNXBQbIN2N/+1F/c2yVVOgSDRMrOaWS+mENS3hTyqbndilVlGnrmYVFKhQZ+SfIEEMID
         FlzX6MWgi/2lLVzqQFfuPifmN26OmkWsv6dPJziTtvaXrNk+8sM/AIXF0TtcPDgV/57x
         ROXnxusjDS51kQDmk9c7xq4dqrRKOmNGFD5qD5H3P0GikW5WyhwMQCU9So0L33RNWM1e
         YwmA==
X-Gm-Message-State: ACgBeo0m8tQEuPc3H/l+egF4ymlxDe4gAYKnnLPbg1pvTt5PUq8W/bOX
        taDe8b90edQtcyz3dt2O2h9llwUv8v5xfw==
X-Google-Smtp-Source: AA6agR7QCkVj74gbUcDCZTlOpfGOLP4ThkRf8rKg4L8c2QVTFY7kOXK8P2fARTf7UvZueCKUUxy+kg==
X-Received: by 2002:a17:90b:4a4e:b0:1f5:431c:54f8 with SMTP id lb14-20020a17090b4a4e00b001f5431c54f8mr1227043pjb.161.1660697795605;
        Tue, 16 Aug 2022 17:56:35 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:34 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Eric Sandeen <sandeen@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 8/9] xfs: revert "xfs: actually bump warning counts when we send warnings"
Date:   Tue, 16 Aug 2022 17:56:09 -0700
Message-Id: <20220817005610.3170067-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit bc37e4fb5cac2925b2e286b1f1d4fc2b519f7d92 ]

This reverts commit 4b8628d57b725b32616965e66975fcdebe008fe7.

XFS quota has had the concept of a "quota warning limit" since
the earliest Irix implementation, but a mechanism for incrementing
the warning counter was never implemented, as documented in the
xfs_quota(8) man page. We do know from the historical archive that
it was never incremented at runtime during quota reservation
operations.

With this commit, the warning counter quickly increments for every
allocation attempt after the user has crossed a quote soft
limit threshold, and this in turn transitions the user to hard
quota failures, rendering soft quota thresholds and timers useless.
This was reported as a regression by users.

Because the intended behavior of this warning counter has never been
understood or documented, and the result of this change is a regression
in soft quota functionality, revert this commit to make soft quota
limits and timers operable again.

Fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings)
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_trans_dquot.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3872ce671411..955c457e585a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -603,7 +603,6 @@ xfs_dqresv_check(
 			return QUOTA_NL_ISOFTLONGWARN;
 		}
 
-		res->warnings++;
 		return QUOTA_NL_ISOFTWARN;
 	}
 
-- 
2.37.1.595.g718a3a8f04-goog

