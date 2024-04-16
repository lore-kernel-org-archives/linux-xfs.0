Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763A8631
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227447; cv=none; b=kLfZd8psuC3xjB5u+QZvQ1CJ+pvsw5fyddg+SnM5T4Wp1qz3d+3Wij0K7JEj4JU+MrcoOIVDFOaGSFM/D42YNWH+wO0ypuMtQuTB3XxyLjaZ9e0+jy58L1j/jycB7GvSoOU+wEFv72vECPeLWvSF6lHon5GEb7B82h+F4oO3C90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227447; c=relaxed/simple;
	bh=twgxwT9Z8XltrtYJQqGQCnPHXu/XPCy3s4HyyWAmtzM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=ecW+90rYlRtbD48+oAQTuUxk7ujmJPjViFWGdc8UpmLNP+PlPx6DAMuJLtJTtDlnsSgm9tHpgCx7zClsPfBdb/pSZ5aMGvT7E7muXOY63rL7A6KwIr5sTO6sydjrR44fdA9ga8aR4uERpajA5pU2N8D4yvtX4NgdvO+yapqyLM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILJIQ7Dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILJIQ7Dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3ADC113CC;
	Tue, 16 Apr 2024 00:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227447;
	bh=twgxwT9Z8XltrtYJQqGQCnPHXu/XPCy3s4HyyWAmtzM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ILJIQ7DxxjaJsxn0by6XyllnJybpJWOH3JwH4V4Hhm5D7oNv3oJzEkclmktolya5v
	 wWGr/coSlFJWijJ3orxrhDVdoJgONxbmslGrAB4Lvh4rgUNsuFyhRQoQ6O/Ra+F+St
	 LZfByglS3iZoYRk9ZmJKa0a4nTVD16UogIJp4E5wFTT1b9RB7q38kKUUkdDx/a1lGN
	 zXMqV3Weulq6NG1U/FUg3hsThR2iq2yQRGna1fner+A6YArTlqXOb1aFarxD6w+4L2
	 vFzLMAb09kHIpWdLwzh3FavCYypjRchlLYTvDRZCq0UtG835cnzmJwWS/oS6x9jbLU
	 J4+uwWJUIFbVQ==
Date: Mon, 15 Apr 2024 17:30:46 -0700
Subject: [GIT PULL 13/16] xfs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322718995.141687.5544842750949971895.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ab97f4b1c030750f2475bf4da8a9554d02206640:

xfs: repair AGI unlinked inode bucket lists (2024-04-15 14:58:58 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/inode-repair-improvements-6.10_2024-04-15

for you to fetch changes up to 1a5f6e08d4e379a23da5be974aee50b26a20c5b0:

xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype (2024-04-15 14:59:00 -0700)

----------------------------------------------------------------
xfs: inode-related repair fixes [v30.3 13/16]

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.  Fourth, the x{chk,rep}_metadata_inode_fork functions
should be subclassing the main scrub context, not modifying the
parent's setup willy-nilly.

This scattered patchset fixes those three problems.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: check unused nlink fields in the ondisk inode
xfs: try to avoid allocating from sick inode clusters
xfs: pin inodes that would otherwise overflow link count
xfs: create subordinate scrub contexts for xchk_metadata_inode_subtype

fs/xfs/libxfs/xfs_format.h    |  6 ++++
fs/xfs/libxfs/xfs_ialloc.c    | 40 ++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_inode_buf.c |  8 ++++++
fs/xfs/scrub/common.c         | 23 +++------------
fs/xfs/scrub/dir_repair.c     | 11 ++-----
fs/xfs/scrub/inode_repair.c   | 12 ++++++++
fs/xfs/scrub/nlinks.c         |  4 ++-
fs/xfs/scrub/nlinks_repair.c  |  8 ++----
fs/xfs/scrub/repair.c         | 67 +++++++++----------------------------------
fs/xfs/scrub/scrub.c          | 63 ++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/scrub.h          | 11 +++++++
fs/xfs/xfs_inode.c            | 33 ++++++++++++++-------
12 files changed, 187 insertions(+), 99 deletions(-)

