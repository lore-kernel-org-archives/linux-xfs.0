Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435D1CF96
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729837932; cv=none; b=eE3mX/LYCav5v8w/RK7L3aPGlOXcfx14RXiSwsgxqN2QQzlOywQUUmhkA6dvj8yvcqSwVWHJNYUVZZwW/xxXSNhGav8x4R5hFbatZD+nzfp9TZcuCtTKnAgdw2PXy8lXgROd+PCuoWtphgrMYAV6rXWcwRKE8yClvFTGEehDdLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729837932; c=relaxed/simple;
	bh=YTo2kdChCQnFL/U/ZjpM4l7hlMeNjjtALT4X9M9Z1gs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgzdUYWlt7facNUneHcS6Lkw+xShYbasC4dKJkAC5ysPcu5sIh6P2EMVv1oqI5Q1IxepJdYuHFt3cMhS3Y3NsIgNJ/l09q03ZOV2RBxhgCgj8L4jRFamVcISFyjE7ZJbJIqZ8Zer8vfLgwbAzFEAYXhjRtqkCMN2Rra7eMwEElI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6+CFQcx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6+CFQcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C38C4CEC3;
	Fri, 25 Oct 2024 06:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729837932;
	bh=YTo2kdChCQnFL/U/ZjpM4l7hlMeNjjtALT4X9M9Z1gs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A6+CFQcxkXnjdryk1hsBmXwMTQegHdSP9nAqPubiYA/Vy+DafSgFsdo0gubTZDZQB
	 CNbLiVr0ecXexoc0ukCKulsDHVeyJu9Y8xOEy77jf9JP71flFHWg1iDwsSOVlbg0Vm
	 meI3Y8lp2iSJaxaXsMtyjZlH4CD6qQZtxo759rTRX4+wOGgUav/Lsy7PbxyQkhMc1c
	 oemgTb2b7uGdJ6KgqfE2dSDJaPGWDlX2npBjsm4iygTDjWHJ7P2beg6yv1TYWM9WXT
	 mjXRE/8xrN9tFGnk2dHW2fr0AdkReEgI/OgRiHf18dboqCu69Y0lYv5/1n7fTpXBAd
	 Pv5Dcb4TuL8qw==
Date: Thu, 24 Oct 2024 23:32:11 -0700
Subject: [PATCHSET v2.6 4/5] mkfs/repair: use new rtbitmap helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
In-Reply-To: <20241025062602.GH2386201@frogsfrogsfrogs>
References: <20241025062602.GH2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Use the new rtfile helpers to create the rt bitmap and summary files instead of
duplicating the logic that the in-kernel growfs already had.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=misc-use-rtbitmap-helpers-6.12
---
Commits in this patchset:
 * xfs_repair: checking rt free space metadata must happen during phase 4
 * xfs_repair: use xfs_validate_rt_geometry
 * mkfs: remove a pointless rtfreesp_init forward declaration
 * mkfs: use xfs_rtfile_initialize_blocks
 * xfs_repair: use libxfs_rtfile_initialize_blocks
 * xfs_repair: stop preallocating blocks in mk_rbmino and mk_rsumino
---
 libxfs/libxfs_api_defs.h |    2 
 mkfs/proto.c             |  107 +++--------------
 repair/phase4.c          |    7 +
 repair/phase5.c          |    6 -
 repair/phase6.c          |  284 +++++++---------------------------------------
 repair/sb.c              |   40 ------
 repair/xfs_repair.c      |    3 
 7 files changed, 73 insertions(+), 376 deletions(-)

