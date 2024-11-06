Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A8920721C
	for <linux-xfs@vger.kernel.org>; Wed,  6 Nov 2024 19:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920687; cv=none; b=F/J1hZD7pTdsAt4HyDa1u/aiRahQ6XrAcwYkuLkmk1mfwa13NASSiEmbl3Wlm5lIxDfcjoRsAlBUh6UivrvZTb6c2YqMY50TxM/Bw1xHQvaTWUjRjhHfllIp4SSA1FK1AMuO0NkOn9jPTsOwgk0thezX043LPEej8sYoELx7ee8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920687; c=relaxed/simple;
	bh=qWU+zySOkZCELsN3d8uh6TbTVI7+9/dRXlmRe9khmDE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKUAo7q64pEJ8YWWhnVe9cxZp6HS0OrLiC0IFzbhwYflHvv3uUdYo5xueNbDMFN+kxHV2XvgNBulfdgmakqqvm2j6fkr2CooNC7m0McoqN2r1emJL0BNtUTVuQxR7AiroCo33bPz2S9rK8oR0dx5eQYgJb7FSskwmnHP6IPu7G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3+BAB4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3+BAB4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A565AC4CEC6;
	Wed,  6 Nov 2024 19:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730920687;
	bh=qWU+zySOkZCELsN3d8uh6TbTVI7+9/dRXlmRe9khmDE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n3+BAB4Q1101zgntxl1wsX2Dw1Lhpv1pKhGXpXve21FkUKKG9cNSow98bJlWKUITl
	 h+HEhszBY+GEcl4rVADfbyuQ+z/lOfyI6ZqEp7bvsrgEuREaiIKFb9t+9S0igNxD+a
	 4CMrrnsObHGHuO6VGHMgVnzCLNwFeUHgc4mS0GixYvGZeLNn4zaCejHqBFHd3SwPAg
	 HyUmzp/ld+s7CCIpdkSF/svQFBO9XpX5ATzr81xtuuMHASXavWv+mE+7/RGDiYKt/J
	 OhD8aKF/IOx0fs8PTcFcQVrFvw4rE42Z2/keTL2+FGHQsCfk+GvJJGWaXI1CAWstrF
	 pd77rqHZwy3tA==
Date: Wed, 06 Nov 2024 11:18:07 -0800
Subject: [PATCH 1/2] design: update metadata reconstruction chapter
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173092058951.2883036.12931641443859459770.stgit@frogsfrogsfrogs>
In-Reply-To: <173092058936.2883036.6877146378997138277.stgit@frogsfrogsfrogs>
References: <173092058936.2883036.6877146378997138277.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

We've landed online repair and full backrefs in the filesystem, so
update the links to the new sections and transform future tense to
present tense.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../reconstruction.asciidoc                        |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/reconstruction.asciidoc b/design/XFS_Filesystem_Structure/reconstruction.asciidoc
index f172e0f8161656..f4c10217910b6c 100644
--- a/design/XFS_Filesystem_Structure/reconstruction.asciidoc
+++ b/design/XFS_Filesystem_Structure/reconstruction.asciidoc
@@ -1,10 +1,6 @@
 [[Reconstruction]]
 = Metadata Reconstruction
 
-[NOTE]
-This is a theoretical discussion of how reconstruction could work; none of this
-is implemented as of 2015.
-
 A simple UNIX filesystem can be thought of in terms of a directed acyclic graph.
 To a first approximation, there exists a root directory node, which points to
 other nodes.  Those other nodes can themselves be directories or they can be
@@ -45,9 +41,14 @@ The xref:Reverse_Mapping_Btree[reverse-mapping B+tree] fills in part of the
 puzzle.  Since it contains copies of every entry in each inode’s data and
 attribute forks, we can fix a corrupted block map with these records.
 Furthermore, if the inode B+trees become corrupt, it is possible to visit all
-inode chunks using the reverse-mapping data.  Should XFS ever gain the ability
-to store parent directory information in each inode, it also becomes possible
+inode chunks using the reverse-mapping data.  xref:Parent_Pointers[Directory
+parent pointers] fill in the rest of the puzzle by mirroring the directory tree
+structure with parent directory information in each inode.  It is now possible
 to resurrect damaged directory trees, which should reduce the complaints about
 inodes ending up in +/lost+found+.  Everything else in the per-AG primary
-metadata can already be reconstructed via +xfs_repair+.  Hopefully,
-reconstruction will not turn out to be a fool's errand.
+metadata can already be reconstructed via +xfs_repair+.
+
+See the
+https://docs.kernel.org/filesystems/xfs/xfs-online-fsck-design.html[design
+document] for online repair for a more thorough discussion of how this metadata
+are put to use.

