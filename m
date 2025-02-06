Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F1323716E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882232; cv=none; b=fPtiSSoNw6uhpLIvTpIJLDnEKxe4TKdBOo2bLi/NB6bzRDhjUlx+kTZaVS1cfIz0mtlBCE6VJXmMW8GhsqNt0WTzSrq9vGYHTCYzb/AlX9j81n92onfDIhHvCoC9Gr7FN27mZRaOfyWdqN/A2ucoD2Ql9Y3omJtql7wCJh1aob4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882232; c=relaxed/simple;
	bh=82ANfVjCKEFwbfsfBHQ3QVEDd2yeEU07BNDL9MvkIH8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AFw+TiviobGC7Py+jmGWlLtaeLsmuosVSu29tJ67QHYKtVy39NxZNb4R611nkWkQbKsKz94S9QdCcNuETNccyXgDpDFSCi8JuCe3LuSNTS4TX/fOBWpnMYAFsxHyQ9mO0EUul4rf+7s3jRsrT24a7ZTwGWPQMcFzjGtVwJI4Lew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sefPnzSo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sefPnzSo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5FDC4CEEE;
	Thu,  6 Feb 2025 22:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882231;
	bh=82ANfVjCKEFwbfsfBHQ3QVEDd2yeEU07BNDL9MvkIH8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sefPnzSoCYrMwrbTqCdf7XqmePidfgOZtO7x1cAKhwRccyZv05ROI0qIxAE5IUYqS
	 HrPsBBRg+qUhll939M/S275c9shpjHeulpSwXoSVaebA/ncmVs1kly2xK28dnO24eT
	 BEx5sQ7f8/1fqnqC+hYbOwwQoWAhz2j8It/Nvurea2gp5Dx8GObj5RHH6/VcV8SlHw
	 0ZSDJk/krmeH0HncCfVhTRsc/H/DDi+yIg/HnB/EOQM7S05LB9vmoVXbcR5CX7b6NC
	 WVK2rdBLSJQktpnXtZ7R7m9e4tdNyiNa9eavZ1C/SYCwT7lXr5olh8JMHiy5sgEgEc
	 NYYGgyPJo6J2Q==
Date: Thu, 06 Feb 2025 14:50:30 -0800
Subject: [PATCH 03/27] libfrog: enable scrubbing of the realtime rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088141.2741033.7748289284781442379.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a new entry so that we can scrub the rtrmapbt and its metadata
directory tree path too.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/scrub.c |   10 ++++++++++
 scrub/repair.c  |    1 +
 2 files changed, 11 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 129f592e108ae1..11d467666d6b5a 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -164,6 +164,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "realtime group superblock",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_TYPE_RTRMAPBT] = {
+		.name	= "rtrmapbt",
+		.descr	= "realtime reverse mapping btree",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
@@ -207,6 +212,11 @@ const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
 		.descr	= "project quota file",
 		.group	= XFROG_SCRUB_GROUP_FS,
 	},
+	[XFS_SCRUB_METAPATH_RTRMAPBT] = {
+		.name	= "rtrmapbt",
+		.descr	= "rtgroup rmap btree",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/scrub/repair.c b/scrub/repair.c
index c8cdb98de5457b..e6906cbd37d0b3 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -533,6 +533,7 @@ repair_item_difficulty(
 
 		switch (scrub_type) {
 		case XFS_SCRUB_TYPE_RMAPBT:
+		case XFS_SCRUB_TYPE_RTRMAPBT:
 			ret |= REPAIR_DIFFICULTY_SECONDARY;
 			break;
 		case XFS_SCRUB_TYPE_SB:

