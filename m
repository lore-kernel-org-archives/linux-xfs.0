Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763181862B4
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560519; cv=none; b=SMPB8ILXDTiioHU4++jhNq4qZH/d7arP3gFGmAfHxFLZoMpJHPv7xnxKrA2lLzmFbbmBc6MLyp11coLNWclXYcZ354kdlV01MK5UIwzEsYlWruZUor0Me2iiHCpM1fopSr63/na4f0flgaVVsLH6FOo09DCQVYzg7+gxWZJ9hA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560519; c=relaxed/simple;
	bh=YntEk1aSrdpflNWOfU1FsKdaUIpTBcq+A2o1PW9IdEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MVXCEiPchrE2F/NqnnPYVKwI4RhvXfAOxlwJqzoLfxacsYsGPrNHy4t3QRCg+CH9eT8nWcmZaK/B1QDMo5p3JoSdlZt1zUP0jDa1aho6qzpZoy85VzEmkkUrm0mmtypS+t9CaJtOHqVNJN9QeveyzUptORg4OSF/lt7H1U2K7Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cd/5aty3; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cd/5aty3"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7c3ebba7fbbso915840a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560516; x=1726165316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62kj8RbxEktclRNWNuIxo0IxrhVzG6pnC4qkEucGbzw=;
        b=Cd/5aty3ybPdwlyazAbe7AlE7m0ISsQCkxhL5O/yeva2sCnNlCl6q+w1H3b2ZOjuCn
         XYdwWujiUPl/9/c7MXlEDe7xOhdK7tk/C0J83DWBOGhXwT1ZXSvqZIwb2N7NNRKuzehp
         I/L5LY/BLy32TMYsOjJCQ4d2TEY3+WP+agcnp2PX+jdZd2ejMnjgANlRFFmwqqyMK9fh
         ctA9Ysc9Pg2x1t/WQmtgO0ZFZSADrJ/fLa1lKVte1pHnjJ42Nckpskk6Wpm/1AWcLfpS
         mswi0ohm+AD3k+G8ppOnPzb6fR8SV4EqquE5PMscQmcZa8WyJtIcxDOQIV2qziIuKmdL
         LdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560516; x=1726165316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=62kj8RbxEktclRNWNuIxo0IxrhVzG6pnC4qkEucGbzw=;
        b=wna54XleAeXvemeDaZI9tMtcP46HCZCC1AvzjV2oWoEK00bCl0+NK8vNAz6GoIHIvF
         m6OWJglAeVeNHMLYhgYKr3KMcyB3SRJvxlRol/5cTLaXGyNrXeW6SABIVaEhaxOXncgM
         ZKbg7fz0BFab3sCwt5j0MCqzJggPtgQS54RsedjHpWhi0l32nB+uIAuigrezuGSg5A5M
         Jl/s2agQTRu67hTIRqRuI7JEZaWe6N1Md77lQMM4EXmvyHhszm6Dxhal1ReJw7OApnnv
         rRUFPKVLFfnt3TBTR0ek4EzWxdlBYHM65EZruSvKtlbaKrcdrMGh6nM6hTG4d2TVyiOb
         vrhw==
X-Gm-Message-State: AOJu0Yzc29KFS5dBsW0bR5FZM/GgIIt195RPmxuzcN8Ov+MzPPbL3ec2
	oWWxVn14X8FV6uzjEhg5pFVwZC4dOV4w54VrC0hsk4p2CZ4aPJrHEXd/KPOZ
X-Google-Smtp-Source: AGHT+IHc6q/HBzjkQJossmB55fxal5w8byk85QV3mK06C8oGuo4nonD52+0sE57ORpQg8H0TGHrNnA==
X-Received: by 2002:a17:902:e804:b0:202:4b65:65af with SMTP id d9443c01a7336-20546b35a4cmr232255595ad.52.1725560516434;
        Thu, 05 Sep 2024 11:21:56 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:21:56 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 05/26] xfs: fix low space alloc deadlock
Date: Thu,  5 Sep 2024 11:21:22 -0700
Message-ID: <20240905182144.2691920-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
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
2.46.0.598.g6f2099f65c-goog

