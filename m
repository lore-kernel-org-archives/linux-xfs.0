Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF09147C9B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 01:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638838; cv=none; b=kSwXuRL4bVOy7yLFltnB7iXlSJcRq33Asb6a+CoVqaHCUQbfV7I3HurpPEPrrK3gjFnlphaMM+s70Q9m4X2dVMj8tMzwf4zITpAecojMDYYj3rWXfKJ3q0X4+ornVFk2sNvuUj3XEMTVHmnGc5b5/d5sXZfH9xhUtkpnNss9V8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638838; c=relaxed/simple;
	bh=TgDouvyZ1Y417bPbbzfRWgs/FZYZ8HEtmD7s35xcaI8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=GSDhG7dsNNDteB/aT8nPnOdSlS6UmSoz/Xg6L5o3IGMMS7/h+jGzynQV6GYKoiuvz6Nsi7wXqe3n1NFIZpqFf+Cnkxv0dSd3Im6q0GEm3aVbtTSX5QDVAv9wiIfekor8GcRaSSZBigwCTnWIjibbdFZsAZl0c9OqkhbLf1urW9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQyxQVQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQyxQVQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE50C4CEF1;
	Tue,  2 Dec 2025 01:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764638838;
	bh=TgDouvyZ1Y417bPbbzfRWgs/FZYZ8HEtmD7s35xcaI8=;
	h=Date:Subject:From:To:Cc:From;
	b=IQyxQVQw4HP9JYedpGPuMM1caSbmZE22GoD1EbdrWD6x2Pr53s2qe71ec6MRxstix
	 Bq0KjFg6ROXQ5CZ8sAlvxquOTqiGnLvYFRWlzlGWujpjw79ZcC6AjutI55uvh6O3eY
	 C3Ys+FGb+Zj924DP58gGMArQUD+YtB1CXYeLc1qJTNTswc6trur1CL1EBS7WIOZtB1
	 OQZZNs+iU+2WerjeUGxdVo7ZBXWaJdeBYxBDKoPFu1HLtKCJdS6pNBY7te5CN2sfTT
	 4SfwP2bZg9rvRCxOrgli45IjfRp91fv1XXjJZbuFMyK2QbhgQf5ybwMpuFuanEZFsX
	 FZ2T2Qns3fOlg==
Date: Mon, 01 Dec 2025 17:27:17 -0800
Subject: [PATCHSET 1/2] xfsprogs: various bug fixes for 6.18
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176463876086.839737.15231619279496161084.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This is miscellaneous bugfixes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * libxfs: fix build warnings
 * xfs_db: document the rtsb command
 * man2: fix getparents ioctl manpage
---
 libxfs/util.c                   |    4 ++--
 man/man2/ioctl_xfs_getparents.2 |    2 +-
 man/man8/xfs_db.8               |    4 ++++
 3 files changed, 7 insertions(+), 3 deletions(-)

