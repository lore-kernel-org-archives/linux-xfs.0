Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4104E3B71DD;
	Wed, 23 Sep 2026 06:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143357; cv=none; b=kXHZMqJ63ZXAu3Jb2DzyJO9dSKs2F97Xwsx8KK3vPzQRD+PRlx+yh3SPaFLbZPjJdqhlxDDHTIbVDbXRHiaT3X30/QLoytMXWBP+Atf3Gw3Sr7hTHwOtaxqLIzuw6+qyNvHJaZp4P7gyKn7X2HmSUhNsuyR4aOGoHnB2cxhzXZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143357; c=relaxed/simple;
	bh=P338lbTYDsyJTYZeqOZhPGyGtoNDOCPC4Se8gUFjUXM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9TGI6Gm1iM0FiSc6qdJ4YzFvF7gEeSH4lrs+xiEiRoYuImAFidVqYIKm0D+uNYm1vDAVwYHUw1xwLPsf9BfCPDYZXKqjqZwNB7Foj8ZSsc1mziCCeK4yONFG25PhEtrZ9N4nMcm+ImGwzqcAPgKpDSBzdBnf0HNRpyTlq15nyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WesvtG30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WesvtG30"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8BE231F000FF;
	Wed, 23 Sep 2026 06:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143354;
	bh=MywcLotdvMOmkY9kDE5Kx2KU1fE+n8dwr1bEWkXx8Po=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WesvtG30iKA8D/qTuaAkfhkCq2vYJeAPJc1WsamnWzhwkvHgdaZ99kQIVQlwbLwPK
	 svW7GpRZ5oW3Ysc5GDEapVyrEZUyH3x9RcTACWkzr947PWsthaxoWfa5cdLSB9XUh2
	 NP9OGQPM0Oz4BAOjGdHUI9ykvfP0RjS6HWxcUCWG/dqkn33u/3ZK2SxWf7nPMw+wu2
	 QQShHSJrSmvHc9PBQMKzT64jtYqq+o6hjzJE645S0kVFAhLYJf7gYOY+Opk88E8cX/
	 Bsjh+Cnu8HBLCudTzpVuukLujETx3+MhIc0PlfMpNx9QdK/8CFmS41630VkbXKm6gx
	 BgqfrkZtdZbiw==
Date: Tue, 22 Sep 2026 23:02:34 -0700
Subject: [PATCH 07/12] xfs: fix buffer overflow in corrupt inline attr
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159692.1875436.11611001761091180522.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed a buffer overrun if the xattr scrubber encounters a file
with a shortform attr fork with sf->count > 0 but if_bytes ==
sizeof(struct xfs_attr_sf_hdr).  Basically, we have enough data to have
a header with a nonzero count, but no space for any of those shortform
entries.  In this case, the xfs_attr_sf_nextentry() call will run off
the end of if_data and blow up.

Cc: <stable@vger.kernel.org> # v6.4
Fixes: ae0506eba78fd1 ("xfs: check used space of shortform xattr structures")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/attr.c        |   11 +++++++++--
 fs/xfs/scrub/attr_repair.c |    3 +++
 2 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d5226939c81072..7600c711362583 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -590,12 +590,17 @@ xchk_xattr_check_sf(
 	}
 
 	for (i = 0; i < sf->count; i++) {
-		unsigned char		*name = sfe->nameval;
-		unsigned char		*value = &sfe->nameval[sfe->namelen];
+		unsigned char		*name;
+		unsigned char		*value;
 
 		if (xchk_should_terminate(sc, &error))
 			return error;
 
+		if ((unsigned char *)(sfe + 1) >= end) {
+			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+			break;
+		}
+
 		next = xfs_attr_sf_nextentry(sfe);
 		if ((unsigned char *)next > end) {
 			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
@@ -618,6 +623,7 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		name = sfe->nameval;
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)name - (char *)sf,
 				sfe->namelen)) {
@@ -625,6 +631,7 @@ xchk_xattr_check_sf(
 			break;
 		}
 
+		value = &sfe->nameval[sfe->namelen];
 		if (!xchk_xattr_set_map(sc, ab->usedmap,
 				(char *)value - (char *)sf,
 				sfe->valuelen)) {
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 28f92e9ba72b24..ac433a5467516d 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -477,6 +477,9 @@ xrep_xattr_recover_sf(
 		if (xchk_should_terminate(sc, &error))
 			return error;
 
+		if ((unsigned char *)(sfe + 1) >= end)
+			break;
+
 		next = xfs_attr_sf_nextentry(sfe);
 		if ((unsigned char *)next > end)
 			break;

