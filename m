Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB3E53A7
	for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2024 00:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732666699; cv=none; b=us2uIBVw1MSX0P6Z2uAxdCppWfiPceOiAudH5zcs3wLL31zQX/gRSHBIsMEM/lhf/WKe5kphq6StPgug7IFxm3z/vV0ce0a2UbPlH2Nn6YjcnHNgXYwThNwHucZmQjjmdpz1xRylJORFrIPr47/wvnPsUQdL8syy90T6z+5zq8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732666699; c=relaxed/simple;
	bh=7rlnOMoFsS9aD1uz+ODdmMOzLVl3yHhkZ6Gk1eGk4G4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPMUU3SUkvclCg6/KUoCygaXkQKlcuvR1NvZKUEbY5GbKUo5rjh7GEWdZMRHLKSPAhxQr+1yLCDPh0ZkMiTn+R+9cMQuqI6XePaA7SIpBXlgVF/wT821yviEUfI/qqicB8X2ctO6lr3QAxOnVDlADAupOmH3U2Wlc5Fd8Qkvm24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3dV8Ok3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3dV8Ok3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5179DC4CECF;
	Wed, 27 Nov 2024 00:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732666697;
	bh=7rlnOMoFsS9aD1uz+ODdmMOzLVl3yHhkZ6Gk1eGk4G4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e3dV8Ok3p5UVxsi2/OarCe/7lVNgMNCA/xN0os8R6CNDe+OOm8Y4KFggTDXqaG2sA
	 R0BG5UBcUiJp1LoPzXjgCEaGPUwZsdCxZnlwqghDghu0MJ1mSxY2Vk8UnFkVCy5JPQ
	 8suX/fh6Iv6fDz5IeNbV9hQCxi2Nhus+nMyPVBiy7vg7Rnb1OBzfe48xBY1RppwdZF
	 IW1CiWrFN8l/tlJdnqi1ggruKVcramRQHZbaPc64DUvUEZWcE+Utn3z6KbT+mxCZXe
	 YBgRW2QdHFhko2kgFC5EwIWCJICjePoVTGdV0Xcu1goFzm28wVTP2gLJZD7SSwT6yH
	 zOdq+m9L8L+og==
Date: Tue, 26 Nov 2024 16:18:16 -0800
Subject: [PATCH 01/10] design: update metadata reconstruction chapter
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, cem@kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173266662227.996198.3279322255032676510.stgit@frogsfrogsfrogs>
In-Reply-To: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
References: <173266662205.996198.11304294193325450774.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

