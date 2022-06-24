Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D573CCA47F
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jun 2022 06:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiFXGhT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 02:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiFXGhT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 02:37:19 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627A5609E2;
        Thu, 23 Jun 2022 23:37:14 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id i67-20020a1c3b46000000b003a03567d5e9so1118466wma.1;
        Thu, 23 Jun 2022 23:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XaAYZ6qH2eW6SbCvz+SG+Z2d1NX2G9RI3Gz0+O4UvMc=;
        b=Ss8g9sg8tfi2jCkfUtmbFabnMNm1BjX9paSgHwH4M6+WA6ZHkRDJ0q5Eltq/1u/Syh
         ALad4GnTC2xLf9ISiyiox2323zegRrrqZMvjtvSr0O3CrvOv/U+jBwxWyCFCtemD9EYm
         KkiYKRMgVLn7TLEWEQdpdAmbtJ4v/rtxTq/Dc3y25RIKP57AgtZfKIQfugJo48AQpG9i
         Fy33NF7bwvsEm9jp490WTfvKVRyGMSJVXadyikTgg4Ht+TU92O25HaMjbKzijL/5mL4M
         2SQusb1BEwVSIyCbjgRfQr0zevBErqhTy+todVBeMDxnZagY/LuH5JDFbydQ6WOpXtpB
         wy9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XaAYZ6qH2eW6SbCvz+SG+Z2d1NX2G9RI3Gz0+O4UvMc=;
        b=qo6LwPpGPe3KxRKXwWZWsd+i60CmFw7N/j3oXfCPkspUCsCMntCRDSI6/3RchDcWH2
         G1FKfY7YDwrr4V9ZZBGSArRopAJRWdMin5ozSekjwfcLInl5kQPocwFAZ/q122XojHbH
         B2JjtCrFB8FSCkQNWW0mFW7YATaQ1Yz72XaIME2qqTDEuq67t6AlNr++zPM3zO9hmn7f
         aDNk+UWLlIzphqQtIhgM3a+ABePQ227jBFMrsqPAN34a7CKJNNWqI8P4GUrrOuATMpe9
         B4Nz2waVkLVgTVp8lYlEJG2qjxLDhe/KWKbcN8xYJpUFhKRbgjF4QfMZNop73IVz0Abi
         iKEQ==
X-Gm-Message-State: AJIora870LxkSlnCLq5abNjf5q1mIquE15AM3rB8RsRFTGB7LNbkTGk3
        +XXUnbTUS+uCawN1k/3a1vc=
X-Google-Smtp-Source: AGRyM1sEAZrXiAnZ+2Xn/wXvrovRXWXy9oeo/rn0lh6K+sviHDh67UzkpgM2l4nLGTnUbx/Xlcgd9w==
X-Received: by 2002:a05:600c:1589:b0:3a0:2da9:bac0 with SMTP id r9-20020a05600c158900b003a02da9bac0mr1880553wmf.178.1656052632830;
        Thu, 23 Jun 2022 23:37:12 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d67ce000000b0021b89c07b6asm1540653wrw.108.2022.06.23.23.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:37:12 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [5.10 CANDIDATE v2 4/5] xfs: remove all COW fork extents when remounting readonly
Date:   Fri, 24 Jun 2022 09:37:01 +0300
Message-Id: <20220624063702.2380990-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624063702.2380990-1-amir73il@gmail.com>
References: <20220624063702.2380990-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 089558bc7ba785c03815a49c89e28ad9b8de51f9 upstream.

[backport xfs_icwalk -> xfs_eofblocks for 5.10.y]

As part of multiple customer escalations due to file data corruption
after copy on write operations, I wrote some fstests that use fsstress
to hammer on COW to shake things loose.  Regrettably, I caught some
filesystem shutdowns due to incorrect rmap operations with the following
loop:

mount <filesystem>				# (0)
fsstress <run only readonly ops> &		# (1)
while true; do
	fsstress <run all ops>
	mount -o remount,ro			# (2)
	fsstress <run only readonly ops>
	mount -o remount,rw			# (3)
done

When (2) happens, notice that (1) is still running.  xfs_remount_ro will
call xfs_blockgc_stop to walk the inode cache to free all the COW
extents, but the blockgc mechanism races with (1)'s reader threads to
take IOLOCKs and loses, which means that it doesn't clean them all out.
Call such a file (A).

When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
walks the ondisk refcount btree and frees any COW extent that it finds.
This function does not check the inode cache, which means that incore
COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
one of those former COW extents are allocated and mapped into another
file (B) and someone triggers a COW to the stale reservation in (A), A's
dirty data will be written into (B) and once that's done, those blocks
will be transferred to (A)'s data fork without bumping the refcount.

The results are catastrophic -- file (B) and the refcount btree are now
corrupt.  Solve this race by forcing the xfs_blockgc_free_space to run
synchronously, which causes xfs_icwalk to return to inodes that were
skipped because the blockgc code couldn't take the IOLOCK.  This is safe
to do here because the VFS has already prohibited new writer threads.

Fixes: 10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5ebd6cdc44a7..05cea7788d49 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1695,7 +1695,10 @@ static int
 xfs_remount_ro(
 	struct xfs_mount	*mp)
 {
-	int error;
+	struct xfs_eofblocks	eofb = {
+		.eof_flags	= XFS_EOF_FLAGS_SYNC,
+	};
+	int			error;
 
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
@@ -1703,8 +1706,13 @@ xfs_remount_ro(
 	 */
 	xfs_stop_block_reaping(mp);
 
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_icache_free_cowblocks(mp, NULL);
+	/*
+	 * Clear out all remaining COW staging extents and speculative post-EOF
+	 * preallocations so that we don't leave inodes requiring inactivation
+	 * cleanups during reclaim on a read-only mount.  We must process every
+	 * cached inode, so this requires a synchronous cache scan.
+	 */
+	error = xfs_icache_free_cowblocks(mp, &eofb);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
-- 
2.25.1

