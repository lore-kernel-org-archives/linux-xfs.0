Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D148D5A4C2
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798605; cv=none; b=mKVwCrSjzvMS9VBx3Nff3ncWAiBsTJa2dgJ0yKLkbewO8DvqWhQPy0GisVpHFaKVriMn3QTAWJXzVLUwMIyCmCgOWzhWVO9Jd6HpIfh3N/gnmucOzoDgIByYEoZRZZwUlYXfCd9wOli9r2VDKwT3gxEwgOfMwL1ETQxI0I6DKNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798605; c=relaxed/simple;
	bh=AAh2zwCRiKXP26tuh6koTV2RapJBUqzMqxLP7Y6muVQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SA5TQKtKwsErSHrxuZL10jmYR1aTMTGdNgKeownvlUPxI3Kbgt6aegy37F0pwpqRX+AZ0DJGmf1iQth15IzKmtJcUY9JyqWGSt3wnbvnkL2dcl2sPLMEMs7zdbSbppMAVRWajjr9NpqzVOe05X5RhfLYSU3Y8OM/J6okCKVVk1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MeFdji+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MeFdji+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CA1C433F1;
	Mon, 18 Mar 2024 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798605;
	bh=AAh2zwCRiKXP26tuh6koTV2RapJBUqzMqxLP7Y6muVQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MeFdji+rIXgaoTrvfTG+1o1mGa1TAbowww9JaRGvtjuIDJRF67sDjOFB+5ipDWX6T
	 mj9RJ+1b+KPYUnfxgOtJ5vuuQnZhePdjodn7UCqEibDz0Fwvvlyx6aBmx0UIuNhAF4
	 do2gLZVNVpZxcTUdwXn6iKd65lFqLaJzredBeF43c87HfA42Ef1EWmOIYXr88S9/gR
	 MIaql+cUQ9K2qE0YVrWnXtQfVILrf/qSTM7a+7KuS81pIxkpRhMaSzGDLAbHv4CSfF
	 G0HMIYZ/dO9ufATaBGferaT0AvVQ+xgOK/HHES6qvHdbe5e38kw7v9qAmSaKOIRb22
	 3IiD2haEqyiMQ==
Date: Mon, 18 Mar 2024 14:50:04 -0700
Subject: [PATCH 08/23] xfs: set child file owner in xfs_da_args when changing
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802825.3808642.13044502785766853653.stgit@frogsfrogsfrogs>
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

Now that struct xfs_da_args has an explicit file owner field, we must
set it when modifying parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_parent.c |   13 ++++++++++---
 fs/xfs/libxfs/xfs_parent.h |    4 ++--
 2 files changed, 12 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 3c31c04dd9a20..3c3fcdf8b975b 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -201,6 +201,7 @@ xfs_parent_addname(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&ppargs->args, parent_name);
 
@@ -239,6 +240,7 @@ xfs_parent_removename(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&ppargs->args, parent_name);
 
@@ -288,6 +290,7 @@ xfs_parent_replacename(
 
 	args->trans = tp;
 	args->dp = child;
+	args->owner = child->i_ino;
 
 	xfs_init_parent_davalue(&ppargs->args, old_name);
 	xfs_init_parent_danewvalue(&ppargs->args, new_name);
@@ -371,6 +374,7 @@ static inline void
 xfs_parent_scratch_init(
 	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
@@ -387,6 +391,7 @@ xfs_parent_scratch_init(
 	scr->args.whichfork	= XFS_ATTR_FORK;
 	scr->args.hashval	= xfs_da_hashname((const void *)&scr->rec,
 					sizeof(struct xfs_parent_name_rec));
+	scr->args.owner		= owner;
 }
 
 /*
@@ -415,7 +420,7 @@ xfs_parent_lookup(
 	}
 
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(tp, ip, pptr, scr);
+	xfs_parent_scratch_init(tp, ip, ip->i_ino, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_OKNOENT;
 
 	return xfs_attr_get_ilocked(&scr->args);
@@ -429,6 +434,7 @@ xfs_parent_lookup(
 int
 xfs_parent_set(
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
@@ -438,7 +444,7 @@ xfs_parent_set(
 	}
 
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	xfs_parent_scratch_init(NULL, ip, owner, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_LOGGED;
 
 	return xfs_attr_set(&scr->args);
@@ -452,6 +458,7 @@ xfs_parent_set(
 int
 xfs_parent_unset(
 	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
@@ -461,7 +468,7 @@ xfs_parent_unset(
 	}
 
 	xfs_parent_irec_to_disk(&scr->rec, pptr);
-	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	xfs_parent_scratch_init(NULL, ip, owner, pptr, scr);
 	scr->args.op_flags |= XFS_DA_OP_LOGGED | XFS_DA_OP_REMOVE;
 
 	return xfs_attr_set(&scr->args);
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 58e59af818bd2..46bf96c7e3c92 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -162,11 +162,11 @@ int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
-int xfs_parent_set(struct xfs_inode *ip,
+int xfs_parent_set(struct xfs_inode *ip, xfs_ino_t owner,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
-int xfs_parent_unset(struct xfs_inode *ip,
+int xfs_parent_unset(struct xfs_inode *ip, xfs_ino_t owner,
 		const struct xfs_parent_name_irec *rec,
 		struct xfs_parent_scratch *scratch);
 

