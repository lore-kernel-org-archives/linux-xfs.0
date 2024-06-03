Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1354411
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717444578; cv=none; b=rB/eHPQ45MfCr73bvII3p4YUHoGxY9/oWn31kaO0WYVccMNdJmqfFAHRaQQYB4Vw0LnpLWiSLVy/SntjJwcWIG9wQKuCObCKNHvA0nmE9uVm6fjE1z7j6E/VSOOMmYB1YuFmVOwGANbaPrkEFEpAVD90OqJslhKSDJH5ZevFqqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717444578; c=relaxed/simple;
	bh=VD22EBrW8a59gaaUg2zpshRG2KzI2rA2N6MfESeIudM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=M47V/gkfHk6BGxRrp2a6PlTB+4i+JpN//LVdGSOk1pVsFtPIT4+lulKJoeMaEq5CxJbl8oxYThyCN3EcUL346Ll8ANiemtLWPwTCCl0ojBp1U9SIcZvn2x+xjrUEn7XKrmSZv2cAfWH6gMCq8kkj5uNasqXT/0I193StJfWKp6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AaKE9Ne7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AaKE9Ne7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E65C2BD10;
	Mon,  3 Jun 2024 19:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717444578;
	bh=VD22EBrW8a59gaaUg2zpshRG2KzI2rA2N6MfESeIudM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AaKE9Ne7Y2QlKwiLfEkz0eZO1uyUHGxUuc9wuxQIttmFVnvzOq6HQS1D1qjDbq7o3
	 FRxixzJlMZ5ssqoeRN3A5Gd14PezUA9dk0iNZQQ3wOu6I2aWYMy+uvCnn7BBAyTYM6
	 Drmw07u6bZmXRapbuh3AXSVvlV7MODSpz1SpPqR/wJKadb5BIAAeenxRXUKQNA/foc
	 hRtfjTnAmdWPNh4YK5zx31DuGn46GTrhxZ3dSYvBG1w47vi7vAqmeL441abAvDue1S
	 DHD/ANMVIz3JQfSruAJzPCY3C5+OqMO9ervZzndDpvoeno1+Ox7NMJwrc+ujCamkNC
	 MuqkMcJTRTaxw==
Date: Mon, 03 Jun 2024 12:56:17 -0700
Subject: [GIT PULL 07/10] xfs_repair: minor fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171744443970.1510943.8198430699020167993.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240603195305.GE52987@frogsfrogsfrogs>
References: <20240603195305.GE52987@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 2025aa7a29e60c89047711922c1340a8b3c9d99e:

xfs_scrub: upload clean bills of health (2024-06-03 11:37:42 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-fixes-6.9_2024-06-03

for you to fetch changes up to 842676ed999f0baae79c3de3ad6e2d3b90733f49:

xfs_repair: check num before bplist[num] (2024-06-03 11:37:42 -0700)

----------------------------------------------------------------
xfs_repair: minor fixes [v30.5 07/35]

Fix some random minor problems in xfs_repair.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs_repair: log when buffers fail CRC checks even if we just recompute it
xfs_repair: check num before bplist[num]

repair/attr_repair.c | 15 ++++++++++++---
repair/da_util.c     | 12 ++++++++----
repair/dir2.c        | 28 +++++++++++++++++++++-------
repair/prefetch.c    |  2 +-
4 files changed, 42 insertions(+), 15 deletions(-)

