Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F2CC2C6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299402; cv=none; b=Q+/rbcFXWLrbqX/b7Y/zKjzJeTFPU1xHLfO8wVHlSnEPOW5Wy2X+nz3lBkU9sJKIfoZBWhVJFXcp1iWmjnS1Vu8P35i/G9XTxmp3Hu6iGlshI+sZlxkcLfP7a5+CzIeVFxfuPlb6s8WSKPOuAamm8lQsi8GkdpVRTx9L6S2P74E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299402; c=relaxed/simple;
	bh=tfbpyHP6Ify91BDRWZYkb9DKk3NMNTL7sy+UkveQvFY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fPGC0xB8qNruu1A7Jk1uM08rdd4fSLyP9GvRvuWIYAFXBR/9ihxaQPTqeZmbsXFpdQudZBB6xFJ7BHAYlTTG6vRaUrYdNg4WY1ZiR9Y0ocNf+0pybp6i+ASK9t8I5O2JCf39bkJ2qeJJj0niIVkVS0MZ4GwPrCYwKjhMwToVit0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHDd3PnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHDd3PnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F92FC32786;
	Tue, 30 Jul 2024 00:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299402;
	bh=tfbpyHP6Ify91BDRWZYkb9DKk3NMNTL7sy+UkveQvFY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dHDd3PnD0jGBmGiWUhAmHPAYIt1bKzB27FL2ulKeL+fRvMFm3HHP5RnbEJX+o6Bry
	 xnOfi1JZdBS5H2X8i8fYEmpLkTkIhaW28n79xcsZplFqyKaKnaSSB4dbsrnidIAIh7
	 +KBCLxT95w/yHDHMNIq+CkjiKs+mjBbA0gaxTPrXmrh+sH7FaCpZF4dF+y/51KpUQs
	 iR7Ifk/YXGJOqWHrJblI0JZiZ/ADpgQ5El7O/mJ61RXZDz+jiX9YG6H/ZvwqYg4V3k
	 d0u8WTlf6Y5DoYYPi2IvM79HlmhRT6B/FULJLLWowUnVCEIuBhgDejsiM5kEumpaDb
	 9+WhNiMtSlJFg==
Date: Mon, 29 Jul 2024 17:30:02 -0700
Subject: [PATCH 024/115] xfs: repair extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842782.1338752.9798387885491587085.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e47dcf113ae348678143cc935a1183059c02c9ad

If the extended attributes look bad, try to sift through the rubble to
find whatever keys/values we can, stage a new attribute structure in a
temporary file and use the atomic extent swapping mechanism to commit
the results in bulk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c      |    2 +-
 libxfs/xfs_attr.h      |    2 ++
 libxfs/xfs_da_format.h |    5 +++++
 3 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index cc291cf76..07f873927 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1053,7 +1053,7 @@ xfs_attr_set(
  * External routines when attribute list is inside the inode
  *========================================================================*/
 
-static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
+int xfs_attr_sf_totsize(struct xfs_inode *dp)
 {
 	struct xfs_attr_sf_hdr *sf = dp->i_af.if_data;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 81be9b3e4..e4f550085 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -618,4 +618,6 @@ extern struct kmem_cache *xfs_attr_intent_cache;
 int __init xfs_attr_intent_init_cache(void);
 void xfs_attr_intent_destroy_cache(void);
 
+int xfs_attr_sf_totsize(struct xfs_inode *dp);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 060e5c96b..aac3fe039 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -721,6 +721,11 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
 
+#define XFS_ATTR_NAMESPACE_STR \
+	{ XFS_ATTR_LOCAL,	"local" }, \
+	{ XFS_ATTR_ROOT,	"root" }, \
+	{ XFS_ATTR_SECURE,	"secure" }
+
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
  * there can be only one alignment value)

