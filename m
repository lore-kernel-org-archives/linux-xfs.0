Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D26C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 04:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3B142339D
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 04:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tLKvqx9Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfHUEqY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 00:46:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43064 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfHUEqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 00:46:24 -0400
Received: by mail-pl1-f193.google.com with SMTP id 4so619662pld.10
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2019 21:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=yI8O5NeomA9vU5KiViEmux7z0ZL2Vy3sxm5JlszmgjA=;
        b=tLKvqx9YgWznUY3tkBxPRinJMviqCDHjwAA/F4FCYs1cdH++Y8D9P3zRb2qz2Zjuht
         If101LFzYbE1ynmv1ltiJHrKdZ818pl+TZOV12aabz+270fBYxHeBAGm9Dedkg/1kFDN
         /k210bUBSD3RRryT0DOPFIDVZsbHP9vXwG6BtMoIMm61c0M9rqXBr6xjePkFO3hAj3BZ
         SqyhCpPRm/XRGhaMckrcbKkcTCgqhbL9uJNdDaGeR9QjE7QEVwNsfeml6f02KM9DkOF0
         gJT6QI2ErQEeYYUM6bIxbEKuELyDzUGYu47IIiBI1eUpZp4JWAJdbBWfDCxN/Tf9JWWx
         oQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=yI8O5NeomA9vU5KiViEmux7z0ZL2Vy3sxm5JlszmgjA=;
        b=DjokWKAWK4N8ghbEXxF4C9WeS5Jk6pNwCaUY1WpNn6WbzgweZVynYgC914C4jIsP/H
         eIyqZWY8G0Chf8d2Y+gx/DDyp3coTBAHCrOfahZRRMgLAgUeoxTLWTod1lEVc5E+hO2/
         koFKcTKFsj6M7EpkfkblTDsLA3U0YSWkioVcyZO2UyKLSJt/ci0JuQgsKC+v3OiqKWk5
         fygVT3O6qWvt58pj5UZOEF3mUPmNlAQn2korjW7QcaU47Rhz1EMFFlakfQrjn5hW8GE1
         Gp62BfKoeHnjtCSkFCErc23oYkLGAcBa8NorXlwtre6uLYmEEH4Ecfp1Nas0DGCoBF9E
         NnUw==
X-Gm-Message-State: APjAAAUZrr7qi42tFjfFjo16XEFYD/qtEyLnEBdAukmyfkqQFi6U64sV
        rRVPFQBqmKlxwN191xwHiurgOao=
X-Google-Smtp-Source: APXvYqx59tIYgX17wW2t8c1NhJS8v8Ks0VGpS2CLRPBVpGGvlGdyR4/ZZePtRkNGOzMy8hZDTUiwmQ==
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr1898091pll.163.1566362783479;
        Tue, 20 Aug 2019 21:46:23 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id j187sm27978126pfg.178.2019.08.20.21.46.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 21:46:22 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com, xiakaixu1987@gmail.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v3] xfs: Fix agi&agf ABBA deadlock when performing rename with
 RENAME_WHITEOUT flag
Message-ID: <cc2a0c81-ee9e-d2bd-9cc0-025873f394c0@gmail.com>
Date:   Wed, 21 Aug 2019 12:46:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

When performing rename operation with RENAME_WHITEOUT flag, we will
hold AGF lock to allocate or free extents in manipulating the dirents
firstly, and then doing the xfs_iunlink_remove() call last to hold
AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.

The big problem here is that we have an ordering constraint on AGF
and AGI locking - inode allocation locks the AGI, then can allocate
a new extent for new inodes, locking the AGF after the AGI. Hence
the ordering that is imposed by other parts of the code is AGI before
AGF. So we get the ABBA agi&agf deadlock here.

Process A:
Call trace:
  ? __schedule+0x2bd/0x620
  schedule+0x33/0x90
  schedule_timeout+0x17d/0x290
  __down_common+0xef/0x125
  ? xfs_buf_find+0x215/0x6c0 [xfs]
  down+0x3b/0x50
  xfs_buf_lock+0x34/0xf0 [xfs]
  xfs_buf_find+0x215/0x6c0 [xfs]
  xfs_buf_get_map+0x37/0x230 [xfs]
  xfs_buf_read_map+0x29/0x190 [xfs]
  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
  xfs_read_agf+0xa6/0x180 [xfs]
  ? schedule_timeout+0x17d/0x290
  xfs_alloc_read_agf+0x52/0x1f0 [xfs]
  xfs_alloc_fix_freelist+0x432/0x590 [xfs]
  ? down+0x3b/0x50
  ? xfs_buf_lock+0x34/0xf0 [xfs]
  ? xfs_buf_find+0x215/0x6c0 [xfs]
  xfs_alloc_vextent+0x301/0x6c0 [xfs]
  xfs_ialloc_ag_alloc+0x182/0x700 [xfs]
  ? _xfs_trans_bjoin+0x72/0xf0 [xfs]
  xfs_dialloc+0x116/0x290 [xfs]
  xfs_ialloc+0x6d/0x5e0 [xfs]
  ? xfs_log_reserve+0x165/0x280 [xfs]
  xfs_dir_ialloc+0x8c/0x240 [xfs]
  xfs_create+0x35a/0x610 [xfs]
  xfs_generic_create+0x1f1/0x2f0 [xfs]
  ...

Process B:
Call trace:
  ? __schedule+0x2bd/0x620
  ? xfs_bmapi_allocate+0x245/0x380 [xfs]
  schedule+0x33/0x90
  schedule_timeout+0x17d/0x290
  ? xfs_buf_find+0x1fd/0x6c0 [xfs]
  __down_common+0xef/0x125
  ? xfs_buf_get_map+0x37/0x230 [xfs]
  ? xfs_buf_find+0x215/0x6c0 [xfs]
  down+0x3b/0x50
  xfs_buf_lock+0x34/0xf0 [xfs]
  xfs_buf_find+0x215/0x6c0 [xfs]
  xfs_buf_get_map+0x37/0x230 [xfs]
  xfs_buf_read_map+0x29/0x190 [xfs]
  xfs_trans_read_buf_map+0x13d/0x520 [xfs]
  xfs_read_agi+0xa8/0x160 [xfs]
  xfs_iunlink_remove+0x6f/0x2a0 [xfs]
  ? current_time+0x46/0x80
  ? xfs_trans_ichgtime+0x39/0xb0 [xfs]
  xfs_rename+0x57a/0xae0 [xfs]
  xfs_vn_rename+0xe4/0x150 [xfs]
  ...

In this patch we move the xfs_iunlink_remove() call to
before acquiring the AGF lock to preserve correct AGI/AGF locking
order.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
  fs/xfs/xfs_inode.c | 61 ++++++++++++++++++++++++++++++++++--------------------
  1 file changed, 38 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6467d5e..cf06568 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3282,7 +3282,8 @@ struct xfs_iunlink {
  					spaceres);

  	/*
-	 * Set up the target.
+	 * Error checks before we dirty the transaction, return
+	 * the error code if check failed and the filesystem is clean.
  	 */
  	if (target_ip == NULL) {
  		/*
@@ -3294,6 +3295,40 @@ struct xfs_iunlink {
  			if (error)
  				goto out_trans_cancel;
  		}
+	} else {
+		/*
+		 * If target exists and it's a directory, check that both
+		 * target and source are directories and that target can be
+		 * destroyed, or that neither is a directory.
+		 */
+		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
+			/*
+			 * Make sure target dir is empty.
+			 */
+			if (!(xfs_dir_isempty(target_ip)) ||
+			    (VFS_I(target_ip)->i_nlink > 2)) {
+				error = -EEXIST;
+				goto out_trans_cancel;
+			}
+		}
+	}
+
+	/*
+	 * Directory entry creation below may acquire the AGF. Remove
+	 * the whiteout from the unlinked list first to preserve correct
+	 * AGI/AGF locking order.
+	 */
+	if (wip) {
+		ASSERT(VFS_I(wip)->i_nlink == 0);
+		error = xfs_iunlink_remove(tp, wip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	/*
+	 * Set up the target.
+	 */
+	if (target_ip == NULL) {
  		/*
  		 * If target does not exist and the rename crosses
  		 * directories, adjust the target directory link count
@@ -3312,22 +3347,6 @@ struct xfs_iunlink {
  		}
  	} else { /* target_ip != NULL */
  		/*
-		 * If target exists and it's a directory, check that both
-		 * target and source are directories and that target can be
-		 * destroyed, or that neither is a directory.
-		 */
-		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
-			/*
-			 * Make sure target dir is empty.
-			 */
-			if (!(xfs_dir_isempty(target_ip)) ||
-			    (VFS_I(target_ip)->i_nlink > 2)) {
-				error = -EEXIST;
-				goto out_trans_cancel;
-			}
-		}
-
-		/*
  		 * Link the source inode under the target name.
  		 * If the source inode is a directory and we are moving
  		 * it across directories, its ".." entry will be
@@ -3421,16 +3440,12 @@ struct xfs_iunlink {
  	 * For whiteouts, we need to bump the link count on the whiteout inode.
  	 * This means that failures all the way up to this point leave the inode
  	 * on the unlinked list and so cleanup is a simple matter of dropping
-	 * the remaining reference to it. If we fail here after bumping the link
-	 * count, we're shutting down the filesystem so we'll never see the
-	 * intermediate state on disk.
+	 * the remaining reference to it. Move the xfs_iunlink_remove() call to
+	 * before acquiring the AGF lock to preserve correct AGI/AGF locking order.
  	 */
  	if (wip) {
  		ASSERT(VFS_I(wip)->i_nlink == 0);
  		xfs_bumplink(tp, wip);
-		error = xfs_iunlink_remove(tp, wip);
-		if (error)
-			goto out_trans_cancel;
  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);

  		/*
-- 
1.8.3.1

-- 
kaixuxia
