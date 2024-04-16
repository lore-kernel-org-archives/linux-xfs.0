Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D6081F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231357; cv=none; b=ti6Qhle912ojK7JyFDjwvofj4PJyt1bZM24eNNEmhSPAIgY9A+kWW6YauAnrteejyJDFbSq1xJ28CzsESNhM0n74/AosJjPATMtKytVE5Fgy5NmUpUzkZf8gO7gGP+U8q0SQb2deIL4IrckGY5Hvrkwq3B/+Pu9wysG9psi0IN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231357; c=relaxed/simple;
	bh=JYfzJiJQckAgUuuI74gpGpzlldkqAuayLZ1Ku9nP89Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MwP4pwIy8I0AB1OYUrhzxtQrX9fCcNCLUgYdShj0J1j9+fWoPIVzPIP2RtYiKq+A84Yw7vXi2Gb860b42JGdrj77EwS8mHOtGFEpgQblhIZCKW3UFVizDNjaB/6nUbIpv65vC/vuljfLF2LI4OX+HGhx5t0nJ29Gr0ySeTkGOa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpTZgIY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpTZgIY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2974FC113CC;
	Tue, 16 Apr 2024 01:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231357;
	bh=JYfzJiJQckAgUuuI74gpGpzlldkqAuayLZ1Ku9nP89Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dpTZgIY6L5pMtDjf8XCMfQ1iPoEtcRb3VHaqlck2+SDnovk3MokJNRr1GRdwTz5y2
	 6b13oHYqCW78sqaxzRurMk2Za1FGa6D8dUOhWnEgQJO0XBeZV6IDWLux3jnB3hH5DF
	 bl3Xw+GH/Nxjn1VJL3PjyCZ7eB1dJa8FSvlH1jQEwqZTz1shtnGfdvK6oAh5LKeakt
	 K7LigOPxDnp9di/nFheGnYzug12lPtX7t3MJzy8lDLL92br8IWgBNmUIry/b6YC/6o
	 X0YEf4uMljbxamjupmYi47nJMiDWZwktbAh3rcvxrjapW7NYc4MdWLJ6zn6kkIYNyE
	 ncw47QchmO+yQ==
Date: Mon, 15 Apr 2024 18:35:56 -0700
Subject: [PATCH 7/7] xfs: check parent pointer xattrs when scrubbing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323028782.252774.15544069095667600524.stgit@frogsfrogsfrogs>
In-Reply-To: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
References: <171323028648.252774.8320615230798893063.stgit@frogsfrogsfrogs>
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

Check parent pointer xattrs as part of scrubbing xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 393ed36709b3a..b550f3e34ffc7 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -17,6 +17,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_sf.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
@@ -208,6 +209,13 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
+	/* Check parent pointer record. */
+	if ((attr_flags & XFS_ATTR_PARENT) &&
+	    !xfs_parent_valuecheck(sc->mp, value, valuelen)) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
+		return -ECANCELED;
+	}
+
 	/*
 	 * Try to allocate enough memory to extract the attr value.  If that
 	 * doesn't work, return -EDEADLOCK as a signal to try again with a
@@ -219,6 +227,14 @@ xchk_xattr_actor(
 	if (error)
 		return error;
 
+	/*
+	 * Parent pointers are matched on attr name and value, so we must
+	 * supply the xfs_parent_rec here when confirming that the dabtree
+	 * indexing works correctly.
+	 */
+	if (attr_flags & XFS_ATTR_PARENT)
+		memcpy(ab->value, value, valuelen);
+
 	args.value = ab->value;
 
 	/*

