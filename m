Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB83A951
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295002; cv=none; b=ncVtyojCDQWumFRJM/7GP6UO1Zquip0yOtpZQtOFA5hOqnTfwFaqHaB4zksWSrFYxNfZiT2iBbuve4D/mpe0RtV7HrRGIjIjC+pCNOETwc2kUx85S1wlFRA4KHETWc9k9Ft69l1u9MkNPLJWX6Vs5RA6HQc2rUROo4aYZvgztTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295002; c=relaxed/simple;
	bh=j+TxrkHsBUaK3YnAm3ejQUNPa9VBFzrpfsfwi0/u0BI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QLg8tgTc/I4vB7P0VYjlduFqDJigo8oEfuOcYOibBwec3imTfRYLkHRdpC4ieLHck1uXm5U1MZyJh9v+wWebJDJZJffIeaqi4QoldHrZc+Ph67JClsTeLNHSw1lSQZmfS2rm45x4rTV2kj3ftQ88zHknZW1YJ4pX2pvF2rTbJbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCWqaiQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCWqaiQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3300C433C7;
	Wed, 13 Mar 2024 01:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295001;
	bh=j+TxrkHsBUaK3YnAm3ejQUNPa9VBFzrpfsfwi0/u0BI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cCWqaiQMGZL8OmwLIGRK8TOUipgd+P0juViz50uzyLkTs+fw9QsEqY+wtsBgIR7xM
	 lnsUPzDz9jDExt6gVAEeF/1K643eTop+BNSQLDdV4XfspMTef0NzVrBWe2qG+G0FQ/
	 +aF5dUSRzA6ClJ7cw1/OJghvE5huqCcHGJJX1WmUkDykbfMB2fO6VguECDh5wuzO31
	 BsvbNVYEyhB1vnGD37NiSLnHACi/MhMHi+Kr2mAYbjgGYKU75f87qezUPnrTSIMoHF
	 xBqdaFgTrrwAy0IYhjrHhkqBK0ftQJws9MyFEBJ/I81jPIXJ1ZR0aTy11qugRuM5tb
	 NFCY/udciTAIw==
Date: Tue, 12 Mar 2024 18:56:41 -0700
Subject: [PATCH 14/67] xfs: elide ->create_done calls for unlogged deferred
 work
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431396.2061787.11287740887349817242.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9c07bca793b4ff9f0b7871e2a928a1b28b8fa4e3

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
 libxfs/xfs_defer.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 29ec0bd8138c..722ff6a77260 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -195,6 +195,10 @@ xfs_defer_create_done(
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 	struct xfs_log_item		*lip;
 
+	/* If there is no log intent item, there can be no log done item. */
+	if (!dfp->dfp_intent)
+		return;
+
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:

