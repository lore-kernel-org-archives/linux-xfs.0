Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9518C128381
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424096; cv=none; b=EGJg4508V6L+hXrE4O6TF1yR/gV+hyLsDFXV95FtKByOp4TdtquY4n3MThAYA6xOYEZhmuGCjHSC/OoFg96OK1fxOICPRTEqByRwKe6olSPtWHdZM1nslClQpxrtv914LplTKnOVH0XCp1ErLbHfj54MohVpLJTy1OJ8xTkyCOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424096; c=relaxed/simple;
	bh=H6xJOpitjV2Ivr09TYBaPrjBy6PLZYYuguuk1c91wj8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJ+E7y5MRY8x9AXIEo0i2mGnIwNn9znDiO3FZmsbqI2eowK84CVfrFD2sTvO2tAjdfUiGGA2LDZLv9lP2yBB3U5Ee/e3E/NHUSbF96kC07d3/AJ7xZmeaOAKjzIOddWjswNZTttpUP2fa8QRvlkHwHCaASaglhnqbQws9iE2nZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/pAK5oq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/pAK5oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65780C433F1;
	Tue, 26 Mar 2024 03:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424096;
	bh=H6xJOpitjV2Ivr09TYBaPrjBy6PLZYYuguuk1c91wj8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=O/pAK5oqtWMFS+5DkGjpo/C5BY0UV+lxS0InqtGpCX8ExuyV3PIiSmQWyp0U2pP5H
	 0RUAVpP5C7sIOPTvVMsuJXkDB8l4LYwZeNMmdiLyBPzpYpe3HxKDvmtEutqUaDXl4l
	 qvNq+4SkDuOv8IGLs7YH0wbvo/1+flRk4gE7mpUJ7roZ94YJs1wyg6y+3wmAL4+elp
	 ux6st5lI/7yFai8JiwGHaBpcE5gdwcqxQ93OKvbdAX79rgPdU6S73gXn+FevLkNccP
	 rMXOMnZ2KBoU7cxNYBawuZOS3oIW9l2mDXIckzbqa37iO4bCvJx+c6HKcsHOWe3bpv
	 Gl37pmTXSbGDA==
Date: Mon, 25 Mar 2024 20:34:55 -0700
Subject: [PATCH 025/110] xfs: add secondary and indirect classes to the health
 tracking system
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131745.2215168.6948451677460307098.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4e587917ee1cc28ac3a04cd55937419b9e65d81d

Establish two more classes of health tracking bits:

* Indirect problems, which suggest problems in other health domains
that we weren't able to preserve.

* Secondary problems, which track state that's related to primary
evidence of health problems; and

The first class we'll use in an upcoming patch to record in the AG
health status the fact that we ran out of memory and had to inactivate
an inode with defective metadata.  The second class we use to indicate
that repair knows that an inode is bad and we need to fix it later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_health.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index ff98c03212b8..032d45fcbd51 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -31,6 +31,19 @@
  *  - !checked && sick  => errors have been observed during normal operation,
  *                         but the metadata has not been checked thoroughly
  *  - !checked && !sick => has not been examined since mount
+ *
+ * Evidence of health problems can be sorted into three basic categories:
+ *
+ * a) Primary evidence, which signals that something is defective within the
+ *    general grouping of metadata.
+ *
+ * b) Secondary evidence, which are side effects of primary problem but are
+ *    not themselves problems.  These can be forgotten when the primary
+ *    health problems are addressed.
+ *
+ * c) Indirect evidence, which points to something being wrong in another
+ *    group, but we had to release resources and this is all that's left of
+ *    that state.
  */
 
 struct xfs_mount;
@@ -115,6 +128,36 @@ struct xfs_da_args;
 				 XFS_SICK_INO_DIR_ZAPPED | \
 				 XFS_SICK_INO_SYMLINK_ZAPPED)
 
+/* Secondary state related to (but not primary evidence of) health problems. */
+#define XFS_SICK_FS_SECONDARY	(0)
+#define XFS_SICK_RT_SECONDARY	(0)
+#define XFS_SICK_AG_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(0)
+
+/* Evidence of health problems elsewhere. */
+#define XFS_SICK_FS_INDIRECT	(0)
+#define XFS_SICK_RT_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_INO_INDIRECT	(0)
+
+/* All health masks. */
+#define XFS_SICK_FS_ALL	(XFS_SICK_FS_PRIMARY | \
+				 XFS_SICK_FS_SECONDARY | \
+				 XFS_SICK_FS_INDIRECT)
+
+#define XFS_SICK_RT_ALL	(XFS_SICK_RT_PRIMARY | \
+				 XFS_SICK_RT_SECONDARY | \
+				 XFS_SICK_RT_INDIRECT)
+
+#define XFS_SICK_AG_ALL	(XFS_SICK_AG_PRIMARY | \
+				 XFS_SICK_AG_SECONDARY | \
+				 XFS_SICK_AG_INDIRECT)
+
+#define XFS_SICK_INO_ALL	(XFS_SICK_INO_PRIMARY | \
+				 XFS_SICK_INO_SECONDARY | \
+				 XFS_SICK_INO_INDIRECT | \
+				 XFS_SICK_INO_ZAPPED)
+
 /*
  * These functions must be provided by the xfs implementation.  Function
  * behavior with respect to the first argument should be as follows:

