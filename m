Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9607A1946BC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730418223; cv=none; b=S9uoTcPpXIbkpn+WNuB/KeIhjm5BumOovo9TVFCGPNLNLHhbfTrVCyl+jdasutmZVyPQYvmVKY/IFHhCWbunevHpmCt5V5FifnN25CObXoE5qENZsycpuSXBYVELylVbVF92D4e74RUm2xh9fPET4TbVsQ1UyyiAAt3j3pflIp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730418223; c=relaxed/simple;
	bh=A5aofJxnrax0Ii6fLXfC7R7Ix+3uGBiv+ca1JcyfCiI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=j2WJmhAPNLvL7XL5mdIhiTpgbbKtpRtXwHqfogyHaSkdtrPkNmJ9IW3V37Vx0oNmIn/A8VhN1dNvp8h9YGVHp3IKSkUZri8lRIjWkj6QXQcOrspwpVcbQy+jTFh/pjsRYpLj6ZSHUlZP67Js/AxLnthoaoWdtxUka4ZB/M0ehhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=evgA6Pxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="evgA6Pxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CC9C4CEC3;
	Thu, 31 Oct 2024 23:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730418223;
	bh=A5aofJxnrax0Ii6fLXfC7R7Ix+3uGBiv+ca1JcyfCiI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=evgA6PxxrGulQnKKqE+ECHUFzSc6YUiy6ENYFCcv3k1tZM1uPMohY4VybE5pmXNpQ
	 0b+pDxymEYqKDek+PJDaelMevQOiFvx8HulXym7xWmtcIKZC7sSFEDBzFyQJbooasu
	 HL2SHEC1V5g/At7z6f2FlFsP6VKkN/5n8KScTEz3JtXWPy0uHzRFH5P95R60h8NBeo
	 9vQA5FvCCfe5Qj1n5FupPN0VDMrAtEKXvigpbTL0X5+/Rbx8rKYquOM8B7z8qvNr4W
	 yUwK4csn18YyTI/KSL+CRb9a34OZXBOpzkdNRR2skNq5AFWmonYZA33QSTRPPKPeCj
	 xc/qDHICC6t0Q==
Date: Thu, 31 Oct 2024 16:43:42 -0700
Subject: [GIT PULL 5/7] mkfs/repair: use new rtbitmap helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: <linux-xfs@vger.kernel.org> # v5.19.0, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173041764757.994242.5921950807905351688.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031233336.GD2386201@frogsfrogsfrogs>
References: <20241031233336.GD2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 5e8139658b798d931079404660273840432bcd9f:

xfs_db: allow setting current address to log blocks (2024-10-31 15:45:05 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/misc-use-rtbitmap-helpers-6.12_2024-10-31

for you to fetch changes up to 07c09d46665cfac48256f6faf829897554ec74bf:

xfs_repair: stop preallocating blocks in mk_rbmino and mk_rsumino (2024-10-31 15:45:05 -0700)

----------------------------------------------------------------
mkfs/repair: use new rtbitmap helpers [v5.3 5/7]

Use the new rtfile helpers to create the rt bitmap and summary files instead of
duplicating the logic that the in-kernel growfs already had.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (5):
xfs_repair: use xfs_validate_rt_geometry
mkfs: remove a pointless rtfreesp_init forward declaration
mkfs: use xfs_rtfile_initialize_blocks
xfs_repair: use libxfs_rtfile_initialize_blocks
xfs_repair: stop preallocating blocks in mk_rbmino and mk_rsumino

Darrick J. Wong (1):
xfs_repair: checking rt free space metadata must happen during phase 4

libxfs/libxfs_api_defs.h |   2 +
mkfs/proto.c             | 107 +++---------------
repair/phase4.c          |   7 ++
repair/phase5.c          |   6 -
repair/phase6.c          | 284 ++++++++---------------------------------------
repair/sb.c              |  40 +------
repair/xfs_repair.c      |   3 -
7 files changed, 73 insertions(+), 376 deletions(-)

