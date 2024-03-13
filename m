Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6218A10A36
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294533; cv=none; b=X5SDEi4bdIznZ2lVrexKUzMqc5rja5qD0mxpUcLg5eVkbfNiij9gO7lB5eXdjJm9RlyI3N6T2svUXInXXZn5l/n3wI0xNLO/mHqgjETTmalFy8nbrBpbaKCJ6n0yEvPORWStQrLevbMkbS6v48wZK74LyQtvs0B7UOSHTJ47hDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294533; c=relaxed/simple;
	bh=RFruLTeEp7UQ4s8cNgUBTY4ftqtyf6LViBPTeNBybao=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LbstIWlFXymdFTuWVGCzIZNdLRRT8px3pzBbeKzDgpoQIvu6XGBM/VbgS4fSf7BvQTnijyY8ruMDnVZM0G4yecmw2d9mb33pPCVyks4PZHo+He8B6OAqxG5VVnPdThwk3jDZjG4uZPD8a4vaQht97zxjfDQ78AG4ng3aTo4447o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dUVKeeLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dUVKeeLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3495CC433C7;
	Wed, 13 Mar 2024 01:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294533;
	bh=RFruLTeEp7UQ4s8cNgUBTY4ftqtyf6LViBPTeNBybao=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dUVKeeLJY2Vsv41e+kSn2bYVHi8y5iJLcTorxL246D6PEB4is5koNILzf409mhaAi
	 FKsHNUOm/3QoPsf1p1svhKDLBSY3KdHKtsbDYOj3BiNYkY6iSN31SN0A745nCnD5Zq
	 EdcxqxUainnSxcOqzMzVjtdQA41zyXhFhh20/haZu7GWpgdb4OEO+T+ifnFd1GkEIK
	 9AivFYoLmPe6byWZ66dDMmml5YA7IKpUHLN6rwH+v86qyxLmRdNTKF/fazLR2V7aKr
	 FWReCJDDTvzlDpttd7qwKhx/nnJS32i7lVZNXt/Ah93aLw6o6HH/OHKieR/MCdmS9q
	 yjTArUcMMvI/A==
Date: Tue, 12 Mar 2024 18:48:52 -0700
Subject: [PATCHSET v29.4 07/10] xfs_scrub: scan metadata files in parallel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029433946.2065570.16411233810474878821.stgit@frogsfrogsfrogs>
In-Reply-To: <20240313014127.GJ1927156@frogsfrogsfrogs>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

At this point, we need to clean up the libfrog and xfs_scrub code a
little bit.  First, correct some of the weird naming and organizing
choices I made in libfrog for scrub types and fs summary counter scans.
Second, break out metadata file scans as a separate group, and teach
xfs_scrub that it can ask the kernel to scan them in parallel.  On
filesystems with quota or realtime volumes, this can speed up that part
significantly.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-metafile-parallel
---
Commits in this patchset:
 * libfrog: rename XFROG_SCRUB_TYPE_* to XFROG_SCRUB_GROUP_*
 * libfrog: promote XFROG_SCRUB_DESCR_SUMMARY to a scrub type
 * xfs_scrub: scan whole-fs metadata files in parallel
---
 io/scrub.c      |   13 +++--
 libfrog/scrub.c |   51 ++++++++++-----------
 libfrog/scrub.h |   24 ++++------
 scrub/phase2.c  |  135 ++++++++++++++++++++++++++++++++++++++++++-------------
 scrub/phase4.c  |    2 -
 scrub/phase7.c  |    4 +-
 scrub/scrub.c   |   75 ++++++++++++++++++-------------
 scrub/scrub.h   |    6 ++
 8 files changed, 194 insertions(+), 116 deletions(-)

