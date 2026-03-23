Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4BD30DD2A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291277; cv=none; b=A5U5A6Oc/YwPS0kYrUyFyZmsmMiOm5U54HXqR+cHOTRjQPgcZIofi45deWwREJRiUoJlwcaNwizNA/16TGDnCHh1Cd0Kzqi15eU3+Hp0CW+hWlZQuEvZHk9W0CfwX0ND478K2jnOeHsbloVRVyuUt1PqOOYu2orT/Ek0niHyadI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291277; c=relaxed/simple;
	bh=tL41jWRu3ldQUlUAq3t0SJEkr9fIVe/otkuAwjda5so=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TWzn6P+u8aREzOEW8GSI0wWSr5wRXazdf/g1+tSPtTbjKJQNPyzGdgHLbrtOZmu2b410re9Ve/0zeyj5k4A3w6QszVQbSJncVix1hh/WCU2gTREEkKNl52hV0uZYxCp2ZnXfVpOw12IjZx4Z33p83JejfAwg9SUz5SzkxcPjRGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3koeZNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3koeZNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B391C4CEF7;
	Mon, 23 Mar 2026 18:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291277;
	bh=tL41jWRu3ldQUlUAq3t0SJEkr9fIVe/otkuAwjda5so=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N3koeZNvbEtrIrj5jlY1EkW8tOMXkZqIMxHnGBc+Hm3pArRtme6DjDs7eDGYkjctw
	 PW9fjr3zo2OKngM4okKHiJ3s/0U2pmpRACIPEUjqgZR/nHj2sYC7JfcS63TnV3WlfL
	 DI2NJqE/i0T3FTPdYY9ZtU+g1i/W3244QYqq1QOERpB2usb9NTv6L5zeMRa6hU1dLs
	 9LKJ0d8KJ23p4fa+3joHOhpxCtrJYBq+1v04wLK/B6nzz9NDIZRrodpUT8/B6R77Er
	 Rk4cNElpIAEcmTqmkoABIpGtC1O6QDhTMy1v9YcdZnUmRUEcPHJO+okpNJ6VxxqfvR
	 HtENeexbLnNYw==
Date: Mon, 23 Mar 2026 11:41:16 -0700
Subject: [PATCH 1/1] xfs_repair: don't fail on INCOMPLETE attrs in leaf blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177429120305.2266172.16996819170156005590.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120286.2266172.6821817395168865287.stgit@frogsfrogsfrogs>
References: <177429120286.2266172.6821817395168865287.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

While trying to fix problems in generic/753, I noticed test failures on
account of xfs_repair:

 attribute entry #4 in attr block 0, inode 131 is INCOMPLETE
 problem with attribute contents in inode 131
 would clear attr fork
 bad nblocks 4 for inode 131, would reset to 0
 bad anextents 1 for inode 131, would reset to 0

Looking at the dumped filesystem, inode 131 is a linked file, and the
"incomplete" xattr was clearly part of an xfs_attr_set operation that
failed midway through because the induced log shutdown prevented xfs
from finishing the creation of a remote xattr.  This kind of thing is
expected, but instead xfs_repair deletes the entire attr fork!

It's far too drastic to delete every xattr because doing that destroys
things like security labels.  The kernel won't show incomplete attrs so
it's not a big deal to leave them attached to the file.  Note that
xfs_scrub can fix such things.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/attr_repair.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 50159b9a533875..fe4089026cae74 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -571,7 +571,13 @@ process_leaf_attr_remote(
 	    !libxfs_attr_namecheck(entry->flags, remotep->name,
 				   remotep->namelen) ||
 	    be32_to_cpu(entry->hashval) != computed ||
-	    be32_to_cpu(entry->hashval) < last_hashval ||
+	    be32_to_cpu(entry->hashval) < last_hashval) {
+		do_warn(
+	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
+		return -1;
+	}
+
+	if (!(entry->flags & XFS_ATTR_INCOMPLETE) &&
 	    be32_to_cpu(remotep->valueblk) == 0) {
 		do_warn(
 	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
@@ -592,6 +598,9 @@ process_leaf_attr_remote(
 		return -1;
 	}
 
+	if (entry->flags & XFS_ATTR_INCOMPLETE)
+		goto out;
+
 	value = malloc(be32_to_cpu(remotep->valuelen));
 	if (value == NULL) {
 		do_warn(
@@ -708,12 +717,15 @@ process_leaf_attr_block(
 		}
 
 		if (entry->flags & XFS_ATTR_INCOMPLETE) {
-			/* we are inconsistent state. get rid of us */
-			do_warn(
+			/*
+			 * Warn about incomplete xattrs but don't zap the
+			 * entire attr fork because that causes loss of
+			 * security labels.  The kernel can handle stray
+			 * incomplete attr entries.
+			 */
+			do_log(
 	_("attribute entry #%d in attr block %u, inode %" PRIu64 " is INCOMPLETE\n"),
 				i, da_bno, ino);
-			clearit = 1;
-			break;
 		}
 
 		/* mark the entry used */

