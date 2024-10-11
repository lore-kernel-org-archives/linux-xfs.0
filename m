Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EDCEEA9;
	Fri, 11 Oct 2024 01:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610768; cv=none; b=VTxHnMeufQn3sZ38aslSmgH6Yy+VB1qF9M1vDnDgVLkrUE1iKAgO1U8c9fki+CjqdqpeFlMbA8KFN6FMTH1QdFLX5Jpc3ZK4f3Xqi/EMj3y43fdz6oHM8007RtS1gVIXxJ3ElDfAA3KXErxNpL4o5LDk/59FrSZ+6NgWZxRZDak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610768; c=relaxed/simple;
	bh=oqjvkm0PnXzl6YOECnpywfiM5l8JO4iHUBCX7RR05gk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQgZ3+vGp/riG+RveH4xqu8RLMw+g5MSmUAY1CLTePHP6etyQLfUdxfMYa7jx4rhNyNilXxXJ/oc3WGMl7J/R1UVErWifUIVo4r+4AJlOyLfPiOaevfA5N+RLG+v5A44va83i4g1uWOuFPv2Y6NjFYrZphB3HhDvYa7doHOubJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzTi6Zoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzTi6Zoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B080BC4CEC5;
	Fri, 11 Oct 2024 01:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610765;
	bh=oqjvkm0PnXzl6YOECnpywfiM5l8JO4iHUBCX7RR05gk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NzTi6Zoj9fazP0qmD9WCKRaQHjgb4SD3weMNM3PMYO26t1mWy4u2pH/QkAcdigxpx
	 FvvulWcYiUUFCEnvfKULfq4Yhimwrr9I8d3tlkw7F9uGxg8IQ+oVh2WghnzY+RS9PL
	 /UU7aAFQpTzjDjxzxMNvuOw1qzbILo0nMBRxlMnq+L+Td3WOlr/fABvTzCIjRfdnqQ
	 bZIRNqTUMncoMjs0PP4X025i7gAYGgbtx5acPzrYgJhB7cQ6I9A8TVfRYlUKZt5gvO
	 LfLalS3wljwfRSb0BVfw+Xe8NW2SeTd4OulCNnvMfudGU2B5m4BeMcibM6BNylG4Hp
	 xuVSXjVHBsOig==
Date: Thu, 10 Oct 2024 18:39:25 -0700
Subject: [PATCH 05/11] xfs/206: update for metadata directory support
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658073.4187056.12493388618887137873.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
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

Filter 'metadir=' out of the golden output so that metadata directories
don't cause this test to regress.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/206 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index 1297433188e868..ef5f4868e9bdca 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -63,6 +63,7 @@ mkfs_filter()
 	    -e "s/, lazy-count=[0-9]//" \
 	    -e "/.*crc=/d" \
 	    -e "/exchange=/d" \
+	    -e '/metadir=.*/d' \
 	    -e 's/, parent=[01]//' \
 	    -e "/^Default configuration/d"
 }

