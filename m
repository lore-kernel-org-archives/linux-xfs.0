Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC0655E41
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798652; cv=none; b=QHu957Cp9I7ZIBuFYQCOG6xrFXltksndLSTEs7CYUSxkzAVozXkirsXlzAbtcAZ/863w5c9LncRDGHJWGnBNeLX6O7kTZldjdbAV+NSgk47rkoKchi/WEzQUxWRT9z7g+fBz4HCwXxUAcydI8pzcSQb2zrx/fdk5aEmX4C0EV98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798652; c=relaxed/simple;
	bh=eBjSiPskRDYdNR+guwqAuFih2WNvyMdDEq7W1O76UzI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r6iVso2iD992Z5N3rRksaUhWMCMV/ckVihU1x3RdcVozRGxh8PFNxx0GP9WmBNQ8vYmfHipV86k0LU4JH0jGTs83OEtYr7gCnBcTGqVBGbKU5oHOMKQ3LdLwImmlO1LwRIiBChU21QZUiKa6c8rGNRLT8tJX8N14B7S62oSBpqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AadQOghl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AadQOghl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D92BC433F1;
	Mon, 18 Mar 2024 21:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798652;
	bh=eBjSiPskRDYdNR+guwqAuFih2WNvyMdDEq7W1O76UzI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AadQOghlp1fu+pbImvn2cT+qc5+WwoZJIRPDjWqT0/RILGXzBhlKE5oZamdnrkfNe
	 tre8ZPXs5gDbCuaybZsicegybF4KDfyIF+c0dNGCqD6iQHz9WnEGyEqA/cWdMNxEjz
	 OaaaS9vCpiHoiE65FJ9zzon4TpY+Gx6AD/VkFdHDGNwQjxkveOQppUeeD1rSkhhI7B
	 mGupKO71ndRVRukWSWC5ROajuf4Nv5HOGocpu8EsGuW219R0n0vwrlLxTkdyLERms/
	 KPfNTRbEw5Lhe4Hv2sw6Ozt2lHggDrcJkk75fOfUkg8nj2eETM2khP6J+aGdMeJTkq
	 MGrkJPpSynVaQ==
Date: Mon, 18 Mar 2024 14:50:51 -0700
Subject: [PATCH 11/23] xfs: replace namebuf with parent pointer in directory
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802873.3808642.4193969572728501581.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

Replace the dirent name buffer at the end of struct xrep_dir with a
xfs_parent_name_irec object.  The namebuf and p_name usage do not
overlap, so we can save 256 bytes of memory by allowing them to overlap.
Doing so makes the code a bit more complex, so this is called out
separately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 4cfda208e9e6b..e89703d1123cd 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -28,6 +28,7 @@
 #include "xfs_exchmaps.h"
 #include "xfs_exchrange.h"
 #include "xfs_ag.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -131,8 +132,14 @@ struct xrep_dir {
 	/* Should we move this directory to the orphanage? */
 	bool			needs_adoption;
 
-	/* Directory entry name, plus the trailing null. */
-	unsigned char		namebuf[MAXNAMELEN];
+	/*
+	 * Scratch buffer for reading parent pointers from child files.  The
+	 * p_name field is used to flush stashed dirents into the temporary
+	 * directory in between parent pointers.  At the very end of the
+	 * repair, it can also be used to compute the lost+found filename
+	 * if we need to reparent the directory.
+	 */
+	struct xfs_parent_name_irec pptr;
 };
 
 /* Tear down all the incore stuff we created. */
@@ -696,7 +703,7 @@ xrep_dir_replay_update(
 	struct xfs_name			name = {
 		.len			= dirent->namelen,
 		.type			= dirent->ftype,
-		.name			= rd->namebuf,
+		.name			= rd->pptr.p_name,
 	};
 	struct xfs_mount		*mp = rd->sc->mp;
 #ifdef DEBUG
@@ -773,10 +780,10 @@ xrep_dir_replay_updates(
 
 		/* The dirent name is stored in the in-core buffer. */
 		error = xfblob_load(rd->dir_names, dirent.name_cookie,
-				rd->namebuf, dirent.namelen);
+				rd->pptr.p_name, dirent.namelen);
 		if (error)
 			return error;
-		rd->namebuf[MAXNAMELEN - 1] = 0;
+		rd->pptr.p_name[MAXNAMELEN - 1] = 0;
 
 		error = xrep_dir_replay_update(rd, &dirent);
 		if (error)
@@ -1421,7 +1428,7 @@ xrep_dir_move_to_orphanage(
 	if (error)
 		return error;
 
-	error = xrep_adoption_compute_name(&rd->adoption, rd->namebuf);
+	error = xrep_adoption_compute_name(&rd->adoption, rd->pptr.p_name);
 	if (error)
 		return error;
 

