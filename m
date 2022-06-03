Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F27CCA473
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jun 2022 18:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347726AbiFCS6A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348473AbiFCS57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jun 2022 14:57:59 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70A629833
        for <linux-xfs@vger.kernel.org>; Fri,  3 Jun 2022 11:57:58 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y189so7775408pfy.10
        for <linux-xfs@vger.kernel.org>; Fri, 03 Jun 2022 11:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1AmL5uUjyEDYD5vOJIFIficQ77W0siDNF76pjvemU1M=;
        b=Wr81TqJKUjOg8Hg+KV9FEbVQ6cVdf7yoUvBe55QWMCN860ZfpVWGNodb41HX15P8DW
         t1HVH95ZOGjl1NI4oLPXo78v1vPHsjDCkHfvt9+wVCPE38kLorDdG/JOs7d95l5sezgl
         QNpnptP/BJUzJ0k+6MIQNsA+YiSv8AZpavhTlGjzwTtQUfE5PJ44qDnU9zkqjx32rdsf
         4CfQlBlsIsfq01lF96pGkQQnJ+xb5MOPryg9mZsL6N6AGgNYWHFznPezOzNDeR7v4G7x
         p9JSP5HMqO5jxmpFtYhUDRF930gtL71g6vZoIHS9VRaiCGy7hFRlgMUcQr2fq7gKzbpf
         kqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1AmL5uUjyEDYD5vOJIFIficQ77W0siDNF76pjvemU1M=;
        b=r7CYxBpKK+N+RGr1x+le2gCoui3hobyzzM6kuam3H62YgKjg+g6xWvN6ciIyL6IQEJ
         bWH1mq901r8WmUhOjNH8S1+DVdlykw502Qn8HfRyM5JMxMMZ+trATsDFweCP47vftqmD
         Wx0SKWBsr1VK3zWnXV4C5wW1WYkraFyRopgFHQMu6q38DquyY/EOW857BTjp825MOyM8
         xwnDfiHaPKZNasb9dPpa1nryMGXILPlTIIaeRIAuQGV+yb0artUZPTmH6aFJ3gC5VbJO
         +2hukI+/yVwKE/MsyGXxu03zfOIqo5B/Jf7pniX3oG2Da1NYa6p7qN6SU2Y+syLPEp8o
         zW0w==
X-Gm-Message-State: AOAM5320hmjTd2Dj+rdRV2BIzYU+84rAGYER/4z0xGc2pc+zUW32Ce1F
        chPw6GG3expapA7QztMaszIqGRnZWbNscA==
X-Google-Smtp-Source: ABdhPJwz2A7mU8LYAGHN82USd1Q5OuVBXzIVFur97+RL3ZgVFzXsfG5vjUk0DRXdHz2ih/WsmKmZmQ==
X-Received: by 2002:a63:5f53:0:b0:3fc:c510:c4a0 with SMTP id t80-20020a635f53000000b003fcc510c4a0mr10209765pgb.80.1654282678170;
        Fri, 03 Jun 2022 11:57:58 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:e74e:a023:a0be:b6a8])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001621ce92196sm4480969plk.86.2022.06.03.11.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 11:57:57 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 05/15] xfs: remove all COW fork extents when remounting readonly
Date:   Fri,  3 Jun 2022 11:57:11 -0700
Message-Id: <20220603185721.3121645-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220603185721.3121645-1-leah.rumancik@gmail.com>
References: <20220603185721.3121645-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 089558bc7ba785c03815a49c89e28ad9b8de51f9 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 170fee98c45c..23673703618a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1768,7 +1768,10 @@ static int
 xfs_remount_ro(
 	struct xfs_mount	*mp)
 {
-	int error;
+	struct xfs_icwalk	icw = {
+		.icw_flags	= XFS_ICWALK_FLAG_SYNC,
+	};
+	int			error;
 
 	/*
 	 * Cancel background eofb scanning so it cannot race with the final
@@ -1776,8 +1779,13 @@ xfs_remount_ro(
 	 */
 	xfs_blockgc_stop(mp);
 
-	/* Get rid of any leftover CoW reservations... */
-	error = xfs_blockgc_free_space(mp, NULL);
+	/*
+	 * Clear out all remaining COW staging extents and speculative post-EOF
+	 * preallocations so that we don't leave inodes requiring inactivation
+	 * cleanups during reclaim on a read-only mount.  We must process every
+	 * cached inode, so this requires a synchronous cache scan.
+	 */
+	error = xfs_blockgc_free_space(mp, &icw);
 	if (error) {
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
-- 
2.36.1.255.ge46751e96f-goog

