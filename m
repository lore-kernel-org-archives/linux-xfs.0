Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1FBECAAD5
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 12:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiH1Mqd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 08:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiH1Mqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 08:46:31 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2D639BAD;
        Sun, 28 Aug 2022 05:46:30 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso6793175wmh.5;
        Sun, 28 Aug 2022 05:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=vR58R442Y/t8Jo0OV+K5yrdrf+CZJYm2VdqXmsIKaQ8=;
        b=qfnKAdBfDoqLi8EzrQPQGQ6n4wR6PI78+xG9xpu0dvcSK/4tixAqXsyPAle/r3Ha9K
         KwOVLj9KvLOIUPdhJQsmxuvmMdbWLNTuLQB2U8ihdgpwO1BBcJsC1tx4T+TSqJT2iU69
         rNEuV7B2aSIEcUqmSxbtiKuVYmydwPJaz1zMku/RE3d5OYoJENmVxPx3tHJdyoxejaYR
         QLyXoSXOAz+U6Jtar2II4P6uUnCT+1k32d4pwH2hPqGeiccietHPoBbxtIu7jgSHA0KF
         MAcNSXS9+6sB6ExQ8gg2y9/f+5wqfvyxPjKvzs6BL2JwmqafWauJeze3E2tA4rmVToBY
         1AVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vR58R442Y/t8Jo0OV+K5yrdrf+CZJYm2VdqXmsIKaQ8=;
        b=fKCLpb071zS3N4jFqjvhsMwoYyfJr4zDdrB2vzPwW0VwUXqKRhuLP/HoJ5Lwy25prc
         oxvaWcFnzDaZJeElHPn6RBkKD/3eliFsqXz2aQ7PIk5nkb0KU5AEszW8Fw9ZQU5SN05+
         j8BZRlbER1VjpUPmbhk5HWdftg0cp6xzIqp2dRzrC2Ig/41yDmp7ciDy9r0ha1dhUzHR
         FzHNMfAKPwgfOu3+1WOApmu+zVB93++HzdZ8jszXOLxDkiNKtWGj6kWLBX0QXwA7anc/
         U5LTvx2LBBgZIpS/T1AK7zSEqUo1go9Ff7//nYnssQLg7QqQz/78CENm+qYt9blH19bu
         BtTw==
X-Gm-Message-State: ACgBeo0zpC4sEQjFjPoQ7oomNIuGIq5XwhUWwuhUdZ4lNjAwFVZkXXup
        tlJyHegGBYkJo1HIQLwOvSzQDjkj+N8=
X-Google-Smtp-Source: AA6agR6105NVNaYu3MnG3zGKETTG3oXzbPYf7EK8KPOxO85rCb7kIoToxnVWQE2SS6QHeh9R80wprw==
X-Received: by 2002:a05:600c:474c:b0:3a7:3954:8818 with SMTP id w12-20020a05600c474c00b003a739548818mr4413631wmo.124.1661690788827;
        Sun, 28 Aug 2022 05:46:28 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([2a0d:6fc2:4b00:1500:ecf5:e90e:2ba2:1534])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm4443414wrh.20.2022.08.28.05.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 05:46:28 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 1/7] xfs: remove infinite loop when reserving free block pool
Date:   Sun, 28 Aug 2022 15:46:08 +0300
Message-Id: <20220828124614.2190592-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220828124614.2190592-1-amir73il@gmail.com>
References: <20220828124614.2190592-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

commit 15f04fdc75aaaa1cccb0b8b3af1be290e118a7bc upstream.

[Added wrapper xfs_fdblocks_unavailable() for 5.10.y backport]

Infinite loops in kernel code are scary.  Calls to xfs_reserve_blocks
should be rare (people should just use the defaults!) so we really don't
need to try so hard.  Simplify the logic here by removing the infinite
loop.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_fsops.c | 52 +++++++++++++++++++---------------------------
 fs/xfs/xfs_mount.h |  8 +++++++
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ef1d5bb88b93..6d4f4271e7be 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -376,46 +376,36 @@ xfs_reserve_blocks(
 	 * If the request is larger than the current reservation, reserve the
 	 * blocks before we update the reserve counters. Sample m_fdblocks and
 	 * perform a partial reservation if the request exceeds free space.
+	 *
+	 * The code below estimates how many blocks it can request from
+	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
+	 * race since fdblocks updates are not always coordinated via
+	 * m_sb_lock.
 	 */
-	error = -ENOSPC;
-	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
-		if (free <= 0)
-			break;
-
-		delta = request - mp->m_resblks;
-		lcounter = free - delta;
-		if (lcounter < 0)
-			/* We can't satisfy the request, just get what we can */
-			fdblks_delta = free;
-		else
-			fdblks_delta = delta;
-
+	free = percpu_counter_sum(&mp->m_fdblocks) -
+						xfs_fdblocks_unavailable(mp);
+	delta = request - mp->m_resblks;
+	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
-		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
-		 * things changed while we were calculating fdblks_delta and so
-		 * we should try again to see if there is anything left to
-		 * reserve.
-		 *
-		 * Don't set the reserved flag here - we don't want to reserve
-		 * the extra reserve blocks from the reserve.....
+		 * count or we'll get an ENOSPC.  Don't set the reserved flag
+		 * here - we don't want to reserve the extra reserve blocks
+		 * from the reserve.
 		 */
+		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
 
-	/*
-	 * Update the reserve counters if blocks have been successfully
-	 * allocated.
-	 */
-	if (!error && fdblks_delta) {
-		mp->m_resblks += fdblks_delta;
-		mp->m_resblks_avail += fdblks_delta;
+		/*
+		 * Update the reserve counters if blocks have been successfully
+		 * allocated.
+		 */
+		if (!error) {
+			mp->m_resblks += fdblks_delta;
+			mp->m_resblks_avail += fdblks_delta;
+		}
 	}
-
 out:
 	if (outval) {
 		outval->resblks = mp->m_resblks;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dfa429b77ee2..3a6bc9dc11b5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -406,6 +406,14 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
 				     xfs_agnumber_t *maxagi);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
+/* Accessor added for 5.10.y backport */
+static inline uint64_t
+xfs_fdblocks_unavailable(
+	struct xfs_mount	*mp)
+{
+	return mp->m_alloc_set_aside;
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
-- 
2.25.1

