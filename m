Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C2859B46
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797405; cv=none; b=uUZ+nIBu8iEYo65XoxaTctSyXpnUA2XxQMGV/OA3zPvC/KRAccqpCdG/wl210/NT8ZmDgx1RdzUTrBSaVaYRjeSNJO0zeaEfuXdE8rWgAzPmUrJzNESrE8rI9rhwmacykULSbnCH/k9FtQFtaa8ZTlskoUQIKXRC2P9LwhOII70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797405; c=relaxed/simple;
	bh=WTSxfAA0Bj71WmDHjJ1KIwrY5RjEEIVyXjWrGD4ykXI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q02NKY9+E5GBm9COkGwMgeu10IzXZW7joUUAT0zSLV9W9YlPevW/Mf+Jb92jI3Eh5Tb3haeBKdlN/v2uMC4Pu4zSBPrrMTGLnUSp1BYO91VEXnz9XmsGLyUHUD2q2K5AFANIcYv965RjNQnVQW9/tgkHD6NM3lyWS0EXYdp9IP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugb9FEgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugb9FEgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EC9C433F1;
	Mon, 18 Mar 2024 21:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710797405;
	bh=WTSxfAA0Bj71WmDHjJ1KIwrY5RjEEIVyXjWrGD4ykXI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ugb9FEgmi7uslQvVzkwY1oBfROng3nCXslPW2WQnmNrB5E4lHL/AS+vFrQCAcM9VB
	 kHP5UhLqXp8LbklqEEEv98H5PUUb0Z6SBZxsaTw7DTSCixsKm+2xrXZnAW1zQeJaPF
	 yfPheQYVrhEE8J+g/u0kRXnSU914NLjBQBMc/zuRCmsTDaJzeAwiAeH/rpB4XsEesd
	 w2g4cYtZTw5ddx6EoEJ8HXSY8pzymMc1pf4LGzFd4XwDd1MBtzL95dF8PZ3KHpX4W1
	 RP1PuajEsOH2aaYI4MtRAhPO2fo16G9AaCP7Jk7wrSHfqQy+IgMe1GXV2tkCJ02UlG
	 pmuD0xX2rhFEg==
Date: Mon, 18 Mar 2024 14:30:04 -0700
Subject: [PATCHSET v29.4] xfsprogs: various bug fixes for 6.8
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171079732970.3790235.16378128492758082769.stgit@frogsfrogsfrogs>
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

More minor bug fixes.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-6.8-fixes2
---
Commits in this patchset:
 * xfs_db: fix alignment checks in getbitval
 * xfs_scrub: fix threadcount estimates for phase 6
 * xfs_scrub: don't fail while reporting media scan errors
 * xfs_io: add linux madvise advice codes
---
 db/bit.c       |    9 +++----
 io/madvise.c   |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/phase6.c |   30 ++++++++++++++++------
 3 files changed, 102 insertions(+), 14 deletions(-)

