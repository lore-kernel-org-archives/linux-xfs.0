Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A529B1C06
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713229333; cv=none; b=IzvCMrLLmHK9+S7kWFZvP4saTj7ybqGLPLorix2/pdAlG68mc1uGT2hhfl1L47s0cDvP48hhue5c+E5AFSOmgBZxMs9YbcYzawkiP1S8ace4WKF8A320/NsFqcSkRY9SVKG+PEIMpxS9czndCTPALlhpOjqv0bPSd2WTBGETwnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713229333; c=relaxed/simple;
	bh=zou1A9NV7RwEqQlnZek6n9QFWNshxUr8pw9xIe13FRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1qDo1J5CB2iG7S7OLxVwumhiVsc+qXn0460gJmyXYO5BQnvaKQfj/24UPrSNsJMubQ06PAF/NG0sIaKiS9AJP5PWi4acN2MBzcIxuDRk6KbguEAsAqCFfzZUiYoN9GByyGgDAFzIdGe87gidncWeR6Ul2B7NYLnDCO1va0Jihw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bc+7KGkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bc+7KGkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F67C113CC;
	Tue, 16 Apr 2024 01:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713229333;
	bh=zou1A9NV7RwEqQlnZek6n9QFWNshxUr8pw9xIe13FRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bc+7KGkhOcvhINSHVO4W8ORH73Tz3OcDoqDcWcc4axcmD3hMFYDOauNPlk7VZngEM
	 JbyEwqFKJopBXy24krm+RaXzmzqTu43SF4V3ED7ibUSBvIiMU7513N1lzUfxWTRUoD
	 xg6+SpdkEN8aZMhWXjhYIU2KCb5zMHekDoqi67Hh496h3hQgbOc7JXYTgi3js+tVd+
	 qEE/9soOYIOnBP04qHgMMqWmpqbvSL6AxY4RQYDlNzM66+0ue6nsR4N67dzgSe6t0k
	 4NQ1vi18Ao1BgKfbpvoh6HV1gXqt/umjBbdURJ/eGWbR/iE7wPf88AHSbMtqdjLRws
	 Ft26tAsqocBew==
Date: Mon, 15 Apr 2024 18:02:13 -0700
Subject: [PATCH 4/4] libxfs: add a xattr_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org
Message-ID: <171322884149.214718.12923043891090426855.stgit@frogsfrogsfrogs>
In-Reply-To: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
References: <171322884095.214718.11929947909688882584.stgit@frogsfrogsfrogs>
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
index 36811c7fece1..fdb922f08c39 100644
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
 

