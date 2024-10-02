Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB68679CC
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831411; cv=none; b=tzp2o/E53egsGsP07mz+aNidCRbF3NpyDGg/scY5jOGrH7Q/d+tW9dHttFxQCOn4sMa41HoZSvpaTi+8/ssddhP1vCKmkVWY/hDiMou4MiFGC58mch6Wt/lALSCKpqC6zIsmBgPH+pe6sMoL3F5dl/8PVYjpRJiIv4YckKU84nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831411; c=relaxed/simple;
	bh=vWjL3NNsge296tHY4E4mjmN+eNGmOmDKmtQn9V89H7I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nc6mDhiuL9KuXqEM4zas16xzqhZWoOA1ejgRX/PpXYmTg57RK1wYyEvr/CH3Wj8wUMPjllfdYxRekpG+OnHvx2Gqc5I2BBuDpHhs6ZpNa7Pq52KV9xax4PsX61uQ7zKuN1TM1FqVBc03yJD6pDi5U6UtB/vGTfjbgC61oJ3cO5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IILoD1an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IILoD1an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B1FC4CEC6;
	Wed,  2 Oct 2024 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831411;
	bh=vWjL3NNsge296tHY4E4mjmN+eNGmOmDKmtQn9V89H7I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IILoD1an4ikLB0pUlaAFghpJm+wONzAXnEBN6jr9d7fEHDNxQgJBh09SC+DdueCWO
	 /gNt5189bKQIjFohcqlSwtNDG1KIToSn417QtqI00T2FKLzbxZZQ5Ub7lm9yl3Rb61
	 KeyOe/0ONNvOCpUSk+m99vu3+sG1VotZ3CDslfv6RB9gHq8utBEfGJR9OOI+TUlWXx
	 ssW+YQaxTWVXZocnH+p9GwEp1T0iRcsd+y2VOcBE9aRXIJkqWcLPf2wsL0tDx48JcQ
	 f+FpwATS+Y4Lz1emFDKUX7sApcI07Fzn6hUf/DItPhWPswc1BblHktEroWg/268BLf
	 VgM5/fr+CoLEg==
Date: Tue, 01 Oct 2024 18:10:11 -0700
Subject: [PATCH 09/64] xfs: pack icreate initialization parameters into a
 separate structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783101917.4036371.7421558791623452408.stgit@frogsfrogsfrogs>
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

Source kernel commit: ba4b39fe4c011078469dcd28f51447d75852d21c

Callers that want to create an inode currently pass all possible file
attribute values for the new inode into xfs_init_new_inode as ten
separate parameters.  This causes two code maintenance issues: first, we
have large multi-line call sites which programmers must read carefully
to make sure they did not accidentally invert a value.  Second, all
three file id parameters must be passed separately to the quota
functions; any discrepancy results in quota count errors.

Clean this up by creating a new icreate_args structure to hold all this
information, some helpers to initialize them properly, and make the
callers pass this structure through to the creation function, whose name
we shorten to xfs_icreate.  This eliminates the issues, enables us to
keep the inode init code in sync with userspace via libxfs, and is
needed for future metadata directory tree management.

(A subsequent cleanup will also fix the quota alloc calls.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_inode_util.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index f7e4d5a82..9226482fd 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -13,4 +13,26 @@ uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
 prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
 
+/*
+ * File creation context.
+ *
+ * Due to our only partial reliance on the VFS to propagate uid and gid values
+ * according to accepted Unix behaviors, callers must initialize idmap to the
+ * correct idmapping structure to get the correct inheritance behaviors when
+ * XFS_MOUNT_GRPID is set.
+ *
+ * To create files detached from the directory tree (e.g. quota inodes), set
+ * idmap to NULL.  To create a tree root, set pip to NULL.
+ */
+struct xfs_icreate_args {
+	struct mnt_idmap	*idmap;
+	struct xfs_inode	*pip;	/* parent inode or null */
+	dev_t			rdev;
+	umode_t			mode;
+
+#define XFS_ICREATE_TMPFILE	(1U << 0)  /* create an unlinked file */
+#define XFS_ICREATE_INIT_XATTRS	(1U << 1)  /* will set xattrs immediately */
+	uint16_t		flags;
+};
+
 #endif /* __XFS_INODE_UTIL_H__ */

