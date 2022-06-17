Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD8DCCA47C
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Jun 2022 10:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381627AbiFQKHm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 06:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381641AbiFQKHU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 06:07:20 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5A669B6B;
        Fri, 17 Jun 2022 03:06:55 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w17so5096881wrg.7;
        Fri, 17 Jun 2022 03:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m11EV4fTYjQr+CF4ItvJAnTX7XtYwLnaXp2qOkxkWzo=;
        b=h9cmdzTF46gHaG9ANVIwEyBi0nsK7WcVU4jjz/jyFa8UKRs1vhi8NvNlme6rM+dfkB
         jKuoSF3krJmqCuShZLggGEcobVaCaarF40f1flhARO+nv5nMmA5d66RfyZmpWLnp/5qs
         bfYULMN65DzIjo9CqhLH7FptX74OEsosOIfMZP3MNIwm/PiGbjJLLYzUY5iV/4jfm3Mh
         cJZCjJxqWf5FhDvrEq5EmwBm7UPtENO+W/yxxm5iRwYrtmrFrsgZdUlRGjyxo/WpfXoy
         OWcK/rdge4T8eP0XXoMLrOkR+q9y1RkNSo9STWwpzcMufgzAAx3jktXF8VAb6tuP8Wpq
         oHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m11EV4fTYjQr+CF4ItvJAnTX7XtYwLnaXp2qOkxkWzo=;
        b=VY0gFrkEc8fTx0lh5zYN0VGYpYVSusQJQmlNt2I+rckBjk+B1lCd+PLZ6jhuh5/yWi
         nu1bcMG4hMpKyn9VhB5+0KGxBlpW89g3cuqScukMw6wA22F/vZlkfct8av8WD82yJKBC
         BUCVg7pwSTDc2DdD9fkUeY1PGGzD1KJnZwFAF8rTjno6tQ0y1sQKFa4FnnDuDhgSbP29
         1KXofTy4L+s4Xn972JIcrC8htjFXIY5SWi6qAusyFcP0tZw7G6wtqm5LBw2wTTK8zh7R
         QpIW/8flV89+4vyhhCzw30s1b3OaRrye9GYVz0gDOGyKVbU35HxuLb8eu1jBoyeKM6X2
         Fy+A==
X-Gm-Message-State: AJIora/ijN4BgQwZGVzwS6Afm2+P98v2D9+f9PoWslq58/VYFHCTamoA
        J8+XLl+K2ML0nnXIJZ/qK5I=
X-Google-Smtp-Source: AGRyM1v6cRBnhrJNK4NC/q0Lx0MgNcl4vveBlH1xqVrddaUIrQ21amVx9/iioJGJQ94d3jY9BWU9pQ==
X-Received: by 2002:adf:b644:0:b0:210:1fde:a513 with SMTP id i4-20020adfb644000000b002101fdea513mr9123878wre.604.1655460413730;
        Fri, 17 Jun 2022 03:06:53 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id m42-20020a05600c3b2a00b003973435c517sm5265534wms.0.2022.06.17.03.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:53 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.10 CANDIDATE 04/11] xfs: remove all COW fork extents when remounting readonly
Date:   Fri, 17 Jun 2022 13:06:34 +0300
Message-Id: <20220617100641.1653164-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617100641.1653164-1-amir73il@gmail.com>
References: <20220617100641.1653164-1-amir73il@gmail.com>
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
---
 fs/xfs/xfs_super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d220a63d7883..6323974d6b3e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1711,7 +1711,10 @@ static int
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
@@ -1719,8 +1722,13 @@ xfs_remount_ro(
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

