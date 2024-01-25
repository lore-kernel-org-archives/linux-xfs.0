Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523EC6A005;
	Thu, 25 Jan 2024 19:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706209596; cv=none; b=hELdXL6E1pQmAKiS9eUOCI+uqjdPNEq+YLvjkOCc4r4bNUpBTtr9hHLo+iXxFAWO5Fl51HWwPSgmBRBYvBD5YlQQiQbN7DjvfaIbMjQZcmFGK/it83k7I92l35RbeS2tp9EwUA5xbNBWzf4WOlmd/FiG2KoT3WTnJW+Z0sc3YGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706209596; c=relaxed/simple;
	bh=sLM2uLqDZXHu+g0PvRoJd31ZQQVQUao6m22FUiAOJZk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tXQDqrauo8ulr/1QvMlx2k0xe+J4CjLxdF7KVdfY6r/I/ds33Boy8OadIMwcGxDxYyY8AifclMjeQry+CeyGRl7NZwbVyTp67VvovVYKS4nz7ZmnGuVjW0F2mKiYp47MVVT4Ay+PHvFPLMuNXJUzufBMcQyYf/TZBow7yLJQdEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oUZRbtUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUZRbtUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB83FC433C7;
	Thu, 25 Jan 2024 19:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706209595;
	bh=sLM2uLqDZXHu+g0PvRoJd31ZQQVQUao6m22FUiAOJZk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oUZRbtUX35jt4sZNA7VPOFMypyDxBFIBFdW0Ap1FF8RmXgEiM/lgBO7h8hFJZLBnO
	 ouXdCSUUpWSSa9jl8/ULpsmaTizGWTSSTK1BxaWJMipkH8Ep33K43Pz2dTEYXZ01Wi
	 sNEoDgGIt3NdUfOCoTKeb6HN1jlLUnMyMM4GHal5lmeFlvWR1GNVw7AljZbgIShgS0
	 MCGBw5YvqgmyaauykF7TXNAkuNFADX6Or+AcPPG0ZrlaWDcaZig+5dCDeUBGC8LNmc
	 99UGvrsSc3zRfhgSoAveLeVs1zVNRgkzZ60SMEDTorYA5NBjUP7XQHoYJZv+4izlF8
	 lL9dv/zVBTmlw==
Date: Thu, 25 Jan 2024 11:06:35 -0800
Subject: [PATCH 10/10] xfs/122: fix for xfs_attr_shortform removal in 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170620924507.3283496.17636943697618850238.stgit@frogsfrogsfrogs>
In-Reply-To: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
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

The xfs_attr_shortform struct (with multiple flexarrays) was removed in
6.8.  Check the two surviving structures (the attr sf header and entry)
instead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 89f7b735b0..067a0ec76b 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -62,6 +62,8 @@ sizeof(struct xfs_agfl) = 36
 sizeof(struct xfs_attr3_leaf_hdr) = 80
 sizeof(struct xfs_attr3_leafblock) = 88
 sizeof(struct xfs_attr3_rmt_hdr) = 56
+sizeof(struct xfs_attr_sf_entry) = 3
+sizeof(struct xfs_attr_sf_hdr) = 4
 sizeof(struct xfs_attr_shortform) = 8
 sizeof(struct xfs_attrd_log_format) = 16
 sizeof(struct xfs_attri_log_format) = 40

