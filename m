Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F6D19F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416091; cv=none; b=PFqItQctRwtRH5pfK2tz42n/3gkyM/bBQ4hl9GRqDGTXTMMI4F755a1ntRSm8KNVIZbPyuUaBPaKgGEw6tjG1fhGymsc0ZJLJgVySMD7m2NEb3dNgYCwvBEQ3vb5YTsaE2/a8PCP3nBEYPADUtU9uC8H3d5YpGonIQIAY77o4bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416091; c=relaxed/simple;
	bh=YTo2kdChCQnFL/U/ZjpM4l7hlMeNjjtALT4X9M9Z1gs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WQqC+cLM9DWpDufE0MP2bAFYD2SC4SudGswEt6T6QaR9KZfUUoOZmgvNpidb4oVBz+i+XCpkSBevp3STNnMDfhCO3b83SRfJmLpd59pXzgUZKNovKZzFm+jI+8iop3q9yfrqLwj0yT7NQY1+0sqAxYrazUw86FyVIOYsJzi4lqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D/NGRBNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D/NGRBNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D92DC4CECF;
	Thu, 31 Oct 2024 23:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416091;
	bh=YTo2kdChCQnFL/U/ZjpM4l7hlMeNjjtALT4X9M9Z1gs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D/NGRBNYJI5R6go2kSJyCQZ446eUbzUBvlpPZogJ/Ht0Sa7ROshWYbaF8zFZHP3sZ
	 bqZvYxMeMPT3hqavV5cEF4cWK7607BzDHQeVWMgKG0WgYFSVXmz/mFEw7aWqwSUmIw
	 REdJNqQXFwoz6YsJvm04DvixWCqKj8DBImwSXFxEYqkLeCzEFyyikD01QbFJDw5vBD
	 KUKGJn4Zf91nOF4/hFedfPSLTt7ePHHjnUPOgCWBgZBpDrEYGLL6zTP1YRrB3gq3rD
	 LAkjBt88absU5PIoAHAinZmsPTxeyVd0GouR0HdTS7aMeOpCMpTy3SgN/l0uek+lqX
	 irnqM/S1LaZfw==
Date: Thu, 31 Oct 2024 16:08:10 -0700
Subject: [PATCHSET v5.3 5/7] mkfs/repair: use new rtbitmap helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
In-Reply-To: <20241031225721.GC2386201@frogsfrogsfrogs>
References: <20241031225721.GC2386201@frogsfrogsfrogs>
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

