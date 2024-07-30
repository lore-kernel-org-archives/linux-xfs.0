Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE871361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299684; cv=none; b=mlYhavjuQ6+wCGZzIehb7zotIPfZvNGsP0A5u067fev4RpheYfKEeBzn2mnFp8qnhCUDB6oJ9C5O/fhtLo2uc5jAQwo0Ap3OX1NVyXzwZvaXEam55Rt8Yx+H5pp2ILtjK7zJRzvb2CZC6WkRUQdfvfjn0ByiWWszx5pwfn8YG5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299684; c=relaxed/simple;
	bh=VPFa4LjvQ67JRlplxD68IM+O1zOKaTD0GD+JSw5i0Ok=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rpLWbOa8NJ10NMNEVFstJFfuVvIGpiwg/PKDZj14qkXrQC/lkt0olZpF/CUiVeOjJr1Vr5fNIAinhUfXkbG1SWiahtXCKN0gml9BeEhRvGPoAzRSi5R/KDDUr0Y23Jm/AerRogNBPyk3FghFys9nekSNGNe7Hd9nuVDj0s2eBIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5vAktXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5vAktXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25315C32786;
	Tue, 30 Jul 2024 00:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299684;
	bh=VPFa4LjvQ67JRlplxD68IM+O1zOKaTD0GD+JSw5i0Ok=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q5vAktXw6jHJpUV8hzJRWbiEV5iMIiQg+f/HT9S/Wjp0KzU5bpIK1wX8yH8OYiL3/
	 OS/aMDmLaMrIpdXNecBWKEjb7c2RrM5P0E1nxW9e3RFLHNJAYmLjChDrCxN3hs+Sqz
	 mVFBiua4zwYXDfB+LlIf/pw8XfUS3xIZxZffFzT3f8iZtzcSGaCfL8ZiN7QLTFywSU
	 TnjQIheGqCcEk2kTVxnYDggMm6VDbnm0D0qEAyZTAXHsYWj9K2zrmajUHtz+OFB/sV
	 O5p0UUdsjb6bvz12CcNUUfVNwpgErC4qKLv34mVvwo5jJNEZyuJY3+NhJQgdwEHht3
	 HRI2ea89m+Fsw==
Date: Mon, 29 Jul 2024 17:34:43 -0700
Subject: [PATCH 042/115] xfs: remove XFS_DA_OP_NOTIME
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843034.1338752.13204698580605910110.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 779a4b606c7678343e3603398fe07de38b817ef4

The only user of this flag sets it prior to an xfs_attr_get_ilocked
call, which doesn't update anything.  Get rid of the flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c     |    5 ++---
 libxfs/xfs_da_btree.h |    6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 07f873927..958c6d720 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -363,7 +363,7 @@ xfs_attr_try_sf_addname(
 	 * Commit the shortform mods, and we're done.
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
-	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
+	if (!error)
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	if (xfs_has_wsync(dp->i_mount))
@@ -1031,8 +1031,7 @@ xfs_attr_set(
 	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(args->trans);
 
-	if (!(args->op_flags & XFS_DA_OP_NOTIME))
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
 	 * Commit the last in the sequence of transactions.
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 76e764080..b04a3290f 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -90,9 +90,8 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	(1u << 2) /* this is an add operation */
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
-#define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
-#define XFS_DA_OP_RECOVERY	(1u << 6) /* Log recovery operation */
-#define XFS_DA_OP_LOGGED	(1u << 7) /* Use intent items to track op */
+#define XFS_DA_OP_RECOVERY	(1u << 5) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 6) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -100,7 +99,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
 	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 

