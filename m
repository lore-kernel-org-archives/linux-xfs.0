Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2490C8821
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302817; cv=none; b=tyXzSqxafN7W75wHqM/QpQIFtzD9umaA0tDxYykz/N3fbePFVsK5xWqwl4abFRRyjcDzmRy+eGi08mqAneUnYUzumo+H0wFQec7efxViv4c0G32h1G5425JK/YQzXMl6OYBdY+9tQFLotRZOeqJWK8VInjSM31XlsuB7LbH5twg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302817; c=relaxed/simple;
	bh=1bFdOG1IwA+Hsw41x7teFnDMdQoHt+PN7YqKKL01sDI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gKMMZJDUE+uVsTCrZYxZ3nW1RxFDT9jrDI2WACpYito3jaWc3jcvBMgh/qWbwthuSqB1FZJ/BNZSxYdJUX2x+qULHK4pbeZ1pTNKoKlOJ2uf4AoOzHhSLWp2qof1U2Ya2j5+HXqVqySTYlPCqskkNw3fLpVwGruX1BBF3eljBj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ff4tXLmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ff4tXLmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAE1C32786;
	Tue, 30 Jul 2024 01:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302816;
	bh=1bFdOG1IwA+Hsw41x7teFnDMdQoHt+PN7YqKKL01sDI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ff4tXLmCy9DQv/mQtRFq0xTot+7CDfeWgMPLXrcAMF3q5osP/+foW8ct6485N4f+r
	 ytqmRQfVEcflUR6RaV0MFjuYZakTX+rGqnvDPN43sqWr2D/qnZvX0y57eYGok7v+h+
	 Gj6Ww6KI4cTMQI+RnnHRVmNYD7d3Hz8yTt3gW/Mvrr107vezBfDPshRi5Y/K25ROOA
	 QexHtbrxQhwQkjk/SiaxG6eN2Vu9K41hqDEy+/PYaHUMD+lNbxpepP0JdM9I+Cd3cV
	 GMZpHIgtOx2tYbkOEOrnVc315byMs3Tr2uTvWWzTGOjItNJElWuu7aZMDiuxNUZT5y
	 QXOZFx6OUY9VQ==
Date: Mon, 29 Jul 2024 18:26:56 -0700
Subject: [PATCH 05/12] xfs_repair: junk duplicate hashtab entries when
 processing sf dirents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229851552.1352527.2090171438986207052.stgit@frogsfrogsfrogs>
In-Reply-To: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
References: <172229851481.1352527.11812121319440135994.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 791f7d36f..9d41aad78 100644
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

