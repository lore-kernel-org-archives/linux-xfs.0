Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FDBC43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiFWUhS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiFWUhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:37:16 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18A160F19
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:15 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id n12so722979pfq.0
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XnCkR6czOl4KFZMbaWAEpeNu+QzA92KobMCND0qAxMo=;
        b=BjVi7rn/xiB1TJFJHxmTOegoqzAdFYkegX4ZdnckbObqGsxWkOv1Rhruft7YfG/Fwr
         OBoU1tAcyphzGU6+ZwHcXZdkU3Wjw+kUP28hebklk6MT5NOYiwiX1DTs5GOGqe7dOW8Z
         6FkPpw9//Vm2rW1UV8kqdMqCpjoZEQRsJL+1hYChuYvmYWD4LS7LdTn4ZYoQugzT6Tbo
         LLF1Tc+zi3HZ4e4iT/Pb7CQpW9JC4uxeN23Om8sbX3yvuDl1UJZBerkuaZyjJAQ6rpz6
         DhuHgf9ikAtHCsxYSqP8jI6F7Tz+8dawijkUEQ6jZx0kAg1ga6LydWA0QAutj/bDgu2M
         qS2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XnCkR6czOl4KFZMbaWAEpeNu+QzA92KobMCND0qAxMo=;
        b=Xf6V95Rf3BHxfnwvlaG23LkOZ6Yfih08hpRF19CCRCGod1/HKzCwj8W4GNIMxOF5pc
         MgqMQkBy1WmH3DAjhmWNLpe3+QywoZLAsL2wAdjJH/F5F5VUsFKWz4qcRGhMW2weIrb5
         GF79m6tEC+8RrtVeqDA46tAP4iBCU232J6bEZjyRp9OmSRJ9/4URzYRGWbbPeRRJQVhI
         i1iyoeuRmPcB3yZH3482fR20X7rGOuXGZVS7kOMt3/3mTPLoGIxFLgbl9pOKYKrqwWSV
         pT4ahScZozMHMGra/PVvLjmnyWF9Dj/qw/vEUTDSNetqsLUY86oBQemzbgra2G5dt1AF
         L76Q==
X-Gm-Message-State: AJIora93JILy404+QYlxmLxj5euVIDkDf8sTIfAKm2Ys/aPcAV10dXQ1
        iYsLzL4/xhuYLUzXVnkRSq+DqthIq81tGA==
X-Google-Smtp-Source: AGRyM1toPHpYlMxYddDTBmH1DrMeXYitpWkrnZFAm4tmNh1k8RDcYNp/PETCqFhFUoTfBz4koLH1JA==
X-Received: by 2002:a63:6941:0:b0:40d:133a:4713 with SMTP id e62-20020a636941000000b0040d133a4713mr8898852pgc.162.1656016635015;
        Thu, 23 Jun 2022 13:37:15 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:a654:18fe:feac:cac1])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902768c00b0016a17da4ad4sm228386pll.39.2022.06.23.13.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:37:14 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v3 7/7] xfs: only bother with sync_filesystem during readonly remount
Date:   Thu, 23 Jun 2022 13:36:41 -0700
Message-Id: <20220623203641.1710377-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220623203641.1710377-1-leah.rumancik@gmail.com>
References: <20220623203641.1710377-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit b97cca3ba9098522e5a1c3388764ead42640c1a5 ]

In commit 02b9984d6408, we pushed a sync_filesystem() call from the VFS
into xfs_fs_remount.  The only time that we ever need to push dirty file
data or metadata to disk for a remount is if we're remounting the
filesystem read only, so this really could be moved to xfs_remount_ro.

Once we've moved the call site, actually check the return value from
sync_filesystem.

Fixes: 02b9984d6408 ("fs: push sync_filesystem() down to the file system's remount_fs()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 23673703618a..e8d19916ba99 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1773,6 +1773,11 @@ xfs_remount_ro(
 	};
 	int			error;
 
+	/* Flush all the dirty data to disk. */
+	error = sync_filesystem(mp->m_super);
+	if (error)
+		return error;
+
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
@@ -1851,8 +1856,6 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
-- 
2.37.0.rc0.161.g10f37bed90-goog

