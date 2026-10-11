Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187091C75F9
	for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2026 07:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791702336; cv=none; b=gya6qdwjIWgTQWU95icREH8cwmah+xRNXtOEOMwj4DM2E6ziux21FaBSdyxE5WKmIsPMxlkGn9xC+4GvtBDqUK7JLY94PvnqNjkN4k3bE9KpHRJTd1QjDM+dr/ix6vVXsGiEZ0d5MT+XXNrSsT5OA8DcC1rCpbxBRNJam0Q4o8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791702336; c=relaxed/simple;
	bh=rNbsw+Wquds4rdX+B+dFMQ7x9EKk1Z2hesWEqOofwbs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cMonFQl+z382nzYpWq529cRSoRHU77SMoaa7wPVPriiDM5/uqPT8aBYVAKEGphJFY01/kx70JJX7ho/S+hhWfmyDdaKfIh/C0VY0Vl0Cak2Ih0G0YWQoyexKjRObvnwSVTQtQhvGxp78wHpoKoWp2KfHRPJEW2u5LpIIKgAAeP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ae561yGk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ae561yGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A0D1F0089B;
	Sun, 11 Oct 2026 07:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791702334;
	bh=Y9LfFf5kas+Nlo00QssILp8wBQcoZjr6DGRnDrz5Kdk=;
	h=Date:From:To:Cc:Subject;
	b=ae561yGk3JKOWwZHX82yScm6I2dut9KqBiJmowqpR+cDqUjtBp2h0O9QaKnUHTlDL
	 4qE4v1sKTQkUORdrOaMOYCJ1D2SHE9ri1DTlr561nyda0brPua/NglMaB3GmYkdO1G
	 TrTRC2Y2pjcPbdjbrzwOpHjbNbEUeaDNQ08puHcxB9FtyQynbHLCN/BWr1hIMzdHQ7
	 3UKSF/AxCGbO3MYa/FmCPtiSMwmm1nk04f7tHHcMbUP81rJCeaDbL12Q4qU1znSxcA
	 FfvH7CT2SnSIJLlnJbQw70H8vTswMc6yqzeddEgAftl5oEkQwu3QYYEmX7ECTI5xyE
	 gudapvWKwAFsw==
Date: Sun, 11 Oct 2026 09:05:30 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.3-rc7
Message-ID: <asssVCAhqkG4d54b@cronus.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

The couple patches in this pull request fixes a data corruption vector
where an user could trick the exchange-range feature to add shared
blocks beyond the file's EOF, which may then be used to modify data on
another file.

I wasn't planning to send anything else before the merge window, so this
pull-request is a bit different from my regular workflow and the patches
are not in linux-next. But those patches are important enough to have
them in 7.3 if possible, without spending time on linux-next.

Thanks,
Carlos

"The following changes since commit a5ebb76233b79db01e82e061173cb73c6d2b5c6b:

  Merge tag 'edac_urgent_for_v7.3_rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras (2026-10-10 16:57:30 -0700)

are available in the Git repository at:

  gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.3-rc7

for you to fetch changes up to 7dfb218c829c1acb626e0fe92c5fddb9a26a03e9:

  xfs: fix exchange-range-to-eof file size exchange (2026-10-11 08:23:43 +0200)

----------------------------------------------------------------
xfs: fixes for 7.3-rc7

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
      xfs: fix exchange-range-to-eof file size exchange

Norbert Szetei (1):
      xfs: stop exchanging reflink flags when exchanging mappings

 fs/xfs/libxfs/xfs_exchmaps.c   | 93 +++++++-----------------------------------
 fs/xfs/libxfs/xfs_log_format.h |  4 +-
 fs/xfs/xfs_bmap_util.c         | 15 +++----
 fs/xfs/xfs_exchrange.c         | 51 ++++++++++++++++-------
 4 files changed, 58 insertions(+), 105 deletions(-)"
