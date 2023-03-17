Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32774C76195
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCQLIe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCQLId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:33 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18FF28D3A
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:32 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g6-20020a05600c4ec600b003ed8826253aso461864wmq.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SN211lgBBr1aJAJHF2diSYORjNp/PE39Z5mZHl1CgbA=;
        b=NIRl8sizAMB9448hisrkRKTggAchBRuTZo5bzdYIbtWx9XDnzEQOpHYjTNyk/wOyMu
         /dO1awWqzgC3xIfrKYssHSZc8EQCKHnwTWoqDrhx/JCKd3gcDY8ohUzXUnyTUEtMBowt
         00vPfM08sJOEBEJwXBU8CT9fbuF4/7nq2FSxdKKz5FuAZkOBVhElgO2jBd+rE9RmRVD8
         rNUz9dmUAGrIMd5fmhneQYV98OErYVh4FdLL9sUcTT6BVR4aGeMPpARBexwq5TyiLAnh
         6SCbAkAKCBLv7DkXecfQVXFzaw6uYGMGcEnJ6aehdy1lhwwnSueUCHLiluy6MYO4JKyc
         282g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SN211lgBBr1aJAJHF2diSYORjNp/PE39Z5mZHl1CgbA=;
        b=IUOeiMdanfCnppVDjUfzqZokPDUVy1V0loV/G5bR1rWRaJrOw1aCEeLV0+FcTCSLKa
         L8N9x8CMyrjyLUxZX0trXrpybL38A93wY0WZAfeSwGyY45Ge6nX6dOXMSqJNHE0bvQSZ
         4c2mBalYwogJ2DrdZxlkozazy3szs8t1NCcF8USqNvbxQsBhSu6v1AYtanZdiMiML/b1
         iOOxlNOky7MyKw9jKegO49Ovld0hHl4pb0/8EBwWJERKTpp7TIDwjh1jZNJh9NQDZE+u
         I864d/o0DCC5tqdDPPu3D0flKPDZoz/vbfpWN1HOk5GYhGyYVU19eDiwdsIM2/J5sXmH
         kebA==
X-Gm-Message-State: AO0yUKUDYWNBrq2VcACOQc/CVzo2IWlDJwKF6kujuyOOG02iIF6i8pVT
        EWhE7nvv+rB8qGJPIuobT7A=
X-Google-Smtp-Source: AK7set/4YXlNQyBk0sWn2jmMDr4T3oxAcB4J4FqWF+3/lVKgzLwn8rLhQuCHwl6dulOhe6xv7L2+KA==
X-Received: by 2002:a05:600c:2053:b0:3ed:5cf7:3080 with SMTP id p19-20020a05600c205300b003ed5cf73080mr4449444wmg.5.1679051311094;
        Fri, 17 Mar 2023 04:08:31 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:30 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 05/15] xfs: fallocate() should call file_modified()
Date:   Fri, 17 Mar 2023 13:08:07 +0200
Message-Id: <20230317110817.1226324-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit fbe7e520036583a783b13ff9744e35c2a329d9a4 upstream.

In XFS, we always update the inode change and modification time when
any fallocate() operation succeeds.  Furthermore, as various
fallocate modes can change the file contents (extending EOF,
punching holes, zeroing things, shifting extents), we should drop
file privileges like suid just like we do for a regular write().
There's already a VFS helper that figures all this out for us, so
use that.

The net effect of this is that we no longer drop suid/sgid if the
caller is root, but we also now drop file capabilities.

We also move the xfs_update_prealloc_flags() function so that it now
is only called by the scope that needs to set the the prealloc flag.

Based on a patch from Darrick Wong.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_file.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 630525b1da77..a95af57a59a7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -895,6 +895,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -996,11 +1000,12 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-	}
 
-	error = xfs_update_prealloc_flags(ip, flags);
-	if (error)
-		goto out_unlock;
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (error)
+			goto out_unlock;
+
+	}
 
 	/* Change file size if needed */
 	if (new_size) {
-- 
2.34.1

