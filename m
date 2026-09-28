Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECDF41A4E7;
	Mon, 28 Sep 2026 06:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576323; cv=none; b=E0sDyz8C5j3TSOr4fyGZ0H9zzqjmnWRGwQEyUs6RH1MdXO8U9hf1tPI+ZKHuJh1SU8zrkeDZf+y2Y3Ya4J7x9FJGkU1aeeyMDhvVAT8C8b/IqxO46TkK6P0cjj9umG6w/y0ZIECmzw8gWTN8FMgWayQhO23CIdxyHedM+3Nh+4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576323; c=relaxed/simple;
	bh=i2uCFNf27z2Os1T14yQsMtREodKc+nSJbhOewRxhDAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKXf6XF7e+3UvFdvEUEw03RG2cMkgb6Enuee24TXFEeZzumb6l3KuoPVltHO39HWR3UOQN1oQocAf6LIZQ+sk9tcozrBHV02A+d3mHgZZ7bIs3/tza5y+BSWj9gPDoxzSEsRI+BQpcfznJyHJOeegGg9YEgCTR29uJKhQbtXezo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iS6a21LY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iS6a21LY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC5481F000FF;
	Mon, 28 Sep 2026 06:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576321;
	bh=qT5tn7h0fg58Ie6Qtb8fGqs7cG+88WalokRZ06EqSMo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=iS6a21LY5UORPcVBPVvf3aITyctPgSAbxr5KiaJzHqY+8b6igNwl0ApMuPxIu+f8N
	 N5WbYyGWUEDcDK3N7u2XBIuTh7ex9bz+HJUBoNejPwi3yQik+G5DwdIMJXUv2tEdU9
	 lld0LYcU354riM9eZW0gujmK4UYRDlIwLOPFwK7jOWziEEy2nUvNj5H01chAL2sAU/
	 UXAvk3gxHICDWB+DlcHmICOUFx2S1rNRAjfZrv47W1iXV+Ow2qWQyXq5dVUsOHxxpH
	 QwPmOMvJrL0wYVQuFcEsu9MqZ+n8DU3DCzYqfKJmc67+c69ZSuxt7MV86SN687Eqvi
	 dGN81JYICh0iw==
Date: Sun, 27 Sep 2026 23:18:41 -0700
Subject: [PATCH 11/12] xfs: don't proceed with xattr repair if the live update
 fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179057612830.479634.12263440837702460390.stgit@frogsfrogsfrogs>
In-Reply-To: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
References: <179057612523.479634.11102922479483109602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes that we ought to make one last check for failed live
updates before replacing the xattr structure.  Let's be cautious here.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/attr_repair.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index ac433a5467516d..387ad909e20bb9 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1477,6 +1477,9 @@ xrep_xattr_rebuild_tree(
 	if (error)
 		return error;
 
+	if (rx->live_update_aborted)
+		return -EIO;
+
 	/*
 	 * Exchange the blocks mapped by the tempfile's attr fork with the file
 	 * being repaired.  The old attr blocks will then be attached to the

