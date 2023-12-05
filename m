Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8A0D263
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agOep7dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BFFBC433C8;
	Tue,  5 Dec 2023 05:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701754574;
	bh=RJrj7RgyCzinIBtJEaW4w9g7rNHnFQ50xaPMEeBiqc8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=agOep7dh3xDjJ1SKe4HEeBc62qGzoKMofXGhrZ8waDKd95sZWiCPD1Eb5f50Vqyh8
	 +axA2acNNAx+zSmix59PRrAqwfkKdPIjbviWS+Z/ZKAKE0YQtw1xPgsZ0qjAvxvVwy
	 14R0U05H8AV9Ir7B5WI812eqaKUlTaVbTNvfPhs6dfMLcagJwl/WP0WVKi5xu9Ibg+
	 YUSNRimxPlpUmqf/tQMeFEaQ/AXXfq2XH4Z99JLFX2yg/YAOAbK2kf12pdIBYFvdYl
	 N5OlUlIPhVo5aRDBhaE0l9PEVLCjrmcSGgMBqQwfOgwOuA7SZqfgCUaNuQ7VyXGY5s
	 fzzT+5wrcLcOA==
Subject: [PATCH 2/2] xfs: elide ->create_done calls for unlogged deferred work
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Date: Mon, 04 Dec 2023 21:36:13 -0800
Message-ID: <170175457355.3910588.11459425968388525930.stgit@frogsfrogsfrogs>
In-Reply-To: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs>
References: <170175456196.3910588.9712198406317844529.stgit@frogsfrogsfrogs>
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

Extended attribute updates use the deferred work machinery to manage
state across a chain of smaller transactions.  All previous deferred
work users have employed log intent items and log done items to manage
restarting of interrupted operations, which means that ->create_intent
sets dfp_intent to a log intent item and ->create_done uses that item to
create a log intent done item.

However, xattrs have used the INCOMPLETE flag to deal with the lack of
recovery support for an interrupted transaction chain.  Log items are
optional if the xattr update caller didn't set XFS_DA_OP_LOGGED to
require a restartable sequence.

In other words, ->create_intent can return NULL to say that there's no
log intent item.  If that's the case, no log intent done item should be
created.  Clean up xfs_defer_create_done not to do this, so that the
->create_done functions don't have to check for non-null dfp_intent
themselves.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |    4 ++++
 fs/xfs/xfs_attr_item.c    |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 54a6be06e6cd..06e890b44c52 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -201,6 +201,10 @@ xfs_defer_create_done(
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct xfs_log_item		*lip;
 
+	/* If there is no log intent item, there can be no log done item. */
+	if (!dfp->dfp_intent)
+		return;
+
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 53d34f689173..e5bcb16b88f4 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -737,9 +737,6 @@ xfs_attr_create_done(
 	struct xfs_attri_log_item	*attrip;
 	struct xfs_attrd_log_item	*attrdp;
 
-	if (!intent)
-		return NULL;
-
 	attrip = ATTRI_ITEM(intent);
 
 	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);

