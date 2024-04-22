Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794E215383C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803969; cv=none; b=a+i6/XyXH1obfx3U9BR9jEyPv+er3Mdkrk2pzC4SxQp+sa/oPPCCVohqCP9vrnM3cCfmEPTCeIMoOCW5lZPKJ7ao7pZdw7dQMwCN5AuS/kX+KDT7Y++eQ4gulyiXwa83IFYsvogx9OeJLU22VNJc2JzaY2yQj0qNM6cyDvwWvck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803969; c=relaxed/simple;
	bh=xuG2F8nmPDhPdSLuNWWFFycgkf8rqnwpQ0kQBe7Aj3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ews5VhWJg9G0t0gfWZn+qIgD2jX5cS3sagHqLrCfl7bti7ltBMLnVL0/74qDnfsY1TIURRS3xzUwWxSrX03V3dyp64oixElrzjA/IQWMwctfvLmw5JeUmftt+1LjHZTvlfNI5Mz/1G5S4PC106etJSVXrmuEn5xGZlSkiz3D53Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZ2/O5M4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZ2/O5M4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B013C32783;
	Mon, 22 Apr 2024 16:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803969;
	bh=xuG2F8nmPDhPdSLuNWWFFycgkf8rqnwpQ0kQBe7Aj3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZ2/O5M4/u3dsCdRjdg5NS6gWv8JYoDKsk7hk/L3cur0k4VPKw2Hg1GnR3gbvxuG0
	 lyrzmxQAoShpAt/r+hIbWkZ5Dix2iJ8RGo0Q3nbWWV3eXzuMDA127p6YhzkmPtPDXE
	 /LyEwu8Roj5fBytFSSbP9F1knKLIzdn4TXNGgquej+lUsfjI1zP2IuBuTjTHr3xH5+
	 gCl2pYlrk6xxTpFhCEyY2pjTAEAtPROP39cxujIZ2LcxXyxWcHZ85NFlCd8h9mme9o
	 e7ayFCUHI/cuf8/QOGX/vqeelip0FhyASoghSWo+Si3VbaXbcoXaWRevBT4BjGfHf5
	 XKVio3Yc0lmkA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 14/67] xfs: elide ->create_done calls for unlogged deferred work
Date: Mon, 22 Apr 2024 18:25:36 +0200
Message-ID: <20240422163832.858420-16-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

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
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 29ec0bd81..722ff6a77 100644
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
-- 
2.44.0

