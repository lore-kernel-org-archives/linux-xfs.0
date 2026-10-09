Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884B135C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589805; cv=none; b=YS4Ns4ygb/uNfU8xktnt/RBGjTj/PfaXDvSpm7sFm8kWLG7SdXzHXmKOF4pLF/9BVOBK3nm4gnK4ti09f/l379qXIVcfzZs6Q2IDJCvE3RVdBViDPfzy5eCBAZTCthCfT12ZJk5FGy2WYBOlIXzzPJQw41Gde/hNWjCt1nOakLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589805; c=relaxed/simple;
	bh=SNNtsbXgUiiYJILuN1yyZl3F5YKb++1oN7x8IgnOw7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OqpQtFWZJPutgRMiehdkBk4obhzJVIP5enByxq7ow1dkXyEuMosAC8SGI/x/o8iFMowA2Wmc+IjARaiZOca0JW2I1vvFtpzSZ4OpLj5SWLY2CMX+m7xrdDjyXTeQuQDODeU/z7k58B7tqJSBhFTXgDvsOpkNDI1pArpeoL+xXuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aA4fFVkv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aA4fFVkv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0213E1F000FF;
	Fri,  9 Oct 2026 23:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589804;
	bh=d5bSATcutBA07X6U3GaXQQPbzLBOAwAj9jrqZNtlQcI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=aA4fFVkvdUYe+2aL83NzI2+lnJLsEaxVO3NokkQJbBitL77lnzT3gYuFTqNprufRa
	 5qx2kcorfh0cJfxv0Vnvs6DOijCgNpCAtRS551RgJKsA9+B7UkdyORpbO5FiLx8RFs
	 Kuxxed/Zv7Iv52m/opjXmVTDMKneUHLvB3CQzCD6pn1nAKG2CmtoA+uj6xrXtUKrgn
	 7Ssjc48J1B8c/QjA4vBr2MkwrBx1lFxrIjZlrPgbJdGK1czJ2dBe5PXsNLlQvA44Bh
	 JBpFp/QTs4+vgObfCLS+Z69ezB6m6UCHq9nktkRK9xlLDr3/hOY8ZuFbOgSq9k8q5h
	 Sh7DecyzFneyw==
Date: Fri, 09 Oct 2026 16:50:03 -0700
Subject: [PATCH 17/26] xfs: assert the reservation covers each da fork growth
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, floss@jetm.me, linux-xfs@vger.kernel.org
Message-ID: <179158947679.3719791.10707703323646118155.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Javier Tia <javier@peridio.com>

Source kernel commit: 0fe77e57588b989450d668f7c978bb0264c5c340

xfs_da_grow_inode_int() subtracts the blocks it just allocated from
args->total, the caller's remaining block reservation.  The subtraction
is unsigned, so a caller that reaches it with too small a total wraps
the field instead of failing, and every allocation afterwards runs with
a bogus reservation.  Assert the remaining reservation still covers the
step, so an under-reserved or uninitialised total trips in debug builds
instead of silently wrapping.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_da_btree.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 50eb44f486ed8a..bd13879f29ca1e 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2382,6 +2382,7 @@ xfs_da_grow_inode_int(
 	}
 
 	/* account for newly allocated blocks in reserved blocks total */
+	ASSERT(args->total >= dp->i_nblocks - nblks);
 	args->total -= dp->i_nblocks - nblks;
 
 out_free_map:

