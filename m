Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0962CC3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 00:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbiHQA4c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 20:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbiHQA4b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 20:56:31 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E235C80343
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:30 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ch17-20020a17090af41100b001fa74771f61so2527637pjb.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 17:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=tKjBFezx+sRNoSLZH1HYf0SLhJpEWp+DqKcAS00qeZ8=;
        b=IE6nnX3Wd077iZWh7zw5wV2tesgn4QePjmVMX+Y0VOqx3mZ2UScGd38etgu5yjYmrC
         Jnj4SswoCkCUMlGVoah4cnM2Nwl7mrvuzu10StXlynA/aAy9vJy9ff48JVerFrxWlpQQ
         D4BonKWRNfr1qQrd/F3DbNnKg7sQOoxM26RJEQZofeV/rDGtKn1Gr38BDzSkeqvJz7Pv
         xm5KyRQRwWjkmVvqaxRIYw7gnNHhjxgKN5tSzhxHNwyDKpEzp8dOVapVTk3pt9CV1U/4
         TvTp+WOjqgdw5jlQggTkSV+PrF16xb5kc5E8EuGoLiMWNdlNgmnlqzY1Br30RJO97mdY
         ECaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tKjBFezx+sRNoSLZH1HYf0SLhJpEWp+DqKcAS00qeZ8=;
        b=RKDI4sCh7493w81KfvQUmRIWxMSGvIZQiodZdJyU/y8o3gTAmiYR9XKbfBd1RA79D4
         zHev3p8gNJzIw4jyfExUNTh2uCt7C9pncY2iXRvrQIk5GNHvgH1O6MnbryI36rAHFPf4
         mexML4x3Ex4rRuxdvANTUgAz3OjMpfzL84BpHhF3G1P4MI3NxJlp+26/cVWOxmuMn9xp
         Z2GKfWYs0oMXwE8EbzLEynwyidKS+yBYYfTjRjB3rd2ZizXp+HKYav7h9RlFd41DY195
         5akWWS5IfWlLCAJ0XAjknuFKq2ZnHXEFMR8he/oeIgZuRrIrXFRsXKZfZexNa2siYxK7
         uVew==
X-Gm-Message-State: ACgBeo0IJHdbjEPJctmWgLp3o3Qbn/64gsSBng9ju/vE0z/ra0+e8uyR
        oL3roERnyOJqYBXqaRwqXhDxU4S3PKXTqQ==
X-Google-Smtp-Source: AA6agR6HYqtQj6Oc/l/QDt0aquG/9akGNwbkz2MzxxYRIe5OyOQJ+s0V5cqDtlc/ZB5i2XxcgJM+PA==
X-Received: by 2002:a17:903:d4:b0:16d:bb31:f66 with SMTP id x20-20020a17090300d400b0016dbb310f66mr24517812plc.60.1660697790200;
        Tue, 16 Aug 2022 17:56:30 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:eb64:ce74:44c1:343c])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090a5e4e00b001f8aee0d826sm153458pji.53.2022.08.16.17.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 17:56:29 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH CANDIDATE 5.15 3/9] xfs: reserve quota for target dir expansion when renaming files
Date:   Tue, 16 Aug 2022 17:56:04 -0700
Message-Id: <20220817005610.3170067-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220817005610.3170067-1-leah.rumancik@gmail.com>
References: <20220817005610.3170067-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 41667260bc84db4dfe566e3f6ab6da5293d60d8d ]

XFS does not reserve quota for directory expansion when renaming
children into a directory.  This means that we don't reject the
expansion with EDQUOT when we're at or near a hard limit, which means
that unprivileged userspace can use rename() to exceed quota.

Rename operations don't always expand the target directory, and we allow
a rename to proceed with no space reservation if we don't need to add a
block to the target directory to handle the addition.  Moreover, the
unlink operation on the source directory generally does not expand the
directory (you'd have to free a block and then cause a btree split) and
it's probably of little consequence to leave the corner case that
renaming a file out of a directory can increase its size.

As with link and unlink, there is a further bug in that we do not
trigger the blockgc workers to try to clear space when we're out of
quota.

Because rename is its own special tricky animal, we'll patch xfs_rename
directly to reserve quota to the rename transaction.  We'll leave
cleaning up the rest of xfs_rename for the metadata directory tree
patchset.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_inode.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f4dec7f6c6d0..fb7a97cdf99f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3103,7 +3103,8 @@ xfs_rename(
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
 	int			spaceres;
-	int			error;
+	bool			retried = false;
+	int			error, nospace_error = 0;
 
 	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
@@ -3127,9 +3128,12 @@ xfs_rename(
 	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip, wip,
 				inodes, &num_inodes);
 
+retry:
+	nospace_error = 0;
 	spaceres = XFS_RENAME_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, spaceres, 0, 0, &tp);
 	if (error == -ENOSPC) {
+		nospace_error = error;
 		spaceres = 0;
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_rename, 0, 0, 0,
 				&tp);
@@ -3183,6 +3187,31 @@ xfs_rename(
 					target_dp, target_name, target_ip,
 					spaceres);
 
+	/*
+	 * Try to reserve quota to handle an expansion of the target directory.
+	 * We'll allow the rename to continue in reservationless mode if we hit
+	 * a space usage constraint.  If we trigger reservationless mode, save
+	 * the errno if there isn't any free space in the target directory.
+	 */
+	if (spaceres != 0) {
+		error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
+				0, false);
+		if (error == -EDQUOT || error == -ENOSPC) {
+			if (!retried) {
+				xfs_trans_cancel(tp);
+				xfs_blockgc_free_quota(target_dp, 0);
+				retried = true;
+				goto retry;
+			}
+
+			nospace_error = error;
+			spaceres = 0;
+			error = 0;
+		}
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * Check for expected errors before we dirty the transaction
 	 * so we can return an error without a transaction abort.
@@ -3429,6 +3458,8 @@ xfs_rename(
 out_release_wip:
 	if (wip)
 		xfs_irele(wip);
+	if (error == -ENOSPC && nospace_error)
+		error = nospace_error;
 	return error;
 }
 
-- 
2.37.1.595.g718a3a8f04-goog

