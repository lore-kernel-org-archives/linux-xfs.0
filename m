Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174427EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkY+vTzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63D8C433C7;
	Mon,  1 Jan 2024 00:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068659;
	bh=BNwdIpPKFBlDRw5hA0Y+A8PqXshVISXAxiamsmADKxY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gkY+vTzk8b9UluXHCKfiOt/KAmDBI6HnNikHdq+1S4RUfTN1uhS42jloTsVRXHpoQ
	 STmzEGBZk1kNxjJ3Ak3dA3dpGtPTDd1Bc5BXK9WPTH3627+kQPkmMDA/v0S3MNrTyu
	 cbeem+Gx/1re1LE/YQtRB1KHapeGfP4p4HLlBpGEfr4egq7n95jd8CJW5AG+rah1No
	 Zbhv3Nc0VH/6BrNki4/Q3FBOSe0icqh1/AIofVskvxaDdO0taZbQ8fd0YvVYemaDZo
	 dWQZe66Umqsj5g+OHr1QKpLUOUpzwNP5uVSdMbb7Z0+lG4l8T6eAQ4OYii6Qox6+le
	 UmnBqlaOrGX/g==
Date: Sun, 31 Dec 2023 16:24:19 +9900
Subject: [PATCH 2/9] xfs: create specialized classes for refcount tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016648.1816837.6387518588947985482.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
References: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The only user of the "ag" tracepoint event classes is the refcount
btree, so rename them to make that obvious and make them take the btree
cursor to simplify the arguments.  This will save us a lot of trouble
later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_refcount.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 9bb7acbdc6f..67c9895efb3 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -50,7 +50,7 @@ xfs_refcount_lookup_le(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -70,7 +70,7 @@ xfs_refcount_lookup_ge(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_GE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -90,7 +90,7 @@ xfs_refcount_lookup_eq(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -1261,11 +1261,9 @@ xfs_refcount_adjust(
 	int			error;
 
 	if (adj == XFS_REFCOUNT_ADJUST_INCREASE)
-		trace_xfs_refcount_increase(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, *agbno, *aglen);
+		trace_xfs_refcount_increase(cur, *agbno, *aglen);
 	else
-		trace_xfs_refcount_decrease(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, *agbno, *aglen);
+		trace_xfs_refcount_decrease(cur, *agbno, *aglen);
 
 	/*
 	 * Ensure that no rcextents cross the boundary of the adjustment range.
@@ -1525,8 +1523,7 @@ xfs_refcount_find_shared(
 	int				have;
 	int				error;
 
-	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_find_shared(cur, agbno, aglen);
 
 	/* By default, skip the whole range */
 	*fbno = NULLAGBLOCK;
@@ -1613,8 +1610,7 @@ xfs_refcount_find_shared(
 	}
 
 done:
-	trace_xfs_refcount_find_shared_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, *fbno, *flen);
+	trace_xfs_refcount_find_shared_result(cur, *fbno, *flen);
 
 out_error:
 	if (error)
@@ -1832,8 +1828,7 @@ __xfs_refcount_cow_alloc(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_cow_increase(rcur, agbno, aglen);
 
 	/* Add refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
@@ -1849,8 +1844,7 @@ __xfs_refcount_cow_free(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_cow_decrease(rcur, agbno, aglen);
 
 	/* Remove refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,

