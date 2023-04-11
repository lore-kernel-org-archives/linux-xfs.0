Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15320C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 23:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDKXXu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 19:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDKXXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 19:23:49 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103512D63
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:23:48 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m18so9406537plx.5
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 16:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681255427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=obkA+aJ8m83DmNTBaASqYVwYt6AV+6XIxxI8ooHND2Y=;
        b=LXbCOrwm5mEcv88xo1VEZDfF+1pt0OPZPMnm2/LOQ9IbAJ/K6kWjDLPTbRuInOcn2W
         4kK8iG/B6/XUjPzGnjZqxi3tRdjadLk+pdzSZ4vezozll/livTYb4Sa9Bd9aN4v3jkoI
         dsj1DDlsx51yVANyLP/fGaIknfmVwJDyV1DXqLdMSpn7BhL8Z3iM9HiKzC1DMf+lgszM
         /vdKkJPIkp1Ju49YEpq9z2d94twAykW8fX9b/JQ5nHdriG6xjj/rkr9uiDsT0o6jFn+N
         pDIIQNzw6ve1Mf2znpX2bOuWVr67EVjrlTEf96WkpMiUrSAKWBnsc4KnTwkpifMbsp+9
         SOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681255427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=obkA+aJ8m83DmNTBaASqYVwYt6AV+6XIxxI8ooHND2Y=;
        b=Siy/mm6hLzqi/gDyfcTQ0XTV8eU8WPpvxUE7X5PJ6qcHlPSauLbUB0oZD9lW/x4yhe
         Q5DsUcMdMgr5u/xEP3lywRCgLgKdxG6T4Ce73ejem2GvxHMgnIfyirKUp9CVja4ivFTY
         kaza7A0hIwyiC2DtxFJvNBKPlPjgTf9ddULYZEl0KRC/DJyO4Gu88/nsYj1fgW7pO53K
         +s9sbgFVwQMXp2R/2kNgzWpbO78iUrTHcfGGbuVl6CFun9+psajLWF+ruPisygFohiJm
         J9pL2MEn2vhCgJmGmt+giEU8PAQ6HN2AF5NF1lxmM0rFGT8gLKd/yC+DPE31U6ye3Smp
         c11Q==
X-Gm-Message-State: AAQBX9dRPhjMfDvB5Ke7yCUq1ouWfa8lQxjyHOOom23SFBGYcee/e4Be
        t7mcxFaV8O7ENC7I19b2fIvXLtRtNGDBf0eFYcFNAYgF
X-Google-Smtp-Source: AKy350ZY3M2Uqv4AUNJ1jwDvSym6/jxEeaYIR4J6ILAhw+bG7CHCcN3g7ysQRVRNPs/sIRbGT7gEcA==
X-Received: by 2002:a17:902:f690:b0:1a2:296:9355 with SMTP id l16-20020a170902f69000b001a202969355mr19469254plg.16.1681255427462;
        Tue, 11 Apr 2023 16:23:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902820a00b001948ff5cc32sm10075441pln.215.2023.04.11.16.23.46
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 16:23:46 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pmNKy-002H7m-DB
        for linux-xfs@vger.kernel.org; Wed, 12 Apr 2023 09:23:44 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pmNKy-000ykt-1A
        for linux-xfs@vger.kernel.org;
        Wed, 12 Apr 2023 09:23:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: don't consider future format versions valid
Date:   Wed, 12 Apr 2023 09:23:42 +1000
Message-Id: <20230411232342.233433-3-david@fromorbit.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411232342.233433-1-david@fromorbit.com>
References: <20230411232342.233433-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In commit fe08cc504448 we reworked the valid superblock version
checks. If it is a V5 filesystem, it is always valid, then we
checked if the version was less than V4 (reject) and then checked
feature fields in the V4 flags to determine if it was valid.

What we missed was that if the version is not V4 at this point,
we shoudl reject the fs. i.e. the check current treats V6+
filesystems as if it was a v4 filesystem. Fix this.

cc: stable@vger.kernel.org
Fixes: fe08cc504448 ("xfs: open code sb verifier feature checks")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 99cc03a298e2..ba0f17bc1dc0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -72,7 +72,8 @@ xfs_sb_validate_v5_features(
 }
 
 /*
- * We support all XFS versions newer than a v4 superblock with V2 directories.
+ * We current support XFS v5 formats with known features and v4 superblocks with
+ * at least V2 directories.
  */
 bool
 xfs_sb_good_version(
@@ -86,16 +87,16 @@ xfs_sb_good_version(
 	if (xfs_sb_is_v5(sbp))
 		return xfs_sb_validate_v5_features(sbp);
 
+	/* versions prior to v4 are not supported */
+	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_4)
+		return false;
+
 	/* We must not have any unknown v4 feature bits set */
 	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
 	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
 	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
 		return false;
 
-	/* versions prior to v4 are not supported */
-	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
-		return false;
-
 	/* V4 filesystems need v2 directories and unwritten extents */
 	if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
 		return false;
-- 
2.39.2

