Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27DA1946BC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730418209; cv=none; b=b/ou7pt8yERmhj1bDazkwyBLWyOl7Cn7BJzuSEzTZVXYZ7q+wAPJucr1HEQvKzla8npaGCOrpt9xdW6ShQGvmfTS7BNfqMFgFyttIunPs65JbdAT5U65qhKunocTGJ0qLr26PcSvh71vZ5uQTVLAOt2u1FEhvoM305N4jrydD1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730418209; c=relaxed/simple;
	bh=uY3xj2F/n52NJC3T8pHCRBb4pcAvqlWPEab59fhlIVw=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=BTJIcJARW0dsrGuQGIWTunPkJw0r4BqdueWu5ty83zF7+J114dNy2kchHG7epXYPfHhxh5ol2j0x6GpfgUKGaGYUML6jIrrQfI2naCKCKyPDa7KV5t8FSGX3E82Wzkiq2vI2k+jDn9G1695XB/BuQT8OcvwmBbKIWwxu7HfcLjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uf78nbJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uf78nbJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC0EC4CEC3;
	Thu, 31 Oct 2024 23:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730418207;
	bh=uY3xj2F/n52NJC3T8pHCRBb4pcAvqlWPEab59fhlIVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uf78nbJ6ZC0UxOR0p3XCthSvGRrB2QrhlKftB876cx6Jkr2BgTGkl4YhnpHubrAku
	 66bYI4VFUXHlf+IDUNY3YsdOdGaVh5qUrxEjryRAUTbG523YBGFeBIS/GT38Y/uFBm
	 2ndSo2JYPg7tWXYo3BtmJLOM10dqAs/zhI1w+gjNtRRNCRhredlaJNJ2+1SbKhC8Ev
	 cbfnh3NFJ5bJqgWA+Fikf9Xt3aJ9f2O+DwGuesFHhSl30fzOnpGGX2NtQHAbEbbOCG
	 6e+Erl4c3AMlW8w9Wyy4X5PeBbmX4/6a9tACiqCOS7LlR3+6BJ2S7zgyIkrmLJ6T85
	 49vyxN2G+KGWA==
Date: Thu, 31 Oct 2024 16:43:26 -0700
Subject: [GIT PULL 4/7] xfs_metadump: support external devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173041764673.994242.698115173572630517.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 5f10590bae67d7698191a1392b6b1d3ce4d11a0c:

xfs_db: convert rtsummary geometry (2024-10-31 15:45:05 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/metadump-external-devices-6.12_2024-10-31

for you to fetch changes up to 5e8139658b798d931079404660273840432bcd9f:

xfs_db: allow setting current address to log blocks (2024-10-31 15:45:05 -0700)

----------------------------------------------------------------
xfs_metadump: support external devices [v5.3 4/7]

This series augments the xfs_metadump and xfs_mdrestore utilities to
capture the contents of an external log in a metadump, and restore it on
the other end.  This will enable better debugging analysis of broken
filesystems, since it will now be possible to capture external log data.
This is a prequisite for the rt groups feature, since we'll also need to
capture the rt superblocks written to the rt device.

This also means we can capture the contents of external logs for better
analysis by support staff.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs_db: allow setting current address to log blocks

db/block.c        | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
man/man8/xfs_db.8 |  17 +++++++++
2 files changed, 119 insertions(+), 1 deletion(-)

