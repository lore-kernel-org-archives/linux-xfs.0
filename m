Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02318BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfB0Hpju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD2FC433C8;
	Sun, 31 Dec 2023 20:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053020;
	bh=/KqDNpinAldf86VLieBZw81nQuLu5fXCoPXNdH8ghz8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TfB0Hpju9Rk3fIvUXqV5IxC9IMSoLx16DHfvzjlH73R+2yhLpxD/AIKMDN+TzrHst
	 7X+Tz9xuAUWH4ZOzGrV0cNGEIjM2J0jH2LiP/JjPx7pIT1HFZOmHXKxZIadVgndOOi
	 aGwJDKGk1d17OMZfO4D4oiPIRgJOrrxswoTFszHdPlvGFVk5UoSNtBIz8N93qDbqew
	 hW+F+oHcMW3XL2R5IjStzA8WblsBm7NC1HFFItFzc7DWsZvO61/FTLE8jETmhhJcfz
	 VjcZ/BQ0xBir/d3o2c2TnhinNfSVwbQn/5AJ4gI/9kRVBos+Ff/2Tl6cCLZhZ6JBd8
	 lR3HYMQdGrAzg==
Date: Sun, 31 Dec 2023 12:03:40 -0800
Subject: [PATCHSET v2.0 1/4] xfs-documentation: document metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: darrick.wong@oracle.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405036960.1829793.10647088428067526884.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231182323.GU361584@frogsfrogsfrogs>
References: <20231231182323.GU361584@frogsfrogsfrogs>
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

This patch documents the metadata directory tree feature.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

Comments and questions are, as always, welcome.

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
 .../allocation_groups.asciidoc                     |   23 +++
 .../internal_inodes.asciidoc                       |  142 ++++++++++++++++++++
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |    5 +
 3 files changed, 165 insertions(+), 5 deletions(-)

