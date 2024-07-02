Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5AB9441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883127; cv=none; b=nI7X1fMTYy1hf1TMZjJKOmT8P1BQ86QaoKB1R8DkfCfB4ckDwFsc1JfsaYhWb8JKmOqYBS91ilb/GqmSzr9JfHDA3hb+D9NzqB+FuUb4LOmw9mAPmHJsxFFVSzkGioK8gZWw7hip2nrt1kXh4gfC7BVhfcScM2K+N+PxC2ajklE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883127; c=relaxed/simple;
	bh=kplgIM4rEH+cKd18bV5k0EYgBt96QWYrQORfj5l9g+4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e360QROHF+C6tJak/ZSFOGCo8Or6x/ChXEOoGnpHei2dPMt71kAMPpsL6z4YzINEVszoSfmCmJxfcRXZejii7SQ7zIq/6hrVzb4R69DZALciJgTndy2CCNmSdnunrt9PQmc/rSsIuaGb69AE7zUYYuJZliakOXc/jbwA8cdVl+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqlLvkyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqlLvkyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FCFC116B1;
	Tue,  2 Jul 2024 01:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883127;
	bh=kplgIM4rEH+cKd18bV5k0EYgBt96QWYrQORfj5l9g+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZqlLvkytqtzU815g92H/FWg7XwK+BnogAHkIvSQnZSd7ucIIjpFOcHdLMRhxkTyt6
	 7pe3o5diQ1wRQL/niHFA9y3+CojpKN5zNzsIpFvOWiTXXVFdzJjnGIr3WzMQhXDa3D
	 C4uiQ/6RRHvNW+w10Zejy87Xpv67WCTWUXx/UgHPXEwmAc8txlIw1k78aOqJHUCXEN
	 qVfjTjO7nOVw5sWWGXkm9w6ljF7Il7/ThetOPApQ2Lvc5h69ngevP67Qrdh3C7UDIb
	 oj597ytCay+aotxo+SlMdY1L06HW26xGeYe5JwBi80lyJU7UUWL8TEDqPj8k/Q9+dc
	 pc2niMeaOYo7A==
Date: Mon, 01 Jul 2024 18:18:46 -0700
Subject: [PATCH 05/12] xfs_repair: junk duplicate hashtab entries when
 processing sf dirents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122243.2010218.604571260560807315.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
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

dir_hash_add() adds the passed-in dirent to the directory hashtab even
if there's already a duplicate.  Therefore, if we detect a duplicate or
a garbage entry while processing the a shortform directory's entries, we
need to junk the newly added entry, just like we do when processing
directory data blocks.

This will become particularly relevant in the next patch, where we
generate a master index of parent pointers from the non-junked hashtab
entries of each directory that phase6 scans.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 791f7d36fa8a..9d41aad784a1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2562,6 +2562,7 @@ shortform_dir2_entry_check(
 	struct xfs_dir2_sf_entry *next_sfep;
 	struct xfs_ifork	*ifp;
 	struct ino_tree_node	*irec;
+	xfs_dir2_dataptr_t	diroffset;
 	int			max_size;
 	int			ino_offset;
 	int			i;
@@ -2739,8 +2740,9 @@ shortform_dir2_entry_check(
 		/*
 		 * check for duplicate names in directory.
 		 */
-		dup_inum = dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
-				(sfep - xfs_dir2_sf_firstentry(sfp)),
+		diroffset = xfs_dir2_byte_to_dataptr(
+				xfs_dir2_sf_get_offset(sfep));
+		dup_inum = dir_hash_add(mp, hashtab, diroffset,
 				lino, sfep->namelen, sfep->name,
 				libxfs_dir2_sf_get_ftype(mp, sfep));
 		if (dup_inum != NULLFSINO) {
@@ -2775,6 +2777,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to ino %" PR
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			} else if (parent == ino)  {
 				add_inode_reached(irec, ino_offset);
@@ -2799,6 +2802,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to ino %" PR
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			}
 		}

