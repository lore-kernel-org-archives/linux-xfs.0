Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A881ACE00;
	Tue, 24 Sep 2024 18:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203147; cv=none; b=ZEnsXqhISdqBSNbK1XlpTHzLS6egkWV3qMXO407SujYYIzyDCxhZHj/CxSPU+HAm3QEVc/1u0xSRmijk2+sWJ/JfcX7Ge1y3RDFFuT31PgO1Q3G7hAdIOz/6TeuvpshbQy/eoG1I5rlV+Ci+5FPPwAK46M7cbie0IaKRPDb8oKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203147; c=relaxed/simple;
	bh=vHC7hp8kOa1EbTDhpw6Ze6OISmQ5dHHPQS17ISvY1RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAypyzSz842hkqTqYz/8IeaSbho8EnIJBx0tFWoDadhsrSgXibsRWI9d5pjh0RLiAKn50c29UNdAdaHEmK8gJJnlixR0jP3NG48F6CzTzmJwlEJiOP//OfznUOHcxptv1GdONWEzwgPvQ/qBE/XhpEiw1CKF26VJHQA60H+X0rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VHGcePfY; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHGcePfY"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20573eb852aso1029985ad.1;
        Tue, 24 Sep 2024 11:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203144; x=1727807944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KN6aynWIfGmMF6yj54h8N6+mGM/wmoW9+W4pkaU71NQ=;
        b=VHGcePfYUFXDQ8WRaTJvtj0B6iUuiXHXd53JdAGXdXO949mrSwt9J1dVg+ZFknrsAT
         GYJ/H0a0HkjFOmT7ViV0PLqcvwmiD3CsJ5xIB5X7vHmqM9zeFmK72HN1LGRGFc26Lmma
         wYFWisCqDigE5W90K/0bACgVh0qWnSwQd/YtiQ7l6CYn4xIEo95UtXiDWe6JebkuLkGR
         zcS6qYdIvCco5Uz21otcIAATo0n0kHfbXKNU/4N5hH2S6+Ci+XdiNc18wbbgtwTkFRaI
         2Qd4WRZ89w9QLWrW0E44qMoBI4aaYV3Bw9FYLHEfmPawjZZ3Dg5qn9CazQC77hSkahW/
         M22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203144; x=1727807944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KN6aynWIfGmMF6yj54h8N6+mGM/wmoW9+W4pkaU71NQ=;
        b=Wn7DccggqgyD9K81OMINERLcR+4bzcpxuZDfb38uKmlh4+hWdiY36NiuuiHZEKgXpY
         cCJpfFqs7rxKzfxjyixaKVgiv+qYREv/prXpErUqgjTJnRyAkD/Eev4spbdBJEZffgLm
         9Dx/aT8Og18BjyiSJ+qhmJwIVWfhDqo84FrtXVIQGBkReGzOO2yskDd24QPCSR3oXemq
         nx+wqdnUU/9WrZ6BmNHq68snlRsQAzmRJsjYNNL5pNQfZ2RteFxZV52T+QB7x65emKMG
         aEbLIBZfNI1YnnjwvNBxi4UTlBq/juLYk/BO5LdmAgrYPzYEI3t3typDBmVtJmnEpNXQ
         6hRQ==
X-Gm-Message-State: AOJu0YyeMqQPwPwWS2DZyKFl7NKJ55WtUjY+Ruq6T/E+8HWxVwWjV9a1
	knAvvMt7dEB7IHrjcQFh+0uwyPbLkf7aIjoT8eoWS3BX3m9cP7+dNuGLjZFD
X-Google-Smtp-Source: AGHT+IGpEc/a44ag2d+L0Bm0vEbZShl3CA3fIU+mB6iXTtn/xxOFVo1Y3+x8ufJ8naoueU7tuy/6Rw==
X-Received: by 2002:a17:90a:12ca:b0:2d3:acbd:307b with SMTP id 98e67ed59e1d1-2e05682b809mr6231549a91.10.1727203144377;
        Tue, 24 Sep 2024 11:39:04 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:03 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 05/26] xfs: fix low space alloc deadlock
Date: Tue, 24 Sep 2024 11:38:30 -0700
Message-ID: <20240924183851.1901667-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 1dd0510f6d4b85616a36aabb9be38389467122d9 ]

I've recently encountered an ABBA deadlock with g/476. The upcoming
changes seem to make this much easier to hit, but the underlying
problem is a pre-existing one.

Essentially, if we select an AG for allocation, then lock the AGF
and then fail to allocate for some reason (e.g. minimum length
requirements cannot be satisfied), then we drop out of the
allocation with the AGF still locked.

The caller then modifies the allocation constraints - usually
loosening them up - and tries again. This can result in trying to
access AGFs that are lower than the AGF we already have locked from
the failed attempt. e.g. the failed attempt skipped several AGs
before failing, so we have locks an AG higher than the start AG.
Retrying the allocation from the start AG then causes us to violate
AGF lock ordering and this can lead to deadlocks.

The deadlock exists even if allocation succeeds - we can do a
followup allocations in the same transaction for BMBT blocks that
aren't guaranteed to be in the same AG as the original, and can move
into higher AGs. Hence we really need to move the tp->t_firstblock
tracking down into xfs_alloc_vextent() where it can be set when we
exit with a locked AG.

xfs_alloc_vextent() can also check there if the requested
allocation falls within the allow range of AGs set by
tp->t_firstblock. If we can't allocate within the range set, we have
to fail the allocation. If we are allowed to to non-blocking AGF
locking, we can ignore the AG locking order limitations as we can
use try-locks for the first iteration over requested AG range.

This invalidates a set of post allocation asserts that check that
the allocation is always above tp->t_firstblock if it is set.
Because we can use try-locks to avoid the deadlock in some
circumstances, having a pre-existing locked AGF doesn't always
prevent allocation from lower order AGFs. Hence those ASSERTs need
to be removed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 69 ++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.c  | 14 --------
 fs/xfs/xfs_trace.h        |  1 +
 3 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index de79f5d07f65..8bb024b06b95 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3164,10 +3164,13 @@ xfs_alloc_vextent(
 	xfs_alloctype_t		type;	/* input allocation type */
 	int			bump_rotor = 0;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep; /* inode32 agf stepper */
+	xfs_agnumber_t		minimum_agno = 0;
 
 	mp = args->mp;
 	type = args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
+	if (args->tp->t_firstblock != NULLFSBLOCK)
+		minimum_agno = XFS_FSB_TO_AGNO(mp, args->tp->t_firstblock);
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
 	 * (or there's only one a.g.) and the caller couldn't easily figure
@@ -3201,6 +3204,13 @@ xfs_alloc_vextent(
 		 */
 		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 		args->pag = xfs_perag_get(mp, args->agno);
+
+		if (minimum_agno > args->agno) {
+			trace_xfs_alloc_vextent_skip_deadlock(args);
+			error = 0;
+			break;
+		}
+
 		error = xfs_alloc_fix_freelist(args, 0);
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
@@ -3232,6 +3242,8 @@ xfs_alloc_vextent(
 	case XFS_ALLOCTYPE_FIRST_AG:
 		/*
 		 * Rotate through the allocation groups looking for a winner.
+		 * If we are blocking, we must obey minimum_agno contraints for
+		 * avoiding ABBA deadlocks on AGF locking.
 		 */
 		if (type == XFS_ALLOCTYPE_FIRST_AG) {
 			/*
@@ -3239,7 +3251,7 @@ xfs_alloc_vextent(
 			 */
 			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 			args->type = XFS_ALLOCTYPE_THIS_AG;
-			sagno = 0;
+			sagno = minimum_agno;
 			flags = 0;
 		} else {
 			/*
@@ -3248,6 +3260,7 @@ xfs_alloc_vextent(
 			args->agno = sagno = XFS_FSB_TO_AGNO(mp, args->fsbno);
 			flags = XFS_ALLOC_FLAG_TRYLOCK;
 		}
+
 		/*
 		 * Loop over allocation groups twice; first time with
 		 * trylock set, second time without.
@@ -3276,19 +3289,21 @@ xfs_alloc_vextent(
 			if (args->agno == sagno &&
 			    type == XFS_ALLOCTYPE_START_BNO)
 				args->type = XFS_ALLOCTYPE_THIS_AG;
+
 			/*
-			* For the first allocation, we can try any AG to get
-			* space.  However, if we already have allocated a
-			* block, we don't want to try AGs whose number is below
-			* sagno. Otherwise, we may end up with out-of-order
-			* locking of AGF, which might cause deadlock.
-			*/
+			 * If we are try-locking, we can't deadlock on AGF
+			 * locks, so we can wrap all the way back to the first
+			 * AG. Otherwise, wrap back to the start AG so we can't
+			 * deadlock, and let the end of scan handler decide what
+			 * to do next.
+			 */
 			if (++(args->agno) == mp->m_sb.sb_agcount) {
-				if (args->tp->t_firstblock != NULLFSBLOCK)
-					args->agno = sagno;
-				else
+				if (flags & XFS_ALLOC_FLAG_TRYLOCK)
 					args->agno = 0;
+				else
+					args->agno = sagno;
 			}
+
 			/*
 			 * Reached the starting a.g., must either be done
 			 * or switch to non-trylock mode.
@@ -3300,7 +3315,14 @@ xfs_alloc_vextent(
 					break;
 				}
 
+				/*
+				 * Blocking pass next, so we must obey minimum
+				 * agno constraints to avoid ABBA AGF deadlocks.
+				 */
 				flags = 0;
+				if (minimum_agno > sagno)
+					sagno = minimum_agno;
+
 				if (type == XFS_ALLOCTYPE_START_BNO) {
 					args->agbno = XFS_FSB_TO_AGBNO(mp,
 						args->fsbno);
@@ -3322,9 +3344,9 @@ xfs_alloc_vextent(
 		ASSERT(0);
 		/* NOTREACHED */
 	}
-	if (args->agbno == NULLAGBLOCK)
+	if (args->agbno == NULLAGBLOCK) {
 		args->fsbno = NULLFSBLOCK;
-	else {
+	} else {
 		args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
 #ifdef DEBUG
 		ASSERT(args->len >= args->minlen);
@@ -3335,6 +3357,29 @@ xfs_alloc_vextent(
 #endif
 
 	}
+
+	/*
+	 * We end up here with a locked AGF. If we failed, the caller is likely
+	 * going to try to allocate again with different parameters, and that
+	 * can widen the AGs that are searched for free space. If we have to do
+	 * BMBT block allocation, we have to do a new allocation.
+	 *
+	 * Hence leaving this function with the AGF locked opens up potential
+	 * ABBA AGF deadlocks because a future allocation attempt in this
+	 * transaction may attempt to lock a lower number AGF.
+	 *
+	 * We can't release the AGF until the transaction is commited, so at
+	 * this point we must update the "firstblock" tracker to point at this
+	 * AG if the tracker is empty or points to a lower AG. This allows the
+	 * next allocation attempt to be modified appropriately to avoid
+	 * deadlocks.
+	 */
+	if (args->agbp &&
+	    (args->tp->t_firstblock == NULLFSBLOCK ||
+	     args->pag->pag_agno > minimum_agno)) {
+		args->tp->t_firstblock = XFS_AGB_TO_FSB(mp,
+					args->pag->pag_agno, 0);
+	}
 	xfs_perag_put(args->pag);
 	return 0;
 error0:
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0d56a8d862e8..018837bd72c8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3413,21 +3413,7 @@ xfs_bmap_process_allocated_extent(
 	xfs_fileoff_t		orig_offset,
 	xfs_extlen_t		orig_length)
 {
-	int			nullfb;
-
-	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
-
-	/*
-	 * check the allocation happened at the same or higher AG than
-	 * the first block that was allocated.
-	 */
-	ASSERT(nullfb ||
-		XFS_FSB_TO_AGNO(args->mp, ap->tp->t_firstblock) <=
-		XFS_FSB_TO_AGNO(args->mp, args->fsbno));
-
 	ap->blkno = args->fsbno;
-	if (nullfb)
-		ap->tp->t_firstblock = args->fsbno;
 	ap->length = args->len;
 	/*
 	 * If the extent size hint is active, we tried to round the
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 372d871bccc5..5587108d5678 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1877,6 +1877,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_badargs);
+DEFINE_ALLOC_EVENT(xfs_alloc_vextent_skip_deadlock);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_nofix);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
-- 
2.46.0.792.g87dc391469-goog

