Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05CB34D4F7;
	Fri, 23 Jan 2026 07:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151865; cv=none; b=uSGDTp18UzjuCvrhMwRiRwXm5AOrqvm9Xh854f4bn9Bw2d4gKS4tHlc7JZ9GgEHgFOimvWHy/EBy3/dVxia2FmMLhakYcpwtKWpzCxP1MXz662mtuvVUmLbKiZZn5c67X1BWAWi3jU84pK+dDN95JpQo7dAju4ndX8rZyzPbibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151865; c=relaxed/simple;
	bh=9BZGIwBSFh4pJlO+TiFPXx4Li+I5oi9TyvMzkG1hidc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LyX1AcismjvBp+lk0zCctEo7nfpDWjZYBScEPQ3UqUqRG0DQQdG7tm1LYG6VWdLK20VdEgetqfE/sewZ5N99PDuk+jzvj1LdYEK2ik1jD5VVOmnGQURQxmVypJVDH/z1Et4OIQeadwkpH0bIMDpglhiPu5JaBkEdMsAeIWWBhvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aCj05FET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aCj05FET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED60C4CEF1;
	Fri, 23 Jan 2026 07:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151864;
	bh=9BZGIwBSFh4pJlO+TiFPXx4Li+I5oi9TyvMzkG1hidc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aCj05FETMHBVQSzRiPoNCx+hSSEDWvTve0KanZah5hyuSZMLM/jeEWRYrGg4tyHl9
	 g3eJEohSbW1W4R4F+pxonenX+9q5Mp4B4869uMx1qFYQMeVImNWFjkt9Cd++j7tnpi
	 X0w10MQ7JTUrnYHb4XOHRN64pAkhlWiGCD2y47I/wOPe3Mc/Sllcann7EIPIFxvZsl
	 tJtujIz+5Imr/r10/l3ofxX2T4d/oJ7q7+cgKV0bYV8cSDvf/l8Ic+3nvK2SNWXwXr
	 bRn7ZJUSOfYPWrJ2hn5VUbBn1NGiwSJafrbroSNPN4Lz5qv8KNgKwTHZ5VOXKUDQfe
	 FnjKcxRBTfBig==
Date: Thu, 22 Jan 2026 23:04:24 -0800
Subject: [PATCH 5/5] xfs: check for deleted cursors when revalidating two
 btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: r772577952@gmail.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
 r772577952@gmail.com, hch@lst.de
Message-ID: <176915153803.1677852.3768821466518761768.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The free space and inode btree repair functions will rebuild both btrees
at the same time, after which it needs to evaluate both btrees to
confirm that the corruptions are gone.

However, Jiaming Zhang ran syzbot and produced a crash in the second
xchk_allocbt call.  His root-cause analysis is as follows (with minor
corrections):

 In xrep_revalidate_allocbt(), xchk_allocbt() is called twice (first
 for BNOBT, second for CNTBT). The cause of this issue is that the
 first call nullified the cursor required by the second call.

 Let's first enter xrep_revalidate_allocbt() via following call chain:

 xfs_file_ioctl() ->
 xfs_ioc_scrubv_metadata() ->
 xfs_scrub_metadata() ->
 `sc->ops->repair_eval(sc)` ->
 xrep_revalidate_allocbt()

 xchk_allocbt() is called twice in this function. In the first call:

 /* Note that sc->sm->sm_type is XFS_SCRUB_TYPE_BNOPT now */
 xchk_allocbt() ->
 xchk_btree() ->
 `bs->scrub_rec(bs, recp)` ->
 xchk_allocbt_rec() ->
 xchk_allocbt_xref() ->
 xchk_allocbt_xref_other()

 since sm_type is XFS_SCRUB_TYPE_BNOBT, pur is set to &sc->sa.cnt_cur.
 Kernel called xfs_alloc_get_rec() and returned -EFSCORRUPTED. Call
 chain:

 xfs_alloc_get_rec() ->
 xfs_btree_get_rec() ->
 xfs_btree_check_block() ->
 (XFS_IS_CORRUPT || XFS_TEST_ERROR), the former is false and the latter
 is true, return -EFSCORRUPTED. This should be caused by
 ioctl$XFS_IOC_ERROR_INJECTION I guess.

 Back to xchk_allocbt_xref_other(), after receiving -EFSCORRUPTED from
 xfs_alloc_get_rec(), kernel called xchk_should_check_xref(). In this
 function, *curpp (points to sc->sa.cnt_cur) is nullified.

 Back to xrep_revalidate_allocbt(), since sc->sa.cnt_cur has been
 nullified, it then triggered null-ptr-deref via xchk_allocbt() (second
 call) -> xchk_btree().

So.  The bnobt revalidation failed on a cross-reference attempt, so we
deleted the cntbt cursor, and then crashed when we tried to revalidate
the cntbt.  Therefore, check for a null cntbt cursor before that
revalidation, and mark the repair incomplete.  Also we can ignore the
second tree entirely if the first tree was rebuilt but is already
corrupt.

Apply the same fix to xrep_revalidate_iallocbt because it has the same
problem.

Cc: r772577952@gmail.com
Link: https://lore.kernel.org/linux-xfs/CANypQFYU5rRPkTy=iG5m1Lp4RWasSgrHXAh3p8YJojxV0X15dQ@mail.gmail.com/T/#m520c7835fad637eccf843c7936c200589427cc7e
Cc: <stable@vger.kernel.org> # v6.8
Fixes: dbfbf3bdf639a2 ("xfs: repair inode btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/alloc_repair.c  |   15 +++++++++++++++
 fs/xfs/scrub/ialloc_repair.c |   20 +++++++++++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index b6fe1f23819eb2..35035d02a23163 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -923,7 +923,22 @@ xrep_revalidate_allocbt(
 	if (error)
 		goto out;
 
+	/*
+	 * If the bnobt is still corrupt, we've failed to repair the filesystem
+	 * and should just bail out.
+	 *
+	 * If the bnobt fails cross-examination with the cntbt, the scan will
+	 * free the cntbt cursor, so we need to mark the repair incomplete
+	 * and avoid walking off the end of the NULL cntbt cursor.
+	 */
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
 	sc->sm->sm_type = XFS_SCRUB_TYPE_CNTBT;
+	if (!sc->sa.cnt_cur) {
+		xchk_set_incomplete(sc);
+		goto out;
+	}
 	error = xchk_allocbt(sc);
 out:
 	sc->sm->sm_type = old_type;
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index b1d00167d263f4..f28459f58832f4 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -863,10 +863,24 @@ xrep_revalidate_iallocbt(
 	if (error)
 		goto out;
 
-	if (xfs_has_finobt(sc->mp)) {
-		sc->sm->sm_type = XFS_SCRUB_TYPE_FINOBT;
-		error = xchk_iallocbt(sc);
+	/*
+	 * If the inobt is still corrupt, we've failed to repair the filesystem
+	 * and should just bail out.
+	 *
+	 * If the inobt fails cross-examination with the finobt, the scan will
+	 * free the finobt cursor, so we need to mark the repair incomplete
+	 * and avoid walking off the end of the NULL finobt cursor.
+	 */
+	if (!xfs_has_finobt(sc->mp) ||
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		goto out;
+
+	sc->sm->sm_type = XFS_SCRUB_TYPE_FINOBT;
+	if (!sc->sa.fino_cur) {
+		xchk_set_incomplete(sc);
+		goto out;
 	}
+	error = xchk_iallocbt(sc);
 
 out:
 	sc->sm->sm_type = old_type;

