Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1862D1DF987
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773701434; cv=none; b=g9vx9JFvhb0I30ZvypzEOmHY3Chq6MgtHN1IiMkgzudWY8ZfKcPPVLv6TJT4hGxurYShoQzD1piUhbXhu3bzUjG4BIpm+/fn1gT7MNPvDaw53BzUxbHm90s+EC1vA3rv2kvLaAFJHuvG22BxwjaukyNmIO826+z7XEaZaLX4EgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773701434; c=relaxed/simple;
	bh=1fz/6o3MNgbRsnq3Un6do2nLSsu9XgTEtm8r0yXLFis=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HOuyu0fW+/IRvKM2fa7u9r23LwoqDhA4BGzvzyE851KQXRzIl6jvIWAewTeWp1spZg+LSbUH5PUr5qMWydTww0SNukq3DRkuV9lg/PTOdoEBpz8w+qmZjErFEuGvpvaqScjJ3oeJXaxKrERTF+2TO7YKgS820BRRs7f1tFExqPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ORVRjOqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ORVRjOqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFAFC19421;
	Mon, 16 Mar 2026 22:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773701433;
	bh=1fz/6o3MNgbRsnq3Un6do2nLSsu9XgTEtm8r0yXLFis=;
	h=Date:From:To:Cc:Subject:From;
	b=ORVRjOqCe5zoo1+po59ZZ4nX2Dd3RK2LlT8Io0Fj+gODBCNzHXl5oIBZuuR9a0J97
	 /IX5Hz/yf4uu65H3MPAYF/cwFSGw9FOJq+ubGegVtdN01Q0JDqYQKe9Y7/+JtGcn1E
	 YAu0fgQ4AoOZYjq5/4+sD96ioP2tmBbLwS2BxSOCHpJD/pnH1lyMJrC1sFUmQL5y8c
	 dSxArX8BfJfCUvkPJu9Z40AbKBtT3FURlptcWM2AZuxjmUBO0aOI4yc7krhRWjXx6U
	 UnS2TyPwQd9qPFyYiw3ExL4FltaP71A2c/3cVjHPzs7oi5BvHv9ou3kPreVWNNI8sE
	 C77yAPceQxI6w==
Date: Mon, 16 Mar 2026 15:50:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@infradead.org, ravising@redhat.com,
	leo.lilong@huawei.com
Subject: [PATCH] xfs_repair: don't fail on INCOMPLETE attrs in leaf blocks
Message-ID: <20260316225033.GP6069@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

It's far too drastic to delete the entire attr fork because doing that
destroys things like security labels.  The kernel won't show incomplete
attrs so it's not a big deal.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/attr_repair.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 50159b9a533875..fe4089026cae74 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -571,7 +571,13 @@ process_leaf_attr_remote(
 	    !libxfs_attr_namecheck(entry->flags, remotep->name,
 				   remotep->namelen) ||
 	    be32_to_cpu(entry->hashval) != computed ||
-	    be32_to_cpu(entry->hashval) < last_hashval ||
+	    be32_to_cpu(entry->hashval) < last_hashval) {
+		do_warn(
+	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
+		return -1;
+	}
+
+	if (!(entry->flags & XFS_ATTR_INCOMPLETE) &&
 	    be32_to_cpu(remotep->valueblk) == 0) {
 		do_warn(
 	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
@@ -592,6 +598,9 @@ process_leaf_attr_remote(
 		return -1;
 	}
 
+	if (entry->flags & XFS_ATTR_INCOMPLETE)
+		goto out;
+
 	value = malloc(be32_to_cpu(remotep->valuelen));
 	if (value == NULL) {
 		do_warn(
@@ -708,12 +717,15 @@ process_leaf_attr_block(
 		}
 
 		if (entry->flags & XFS_ATTR_INCOMPLETE) {
-			/* we are inconsistent state. get rid of us */
-			do_warn(
+			/*
+			 * Warn about incomplete xattrs but don't zap the
+			 * entire attr fork because that causes loss of
+			 * security labels.  The kernel can handle stray
+			 * incomplete attr entries.
+			 */
+			do_log(
 	_("attribute entry #%d in attr block %u, inode %" PRIu64 " is INCOMPLETE\n"),
 				i, da_bno, ino);
-			clearit = 1;
-			break;
 		}
 
 		/* mark the entry used */
