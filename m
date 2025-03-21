Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAFF146A68
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574740; cv=none; b=Ux0xY6BZFeJmp8fXZsx2VxAVEuuKpJ5xZpftMOEIKvh0XJQxGQ6Zo0DTXvFq3pj8aNa0PYYAJjDoT24arHFKgKSoaDqQaiFsMwBke7jYVdEJse1p9QU/03hj09WzLP+W3cOvj3SUVlQ7Xtq0R8wh+jCtZ8TYbUKL7JXJvXzvZlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574740; c=relaxed/simple;
	bh=XttjF6CYdtP2ctfnrRaJtTbi8NbUhoeK4IaSCACRvZw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kOKTexmBGD6y1OwdFCXcGTYl/P7WD0rzJ0z72vbGgW36LtmlBBXGLvrAw617XLeT63xy6jeKcg38lDFkyJWUWqVQFbjiDxM1AjPp+0S+ZMQSgkxoAWhXDgO4qi13sVSYG/E6gyaGUD+grMvML1hxvFcp79MC5z/Te9ShI554rNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kis9GbSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kis9GbSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6307CC4CEE3;
	Fri, 21 Mar 2025 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742574738;
	bh=XttjF6CYdtP2ctfnrRaJtTbi8NbUhoeK4IaSCACRvZw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kis9GbSd+MfEP+lFEfed6ECg+hBKYWvqjnm29sWFAaC6yavoFHIQ6ZUIBQczv4BsT
	 nHfHxBs365nm1Gi9kFWCco0K0wY8cWbXrAI4qvIiuTB0aQqLdz3g39k3q/BGmaDSYz
	 DFXAIlAgyqyuOgvMow4O4Igi4Bjnt9Sa69m404OsJrzniLy0x0M3X434zWpqrQ0j83
	 zl8gfkGezdKi+OtKTODyjLFOF9ctj1bRLEWjb1NXaHXJtXgOdZYUqTU0CaoMQSvItG
	 0Ot+nxV09W5ar/wFKhvKglKq8fcGrJgbZxIfyqVi77bhFenEXG7iGsT83bGrzoB4dr
	 q9q26KHtR8F9A==
Date: Fri, 21 Mar 2025 09:32:17 -0700
Subject: [PATCH 4/4] xfs_repair: fix stupid argument error in
 verify_inode_chunk
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <174257453669.474645.15431452443530778898.stgit@frogsfrogsfrogs>
In-Reply-To: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

An arm64 VM running fstests with 64k fsblock size blew up the test
filesystem when the OOM killer whacked xfs_repair as it was rebuilding a
sample filesystem.  A subsequent attempt by fstests to repair the
filesystem printed stuff like this:

inode rec for ino 39144576 (1/5590144) overlaps existing rec (start 1/5590144)
inode rec for ino 39144640 (1/5590208) overlaps existing rec (start 1/5590208)

followed by a lot of errors such as:

cannot read agbno (1/5590208), disk block 734257664
xfs_repair: error - read only 0 of 65536 bytes

Here we're feeding per-AG inode numbers into a block reading function as
if it were a per-AG block number.  This is wrong by a factor of 128x so
we read past the end of the filesystem.  Worse yet, the buffer cache
fills up memory and thus the second repair process is also OOM killed.
The filesystem is not fixed.

Cc: <linux-xfs@vger.kernel.org> # v3.1.8
Fixes: 0553a94f522c17 ("repair: kill check_inode_block")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dino_chunks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 250985ec264ead..932eaf63f4741f 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -132,7 +132,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 	if (igeo->ialloc_blks == 1)  {
 		if (agbno > max_agbno)
 			return 0;
-		if (check_aginode_block(mp, agno, agino) == 0)
+		if (check_aginode_block(mp, agno, agbno) == 0)
 			return 0;
 
 		lock_ag(agno);

