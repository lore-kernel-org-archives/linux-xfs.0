Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DDEC678D4
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Mar 2023 20:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjCBUfY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Mar 2023 15:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCBUfW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2023 15:35:22 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D863C3644E
        for <linux-xfs@vger.kernel.org>; Thu,  2 Mar 2023 12:35:20 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id oj5so358712pjb.5
        for <linux-xfs@vger.kernel.org>; Thu, 02 Mar 2023 12:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677789320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4WpNmWp/owzMHNA+RAMNdVLVQ750os1p8Tw/jbG7Fw=;
        b=cntb3iP/Ukpau6IFtcwqcVsAp/gqvAS8nBIswQXAK8DLVve8AbaHdhVAljrpH8X98U
         gwfFtbTQa01/Zfdi/fG3SgZN81cHWV+wP5tX22y6NhfprTMYqIy6MVpdt1ZbGl6x4oBR
         73GDHITbFWYdzIO/7C2LQJehvQSLFxdCt0/bFk8j4XsQs3Rjabrwjt0DTNkWefYqejsm
         sFbTA/JQyEnrVSPu18LjoROZ38v2T0F3rmbPwDyOv//qzKUmmWhPBjoJDvJCK9e7pD2U
         CFAkQTPQ5Q1IhFeLnW0nSdOHoTJ1QcLidN28hl+SHp2TB0Ybw+RlEvpjKV9ddb8ExQvL
         w97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677789320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z4WpNmWp/owzMHNA+RAMNdVLVQ750os1p8Tw/jbG7Fw=;
        b=gwm0vlmXwe/S8lUub5iIFYkV9X/w1VegKZCGmJ05vCczxJHz7MU7Wi738XhrK/Pl/5
         6zMHO/mAce1BlGu4HLamJQhUAsWcRsB1qxZdhqmFxFN1igMwvQhPiRm4QNHwNukl1DSH
         CvlSjUaxoPpWMWb1rTCchbxZ87PH28s74yWwvbHNyz5OGI91rrX6hkRyWzgd+6e1aARx
         fItf0kcKzzOi9QG2COr8FxvQtNZrZUnI1zZE97z70ENLUoDhzU9i3Wme8Xmia5DkMuMH
         nxX34nudImQleDuDbjW/SCHhklh6Y28ijc2ZQXddnrO5zvyGsuRYVMwUcbA/KyZGNaVd
         A5zQ==
X-Gm-Message-State: AO0yUKXbRxfbbG4wOvz3WmIILUZKzCyOhqQ5pToOQD8iPtsRkCO9dyZC
        cN8bgfkOnOYeBc79ymLp2AQYTLQ8b3YOHA==
X-Google-Smtp-Source: AK7set//ypfzWvOzim6/G3l28dzxYWX/8CjR7hLsOmw73L3La4IXaq8BmcRkcfXBYhQ+5EEtHJoY0w==
X-Received: by 2002:a05:6a21:6d89:b0:cd:ed5c:4ac with SMTP id wl9-20020a056a216d8900b000cded5c04acmr11336640pzb.17.1677789320276;
        Thu, 02 Mar 2023 12:35:20 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:637a:4159:6b3f:42eb])
        by smtp.gmail.com with ESMTPSA id b13-20020aa7870d000000b005ac86f7b87fsm113459pfo.77.2023.03.02.12.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 12:35:19 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 04/11] xfs: set prealloc flag in xfs_alloc_file_space()
Date:   Thu,  2 Mar 2023 12:34:57 -0800
Message-Id: <20230302203504.2998773-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230302203504.2998773-1-leah.rumancik@gmail.com>
References: <20230302203504.2998773-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 0b02c8c0d75a738c98c35f02efb36217c170d78c upsream.

Now that we only call xfs_update_prealloc_flags() from
xfs_file_fallocate() in the case where we need to set the
preallocation flag, do this in xfs_alloc_file_space() where we
already have the inode joined into a transaction and get
rid of the call to xfs_update_prealloc_flags() from the fallocate
code.

This also means that we now correctly avoid setting the
XFS_DIFLAG_PREALLOC flag when xfs_is_always_cow_inode() is true, as
these inodes will never have preallocated extents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_bmap_util.c | 9 +++------
 fs/xfs/xfs_file.c      | 8 --------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73a36b7be3bd..fd2ad6a3019c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -851,9 +851,6 @@ xfs_alloc_file_space(
 			rblocks = 0;
 		}
 
-		/*
-		 * Allocate and setup the transaction.
-		 */
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
 				dblocks, rblocks, false, &tp);
 		if (error)
@@ -870,9 +867,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		/*
-		 * Complete the transaction
-		 */
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 020e0a412287..8cd0c3df253f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -909,7 +909,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -1007,8 +1006,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1059,11 +1056,6 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-
-		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
-		if (error)
-			goto out_unlock;
-
 	}
 
 	/* Change file size if needed */
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

