Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB368489
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883064; cv=none; b=ERRAZA6ggr0qBP0Gdg+h4jllLNVvtkgcZVR1xD5mrPV+/m+kA1m6DEZ3SA5kqEbdOjuzsQGEsAzA8BEuXjoqmVG/61ljyMQpbuR+AfyV/CdbH+bcXNSwkDFe4heoOXvm3qD8wN+qzzo3NEndGJlklMvYDQE0BkvCoRRVuVvQUP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883064; c=relaxed/simple;
	bh=tW66rJzXnO2YVvcEPHKEPTyG4uFUCQF8Q+zmHXkXNgM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6ZDEC1yPYUXpOMgaZ7yXKQd33jikCx9ETUsbs+TOCeFNXmKDFBWOpltJONAbntPWY6kQy7Qf5PcQoKps+VTWgVJCoaagRjmUWGSorLRAO1bwdBPWsFh9HsyII8IajGDS8V/16Um2SbYAi3MUgvMWYLId8igmu47l8uBGYkcCNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ng5M21b+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ng5M21b+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604C6C116B1;
	Tue,  2 Jul 2024 01:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883064;
	bh=tW66rJzXnO2YVvcEPHKEPTyG4uFUCQF8Q+zmHXkXNgM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ng5M21b+mqQGE9ODuI1Y5TeTrWiixVV06miSy120L1AsNy08NDkuTB6Oq1kk2Nbnr
	 A8QaH8c06/x8UDWXe7Ksai4VEeEZlyWXUnoflJXobQptXSxGwqiWHG4f2qijyFEj+v
	 XSxD+HSnTuioABDrZ4eq0gOH7V2yhad46HsQ+EnKp1tPz+ub26Ce+RFc3spupRnU2p
	 YSXxstWOJXozDqLrRx4ACmbpa6TLn1gsSZbPjG9H7Efq3b8oXunW258b+D/kp44tOk
	 Na0Jo7RYtoxTwjVuLonrPvJbb6X5Zyy9/i+dRBgJD1JY3Uhen2h1oY3/eUVdAd7Rgx
	 aDPsSahY+eM/A==
Date: Mon, 01 Jul 2024 18:17:43 -0700
Subject: [PATCH 01/12] xfs_db: remove some boilerplate from xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122181.2010218.3340368343323073575.stgit@frogsfrogsfrogs>
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

In preparation for online/offline repair wanting to use xfs_attr_set,
move some of the boilerplate out of this function into the callers.
Repair can initialize the da_args completely, and the userspace flag
handling/twisting goes away once we move it to xfs_attr_change.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attrset.c             |   18 ++++++++++++++++--
 libxfs/libxfs_api_defs.h |    1 +
 2 files changed, 17 insertions(+), 2 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index d9ab79fa7849..008662571323 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -111,7 +111,11 @@ attr_set_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_da_args	args = { };
+	struct xfs_da_args	args = {
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+	};
 	char			*sp;
 	char			*name_from_file = NULL;
 	char			*value_from_file = NULL;
@@ -253,6 +257,9 @@ attr_set_f(
 		goto out;
 	}
 
+	args.owner = iocur_top->ino;
+	libxfs_attr_sethash(&args);
+
 	if (libxfs_attr_set(&args, op, false)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			args.name, (unsigned long long)iocur_top->ino);
@@ -277,7 +284,11 @@ attr_remove_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_da_args	args = { };
+	struct xfs_da_args	args = {
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+	};
 	char			*name_from_file = NULL;
 	int			c;
 
@@ -365,6 +376,9 @@ attr_remove_f(
 		goto out;
 	}
 
+	args.owner = iocur_top->ino;
+	libxfs_attr_sethash(&args);
+
 	if (libxfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, false)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			(unsigned char *)args.name,
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index df83aabdc13d..bf1d3c9d37f6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -47,6 +47,7 @@
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
+#define xfs_attr_sethash		libxfs_attr_sethash
 #define xfs_attr_sf_firstentry		libxfs_attr_sf_firstentry
 #define xfs_attr_shortform_verify	libxfs_attr_shortform_verify
 

