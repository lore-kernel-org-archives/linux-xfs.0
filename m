Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B49184E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299887; cv=none; b=UOd+a1HoZn+E4ADwcVlssgVYJWny1IWMkyYZq1kSnOaMZsM0fphFrmDWGXdKfOk74g2/dskc0C3PGiKX3/rZ4Zenh1YUna1PN1XLnpbQDk/1V59d+Ikg2dIuRrDTljxpcsD24MasmYWFvgVt5GmLzFaLaJF8+dQ8LUGX9iHqTKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299887; c=relaxed/simple;
	bh=7So8USdXZMqNeGqjuaTWyEbBipxHe+YA2GVwoE1/cZk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a5T9QYPAtJQLOQaIFw4G4ayMRlfNysjwpxQtSP0bXPU/1D3MFuNp8M6hf+ok3wRx+zHtrre113IJ+UcdFFHETieRxxzSoz3sWJs5NhYLXrqpn6jqSPbE12aYwON4o6hr8mvqT4+chb4RcNFFrM8K7VyA5I9QZ/FHLNsQv98OThA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyhmR5Ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyhmR5Ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E29FC32786;
	Tue, 30 Jul 2024 00:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299887;
	bh=7So8USdXZMqNeGqjuaTWyEbBipxHe+YA2GVwoE1/cZk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YyhmR5ObisuXVU7lmhwa6XA/0QYDMJxFDfOokXwZ9S4EzGUdf9xm1893AFO82CTLJ
	 QJzwcD+MSRi3YIcp8fYUr38nvhJ5GuzzoDCe60LrBzqingJWJM+OYVHBOywrQ2Ke2w
	 IEvoD1RPY1mBOtqvBS6QPz4ziFeguGd7a0rzsmjWkbuy+lBQ2a1LR9ESyipi2opd5l
	 Ca2VfP3t+q/fAZo/zYQqPr34XNrHhNovH1QTZxlPCvTwoz9LJYBnUarz4tncMF2Ubm
	 pWSmSHb/S+mdl7AmLRU23Q6n5mn9oWT5sWF2B+hB2dbJkTPtbe1AW7+XzaUXKiF20B
	 3kOqQbyWfCMVg==
Date: Mon, 29 Jul 2024 17:38:07 -0700
Subject: [PATCH 055/115] xfs: add parent pointer support to attribute code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
 Dave Chinner <dchinner@redhat.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843217.1338752.13633317236906999474.stgit@frogsfrogsfrogs>
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

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 98493ff878859eb0adefbc57a49ad47a92dfd252

Add the new parent attribute type. XFS_ATTR_PARENT is used only for parent pointer
entries; it uses reserved blocks like XFS_ATTR_ROOT.

Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_format.h  |    9 +++++++--
 libxfs/xfs_log_format.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index ecd0616f5..0c80f7ab9 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -714,13 +714,17 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
+#define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
+#define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 
-#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
+#define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | \
+					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT)
 
 #define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
 				 XFS_ATTR_LOCAL | \
@@ -729,7 +733,8 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_NAMESPACE_STR \
 	{ XFS_ATTR_LOCAL,	"local" }, \
 	{ XFS_ATTR_ROOT,	"root" }, \
-	{ XFS_ATTR_SECURE,	"secure" }
+	{ XFS_ATTR_SECURE,	"secure" }, \
+	{ XFS_ATTR_PARENT,	"parent" }
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index accba2acd..020aebd10 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -1034,6 +1034,7 @@ struct xfs_icreate_log {
  */
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
+					 XFS_ATTR_PARENT | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*

