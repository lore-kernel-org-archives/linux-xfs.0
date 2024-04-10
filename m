Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394CF387
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710161; cv=none; b=MsqjoMNw97LFaL9SNWw8qlcTEX0+FM1J6c/JwUwZgpDiMGhkwjFvNOHb21DXd+qomzbZjNm7ju/NEU+l38Pl5Smi5BRo5d5AXItJRlFJjNlGE4RmhXVY4IjjCurDNKvZ67k0q3AgnofN8Z6v3GVF8SYsXdZJKi08Ym81kE7zRVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710161; c=relaxed/simple;
	bh=vWortD+t4VXVCVqICYf6vmcjQ0DzdCMNCNjNcfiZTRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LWADjPYgBPOKBHScYRRzyEgl9Qfw95CNOsKslpnOtS2TcwhHU9fK7aagk9kXMhUYsrOtokKqvL1q1VYOj4Vdc0pkyinjotZ6iG0ky6YUl5fWHjuKGR4dNi08W4QsHZs25Wl4c5MZ4nGg3PsHph7KHJjIeuL7q7fPU7bxVAyW4/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2hfyvDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2hfyvDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6062C433F1;
	Wed, 10 Apr 2024 00:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710160;
	bh=vWortD+t4VXVCVqICYf6vmcjQ0DzdCMNCNjNcfiZTRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=j2hfyvDjMnGN+uaUOWmM3MHrFy8uQZ9ZTrywEP4VNoVC9JNJ27+3NLmVFowioYoz2
	 TZWG9mrpT6acbAtS9SKPuqCtF0JZdLp5ENa+zwa7ihjAmEPbDHoi/KwqabKPT++1zv
	 FYRLNSDTwrj0mT0LBP98zrOl1hQLsJVBW80q6YBQSsrMGFlGtHASQ38PmYwFizaiqe
	 Czz376vL+s2u7BsCiPCVYbzrA/4HTtzR/72WD/ArR/qFkUAkcj/BAur2tzSBeE8Ixp
	 U5dSNgNauN837ZZW3ak8XMGjvaSaHRPeuARy+Y6gDUCZN4mXtmyNVz0hSqFjErf51K
	 2wU9368hYzxxQ==
Date: Tue, 09 Apr 2024 17:49:20 -0700
Subject: [PATCH 7/7] xfs: unlock new repair tempfiles after creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270968021.3631167.3162988716447434676.stgit@frogsfrogsfrogs>
In-Reply-To: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
References: <171270967888.3631167.1528096915093261854.stgit@frogsfrogsfrogs>
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

After creation, drop the ILOCK on temporary files that have been created
to stage a repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index c72e447eb8ec3..6f39504a216ea 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -153,6 +153,7 @@ xrep_tempfile_create(
 	xfs_qm_dqrele(pdqp);
 
 	/* Finish setting up the incore / vfs context. */
+	xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 	xfs_setup_iops(sc->tempip);
 	xfs_finish_inode_setup(sc->tempip);
 
@@ -168,6 +169,7 @@ xrep_tempfile_create(
 	 * transactions and deadlocks from xfs_inactive.
 	 */
 	if (sc->tempip) {
+		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xfs_finish_inode_setup(sc->tempip);
 		xchk_irele(sc, sc->tempip);
 	}

