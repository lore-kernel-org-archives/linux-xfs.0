Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18580C3F2D4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbiFCS6H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348487AbiFCS6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:58:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8539629C82
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:58:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gd1so8006395pjb.2
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jP52FfyPXwWCsSjwMiiYrSa+6BfonFcbqdjYQDS7PLs=;
        b=jtlufLLpLW6eiBHiBET7vhfsbTOf4CPlAnHC8DQ7SrXqzKRLURLQKge2hruUyuSu98
         +fUhDWBEuqqfT8/VnqxEGFjO8zGzA9a6aTRg3kYQoEAQeLjAkeo1Ut0SIh+Ifm7+n6Fp
         blPWx0Oi0OpAX/KQSxL8bby6N/3wnzU//SXiApmH7sN50eeomsztSKJL1PSrIUp50yug
         QJFsC3E6Xzig/5rOzjFKQ6bTFvrcWkyVB9dLQnpQIIivLeuj+pY82PTxZiKeUDoCsVqP
         1owdib+5ipyUMAHC0NSj2DZ1AoJ+LB+kklsxKMEpEAWJu+HS+/sJ5atOYYLjN3O0f6rH
         uhYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jP52FfyPXwWCsSjwMiiYrSa+6BfonFcbqdjYQDS7PLs=;
        b=4VD6aq7oFSSzG9rPPTECX4WQuXTUdo0EFzqy3puj50OH7Yd1nFI485e9ZiapF4G2xX
         qO1PQnhXbKj2eyGQckj60xywWK78lOr+/YCzhpc62fHKDGjpHdU7MlxNB/e26B4fJg4c
         3ZpO8oVG5voxyMClnXjwX4yzgGYd7EmlWL2LdCPy/EumCHB+T0ZkrKfnQ8tuiVDgaIPu
         Fuczj1pa2W7MPW9ovx9B5EX15ThBBGRLuwluAWNK/+HZd3Z8e+2YlOHXt+h8mfxqsSnm
         IRJMri160Lg9i9/Lz7DDhbyJjrxxaOgixNZQh8ExH2mS0lPVH37lPKyQ+2+FkqFdmXAi
         IIgg==
X-Gm-Message-State: AOAM5331ve/C9X5Xx923MfwiL/vgsUxZGJ3bDcb89V8n0V1YiOdTTW96
        MFebkpMVwz1+6YHeVeNPpn3spCk5zIdmIQ==
X-Google-Smtp-Source: ABdhPJzrIJQo2ZCNhzlBx7glknHp/5/GW/X9OhIgj6WKGLSF/V/d2dWisGtoJ2OgNjg3hLtzbBfu7A==
X-Received: by 2002:a17:90b:1d08:b0:1e3:2a4f:6935 with SMTP id on8-20020a17090b1d0800b001e32a4f6935mr24982180pjb.174.1654282682824;
        Fri, 03 Jun 2022 11:58:02 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:58:02 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 09/15] xfs: only bother with sync_filesystem during readonly remount
Date:   Fri,  3 Jun 2022 11:57:15 -0700
Message-Id: <20220603185721.3121645-9-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
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
---
 fs/xfs/xfs_super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8d85114ea047..5410bf0ab426 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1764,6 +1764,11 @@ xfs_remount_ro(
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
@@ -1842,8 +1847,6 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
-
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
 		mp->m_features &= ~XFS_FEAT_SMALL_INUMS;
-- 
2.36.1.255.ge46751e96f-goog

