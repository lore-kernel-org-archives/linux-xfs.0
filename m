Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793175088;
	b=YVgKR9MVX1DA+fqtvAM+w6FHXloVhMqnjzIUJL6A1Ywg8NwH+go22p2XbPyVTcdTDm3k
	 GAvImGQwyNwvS7mIvvSC7KJV+JUini8nE1Acj3dhXPybbg8fnIOs7Wt+MShP90b/MKt0a
	 s0D5UCwb6AOQBtcXYa5IO2r20dNZ3jySwxZpVBzf/dbzwEP3MNmA3lL3RcHVLhy6R3vCr
	 p6u+Wz7NOARu+TNjiU+ZbreqTwcJy2zXpj5tBSOOf3SklLzZIymTclS0wY/djXUGQnGxT
	 x5zFzIiK928EanEBejxKr+kVrSt41dM6QJ0HvCUQ/qx/sKZrCTW8BqunH3uNCLrsXuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793175088;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-SRS-Rewrite;
	bh=CUeDFBLD4toxqqSrteXkNbxXZ3bppLVdS5Vd57c91C0=;
	b=w2EWouBnOypmwz7rZlJpc49RCYxr9A9omZ7HRZuU7R3Dmf+LqPeBgdJvq4OAX0qgP0+z
	 ybF1+eaqgh6eSmO80rEkfbxBOmtYDyOyVHkzA1fDP33TkHRFRcuwbVDga5VWi60s1vros
	 MJBVS0tRmYbiMbE7E3lehh+hl46cz+9rCVEJ7eAmfoIgT4p0GNHPl3KmUXAhWVB4uVJsr
	 QycCOolll10PWLesQQA6jxcBgv18YZy32tBhP/s+dw9w5J7Ta7o9sCI3wM/MJtMR0FrwW
	 B/jwzhh0Kiwci1xleoosPgcPZo6jTR7noPhXjmHI3jBYbUyw9SynD/ApGUPWjOsaOng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b="C6+/1vPF";
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D531606A31A
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 08:11:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D531606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=C6+/1vPF
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CUeDFBLD4toxqqSrteXkNbxXZ3bppLVdS5Vd57c91C0=; b=C6+/1vPFnWOdZY+kuc31VqKvhg
	rJ71tv9U1+mhX6JYD/XSL/lVx41nM3wm5e61eq7O/DgoLkcJyyfm3sj0/Y3c2gGXeuZVXxQMvukl/
	15MS3VIoc6o2aFd7R18HKWjDJREnJkTjJsAdyvxf4RnHN3Rn7eVjFnrT977gagz57SelX5Y1NnKZa
	0cnNzW7SxTWTIuZljBxnndHBDSIulMSSSkFj3FHxHScg8aOWEVGwuP6yA6k/biexhwQZyk80gOyQ5
	M2NzYAk0AX4KlKSptz8HRa0aC9VygcOULnkbWoppK+eY1Ap8XspvVBSwh9GFHobx+8fjJ0dvODnQv
	Na551hPQ==;
Received: from 2a02-8389-2301-9f00-31e8-efb6-e973-61ca.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:31e8:efb6:e973:61ca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLykp-00000006WAl-0ggK;
	Wed, 28 Oct 2026 08:11:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix recovery of partial attr removals
Date: Wed, 28 Oct 2026 09:09:39 +0100
Message-ID: <20261028081125.2209827-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When running xfs/753 on parent pointer-enabled file systems with DEBUG
enabled, log recovery will eventually crash after a few dozen iterations
due to an ASSERT that XFS_ATTR_INCOMPLETE is not already set when
xfs_attr3_leaf_setflag is called:

XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 3045

This is because parent pointer use logged attributes, and the attribute
intents do not track the work that has been done as the transaction
rolls, and the recovery mechanism is to run the operation from scratch.
Because of this various places check for XFS_DA_OP_RECOVERY skip work
already done.  But while recovery tolerates an attribute already fully
removed, it currently trips the above assert for an attribute that
already has the INCOMPLETE bit set, but still exists.  Fix this by
handling the case like all the others.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

This really wants a Fixes tag and/or a cc stable, but I have a really
hard time coming up with a good one.  The logged attrs are a messy
history with tons of refactoring, but this actually code goes back way
beyond that, but wasn't a problem before the attr item recovery.  Logged
attrs themselves are still only a debug option and not used by default
except for the parent pointer.  Any good suggestions?

 fs/xfs/libxfs/xfs_attr_leaf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6068fad9dc9e..82932b5c02fd 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -3042,7 +3042,14 @@ xfs_attr3_leaf_setflag(
 #endif
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
-	ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
+	if (entry->flags & XFS_ATTR_INCOMPLETE) {
+		if (!(args->op_flags & XFS_DA_OP_RECOVERY)) {
+			ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
 	entry->flags |= XFS_ATTR_INCOMPLETE;
 	xfs_trans_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
-- 
2.53.0

