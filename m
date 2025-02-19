Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7187876025;
	Wed, 19 Feb 2025 00:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926783; cv=none; b=RNFqknPtP18Lyf+L7D4kXDh5Y3vMsO+X+KDcf5ofAo+P7FcioQHsu2unpcMjwJlEffmc4a/fF0GIv4fxbDtlo4ARiaw4IQaewHif/8GVtdBfjaKDThOytHH0voBlXPz7GLVjY+sZeHtOMxILHkKjnr9HjEvhJQUCYDisDhXWE/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926783; c=relaxed/simple;
	bh=duWzI1uS82Jk3R0gIyLbBxxtpjoQqhp5UbLvIPzcoI0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wh615s0uY4TLrQvW9jy+sfmQAPECzWGTvBmqiJMEuGJfCVMmH/HBbIsZL5gKfO4+nKDJb4ImulHuuOMxGlVbNzb6L9QYWYSMk0/TAl/jbeGbVWIhXStF1qEdZ7WXqfG+XzxEKUbofw/stYi+TWHmphhbwaOrx1t9iXlFC3jiTZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hg1QBQJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hg1QBQJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70DCC4CEE2;
	Wed, 19 Feb 2025 00:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926783;
	bh=duWzI1uS82Jk3R0gIyLbBxxtpjoQqhp5UbLvIPzcoI0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hg1QBQJiWMp69LpT4OHKnzBn74Q0uXmrpHNRlj8NNE3yJcy2WJFG/R3HZTcFFQ8Ec
	 WBOBvEUHXaLoQORHvk4v1arLpSkAto7iw5+EAD7g4EFJfTydDeKCnwJhljFtATagcU
	 Ej4uJEgCcgO22iYR6phXkucg91e31rj7E9bHo9B84e1s6aOg14+kv3HPT8iREyOGue
	 Ci2L+15wGi8tWeM14B1hC+DQ+v+aFlkZf89JM9URi4Sf7RU8Pl5kpuIn2Ymf8YymMD
	 QJOfWiHEe2B5f59+8RO95XduXzuqEgIximiNJWnKiiUA1IREz+T9z/BGBXQRvcG0Oe
	 lP79jSAcy9KzQ==
Date: Tue, 18 Feb 2025 16:59:42 -0800
Subject: [PATCH 08/15] xfs/206: update mkfs filtering for rt groups feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992589327.4079457.1787652822219676386.stgit@frogsfrogsfrogs>
In-Reply-To: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Filter out the new mkfs lines that show the rtgroup information, since
this test is heavily dependent on old mkfs output.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/206 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/206 b/tests/xfs/206
index ef5f4868e9bdca..01531e1f08c37e 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -65,6 +65,7 @@ mkfs_filter()
 	    -e "/exchange=/d" \
 	    -e '/metadir=.*/d' \
 	    -e 's/, parent=[01]//' \
+	    -e '/rgcount=/d' \
 	    -e "/^Default configuration/d"
 }
 

