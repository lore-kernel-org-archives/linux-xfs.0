Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B334AFC0E;
	Wed,  7 Feb 2024 02:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707272371; cv=none; b=D8u/UnhqIqJTWMEmNG5lmGW+ZCJUhnkWCM5UaX8tMHcdW6UQHxjj14B/6eYjE9wZAu3XEewh1e9dUkBT/gM9DEUsk7KdjHELxFvnfY2pWi89RewhMpoPgk3laPwW1LLMqofXK2e7nY/FWdRx+ET9oqaXtksRdVh1gMFsaYmc8MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707272371; c=relaxed/simple;
	bh=UAlpnsmgl0Qg1lH8S9OO69u9rlBwquRjVoJ8Ib/QKUc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bzMIxaFEh398DVWmO/XzR7U3DTkeShydaRjGkM+bCgfErpu8degln+ZwZsci9acy85p+EEs2dQZPyPEVy6CZnq3qfwAbwHAOlZ3AHE2Uk7ugyTKiwzzRlv//OjDlyTEuYNyriocYvoFp/LlSykTb9YiyrSfSXPG3OHaq51ycNus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifGQgVHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifGQgVHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3B3C433C7;
	Wed,  7 Feb 2024 02:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707272371;
	bh=UAlpnsmgl0Qg1lH8S9OO69u9rlBwquRjVoJ8Ib/QKUc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=ifGQgVHgERpA8ZARfB7Fvub2txrQG/h7uuakGPPXsAMRcm5hPW2O7J7lDWbFBODk5
	 FVOiXeC6QOzMDxbtVGCT8PYlmDdfVMIsrcXeiswgd2mi4JyNf5wMWPSwtuVLOoNdRx
	 5AiG6WNspKh504ekiUIvhv/I17fn05KNMk26m/qVXHlrtolhGnHyLLfDAZkC5WauZS
	 IlH/x8uRWfO+bdv1nB6L/t1cVIuCybwQ8l/OBwyTFOoM99QJrJsD692/wPmXCQ/Fxl
	 XVoXimuJK2aT5wyp9lJ8uQPab0ezuO9Bpo1ROrcsXlz619ZxakoM+v9Xn2khY2f3l2
	 +MIfpV1JU06gg==
Subject: [PATCH 10/10] xfs/122: fix for xfs_attr_shortform removal in 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org, guan@eryu.me
Date: Tue, 06 Feb 2024 18:19:30 -0800
Message-ID: <170727237066.3726171.11659068396490963689.stgit@frogsfrogsfrogs>
In-Reply-To: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
References: <170727231361.3726171.14834727104549554832.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Zorro Lang <zlang@kernel.org>
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

