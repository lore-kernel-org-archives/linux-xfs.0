Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE91C636D3
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 17:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjBHRwq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 12:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjBHRwp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:45 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A649445F6F
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:44 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id k13so20224162plg.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B9onRQALc3Snrm18hU7Fy9uxMDBR1lixJy8MQTLDR7Y=;
        b=pHtWDDR5S6zLwAXdqoBi80d6SMtB8I4a33W823Ks8izCXzvLTLR6AGZXFrc3XJcAqv
         Dj8hCHiyJK1/gmsoJOeqDzvYxzD9LzXzFUoX69vVWhDNsRujKAHYaO6sk5g5XF6W+Nsn
         +q0PXnjKXMwuwAobecqt7g06dyoH0hBNjOGRL4gE0W/cH0/1b92JhX0fXxgExMdRLaJZ
         tE+tOj9Td5BexFNkjM3cx6bYKWI3WjpGPalKeA1/mmp3Y1nJzWuRoqWp+xA2Z6XdRhfs
         YSYIKiVuuoD0CP+psr0aflSlNxk8OvQJ+1t3bwW7L3PNxSTp+8Cpcib2C8xNC3ciUTiN
         gTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B9onRQALc3Snrm18hU7Fy9uxMDBR1lixJy8MQTLDR7Y=;
        b=8AEZOzaE+Rww6Ls9VdIONBA0DhjbAliJ4XDdoBRwBvtzHMoiumU5DNc9uTx0IsP9fi
         IAwEvWzWeWWaakifehNAjSTp3uwltJ3USfKBPsrnd75G+cQPJPWuUyfJP/6Jwm+eHfB9
         qGwyyXr9G5P+tzhAqMbLiJMSo0VkFXKsVl04XRe1p+/VhBUvCqHxaC/1BYOOsEQa8MpT
         HFiYt6rNVhiKiiz7POTLw8QKqqxo0wHZguWPE4w68WbT+mVMNQoml/EgQDRNrvaYz7Hf
         T684r7z6tb/9qMfXDdwkxIhAiICh3BLcnQ/Y7Zh9froIDR1+rw6W/lrEEipXsh9Trj8g
         kf1g==
X-Gm-Message-State: AO0yUKXQH8fI8mg1muxsMfvJGlXtyu2Pg3OcwlP96Yavx+nuTg7s10D9
        lDr3NGSS6dnFY+lcNnaNdGv2X3ihraslDw==
X-Google-Smtp-Source: AK7set+pIQi/evVYeO+1BUh/BYsr8luAlDs9sr9IDenHeyB6AJu6CmzapFGKvX8cYd/WK+pc68rsmg==
X-Received: by 2002:a17:902:d501:b0:198:b945:4107 with SMTP id b1-20020a170902d50100b00198b9454107mr8433967plg.65.1675878763933;
        Wed, 08 Feb 2023 09:52:43 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:43 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 04/10] xfs: set XFS_FEAT_NLINK correctly
Date:   Wed,  8 Feb 2023 09:52:22 -0800
Message-Id: <20230208175228.2226263-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit dd0d2f9755191690541b09e6385d0f8cd8bc9d8f ]

While xfs_has_nlink() is not used in kernel, it is used in userspace
(e.g. by xfs_db) so we need to set the XFS_FEAT_NLINK flag correctly
in xfs_sb_version_to_features().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e58349be78bd..72c05485c870 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -70,6 +70,8 @@ xfs_sb_version_to_features(
 	/* optional V4 features */
 	if (sbp->sb_rblocks > 0)
 		features |= XFS_FEAT_REALTIME;
+	if (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT)
+		features |= XFS_FEAT_NLINK;
 	if (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT)
 		features |= XFS_FEAT_ATTR;
 	if (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT)
-- 
2.39.1.519.gcb327c4b5f-goog

