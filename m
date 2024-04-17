Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D0884D3F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 22:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713391797; cv=none; b=D3lBMdxqOx99Vh312rsb7vTlO5+/wBw3MuHaXYAMmt0TW2uVz9pgacJ+yG/S6v5uDleShjFVWKqjmEvDKxzfSTtat0gO3HNl/ISIxd3rhQzpA8JziH8p4UN/0tE9vB2QuhSZWnXlXWPvLRB2q3J8YHGs4cVo07t/esc05PpX/LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713391797; c=relaxed/simple;
	bh=8GD8N805yR9iHfyuY26GuXjLJjHCq3ffEEChskF/7zI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=hgCViMFDADGNIgzEMjDTHwNTmSzKAtA052iNxhePFP1xk/87F12fe8sbfnLElfLiZB8rOgB+cRovHNxO7WPP6Nj6nGFuoT36FbxyPWpBHrjpPdsYmqdZHGdF0xI5BbMirSLppzuwrkmFj+ZmJ4kZhJ8wxC5Zg2jI00Ygc0a5etg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEb92Yk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEb92Yk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11826C072AA;
	Wed, 17 Apr 2024 22:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713391797;
	bh=8GD8N805yR9iHfyuY26GuXjLJjHCq3ffEEChskF/7zI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dEb92Yk6sEhINolxVAiYEnL0eC70eClUIrS9DbKf/PKNvDNgmHSKcwsSOuwSF/OvM
	 4pC5xKI6FjCe4wQ5PaR0tkDuqtNKoik+mTKVwmOP4XF87xisV9SbbNidXXYe52b39n
	 5GT+IX65QsjW5sVpA2T1Xv4akAITqyjgYNtspNUkqXLk2TTXVO/01klq3OS9Z96heE
	 +Esn2Ef//3jGk8LFN/HbEnttrxBur9ymE7h8QzdrieD07J1m+gArkR466h/MO15ubO
	 knIB3J9Ap0r5TtVJ/pO9KmlMDk7PBitQXo1x4+bpj8AwxPaTq6godGeoXtOM9J1BSM
	 HOFjuplGBdjfA==
Date: Wed, 17 Apr 2024 15:09:56 -0700
Subject: [GIT PULL 10/11] xfs_repair: rebuild inode fork mappings
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: bodonnel@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171339161892.1911630.8944244918021763785.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240417220440.GB11948@frogsfrogsfrogs>
References: <20240417220440.GB11948@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit bd35f31ce91bcf5ed9370e94a4a5da89638f37f4:

xfs_scrub: scan whole-fs metadata files in parallel (2024-04-17 14:06:27 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/repair-rebuild-forks-6.8_2024-04-17

for you to fetch changes up to b3bcb8f0a8b5763defc09bc6d9a04da275ad780a:

xfs_repair: rebuild block mappings from rmapbt data (2024-04-17 14:06:28 -0700)

----------------------------------------------------------------
xfs_repair: rebuild inode fork mappings [v30.3 10/20]

Add the ability to regenerate inode fork mappings if the rmapbt
otherwise looks ok.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs_repair: push inode buf and dinode pointers all the way to inode fork processing
xfs_repair: sync bulkload data structures with kernel newbt code
xfs_repair: rebuild block mappings from rmapbt data

include/xfs_trans.h      |   2 +
libfrog/util.h           |   5 +
libxfs/libxfs_api_defs.h |  16 +-
libxfs/trans.c           |  48 +++
repair/Makefile          |   2 +
repair/agbtree.c         |  24 +-
repair/bmap_repair.c     | 748 +++++++++++++++++++++++++++++++++++++++++++++++
repair/bmap_repair.h     |  13 +
repair/bulkload.c        | 260 ++++++++++++++--
repair/bulkload.h        |  34 ++-
repair/dino_chunks.c     |   5 +-
repair/dinode.c          | 142 ++++++---
repair/dinode.h          |   7 +-
repair/phase5.c          |   2 +-
repair/rmap.c            |   2 +-
repair/rmap.h            |   1 +
16 files changed, 1231 insertions(+), 80 deletions(-)
create mode 100644 repair/bmap_repair.c
create mode 100644 repair/bmap_repair.h

