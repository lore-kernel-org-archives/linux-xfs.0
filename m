Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C2E492E55;
	Tue, 13 Oct 2026 06:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871607; cv=none; b=VHSnahNbOezMSERF9PO+iQqXv+Bi8Sej5+ujGGVwSzmBoV51SMnNrrGYfbejWwOnK3cKRQtqWDx6XohudhKMe+4RkoV1vTEFn/+Cyji3WPYF8XmVlm/ja7Tv9HPRf4sypOXp2cOYHyS3LLU3edx7KGDMMN34cn5jv/R8EqxoN20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871607; c=relaxed/simple;
	bh=re2AkThea1uQ84gCxiGbq6C2t2oCCi1Lr9EoJB6+ETY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwNi4+LlmPor1iyU4wrJSIReZLq1tzrWcW7gW9T/g/5Zd+1jhrYSOv4PgtSr3R8T/4+8DDiyWS9lVqXmSrW3rwULUO6DXd9TMB0pnGXETCb4OaaMeVpBtHBVWt/0Qjf7lTVdPuHmpwVnmkS6qHoZcyvuP1Uhu8QqgVbyFHgStXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GgkoEvho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GgkoEvho"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD8401F0089A;
	Tue, 13 Oct 2026 06:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871606;
	bh=qENhsNILBRoYV600uyeV9esh7PZBgPpXaCdon7t0N14=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=GgkoEvhoMW2KYVWfTYiZN0qT9xJb9/OK/+uYHgtRypZmuLIdL7z1l6uC6RYwSAIWD
	 hcgZVZmOsoNwkq/jeXLq4kj1XD6ZrV7A73xmdCSS9LJY5CWu2x44NUhTLu3uYuyvyS
	 D54858IBeTU22No+LZOpI1XqVweWU7YYixnUCGmov/83MsYAvcRErWL1e677ALovvI
	 0Ke5trclIAIrWoWqnEdP9vHWXAGVSLRTuYCaRCzzjT0j510xO0cPbaa0Rk2ivgHkbb
	 u9Qexb1jVv5F7c6n90gGX2w94AbeNQazzL91qB6oM71FBmH3R0+QBzc+937xmXv4/7
	 jeOzDYYam+hMQ==
Date: Mon, 12 Oct 2026 23:06:46 -0700
Subject: [PATCH 06/12] xfs: only written file data blocks can be shared
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107268.1898400.2017479521256451856.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
will count any rmap owner towards the shared count.  However, the only
blocks that can be shared between xfs files are written file data
blocks; and the only blocks that can have single-refcount entries are
COW staging extents.  Fix the checking code.

Cc: <stable@vger.kernel.org> # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/refcount.c   |   12 ++++++++++++
 fs/xfs/scrub/rtrefcount.c |   12 ++++++++++++
 2 files changed, 24 insertions(+)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index f8c51d8fbb3da5..a900d13c9e27c0 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -129,6 +129,18 @@ xchk_refcountbt_rmap_check(
 		return 0;
 	}
 
+	/*
+	 * The refcount btree should only have records for written file data
+	 * blocks or for COW staging blocks.
+	 */
+	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
 	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
 		/*
 		 * The rmap overlaps the refcount record, so we can confirm
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 3d916d71a135dc..00da8e98506d63 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -144,6 +144,18 @@ xchk_rtrefcountbt_rmap_check(
 		return 0;
 	}
 
+	/*
+	 * The refcount btree should only have records for written file data
+	 * blocks or for COW staging blocks.
+	 */
+	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
 	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
 		/*
 		 * The rmap overlaps the refcount record, so we can confirm

