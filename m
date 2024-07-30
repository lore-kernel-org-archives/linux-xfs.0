Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A546646
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300717; cv=none; b=ovHjpZzrZJ5Pc6hvWIoSlDgpHrtCPO6aWvBEl+VnY6YOCn4ZJPsSR+xwQdblrcjqt1m/57Eu9tq2u34Qjcu3DPo+gzJ0FSh85fr992T3lOzpDlBkvJOz1NFs7tYEPD46lvQg9m1RR9Y1WyW9pU8y13nhUZH4YXKte+86gnbiNcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300717; c=relaxed/simple;
	bh=O+7b27+HrjFX1+2EeFesgf6R2DojOfupQIa3yBZC1tI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jr8YjJHjDWtKHfPRp4y5FJjHJL2BHiF0sVAgIu26DRAtHHP0/SnzDBCfLwnaAaLWZhjkZqd+/E0+srOja592UmKdyzv1Q2qJQs474aHglsIGujHHUNmFxj4+fP76Xi0OMeMzkDYuzlmT3dF1DsrfdrKYLkgbZzXx02/LTs145Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KL2gYcil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KL2gYcil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F630C32786;
	Tue, 30 Jul 2024 00:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300717;
	bh=O+7b27+HrjFX1+2EeFesgf6R2DojOfupQIa3yBZC1tI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KL2gYcilO1XpFdKw0vrLBpkpAKkZX5j6aDFYKFBCOp3braejYMLpI58FhUkvS4J/t
	 DfoemNPD2c2ze3D9Am91gChLIiEcMRUxONAudRlCXGnEZ+e9Tfjd8yJUZhtdY+gWzQ
	 NiEQapEXxWwnCxVp1FtUBb2EW9aqTj+gslor8jhMX2obx23KTnZPCRCzA4lpRbpXv4
	 GG/NgGtgtWuAsH18T8PxJah0hW6QcOxMoeIjLV8WIpHxHDVlYTMWHT7HNsJyiWoqLl
	 TFa4XPApj3epuFsW1GPdKX+3NTYa4hrY384Jv0uYvlLjaASE6EAfIBzWf3fduzrmKt
	 7nekj1IffFndg==
Date: Mon, 29 Jul 2024 17:51:56 -0700
Subject: [PATCH 108/115] xfs: Stop using __maybe_unused in xfs_alloc.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843967.1338752.9487755586572190314.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: John Garry <john.g.garry@oracle.com>

Source kernel commit: b33874fb7f28326380562f208d948bab785fbd6f

In both xfs_alloc_cur_finish() and xfs_alloc_ag_vextent_exact(), local
variable @afg is tagged as __maybe_unused. Otherwise an unused variable
warning would be generated for when building with W=1 and CONFIG_XFS_DEBUG
unset. In both cases, the variable is unused as it is only referenced in
an ASSERT() call, which is compiled out (in this config).

It is generally a poor programming style to use __maybe_unused for
variables.

The ASSERT() call is to verify that agbno of the end of the extent is
within bounds for both functions. @afg is used as an intermediate variable
to find the AG length.

However xfs_verify_agbext() already exists to verify a valid extent range.
The arguments for calling xfs_verify_agbext() are already available, so use
that instead.

An advantage of using xfs_verify_agbext() is that it verifies that both the
start and the end of the extent are within the bounds of the AG and
catches overflows.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_alloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index b86f788f4..45feff034 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1004,13 +1004,12 @@ xfs_alloc_cur_finish(
 	struct xfs_alloc_arg	*args,
 	struct xfs_alloc_cur	*acur)
 {
-	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
 	int			error;
 
 	ASSERT(acur->cnt && acur->bnolt);
 	ASSERT(acur->bno >= acur->rec_bno);
 	ASSERT(acur->bno + acur->len <= acur->rec_bno + acur->rec_len);
-	ASSERT(acur->rec_bno + acur->rec_len <= be32_to_cpu(agf->agf_length));
+	ASSERT(xfs_verify_agbext(args->pag, acur->rec_bno, acur->rec_len));
 
 	error = xfs_alloc_fixup_trees(acur->cnt, acur->bnolt, acur->rec_bno,
 				      acur->rec_len, acur->bno, acur->len, 0);
@@ -1213,7 +1212,6 @@ STATIC int			/* error */
 xfs_alloc_ag_vextent_exact(
 	xfs_alloc_arg_t	*args)	/* allocation argument structure */
 {
-	struct xfs_agf __maybe_unused *agf = args->agbp->b_addr;
 	struct xfs_btree_cur *bno_cur;/* by block-number btree cursor */
 	struct xfs_btree_cur *cnt_cur;/* by count btree cursor */
 	int		error;
@@ -1293,7 +1291,7 @@ xfs_alloc_ag_vextent_exact(
 	 */
 	cnt_cur = xfs_cntbt_init_cursor(args->mp, args->tp, args->agbp,
 					args->pag);
-	ASSERT(args->agbno + args->len <= be32_to_cpu(agf->agf_length));
+	ASSERT(xfs_verify_agbext(args->pag, args->agbno, args->len));
 	error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen, args->agbno,
 				      args->len, XFSA_FIXUP_BNO_OK);
 	if (error) {

