Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD23C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 04:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDF1E21848
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 04:33:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbOM9bJA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfHVEd2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 00:33:28 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41520 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfHVEd1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 00:33:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so2720071pgg.8
        for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2019 21:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dkSpigVGL9aeu+fwJhPkmW5Jl8D1dRgil2Lfn5rr2XI=;
        b=QbOM9bJAiNaSPMPqAlCSPLKLOq9IDbbZ7ktip30wEQ43ELegkiRztvffdGl2yQQqWw
         YzKuMvxnmpZ3I9DXXtSUTZMEtQZqK1PuBar0vhOcFbCU7R+2l3Rpi0yb3iT/HluZgv1k
         zqDbZozsZiXDGVEQoHpWC+uDVxcF8mpcjB8RKnAg84s7ggO/P1yB3eQaFw1JJJ+Hh9X8
         LGZ5t9+7WZSTgv9oAFVj9bmvknX5rSfAvINnI+uppYOzTIhlYirZYJfHs+Amk8tqpunQ
         ZQvR1nV9DMjjmywK2pR4pRCoIKj04kz1rsDZKv/jOhEkNsgT8wJi+Api2xjZoFyRbHqD
         Br/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dkSpigVGL9aeu+fwJhPkmW5Jl8D1dRgil2Lfn5rr2XI=;
        b=m9K8+NzDERwLX7NnP203zm9GI+ysV6Pu3RCDqWifpbwucWHHU+TAp56ML708Rny23g
         eK4StAlZvgk9FlX2D2qyaCdckgF3p15pHgEih0Exkp1jUD49B+ViDym+jEsNxAkF60nP
         rxKEYnreUca6kqh3AwvZ4KHlBteAafTax5TwnYyA0LuXHiNuIZ55B5bA2h7KlbDqN/dU
         ZkSp/4Agh8T8HexQR6l8VH0EONdLg9j9d+UvjgqYviZIjYVbS0WcVzS1/eLUij8iMOis
         vpsu0gCsO89OTUoI3n9Sn7T36BJJMXRUP81q24AcOWPqu3qqXXH4KKADbbad7w8gV3Gq
         m9zw==
X-Gm-Message-State: APjAAAUNJL0zuPD7SHXsP17Y3pZt1nLY09Y1SDYvZiwjfAAcssy4p/Ql
        M0YR2Li7zPGEm10E5yQ8yw==
X-Google-Smtp-Source: APXvYqzaB7kIux40MfKPmZgVmMoHuv/6isAJF1aw2Aws44BMWQcJIM4fgueGNc3EILqK0CVsz0rgoQ==
X-Received: by 2002:aa7:8a0a:: with SMTP id m10mr40362166pfa.100.1566448407079;
        Wed, 21 Aug 2019 21:33:27 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id r137sm39204577pfc.145.2019.08.21.21.33.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 21:33:26 -0700 (PDT)
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com, xiakaixu1987@gmail.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v4] xfs: Fix agi&agf ABBA deadlock when performing rename with
 RENAME_WHITEOUT flag
Message-ID: <72adde91-556c-8af3-e217-5a658697972e@gmail.com>
Date:   Thu, 22 Aug 2019 12:33:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
 fs/xfs/xfs_inode.c | 76 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6467d5e..fd0f5ec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3282,18 +3282,46 @@ struct xfs_iunlink {
 					spaceres);
 
 	/*
-	 * Set up the target.
+	 * Check for expected errors before we dirty the transaction
+	 * so we can return an error without a transaction abort.
 	 */
-	if (target_ip == NULL) {
+	if (!target_ip && !spaceres) {
 		/*
 		 * If there's no space reservation, check the entry will
 		 * fit before actually inserting it.
 		 */
-		if (!spaceres) {
-			error = xfs_dir_canenter(tp, target_dp, target_name);
-			if (error)
-				goto out_trans_cancel;
-		}
+		error = xfs_dir_canenter(tp, target_dp, target_name);
+		if (error)
+			goto out_trans_cancel;
+	} else if (target_ip && S_ISDIR(VFS_I(target_ip)->i_mode) &&
+		  (!(xfs_dir_isempty(target_ip)) ||
+		  (VFS_I(target_ip)->i_nlink > 2))) {
+		/*
+		 * If target exists and it's a directory, check that whether
+		 * it can be destroyed.
+		 */
+		error = -EEXIST;
+		goto out_trans_cancel;
+	}
+
+	/*
+	 * Directory entry creation below may acquire the AGF. Remove
+	 * the whiteout from the unlinked list first to preserve correct
+	 * AGI/AGF locking order. This dirties the transaction so failures
+	 * after this point will abort and log recovery will clean up the
+	 * mess.
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
@@ -3312,22 +3340,6 @@ struct xfs_iunlink {
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
@@ -3419,25 +3431,15 @@ struct xfs_iunlink {
 
 	/*
 	 * For whiteouts, we need to bump the link count on the whiteout inode.
-	 * This means that failures all the way up to this point leave the inode
-	 * on the unlinked list and so cleanup is a simple matter of dropping
-	 * the remaining reference to it. If we fail here after bumping the link
-	 * count, we're shutting down the filesystem so we'll never see the
-	 * intermediate state on disk.
+	 * The whiteout inode has been removed from the unlinked list and log
+	 * recovery will clean up the mess for the failures up to this point.
+	 * After this point we have a real link, clear the tmpfile state flag
+	 * from the inode so it doesn't accidentally get misused in future.
 	 */
 	if (wip) {
 		ASSERT(VFS_I(wip)->i_nlink == 0);
 		xfs_bumplink(tp, wip);
-		error = xfs_iunlink_remove(tp, wip);
-		if (error)
-			goto out_trans_cancel;
 		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
-
-		/*
-		 * Now we have a real link, clear the "I'm a tmpfile" state
-		 * flag from the inode so it doesn't accidentally get misused in
-		 * future.
-		 */
 		VFS_I(wip)->i_state &= ~I_LINKABLE;
 	}
 
-- 
1.8.3.1

-- 
kaixuxia
