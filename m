Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BAF6FC7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231263; cv=none; b=AKMMutkwi/2Vo/sFrPlVbZ7AbjJrPSmNb737QMbP1qaJo0OWT9Kqr1Hh2VgmCSqgE+C0gecI6dKPop5X+s+nZdv4Umt9F+KpOR4E9IFIHHEDjx8EiscNj42ZQzO3SeF+4DZojjILJ1rF4HsGvekyTW2ox8ClZtxGy6LwASMOvQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231263; c=relaxed/simple;
	bh=F7zK4ci/QpTP3/uWOxcXLm1PzsyrOge5U1YjyGSc5kY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUMz5XyaxKDK6bNosmlYWvUbsOhmoCH6DTFv1cIcnt/QMHabH/SYEKrFm9UmHT8D7mRDjOVX4ELcfbuX5g+w+KbxQQU9oe/1CFBhmlHu9Ks1e+t0dlhcnFyyWVVuToS1yOe3FB8dYRVcU9HGLx/ZVid5dJr5sCzTwQg4YB18LyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZToWSmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZToWSmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C1EC113CC;
	Tue, 16 Apr 2024 01:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231263;
	bh=F7zK4ci/QpTP3/uWOxcXLm1PzsyrOge5U1YjyGSc5kY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OZToWSmxnlYmdI5CowOps0WNz19FiKS1x0VYXc/yWoyhwwG9tCZbuRUplokhnURU/
	 Fisql1ebUQ1zwc/hGk7QKjTe/y35KbUMMCGi7UgqCfDHsqXyP1oEPMkd+rOnn30h1u
	 ZQBeSViemFuiiPXtx3NfDIaWER8W/FVqIC04m4drjeTn9WITMuh3uAkQyEDanJ7JiP
	 rSsDOeNyNGQnDugspKA1luWmqa20Ry75iRQcYRMTQDWhgtSleGJktvZxQJ8HXaJ4Q5
	 KyKMfosCgiipkLrmf9CD7Xm6+6sbugSqJL/+wmzt5QK1bsFsBSScaGcvc0aagCEjr4
	 vzERX2RdEr8vw==
Date: Mon, 15 Apr 2024 18:34:22 -0700
Subject: [PATCH 1/7] xfs: revert commit 44af6c7e59b12
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, hch@infradead.org,
 linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323028683.252774.4862531675710024941.stgit@frogsfrogsfrogs>
In-Reply-To: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
References: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
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

In my haste to fix what I thought was a performance problem in the attr
scrub code, I neglected to notice that the xfs_attr_get_ilocked also had
the effect of checking that attributes can actually be looked up through
the attr dabtree.  Fix this.

Fixes: 44af6c7e59b12 ("xfs: don't load local xattr values during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index c07d050b39b2e..393ed36709b3a 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -208,14 +208,6 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
-	/*
-	 * Local and shortform xattr values are stored in the attr leaf block,
-	 * so we don't need to retrieve the value from a remote block to detect
-	 * corruption problems.
-	 */
-	if (value)
-		return 0;
-
 	/*
 	 * Try to allocate enough memory to extract the attr value.  If that
 	 * doesn't work, return -EDEADLOCK as a signal to try again with a
@@ -229,6 +221,11 @@ xchk_xattr_actor(
 
 	args.value = ab->value;
 
+	/*
+	 * Get the attr value to ensure that lookup can find this attribute
+	 * through the dabtree indexing and that remote value retrieval also
+	 * works correctly.
+	 */
 	xfs_attr_sethash(&args);
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */

