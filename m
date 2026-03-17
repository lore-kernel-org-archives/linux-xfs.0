Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDB7189F43
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 20:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773780619; cv=none; b=jYFox8q6Ap81E8GhiWzsP36jZXMJJr+4T8ZZgIU/TIj+TVL1IGcisFTrANxHWpD3yp1VFVmYP190AvM++gLVdzjRJqHde1OflJpn4TJxgJWYrjYM48uGNd4v48s8GEP1SnyX11MRRDKcl2tlmJ+17qUNgflBzPmDFm94linzvnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773780619; c=relaxed/simple;
	bh=rd04TuG7DeU/HRObv3M31QHWccPXE4eG+ojAskegHFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MOeHTZO9GISxdYdAIR/Vl14zB1jk1I9uiByjdgxr/NAOab944GYkXwF6A/yJDh39gqVNS+D2J+SRFpdPQrR+T+HBZVzO4tEpLBPBZ4e8NZJbgkrsD9UbWhnpu5rg/svyH1RPsYY6zUXNMJI47Bp9Jss0PbTUYmoFyyUf0g/w0aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uGKYI5vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uGKYI5vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992BEC4CEF7;
	Tue, 17 Mar 2026 20:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773780618;
	bh=rd04TuG7DeU/HRObv3M31QHWccPXE4eG+ojAskegHFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uGKYI5vNarRRf7tTRV6vYYaOmdbAUU5HzCYXMLAyxSrTWWTKjyqquC3Nxpxk11qUP
	 xPP2R1+vc78LpMCS2WxQRnf6Wx5x95NfFd/8L7sXw4QzLMHizVK6fXE1DDP8vl69uU
	 b6NVxRzQUVmoQ2pvEfFO7JL20IqdR3ND0SdgzP0fQbg8A06W9Fi6+oeaw01Zseugf0
	 H4lZr6ppHo5jo2qYTci4sClJZgYAzAEQc1MynY5P6MF5wt/5Bynl/UzSllfx31bZUe
	 37jgUyk3jU1y7KMwi7NX9L3BmZ1ej2EUR87xUoaVsVvt1SQLn84Hrev4IZB38+4CbB
	 PwkB+nmMuB71g==
Date: Tue, 17 Mar 2026 13:50:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@infradead.org, ravising@redhat.com,
	leo.lilong@huawei.com
Subject: [PATCH v2] xfs_repair: don't fail on INCOMPLETE attrs in leaf blocks
Message-ID: <20260317205018.GJ1770774@frogsfrogsfrogs>
References: <20260316225033.GP6069@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316225033.GP6069@frogsfrogsfrogs>

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
---
v2: improve commit message to explain how we got to this acceptable
place
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
