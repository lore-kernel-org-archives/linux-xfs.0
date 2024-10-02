Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41C110E9
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831505; cv=none; b=tZ3V5FulJUe+QLh/3nwFCY1p6ileoMwHQkdZzRy4lhB0sfUeX2vcZw7lqs4Se6iwMB0eHTx/6OorOf068ac3QvAqnzpSQtpCrhclHanla5cm9Nj6XJfNAPjmgjPMXHwJI3b6X3RhkMetnmX3zsWqRHEinsm7auCk7ePgJfNPmlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831505; c=relaxed/simple;
	bh=HHRHmhvif5XlpQQVLnqaI3armtxkr/jthCr/jlvNwZY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gH7HV+x2mTPdk4cc4vorjggVdP0+Am7RNsSvrZLGyLDd6WQv8GZgqjLJuyzF4qyIBruLVyd58oXPB806mZUxR6mq+ni4EZG3aQWcsVlS2zqjaKIzEH5xoDwIFjOn7Ft7HYI/ynXaTF4Ac2llTMom25Sfj5B5n0AKWRwNKJ6CZVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnIhcD8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnIhcD8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50532C4CEC6;
	Wed,  2 Oct 2024 01:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831505;
	bh=HHRHmhvif5XlpQQVLnqaI3armtxkr/jthCr/jlvNwZY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EnIhcD8dJuSiR4Z9HjOegOg0BRr4+p9Gqcp6p+2W9Q/KVjjLLE2wOR3BK6g8d8Phm
	 dmcGuhnWYu6Pq3gPTbszXKahkU450nUOt25hDapoi5sj1oMGWppEg0SryePJyEVi1z
	 O1uE6w5Tdaux7smrfmhHT4G7XYfJon9KusrELQdrC+qorzJCsnitbMrkK01SVkgqlq
	 dTVFdTC4KNg0vIIs+kIq7O93NeSYqva1UZ/ryRMv0Al9D1Ll1YOO0pnybzzvK0TlGb
	 3/g57aUUnrBSfaSsjJg5BDz/eUj2QI2WHHnB/fALgoAIP2be2LxLU5uiVDoHbkP10R
	 qZmLFAdLmfTIA==
Date: Tue, 01 Oct 2024 18:11:44 -0700
Subject: [PATCH 15/64] libxfs: pass flags2 from parent to child when creating
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783102007.4036371.6326005460816006792.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

When mkfs creates a new file as a child of an existing directory, we
should propagate the flags2 field from parent to child like the kernel
does.  This ensures that mkfs propagates cowextsize hints properly when
protofiles are in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index d022b41b6..3e72b25cc 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -59,6 +59,20 @@ xfs_inode_propagate_flags(
 	ip->i_diflags |= di_flags;
 }
 
+/* Propagate di_flags2 from a parent inode to a child inode. */
+static void
+xfs_inode_inherit_flags2(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = pip->i_cowextsize;
+	}
+	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
+		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+}
+
 /*
  * Increment the link count on an inode & log the change.
  */
@@ -153,6 +167,8 @@ libxfs_icreate(
 	case S_IFDIR:
 		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
 			xfs_inode_propagate_flags(ip, pip);
+		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
+			xfs_inode_inherit_flags2(ip, pip);
 		/* FALLTHROUGH */
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;

