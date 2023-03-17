Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00557C74A5B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Mar 2023 11:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjCQLIg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCQLIf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 07:08:35 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB42A26C1D
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id x22so3072323wmj.3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 04:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679051312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kUvv3uBGGOzJwwn6KRNuDlAWVNfTAIS5jkw/tF5MpM=;
        b=kU9MmlBCZy0t8WRgmcl+vwlShFOLXyzNechlV6AjeHG1zFJh+05RdG+BIMqWOJeqd4
         KJrdKP5CFsxb4xzFP0k0GVZWZGJEb7rh65lKxUeGqVL8zftXuQRTsxPcZ5kRoWCh8M/r
         B+q3v2NHFawlC+w4vPVauCTw1cPUXHtjKItUyhZV2boMkOxVN+qoPROrIiL5b+69OHMm
         OSmrYWimpzRhigcq+vKm5Y4GAsyn0Yo1iprq+xouJmAYAefZ2GDXWQ03XXIf8UYCIJMj
         Ih3gqNwACyb3SKabwPdjSLWPYU8rIIf5SQyUszzcPVabz+M/R7vzvfDaSEN1TNVbPWQ6
         jARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679051312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kUvv3uBGGOzJwwn6KRNuDlAWVNfTAIS5jkw/tF5MpM=;
        b=I0bv06tXOCOWE0+T6MQMxkQJohb3vbmHF+ClWlSIi2s8PZw3vycLGsaXP05W42Yc2i
         nuXf/IacfOJ5NDfiXK9r5/zdR9IHK5woKReqPpL1ck04N4ViPhMCnHdpMa4TPrtm2tsQ
         hKM8le2LHyk0hxcjIY+Lqdm/FOtzTUnvMle6cPGbayud/AOEILzuiOzZBYtI6Ec/u79N
         GkVUdhc2gUvSxyJZMDSXAO/BBEcBjxckOaabBMv7pqE5AI+wDBO8eT1zGUsTOBRoBrma
         5jZ4SqFDVANFxpQ1RVUzV5WZlzVPHKYsNQdRUHBBLP10YE/TlrzGLf9ujwiHH1N4treN
         sZGw==
X-Gm-Message-State: AO0yUKUSikHFHLx3KS+OWpk2wR1pGaV7yNbWCIHlxZQ2HrBoOZeg0kOc
        hu1tH24/Y/YBE1X1FfFq3GI=
X-Google-Smtp-Source: AK7set+B69Qxlhwzdr4B/K27HjdVDjq87Qa/2jh+Frkhr2o+/WtPRDqZfW3MHE35TQkGhmSzIuXxOw==
X-Received: by 2002:a05:600c:470e:b0:3eb:29fe:734a with SMTP id v14-20020a05600c470e00b003eb29fe734amr24080282wmo.39.1679051312468;
        Fri, 17 Mar 2023 04:08:32 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b003daf7721bb3sm7551100wmi.12.2023.03.17.04.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 04:08:32 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 06/15] xfs: set prealloc flag in xfs_alloc_file_space()
Date:   Fri, 17 Mar 2023 13:08:08 +0200
Message-Id: <20230317110817.1226324-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317110817.1226324-1-amir73il@gmail.com>
References: <20230317110817.1226324-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 0b02c8c0d75a738c98c35f02efb36217c170d78c upstream.

[backport for 5.10.y]

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
---
 fs/xfs/xfs_bmap_util.c | 9 +++------
 fs/xfs/xfs_file.c      | 8 --------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7371a7f7c652..fbab1042bc90 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -800,9 +800,6 @@ xfs_alloc_file_space(
 			quota_flag = XFS_QMOPT_RES_REGBLKS;
 		}
 
-		/*
-		 * Allocate and setup the transaction.
-		 */
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
 				resrtextents, 0, &tp);
 
@@ -830,9 +827,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error0;
 
-		/*
-		 * Complete the transaction
-		 */
+		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a95af57a59a7..9b6c5ba5fdfb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -850,7 +850,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -948,8 +947,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1000,11 +997,6 @@ xfs_file_fallocate(
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
2.34.1

