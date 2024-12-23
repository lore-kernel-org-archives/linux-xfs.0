Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448E218052
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990078; cv=none; b=mABqpgMleJZn61vRBueuVokY5SYZXczZeeKmn7de+uBViaJO8JqnZW3k/Evz+JBxpDMtvJdypqMs0OkPEUVnv/XefXZjDn86KKV2dhLzLBtxWE/ZzUOZWxWpRw7McYk0KV01Zw1miqTln49KgPp0CEDWj8550IKAEOPM9GQ69J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990078; c=relaxed/simple;
	bh=+Zz/NXzkIN7ajYVouiv0ruG4AwetK7xTkqG/Ddykk1Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hu14dvNKp95zd8t+VZZljTmGyCdtW2SjSwQJ9fnB0A90CsDCEDIXjsIyQ7pcHCn7c5HVFjQWFwFSmq3G8ZDmCj4m4UfD8DI4Eq9PxHZWBWkl54jSToBCZJV1+chvkHQFz+KRKnKLS6RZnrrVUsUg4XPWZXumpNTCNCGEFoXv69Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WB7GyTzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WB7GyTzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CD2C4CED3;
	Mon, 23 Dec 2024 21:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990078;
	bh=+Zz/NXzkIN7ajYVouiv0ruG4AwetK7xTkqG/Ddykk1Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WB7GyTzMt12UBTn6MiYdqJibtlg0UinZNpUbKudI2Sn3gkPzzzji2Tlzb/HFMFe6g
	 GoyrbRiJidVMjC5q00wZEoZtdWR/AGnsOx8LK3HwcVNlFgY+cDk9X6dyHG637e2czo
	 a33VYuuCIpBBqKFPLmcOj6z+j6JImNDhsp91hLsh8S7SaTKLu9HcltyJ8GQCpZdwH+
	 pUUW/pvOcLTwofyf4PYvzofsy0L7yJRYxvsiE0lXp95QEhu9hi207a4yCB6Hg6oEPL
	 2X8Xmj+CVISxXdTQhZoAzx6x3xeXoOMQwm+vZYEJLfC07QSE3FBqpJ2NX9pxJBKAgm
	 RArrOaTMqk5UQ==
Date: Mon, 23 Dec 2024 13:41:17 -0800
Subject: [PATCH 16/36] xfs: add a xfs_group_next_range helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940189.2293042.12796489335865903644.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 819928770bd91960f88f5a4dfa21b35a1bade61b

Add a helper to iterate over iterate over all groups, which can be used
as a simple while loop:

struct xfs_group                *xg = NULL;

while ((xg = xfs_group_next_range(mp, xg, 0, MAX_GROUP))) {
...
}

This will be wrapped by the realtime group code first, and eventually
replace the for_each_rtgroup_from and for_each_rtgroup_range helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_group.c |   26 ++++++++++++++++++++++++++
 libxfs/xfs_group.h |    3 +++
 2 files changed, 29 insertions(+)


diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index 8a67148362b0d7..04d65033b75eca 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -86,6 +86,32 @@ xfs_group_grab(
 	return xg;
 }
 
+/*
+ * Iterate to the next group.  To start the iteration at @start_index, a %NULL
+ * @xg is passed, else the previous group returned from this function.  The
+ * caller should break out of the loop when this returns %NULL.  If the caller
+ * wants to break out of a loop that did not finish it needs to release the
+ * active reference to @xg using xfs_group_rele() itself.
+ */
+struct xfs_group *
+xfs_group_next_range(
+	struct xfs_mount	*mp,
+	struct xfs_group	*xg,
+	uint32_t		start_index,
+	uint32_t		end_index,
+	enum xfs_group_type	type)
+{
+	uint32_t		index = start_index;
+
+	if (xg) {
+		index = xg->xg_gno + 1;
+		xfs_group_rele(xg);
+	}
+	if (index > end_index)
+		return NULL;
+	return xfs_group_grab(mp, index, type);
+}
+
 /*
  * Find the next group after @xg, or the first group if @xg is NULL.
  */
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index e3b6be7ff9e802..dd7da90443054b 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
@@ -20,6 +20,9 @@ void xfs_group_put(struct xfs_group *xg);
 
 struct xfs_group *xfs_group_grab(struct xfs_mount *mp, uint32_t index,
 		enum xfs_group_type type);
+struct xfs_group *xfs_group_next_range(struct xfs_mount *mp,
+		struct xfs_group *xg, uint32_t start_index, uint32_t end_index,
+		enum xfs_group_type type);
 struct xfs_group *xfs_group_grab_next_mark(struct xfs_mount *mp,
 		struct xfs_group *xg, xa_mark_t mark, enum xfs_group_type type);
 void xfs_group_rele(struct xfs_group *xg);

