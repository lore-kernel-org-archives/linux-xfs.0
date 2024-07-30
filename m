Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30AB4A2D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299762; cv=none; b=WeaD16g2woasyPYA4tFKDPHbI9jZG8A6P/2vpuU81DE2AUTlSxh7p5zXFH4PdbGs0MqF2sLKsouZ87TeWJwvvuBiEiFOoVIUyTIKMl8iWINFUN65GWQXASJTVXibyXkMGy8hUU8NLk+DfCngtB/P65t5LvS9U6/pYexIkQE/Q3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299762; c=relaxed/simple;
	bh=NI9T2Ry4vM4zGfNQ4bqw4+g3geXbtELGOzbN3rdTIFc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aso6AZMP2wpONQsStLig88AL6yLkOO8UnlPRmP7y/JZVqLHWOM0nfLUoQxks07ZONyCIY5D/SuZ60X3qODBmWE99YQTlGLs8HnoODN2SCJcjpiKa6R+zIUWsQxBZNMa8aNC0KwA52iVDi+7M7PXlIyxBcWgsv793JY509Jmw+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLHQvuC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLHQvuC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4CBC32786;
	Tue, 30 Jul 2024 00:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299762;
	bh=NI9T2Ry4vM4zGfNQ4bqw4+g3geXbtELGOzbN3rdTIFc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OLHQvuC1yGoN/Z0GArqYhdD86i1FC1aCkS7ImRnCzdngC9eui3YmBKlC05Cg1b1ie
	 9BxHchdF8EAFCzKStXNgWs1AaXbRyvc0OS3xDiUXEoZxuRX6YegCE7qRjAQ4Lp2MZ5
	 wFE+hyHlHNzztQMtiq2QotHpBkz4kBL+ThZVeG17dDHcxL5fRbt8entM0wRKSUOxt2
	 zX+ApvgPT2BJ7kb0eGc+22tbSKORy7dgXcaTiU/dcCI/QYANEmQoaKaxB9taeD8TQ9
	 fDQIZ0fvjGMIH/N+ioRnN9T6esFCuDYYBdvEU79y47Uk+4zeKmTp54p75n6CTCSglh
	 r1ewd3vP4ediw==
Date: Mon, 29 Jul 2024 17:36:01 -0700
Subject: [PATCH 047/115] xfs: fix missing check for invalid attr flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843104.1338752.14553982670184862324.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: f660ec8eaeb50d0317c29601aacabdb15e5f2203

The xattr scrubber doesn't check for undefined flags in shortform attr
entries.  Therefore, define a mask XFS_ATTR_ONDISK_MASK that has all
possible XFS_ATTR_* flags in it, and use that to check for unknown bits
in xchk_xattr_actor.

Refactor the check in the dabtree scanner function to use the new mask
as well.  The redundant checks need to be in place because the dabtree
check examines the hash mappings and therefore needs to decode the attr
leaf entries to compute the namehash.  This happens before the walk of
the xattr entries themselves.

Fixes: ae0506eba78fd ("xfs: check used space of shortform xattr structures")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_format.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index aac3fe039..ecd0616f5 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -719,8 +719,13 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
+
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
 
+#define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
+				 XFS_ATTR_LOCAL | \
+				 XFS_ATTR_INCOMPLETE)
+
 #define XFS_ATTR_NAMESPACE_STR \
 	{ XFS_ATTR_LOCAL,	"local" }, \
 	{ XFS_ATTR_ROOT,	"root" }, \

