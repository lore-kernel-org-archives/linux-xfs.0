Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7905738C2C3;
	Mon, 12 Oct 2026 05:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784733; cv=none; b=sddzim6yaWhI8Gr3UdTJvx1bGEWkCbTiwPAzDhaWJ8VgilhrMmuXlfzCE8jJi41rETC92WyIl6MocEHM1H/m4kmo9MgBpRbhVrDtVOx3xDDeA7ftWE62aN4Zk6H3WTZj3uFflEPZV0UfyeDXgjeMSc9rIhn/hGhKjkARQJPXFes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784733; c=relaxed/simple;
	bh=lu3cQy1KAPAfEDDrpyTiRYuJzG+cl2UmEYPqAGzLjhc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aad/uQVqFPiAiSj7cD7etU5ueE8a9Z3TZWxGt2ne/U/G/SVqRE39LDex8Wbdjgou86sXT3TnDdLmzqEIIJwHUyejaBQwBHQo3XkirXh3PhxxPvcpobYstniukAccDzUKJnf6CTX1M2jLm6OGLqe/bqsVjFgFYF7PF27nvdPSGOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMgANzuv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMgANzuv"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4C4DF1F0089B;
	Mon, 12 Oct 2026 05:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784732;
	bh=J+NbyE1iR/3ktBLA9DyFrL2v1hiV1z/LBLa4tDXteMU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ZMgANzuvx7CqkmJaF8oOQIPvLCzWDUxKE25GDb9xaEqF5AOcuJF2HQ34tjdNqVxxC
	 FW+HOypPSm383ifsVn8xXLOTJQS8n1ei2a2QjExlqQnWcvMtLqX4qqVyMJEQ5pC8Ba
	 VoF4xsSpz4DO200vicyuiD3lJM2odN9KPHhgWP+bLEqE84/39ETARabB249qlf/n8j
	 dX/LyfPhZ3swCvk7wxXePjjZuZvP7FI0bVeKsoXAjBsxH4ub2aqNwy6OEV/WAUjR25
	 31OXIt5w00xOndkmvxEXRLn/RRLMt15dqdm1YtzjD1k/Qxi92TT+q06/X3/qAKIB59
	 +fd+NYnyJBodg==
Date: Sun, 11 Oct 2026 22:58:51 -0700
Subject: [PATCH 12/12] xfs: don't scan across metadata/regular directory trees
 for dirents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065454.1058326.7569360626998167597.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that the directory repair code should never scan files
in the regular directory tree when fixing a metadata directory and
vice-versa.  Amend the scan predicate to check this condition.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 4f3d4dd1b04b2b ("xfs: define the on-disk format for the metadir feature")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dir_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 2cfcf1c35679ea..4a0b912b657696 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1189,7 +1189,9 @@ xrep_dir_want_scan(
 	struct xrep_dir		*rd,
 	const struct xfs_inode	*ip)
 {
-	return ip != rd->sc->ip && !xrep_is_tempfile(ip);
+	return ip != rd->sc->ip &&
+	       xfs_is_metadir_inode(ip) == xfs_is_metadir_inode(rd->sc->ip) &&
+	       !xrep_is_tempfile(ip);
 }
 
 /*

