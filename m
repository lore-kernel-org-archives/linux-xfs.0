Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 309EACCA47C
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 20:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiFWUhO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 16:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiFWUhO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 16:37:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617B260F17
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:13 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id l6so234137plg.11
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jun 2022 13:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hlu4iuvVEFL0RFP9rItuvOieChz+ZKZcK5FBCkGby/Y=;
        b=Fz5lWZahggnuKf6Eb3ZmPtqGYQ8ymkqAbrl22QyYRNFxrn+x0a2UGfc+n187QBnBYi
         iFyT881wRwmecZPVkUy+muWctTtw/qY0kXa/GMQGkHJZ+uyeujM4bR606bm+VuVLCwtf
         kYfcfiKySwleeIIsd+sQ30h2JhR7idZ3fS8UlnIy7B3SAKszAw63D+EqIEUJ0PBcZZxP
         l7nN5YRyw1NmTiIz4wlXJmG0bNUQNM5oV6BR8jBgJW62Ad5pK3GkYAa6A1ifWihBPO3E
         deP0Lcb6QCowzgqM9K8jkgmLvnlgDISVCMsyfH7HQW1l0ykndMmtDurQL3YowlcN1jbr
         J0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hlu4iuvVEFL0RFP9rItuvOieChz+ZKZcK5FBCkGby/Y=;
        b=VKXk3SQQ62lU7oUiXtBOp+6UyUq8u2TB2uRnsfk4G7GveZx+AUCf7IGcgU5woa66rT
         7n+FlSkaXTX0We6gzq58DB184sP6/0G+xbgLCTdx02bIIECe0YcAp6lxnZaQfABGtrPs
         QRFaPc6UwBgd+NPPidueF4A7jiF3NbPprCulWahuUNIjrVJvYoK//3Oq0WBBdX5nxnGc
         8Gj2ijISaNnE6zgRkNIhe1FM6Fo14tRB2aQdoebTVnDIMBddJktH3OiD16QHCehZny4W
         itoYLEHrRDZD17ZtfVlOsUd7o+EoiOH9N7IxOQP5JLdXNF9G/gKw33jsBQNUVbUkXqJG
         JKrw==
X-Gm-Message-State: AJIora800/WNPgkA8TA0klTXpANg5DR6qjOuzbOmQtWXLje97PfMYOEt
        mYqpF0MrOFfOd2zeKfu8KDA06jVAdNvBZQ==
X-Google-Smtp-Source: AGRyM1tBezQOY6mJP4Oz189B20u5yyBH4Kt6BDvcN2fLpbAslCgbufrw9+jdO8n0rmlj9RF+T6c2ow==
X-Received: by 2002:a17:902:f78b:b0:16a:4ad:f359 with SMTP id q11-20020a170902f78b00b0016a04adf359mr34167776pln.99.1656016632689;
        Thu, 23 Jun 2022 13:37:12 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2cd:202:a654:18fe:feac:cac1])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902768c00b0016a17da4ad4sm228386pll.39.2022.06.23.13.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 13:37:12 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE v3 4/7] xfs: remove all COW fork extents when remounting readonly
Date:   Thu, 23 Jun 2022 13:36:38 -0700
Message-Id: <20220623203641.1710377-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220623203641.1710377-1-leah.rumancik@gmail.com>
References: <20220623203641.1710377-1-leah.rumancik@gmail.com>
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
Acked-by: Darrick J. Wong <djwong@kernel.org>
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
2.37.0.rc0.161.g10f37bed90-goog

