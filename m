Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3015359167;
	Thu, 20 Jun 2024 21:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718917236; cv=none; b=cjotOC/g4HzwJH/tE3nv/LvOhZ5V0cKgsbWwqcZrTQJeTVKl4NFlHAMRqTEErhq6SSy8IeW7Ha88xR3EPaJZ02ghPA4lOFa0SWxLZ9cIMYiyaL33Q68Zhr93d5Ob9ERu7PGoX6HtKBF6rnoajKsCusoVbO15KW4OJDblI/BEvqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718917236; c=relaxed/simple;
	bh=NCdAeRSVPXpmJKzNQ6MDvfliBtgoq9jgRrj51ShBLw0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gaa3vFTflAkWEUNx1qu0x/na4Ax9iu/gkN1pUn7LU+vKOpf3A+zmjEcyiU46+VU1vMg9KqfbPq6ERf0mKgzCtRRNl1TBvphB75EXq3GKmdYn7piF/jR6eFhMNIKABE9tBuyZTjf302Bog3zetzFEoJ+5YpUMRLovZPE3noF+k2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lbY0cK10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lbY0cK10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA671C2BD10;
	Thu, 20 Jun 2024 21:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718917235;
	bh=NCdAeRSVPXpmJKzNQ6MDvfliBtgoq9jgRrj51ShBLw0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lbY0cK10rwuneOIUorekgjO+sGRoU+GDE14L1svSOj0cAtwWw8USKLDiwOVFlc5I/
	 Eq2X3+ZEy6mkYAdflBfqDSO96hKQPQXYWgfPbfdvBoub3B118wn4HRxI5hejWWvzfI
	 xM17mAn2DdknF+pfDyZsSs1mJQ1Pj6z34V666iQFvNHWqMZvyI5+ebwSSXBumGQpYX
	 CMdGqzdl7hbPJhw7pSmIka7cLbBOArYpv+FdL0OLi2yJSV+ADq0+LBsMPgo7TXqHXS
	 dGnpT15C9ZvVr7tmREvMohoRuBV5IRSnITDwPCMqkdiBB7dJj8dpYSvEWL3a+AtLfR
	 awLWThvevAZRA==
Date: Thu, 20 Jun 2024 14:00:35 -0700
Subject: [PATCH 1/1] xfs/122: update for vectored scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891670536.3035797.8974720474502661581.stgit@frogsfrogsfrogs>
In-Reply-To: <171891670520.3035797.9407325539574639419.stgit@frogsfrogsfrogs>
References: <171891670520.3035797.9407325539574639419.stgit@frogsfrogsfrogs>
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

Add the two new vectored scrub structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 7be14ed993..60d8294551 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -124,6 +124,8 @@ sizeof(struct xfs_rtrmap_root) = 4
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64
+sizeof(struct xfs_scrub_vec) = 16
+sizeof(struct xfs_scrub_vec_head) = 40
 sizeof(struct xfs_swap_extent) = 64
 sizeof(struct xfs_unmount_log_format) = 8
 sizeof(struct xfs_xmd_log_format) = 16

