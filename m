Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877BF1845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhsrXKaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58497C433C8;
	Thu,  7 Dec 2023 02:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916129;
	bh=Bemw4zoL8SOlvH5z5OcigV7kHwIU9sbq8NnuAP0B2SA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lhsrXKaqScAM19juSmwTm4v8PbhcWn6aa5Y23JCvE+NaFZWa7ljX4RdgIkVsU1cFi
	 ueGHhXr3GhdHuvFj9zjXEb+b8yHryCffFdRJ7bKWG+YQ6L+L7SIpFMmWT+MwHH9mLC
	 YMqXMdXOqjoqXKRIZ64GoGv2PqnxxCr5q72MFT1r0c0ZYsNWm148myHGEj0l76l3x1
	 PeE9ExaHU1/J7p2rS4mzXMYaO8Ch1uUoNZykF4THSwzpoIi8F9TyVEEAC/m26Idyk5
	 w8rGURrKABMONrJJ8XeSx7TKkTMsjkG9wsCtGTcv0uGEv3fizkc9gtdIzIHiAOZMge
	 mvOQmFFmxfg0g==
Date: Wed, 06 Dec 2023 18:28:48 -0800
Subject: [PATCH 2/2] xfs: elide ->create_done calls for unlogged deferred work
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191563309.1133791.5522737407197572289.stgit@frogsfrogsfrogs>
In-Reply-To: <170191563274.1133791.13463182603929465584.stgit@frogsfrogsfrogs>
References: <170191563274.1133791.13463182603929465584.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 988d395a48ad..39f2c5a46179 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -740,9 +740,6 @@ xfs_attr_create_done(
 	struct xfs_attri_log_item	*attrip;
 	struct xfs_attrd_log_item	*attrdp;
 
-	if (!intent)
-		return NULL;
-
 	attrip = ATTRI_ITEM(intent);
 
 	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);

