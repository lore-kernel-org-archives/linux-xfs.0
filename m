Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2167CC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khQrxf9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C0AC433C8;
	Sun, 31 Dec 2023 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061498;
	bh=ZaGmaYL+1Ga8Adlgmzx2Tg6tHo1perom219mZMQAWYM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=khQrxf9WjAxS4S5tLSxaUwdlL6Qy50vLi1TdWNPnUJ4BrDfPL2jmqj2Plp+aN4GI6
	 KZHR0eSShcs1mL48AARNxqjmjbHfYte0NxtPij/4T6EqhoVnAssqzFn3REcJDFRoG5
	 1+FCLY99MGwiICnJOdAMbbC2cTgYJ2aCS1kX9OqBhyk81b2dDFo7WVg+h2WmiCUEom
	 SFZ+8IPcpkeOy1SSBwm095eDGPId54fEmanOiZ9awEzPC29aS7/w9/WhJS+rCszhyV
	 PB37ABxo+/uCCn0Vp2LHs+92zDI5mXm2AHinoG+ajGPqrQQqcWRgBLZSkAILow9AW/
	 byaoj+s8D1NFg==
Date: Sun, 31 Dec 2023 14:24:58 -0800
Subject: [PATCH 5/5] xfs: add a xattr_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994887.1795600.5522642082995268669.stgit@frogsfrogsfrogs>
In-Reply-To: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
References: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the attr_intent
item structure and use it so shorten assignments and avoid the need for
extra local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index c9502d30860..e9875f3e208 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -570,6 +570,13 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.cancel_item	= xfs_bmap_update_cancel_item,
 };
 
+/* Logged extended attributes */
+
+static inline struct xfs_attr_intent *attri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_attr_intent, xattri_list);
+}
+
 /* Get an ATTRI. */
 static struct xfs_log_item *
 xfs_attr_create_intent(
@@ -618,11 +625,10 @@ xfs_attr_finish_item(
 	struct list_head	*item,
 	struct xfs_btree_cur	**state)
 {
-	struct xfs_attr_intent	*attr;
-	int			error;
+	struct xfs_attr_intent	*attr = attri_entry(item);
 	struct xfs_da_args	*args;
+	int			error;
 
-	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	args = attr->xattri_da_args;
 
 	/*
@@ -651,9 +657,8 @@ static void
 xfs_attr_cancel_item(
 	struct list_head	*item)
 {
-	struct xfs_attr_intent	*attr;
+	struct xfs_attr_intent	*attr = attri_entry(item);
 
-	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	xfs_attr_free_item(attr);
 }
 

