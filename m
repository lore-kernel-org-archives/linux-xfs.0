Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DF9282E5
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347989; cv=none; b=as7a4wXi/nEjKMEaIFnK3y9T48z1aV7PlhzksbOiAideTAbxLvsfcjbnME8k73IlNnGUNsPfEfSJg3bOMhcvh+vmN8hoxARSXqeb+qmrcaFE7f7so3hEoGf9Dj6h5jSWaRZls0k9xHqS0fwrlhVmSCTOLDqKnCUkfTH/K3x1sNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347989; c=relaxed/simple;
	bh=b0ziBavsADgckRsPanyNVv3w3P6l9IYxtTBJjiIgOeE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=egical/4hCc3VAZiMgVhESZ3VEZ21XjPA1kLzdJ/cJmo5oxKEoYlg6hb9BmYhMQ2DwfivtCKBHtggqxIxoytnnEjDnZHCdLmphS2qLq2cqvjhay98G9rWXSGL732zzyoEuV3/o7St+xIFCskcrMqENTLDl9AHkViWXqqq/Yz1xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyJ4O+ES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyJ4O+ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49046C2BD11;
	Wed, 22 May 2024 03:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347989;
	bh=b0ziBavsADgckRsPanyNVv3w3P6l9IYxtTBJjiIgOeE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oyJ4O+ESGpGETlM9cNsDIwowstPSoixAGfW7FKobropNNKRDmBxsyBt3fMc7ClF1M
	 /knuifF8xarrNnmS2U1Ot7PisGPkUCPInUz02JexD3HnS8xTEYHVFpZURB/QZ76NzH
	 45/rN6vu1y8uQaoBhTon1d2lvd/AqYMXT6PF1hTaaMjBSMy5/opK9BtQIl3DoIUun3
	 qEn5RDZcXTXdRFCJEfVvK9i3eVRizv2CMVe8kEuM9tsrvnopXVaM2QCpIm2i/83l14
	 Y/uZCXZ0EaTbevZv6brpGQ7EXjepLVPjwTX6oytRM5WQAOBXSlzAwqaVfF63rL/8mw
	 iPF2VHr77Ba+w==
Date: Tue, 21 May 2024 20:19:48 -0700
Subject: [PATCH 1/5] xfs_scrub: implement live quotacheck inode scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634534729.2482960.3779611153495120282.stgit@frogsfrogsfrogs>
In-Reply-To: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
References: <171634534709.2482960.7052575979502113240.stgit@frogsfrogsfrogs>
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

Teach xfs_scrub to check quota resource usage counters when checking a
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/scrub.c |    5 +++++
 scrub/phase4.c  |   17 +++++++++++++++++
 scrub/repair.c  |    3 +++
 scrub/scrub.c   |    9 +++++++++
 scrub/scrub.h   |    1 +
 5 files changed, 35 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 5a5f522a4..53c47bc2b 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -134,6 +134,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "filesystem summary counters",
 		.group	= XFROG_SCRUB_GROUP_SUMMARY,
 	},
+	[XFS_SCRUB_TYPE_QUOTACHECK] = {
+		.name	= "quotacheck",
+		.descr	= "quota counters",
+		.group	= XFROG_SCRUB_GROUP_ISCAN,
+	},
 };
 
 /* Invoke the scrub ioctl.  Returns zero or negative error code. */
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 5dfc3856b..8807f147a 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -128,6 +128,7 @@ int
 phase4_func(
 	struct scrub_ctx	*ctx)
 {
+	struct xfs_fsop_geom	fsgeom;
 	int			ret;
 
 	if (!have_action_items(ctx))
@@ -143,6 +144,22 @@ phase4_func(
 	if (ret)
 		return ret;
 
+	/*
+	 * Repair possibly bad quota counts before starting other repairs,
+	 * because wildly incorrect quota counts can cause shutdowns.
+	 * Quotacheck scans all inodes, so we only want to do it if we know
+	 * it's sick.
+	 */
+	ret = xfrog_geometry(ctx->mnt.fd, &fsgeom);
+	if (ret)
+		return ret;
+
+	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
+		ret = scrub_quotacheck(ctx, &ctx->action_lists[0]);
+		if (ret)
+			return ret;
+	}
+
 	ret = repair_everything(ctx);
 	if (ret)
 		return ret;
diff --git a/scrub/repair.c b/scrub/repair.c
index 65b6dd895..3cb7224f7 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -84,6 +84,9 @@ xfs_action_item_priority(
 	case XFS_SCRUB_TYPE_GQUOTA:
 	case XFS_SCRUB_TYPE_PQUOTA:
 		return PRIO(aitem, XFS_SCRUB_TYPE_UQUOTA);
+	case XFS_SCRUB_TYPE_QUOTACHECK:
+		/* This should always go after [UGP]QUOTA no matter what. */
+		return PRIO(aitem, aitem->type);
 	case XFS_SCRUB_TYPE_FSCOUNTERS:
 		/* This should always go after AG headers no matter what. */
 		return PRIO(aitem, INT_MAX);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 023cc2c2c..a22633a81 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -440,6 +440,15 @@ scrub_fs_counters(
 	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
 }
 
+/* Scrub /only/ the quota counters. */
+int
+scrub_quotacheck(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0, alist);
+}
+
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 0033fe7ed..927f86de9 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -27,6 +27,7 @@ int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

