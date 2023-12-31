Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC790B666
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqXXHXiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DB5C433C7;
	Sun, 31 Dec 2023 19:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051144;
	bh=72or/JDMCgZK02a7ZAko0XXryquJPFpAhbFe9SCwM3s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IqXXHXiFLBo/X1jM7fS/0aVUwDm02N7FvkTjomFLyrnX7/hunv5kpYMjXrYESyiI0
	 K73qmhSixyEoRA7Teb/3kOvK2uK2RMZOEs1UBicYRaZH10s2S5l9S0x93PKtN2VX4t
	 3h5MMEZtGK5dLpmt8OIHtgjLNHTSmQDAFFGmUU/0d0vuS2czeuREJSOUe3kTMYYBFx
	 klKtE9nsJWvWh0Iclij4+PuE/iV9TS6QyLyrRj2LupmU6rJDelalhTKaVqFjSbGRa1
	 EuUJcuNs1hHIlkGfKC0ajkk62Lun6nKsE6SVA2P7WaHhUxVF8oifiXeRzC+zdyixe9
	 ejpCNkozrQIkw==
Date: Sun, 31 Dec 2023 11:32:24 -0800
Subject: [PATCHSET v29.0 27/28] xfs: inode-related repair fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404837990.1754231.2175141512934229542.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181215.GA241128@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
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

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.  Fourth, the x{chk,rep}_metadata_inode_fork functions
should be subclassing the main scrub context, not modifying the
parent's setup willy-nilly.

This scattered patchset fixes those three problems.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-repair-improvements

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-repair-improvements
---
 fs/xfs/libxfs/xfs_format.h    |    6 ++++
 fs/xfs/libxfs/xfs_ialloc.c    |   40 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    8 +++++
 fs/xfs/scrub/common.c         |   23 ++------------
 fs/xfs/scrub/dir_repair.c     |   11 ++-----
 fs/xfs/scrub/inode_repair.c   |   12 +++++++
 fs/xfs/scrub/nlinks.c         |    4 ++
 fs/xfs/scrub/nlinks_repair.c  |    8 +----
 fs/xfs/scrub/repair.c         |   67 ++++++++---------------------------------
 fs/xfs/scrub/scrub.c          |   63 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.h          |   11 +++++++
 fs/xfs/xfs_inode.c            |   33 +++++++++++++-------
 12 files changed, 187 insertions(+), 99 deletions(-)

