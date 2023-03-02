Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B3DC7EE30
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCBUfX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjCBUfT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:19 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D57730285
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:19 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id oj5so358616pjb.5
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/bEWH+U8Y2Dq4zNfoM47whXgwcdRl+8McABR13FG/s=;
        b=oUo1uswTE0FuWV2tnqOgboISuseqCs5KdeR0Xg957zwhvx4o4aleH5crYhAsIx0vem
         LQUKBds1iLNlA9AZ/nKxWMFJ1XrjksFudJqkgy3cbJ6uzR/PBL2hpXiXFFP5uoElegzc
         OSSuNQg8Zg/GjgYVftlOSa1jlMeBKGoyHFbxzjP4FJlagZWWgcsCjWH8iaABk5XOKmrf
         m/3zXrF2Lhbb0HqbrXMWXBz3+yDPAWxkB9lJQ/M6BZihnAB2JBVkYLNFVLI8ZDz6CzaA
         AifrzPxwCaEQI1Sc1yPektWLe5QGpbgUFVaCrrTv3MN3KqbKKfQW5liiv/q0tj6viXhP
         D/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/bEWH+U8Y2Dq4zNfoM47whXgwcdRl+8McABR13FG/s=;
        b=NMCbPT9vTCOGbXAaYS6m2bPybPR+91OoxD8h/t2XUilWBqI4dXul+VfJVeGbHSeoSW
         vs0yhJbOVI0ytPWWChHQFXw0rngi4ZQ3r8SIIu5gJ2aV1IHN2riPBo9zUL006mfVV/VE
         GJIlFZgwyUANPGo6vrZBUH79CLMSk0WGwQ9bm+O6O9DEUn6rT1oEWpGX5AIWQDuOF4Rg
         8Dn1U2pOzAxknyKXwBTiHZ0B8I/PWz9g93sc/Dn8mAMZp6L1Wg1xKjzgz703SN7FHr8w
         9h12Qbgia9vl3DXnm/YhwpIj7vbG6Yn73kZ3OydPL7e9OHLLiV3VF72jtcGa98MXfSKR
         oWLA==
X-Gm-Message-State: AO0yUKUJqhzxT/eLJnfwzg1b4RjR62ZWDsAPdbhYXBZazOmZP5ZqD9On
        A8w7okZ2DqQx9ssC2s9zLf/b96xiriql5Q==
X-Google-Smtp-Source: AK7set/4fGtUXDYX+d3hLWoPttfEDixWzNpN8sVDQsUyr1urVp5z4gItHsT7WzOD2DB+ZdIi0v4vNQ==
X-Received: by 2002:a05:6a20:12c6:b0:cb:98e5:de33 with SMTP id v6-20020a056a2012c600b000cb98e5de33mr14911276pzg.3.1677789318248;
        Thu, 02 Mar 2023 12:35:18 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:17 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 02/11] xfs: remove XFS_PREALLOC_SYNC
Date:   Thu,  2 Mar 2023 12:34:55 -0800
Message-Id: <20230302203504.2998773-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 472c6e46f589c26057596dcba160712a5b3e02c5 upstream.

[partial backport for dependency -
 xfs_ioc_space() still uses XFS_PREALLOC_SYNC]

Callers can acheive the same thing by calling xfs_log_force_inode()
after making their modifications. There is no need for
xfs_update_prealloc_flags() to do this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_file.c | 13 +++++++------
 fs/xfs/xfs_pnfs.c |  6 ++++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 240eb932c014..752b676c92e3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -95,8 +95,6 @@ xfs_update_prealloc_flags(
 		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (flags & XFS_PREALLOC_SYNC)
-		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
 
@@ -1059,9 +1057,6 @@ xfs_file_fallocate(
 		}
 	}
 
-	if (file->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-
 	error = xfs_update_prealloc_flags(ip, flags);
 	if (error)
 		goto out_unlock;
@@ -1084,8 +1079,14 @@ xfs_file_fallocate(
 	 * leave shifted extents past EOF and hence losing access to
 	 * the data that is contained within them.
 	 */
-	if (do_file_insert)
+	if (do_file_insert) {
 		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		error = xfs_log_force_inode(ip);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 8865f7d4404a..3a82a13d880c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -164,10 +164,12 @@ xfs_fs_map_blocks(
 		 * that the blocks allocated and handed out to the client are
 		 * guaranteed to be present even after a server crash.
 		 */
-		error = xfs_update_prealloc_flags(ip,
-				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (!error)
+			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
+
 	} else {
 		xfs_iunlock(ip, lock_flags);
 	}
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

