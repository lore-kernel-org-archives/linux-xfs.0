Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631901632E7
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565696; cv=none; b=hTuvZreNLdYO8sLsObCOlTNi/VwmqnW2O1zEZ8t1HEpKanwcvpJUl1hCVTnSasl/L3vDGC4ocj8xes495fiqVxaMqAvqOia+pxRnY1oBfPtIJ4O5mLqPGSDpcF9bK24WDZFxg6iB4hJ9wJ5Owj1PWiORVQqcyp7tt0o4pMvZTNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565696; c=relaxed/simple;
	bh=KdOpzw15x0u4KqRx5y8W143dUiOiEjESoFVtQ3GyHQE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=bByyoIowEjaCr0iQSJ5MaE+A9XY0/6tM1nHOYyfuXL0dAFcZVijX/tSRZ3wunpQ3Nts+GSC8Qj7yXmQe1MuMJFTiOmvZKG+QwK3ce06TABSh+cBHl2pCuArWbEmkZaDlYxow8IFc+GHkNvNkzaSk9dVaeBtPHfwehqPS2QBfdJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=usEYM2F5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="usEYM2F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6D5C4CECF;
	Thu, 14 Nov 2024 06:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565695;
	bh=KdOpzw15x0u4KqRx5y8W143dUiOiEjESoFVtQ3GyHQE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=usEYM2F5HOZ6TKie3aAjtu7PVCI9jdwm0beGNKqA+67+/oWAzQnIxTpzLRHZZbv2J
	 p+kgLbVpKt26HRGh4DPYWn19ouoofT8Tll3wptOmW435OmZ4DtPOFj8yIuy5XPJGgV
	 iRkLdcv3/ZhjITz+tP5WVu6PtT3OWiihpO8gP5IsOpiJYxXk1OSVYE2+Y7jruRD8Sp
	 iD5d2/4E1CFWqblgGg3bHFYQsQlKyEjzgG9f//NLh+6N6psvlZBr0/87jEq41VlCbo
	 R4P7BOTZ+VHlpoeMBVKKvYhAkx1yXv+t3MPpuu+SnAxYrsYCrWiVTCS68CVGu22ayz
	 SIpmE0o59GEvQ==
Date: Wed, 13 Nov 2024 22:28:15 -0800
Subject: [GIT PULL 09/10] xfs: enable metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173156551873.1445256.9246176355935119098.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114062447.GO9438@frogsfrogsfrogs>
References: <20241114062447.GO9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 5a1557a29fb395698f8222404507d19c6f893361:

xfs: enable realtime quota again (2024-11-13 22:17:13 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/metadir-6.13_2024-11-13

for you to fetch changes up to 407ef7c670221fd3d67a69a4b5aac49f5d89446b:

xfs: enable metadata directory feature (2024-11-13 22:17:13 -0800)

----------------------------------------------------------------
xfs: enable metadir [v5.7 09/10]

Actually enable this very large feature, which adds metadata directory
trees, allocation groups on the realtime volume, persistent quota
options, and quota for realtime files.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: update sb field checks when metadir is turned on
xfs: enable metadata directory feature

fs/xfs/libxfs/xfs_format.h |  3 ++-
fs/xfs/scrub/agheader.c    | 36 ++++++++++++++++++++++++------------
2 files changed, 26 insertions(+), 13 deletions(-)

