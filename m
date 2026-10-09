Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E552C35B14E
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589664; cv=none; b=HWrVPfxNjwqUzFGHRoj2iwt8gsx25+6kYLTlZSh9KvDhQFYLYGd9t29WmJVd8qfaQ/iZXOq6heDqGuugBrCdvStF81n2QV+69dWOwjK+UzlhRM2626rRaKX4AoiZfdMQ6Aq1lMgtcGcUtU6rSrlnGySsF99GeMw4GnfD8yKVvj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589664; c=relaxed/simple;
	bh=VnyJM6AkiNuAgGBmQ/t73moEhVvJcTof811aIokZtTw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2bxvVn1RWSZZVRNZyrWuXtnIjV8je6arnKjwUOEdZpCQ6Uo4RUPxnv+r6I/7BF4z6dttHvEKBHBNsae+1gR861GX4oQfpdNsbvfpkOKhl4LBfhqg5qgK91rynEdz/jrexz5/LEqPV7iC1YZxUHG4j3fEAB/0LtRYnVFGmCkzF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ka7LKGrA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ka7LKGrA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 691FF1F000FF;
	Fri,  9 Oct 2026 23:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589663;
	bh=Cm0iQR0kAjzE8aet+plBn4OFzsBJO67Btm7vCBTLV7I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Ka7LKGrALk+u/+YWhNOiTQfywlNOSOH0+xm4GTUxtsXGUxLQVM9jolryISLOngGru
	 M0nDqhaCgHxMrcwC4Nb5eDqnzbDW9R1uw2OA8mJo53Gki+g0249WCKg7leFClnsYDi
	 UkqmXcYejjgMMWV7o0Jl5nXWCDxPMnAAQqCDEw8nBbquSfSZgWlUEAOrQphVoSM61c
	 d4GPsitm4hy7rBUr1rgbH5AQLUE3flobdwUO8cJFaKNhUO8p9EYV0Z6e+VxUusoGpa
	 TdauycM1RzWF9+Jkb3ukt6L4xWaH6CqM7EnHmmNgLVZdKEwCEt9gHh3jWNb9bT3JkP
	 vEALqVoEcXdHg==
Date: Fri, 09 Oct 2026 16:47:43 -0700
Subject: [PATCH 08/26] xfs: validate attr entry pointer before field access
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, zenghongling@kylinos.cn, linux-xfs@vger.kernel.org
Message-ID: <179158947512.3719791.14512605594019500342.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Hongling Zeng <zenghongling@kylinos.cn>

Source kernel commit: b7eea80be25f3334f131d52982b3131aba77b97d

xfs_attr3_leaf_verify_entry() accesses lentry/rentry fields (namelen,
valuelen) before checking if the entry pointer itself is within bounds.
If nameidx is crafted to point near the end of the buffer, these field
accesses can read out-of-bounds before the bounds check at
name_end > buf_end is performed.

Add explicit bounds checks for entry pointers before accessing their
fields. Use offsetof() to check that the start of the flexible array
member (nameval/name) is within bounds, which ensures all preceding
fields are safe to access.

Fixes: c84760659dcf2 ("xfs: check attribute leaf block structure")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr_leaf.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 0ac2ae28efa610..a7c4c0bbcf5278 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -323,6 +323,13 @@ xfs_attr3_leaf_verify_entry(
 	 */
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = xfs_attr3_leaf_name_local(leaf, idx);
+
+		/* Validate lentry pointer is within bounds before field access */
+		if ((char *)lentry >= buf_end)
+			return __this_address;
+		if ((char *)lentry + offsetof(struct xfs_attr_leaf_name_local, nameval) > buf_end)
+			return __this_address;
+
 		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
 				be16_to_cpu(lentry->valuelen));
 		name_end = (char *)lentry + namesize;
@@ -330,6 +337,13 @@ xfs_attr3_leaf_verify_entry(
 			return __this_address;
 	} else {
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
+
+		/* Validate rentry pointer is within bounds before field access */
+		if ((char *)rentry >= buf_end)
+			return __this_address;
+		if ((char *)rentry + offsetof(struct xfs_attr_leaf_name_remote, name) > buf_end)
+			return __this_address;
+
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
 		if (rentry->namelen == 0)

