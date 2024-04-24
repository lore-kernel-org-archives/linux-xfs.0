Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AC454F8D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928841; cv=none; b=L0Hkv1dqso+NkmMqKnkZyMhCcYyoK/tqq/8JgXM69gYTyfmt4SEHDf/P/gy3p2LXws304otEDTnP+uii05L0DkGgc4m/grJvJDhgNXbDgoAlF5jlxXYd9JtXaBt1oxeRboYztA7x/8jhVlBnqnS+SmZN6bSJs+VXQiYXt4Y5qQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928841; c=relaxed/simple;
	bh=vn1zeVbn7g2flQWOkc5lJD40vlSjhm4fYZkVy1/MvAE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1VZOxofYHRmXNhVOG2TtutlCFNKq+ZlOXjVpe+U6GfWxnI5tEHZPBYoQPpghZbFjr2eh5icQeBh/4qHE9z/XseF+gLjVhjSTuEjRwtuPb0IgJ6ejFBjJBxy9zzTid+oS2EL6/taANis6jZtK84Qk8TilQQtsz7eeZCZl4SNMoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zj/GXLiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zj/GXLiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24590C2BD11;
	Wed, 24 Apr 2024 03:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928841;
	bh=vn1zeVbn7g2flQWOkc5lJD40vlSjhm4fYZkVy1/MvAE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Zj/GXLiJfvkV75YDEv2JhhbECKfNvSf2thbuysaZGil/VEsjPFPHk4QxtUwm+Kc+D
	 UgjC8+azfxGj1P3Qe3YiP+tp1xalIzJitaIxtY3kxkTaC0Z2u7wdU/HzA2Jh7UnYk2
	 4w6bNwqkUaDMlt2eSwvY147eHK6M4xJ9DQlJEc54iuIg9tSsP8bmXG7lo/BVrkf7DA
	 WwtOznLX+L+9p+0Pj1OUU6V199uEJb4vBWjYsWJvPP1iVQ9BkDYFayrvkF4YjnHUHX
	 ncjGnh8gYffQLaJvQOBo1LlHZ9EMqVutljDC2dw1qgj2vdN743jaLbZ3RGp8yqloo2
	 OwSaEU0lSHS4g==
Date: Tue, 23 Apr 2024 20:20:40 -0700
Subject: [PATCH 1/7] xfs: revert commit 44af6c7e59b12
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784153.1906133.10514406855810896421.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784119.1906133.5675060874223948555.stgit@frogsfrogsfrogs>
References: <171392784119.1906133.5675060874223948555.stgit@frogsfrogsfrogs>
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

In my haste to fix what I thought was a performance problem in the attr
scrub code, I neglected to notice that the xfs_attr_get_ilocked also had
the effect of checking that attributes can actually be looked up through
the attr dabtree.  Fix this.

Fixes: 44af6c7e59b12 ("xfs: don't load local xattr values during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index c07d050b39b2..393ed36709b3 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -208,14 +208,6 @@ xchk_xattr_actor(
 		return -ECANCELED;
 	}
 
-	/*
-	 * Local and shortform xattr values are stored in the attr leaf block,
-	 * so we don't need to retrieve the value from a remote block to detect
-	 * corruption problems.
-	 */
-	if (value)
-		return 0;
-
 	/*
 	 * Try to allocate enough memory to extract the attr value.  If that
 	 * doesn't work, return -EDEADLOCK as a signal to try again with a
@@ -229,6 +221,11 @@ xchk_xattr_actor(
 
 	args.value = ab->value;
 
+	/*
+	 * Get the attr value to ensure that lookup can find this attribute
+	 * through the dabtree indexing and that remote value retrieval also
+	 * works correctly.
+	 */
 	xfs_attr_sethash(&args);
 	error = xfs_attr_get_ilocked(&args);
 	/* ENODATA means the hash lookup failed and the attr is bad */

