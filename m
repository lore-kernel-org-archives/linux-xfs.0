Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2B2FC1D;
	Wed,  4 Dec 2024 03:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733281350; cv=none; b=rLAaK1PiC6ZvhT+3sNatGLRALzPjE3CD7nO40pvSxGzP1/LtB1m5dsHjjX9U9b/s4aplG+NaZU4hO0BdJuwYP6ja0xL9EWLKAc7TRV/hEC1Y4YFj1mC4S0W+tfneO6Qg1u+Za488jwgKb6iAlM8pSA50ttXoclrwqgqhecDK+yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733281350; c=relaxed/simple;
	bh=/9DMj9mCY56yShe+2B6QMa1OZCb0/du3Y3WzUpitJgY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QbsqXWCWj8tpJ31fCIuRA53BdxOfS87IrjZXiJdhnttU/uvexG64jmI0EgTK4ZR9+0/Zf9KnVSDDOgOQFPEE3cSvxxql0zGGTZO2+VjAcO8uEHi25SGdJD/Syx+JmJT+35DUeIaGmCpY885XZ0ZPNJlFGtb8Kvvx3IzZLCa8KzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpaM0SNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpaM0SNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3170C4CEDC;
	Wed,  4 Dec 2024 03:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733281350;
	bh=/9DMj9mCY56yShe+2B6QMa1OZCb0/du3Y3WzUpitJgY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BpaM0SNzPf26KIBHUmqzyoaSXs3AEubpPheJH52IJdlHOxBE5dtFzMZh+qROcuc2u
	 8kfw0nBeYRmj4tdnV10LzrGJMk9QTPbVWE9rc3G+IKQ9xmRTRL4YiUD629whctX871
	 f3531PsbR/YgQ6opsT0MyW6zNirYMiuJkCtr1RRBxOr1uw/GHpF6rXKHlzTv2yxdrj
	 RpsOaObfbvlEtjkN0uyoZS3ILXHPOJLAIBzGF2CPt+MYZ/C8DcI5q7n3Fq5Ezo6jXQ
	 d1eNuaOhUzVTjtwdFAFqGbO1HFO9V90fRHJmQ1K1f4R124YJB+9s2r52mQgC9ktsM0
	 v/v863+zFxGfA==
Date: Tue, 03 Dec 2024 19:02:29 -0800
Subject: [PATCH 1/6] xfs: don't move nondir/nonreg temporary repair files to
 the metadir namespace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173328106602.1145623.16395857710576941601.stgit@frogsfrogsfrogs>
In-Reply-To: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Only directories or regular files are allowed in the metadata directory
tree.  Don't move the repair tempfile to the metadir namespace if this
is not true; this will cause the inode verifiers to trip.

Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: 9dc31acb01a1c7 ("xfs: move repair temporary files to the metadata directory tree")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index dc3802c7f678ce..82ecbb654fbb39 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -204,6 +204,9 @@ xrep_tempfile_adjust_directory_tree(
 
 	if (!sc->ip || !xfs_is_metadir_inode(sc->ip))
 		return 0;
+	if (!S_ISDIR(VFS_I(sc->tempip)->i_mode) &&
+	    !S_ISREG(VFS_I(sc->tempip)->i_mode))
+		return 0;
 
 	xfs_ilock(sc->tempip, XFS_IOLOCK_EXCL);
 	sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;

