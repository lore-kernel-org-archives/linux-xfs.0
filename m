Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3844C37163
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388531; cv=none; b=bsAxuj53cVEh3n6xcAfzgpMCVt6v06D7gFbW0VSiOLaRSYyFm4MuEO/kvRyLjVcG/jH3Wac/bcpKbLbNtrq99Vw3EvqqtMz0VIlWmi/TTderr1SvdF+ZO9kFTDF7myYEXfvhpd2JUE5A69iSJtwTb4cNo1oI96HoiYdCcrTD/Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388531; c=relaxed/simple;
	bh=QUcvTLe0kQbOEwaq1Cz591vaOZ0t0vaQXTGRrBMZ7VY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a6Gq1GNT96M0MZAu37mBecGTfcLUVjMelJYzfb/Lmq1XoLGm/qeasKPUW2+/fF9+RN3YYIkf19kKT5vkjVbtjExglK9nnHZbILcrDsyc7bRyCD4+yW9xujGXv28jCRXKfVJF/UuPZ3C8llQKeB89F+CGr5PtZKNvuVnV+F3PjiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZN31DMzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZN31DMzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B8CC072AA;
	Wed, 17 Apr 2024 21:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388530;
	bh=QUcvTLe0kQbOEwaq1Cz591vaOZ0t0vaQXTGRrBMZ7VY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZN31DMzZxFj/T7L+0WmfuXCq0Q/03Fm99dWG3boyHoG7xfIO2uX74UupZO7M0qvr1
	 BNqsy/lf0oES0rpZAZ2qF++jHOzLCIE5vdOMfGFN3SjI58Pto3uJ7wCWppOa4Dwywh
	 7/xJpxON4fkK7Yn7KMTEC6p1SSg30MvF0/yGJCIcw2lVW/rZDVDK52lhZX8rU9QzkU
	 MABxDbLy+w3uW4I+qLfhNAWWuRqE5KbRaE+iLyvyyYzuS1csPNfbyjIxR284w5Krt6
	 acIXKJVJWukXI3kZMxwBvuyTcfcjYH7gd6nJmZbiPNfcLn27cqzf0QxIZ2x5isgLDG
	 3/+VcATBhexuQ==
Date: Wed, 17 Apr 2024 14:15:30 -0700
Subject: [PATCHSET 01/11] xfsprogs: packaging fixes for 6.7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Bill O'Donnell <bodonnel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841078.1852814.8154538108927404452.stgit@frogsfrogsfrogs>
In-Reply-To: <20240417211156.GA11948@frogsfrogsfrogs>
References: <20240417211156.GA11948@frogsfrogsfrogs>
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

This series fixes some bugs that I and others have found in the
userspace tools.  At this point 6.7 is released, so these target 6.8.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=packaging-fixes-6.7
---
Commits in this patchset:
 * debian: fix package configuration after removing platform_defs.h.in
 * libxfs: fix incorrect porting to 6.7
---
 db/check.c            |    1 -
 debian/rules          |    6 ++++--
 include/libxfs.h      |    4 ++++
 libxfs/Makefile       |    1 +
 libxfs/xfs_rtbitmap.c |    2 +-
 libxfs/xfs_rtbitmap.h |    3 ---
 repair/rt.c           |    1 -
 7 files changed, 10 insertions(+), 8 deletions(-)

