Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308A319ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528067; cv=none; b=HOvv5lusnBD8uVignm+bPmtsmRlOiSXNgD3la2kwKnJb7C5IFxD3RS8PhbvTUeTnWlIxsws3yfF6gAcQknjnTKeNFZBu1DsocQ/8n3VeZer7ikGyhjhhaBelNiVp3Ca/VbBTVVQH2hgRI7jROarGVPZU4t6J1Vz8MXwurfcMJbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528067; c=relaxed/simple;
	bh=LW2P5VN7FXCh2ZwtvU1Yo/7u8S76LEE/hbhWgoMVBfA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qUIdWaYD3YoK6VrqVjRdVxhr7IbE1KzhswEbkB9y7mQL8sQFyQphkUtE3rE+MKTQsbVxHc6cFBpmtSHtbAQd2p59nkYdHRSHihpUy3Te1xXit/j7bIfSZWrILpQzcrTbZwziqhACYh15BKIkEkiHHcYgxZSwjinldszfaAnhpzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YIx+/vip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIx+/vip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4377C4CED1;
	Fri,  6 Dec 2024 23:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528066;
	bh=LW2P5VN7FXCh2ZwtvU1Yo/7u8S76LEE/hbhWgoMVBfA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YIx+/vipgnN5nIJnikGG93OsPZW4j3fuS3fQJwqycEO75EHCiqbucepAJj9cEcAOZ
	 guDHuz2eUwHCR1eiamfnV+28DAW4K4vGUfFSfqkifFE+AWKTuZ4Z+u1U9WFXt+6LJO
	 UtD8EAcIkT9FhbHrQwX9DwTRmfg/IRzIDVzWWW+1kkaCFESfTyVMep9whdJCrGRjLi
	 7cAQlaI3A6pbaBFu1lwKS7nH3Pzj5qQ2aMzbcwIQCQXCez4/7FvTAcqn1Ixfwru/n4
	 0fkzlahTzonoMz6CKVnCjwpUVdkVzGm5eaqLMbRzlN50crpIZfTyOF1JXt9dH46abc
	 +7TJJuSiLcc5A==
Date: Fri, 06 Dec 2024 15:34:26 -0800
Subject: [PATCH 16/36] xfs: add a xfs_group_next_range helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747123.121772.4416461135513997240.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
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

