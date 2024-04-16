Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D905227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230700; cv=none; b=q8EPpoX6mGSyH+tajGWIm17Ot0N+DMg/8b/+kilvT6a+RCxg6FlgkJbL97o4wMFnVjh2nQyh41Btkec/jsApboqqTv+9FMdlhH+ZwrtMZREiTSw4a0AiHG06hMIbOXTBLqZgsbOZmWRzg0hdjHHC5Dm+1CtRTR8vm0FF6WD8fJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230700; c=relaxed/simple;
	bh=hN/SjeRkn8fNZuwZz+1KTIUSdvPalMhXBwnGF9mWORM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gj7zIrE/Q4flu7HGDh/+3+WzDziNWxS6lF6xZ2jsVOWATjsjqicKJIg6oPLftzSEtDgGxJJET59R4AP4R6YSO0r/d877BRsdolVRUQ2WoWDRU0VCVS4BLfrc0iw5ruPjEgqK60Zh1UUbDdRY+leHj4pfSY4hRcwCtX64rkGkhIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uCchZy50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uCchZy50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639E7C113CC;
	Tue, 16 Apr 2024 01:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230700;
	bh=hN/SjeRkn8fNZuwZz+1KTIUSdvPalMhXBwnGF9mWORM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uCchZy50swuisuYT6zOV/a8UkeEzm7NRH85cw/jh03VReFg7G7pOUrk45PkKGaenM
	 J3MOwD/G5PKT5WQI8P/s09dECyJKdSYi0EDBuiyTNSL/tXonwQertdSOpRNSi9rjdP
	 LmjURUWP1/jwBy09ljQSfg1ck0Yv9JbeMRs5iYpYGgKC9X9mAIOEbFWwNd0NCtMPB1
	 pPe28Uu2Wjwf1j64tcCcaxst3cB5CHPC3EIRmeLA5dyooePehyhmTlR84L4AdiEWoQ
	 Ur4GN/rUMVEejWHv4YDjlntRdN1cGXJ8oCS2XMG5jKCElvAL/0mveGpERmaHh1wrqL
	 uhAMzwNugpSzQ==
Date: Mon, 15 Apr 2024 18:24:59 -0700
Subject: [PATCH 10/14] xfs: always set args->value in xfs_attri_item_recover
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323027233.251201.6130490218042776101.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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

Always set args->value to the recovered value buffer.  This reduces the
amount of code in the switch statement, and hence the amount of thinking
that I have to do.  We validated the recovered buffers, supposedly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ebd6e98d9c661..8a13e2840692c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -572,6 +572,8 @@ xfs_attri_recover_work(
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->value = nv->value.i_addr;
+	args->valuelen = nv->value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -580,8 +582,6 @@ xfs_attri_recover_work(
 	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		args->value = nv->value.i_addr;
-		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
 		if (xfs_inode_hasattr(args->dp))
 			attr->xattri_dela_state = xfs_attr_init_replace_state(args);

