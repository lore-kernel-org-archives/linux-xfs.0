Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4229F18FDD2
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130909; cv=none; b=UawMwyHYFT8G1qBdpDSjU5Pfw81nisjhTRVpNolXHvHeeTPlDYhDBieePav25a22LpO2eyTsZieW5Em5DSb5t7uGaeiDrXYNG5OoczKAK/0exPBwU5zFw/dQrHByRoUbj9o1vIXj38Ry+vu1Dwwx4AxYeXkkXiMnyzbyjxcnGLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130909; c=relaxed/simple;
	bh=0GVmUSFOVq0CuGURGQXVHcs+mjzqRAmUqTtzN8yKUkw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eqdkX0BKlxJEFrQFxdSPSIJ9vg2e3M0Fi4/0LgPf6NqPLN/51Qk3U3KYy2wbc2IbXIW0wxfNTYR5ubM2NogkWR3Kwsg8mIoT7CPZQqM5deb/jHykbthztzy6uANlgc468EHFVyR49ZwQwYVlFvVilpyfFCiK9cpF8b+JXDP2pRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dqz4kl0t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dqz4kl0t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WNSygOA8Jm52UlTnQw+eA6erbcIEBD41gCRR4RWQBBg=; b=dqz4kl0tXAPTaBxg582pyiHrS6
	uG3og9hJJevTcxiuEcGptT2wAkRB3mHalM32RhTIUeV3+tZkbBkzg5JfEQ50XgfJ6nd9cK18yxvAQ
	EMgJ7rG6+256qpbN99RY10sXOdUqbx7HILoSfw/v9zW8sZI0FfnxgOh47SqekNzqRcD+dqmTwXSrK
	Us+BudP/FaHm8PEnTG5nyp+tme6+SDXs/xDAon56ukPTlw7UFnRKJnF0qSbkZE4+dvoJOoLceTCij
	W4bBvTPZH+hmGdx0UhwDk+vAYB69FRKLVn0Q7CkZrpDhojIeIkzncnGBNnjZs40JGSdWa3SSGVnzm
	1u4OAHZA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc53z-00000008kW2-2lp6;
	Thu, 08 Aug 2024 15:28:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: post-EOF block handling revamp v2
Date: Thu,  8 Aug 2024 08:27:26 -0700
Message-ID: <20240808152826.3028421-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series reworks handling of post-EOF blocks, primarily in ->release.
This takes over the work originally started by Dave in:

    https://marc.info/?l=linux-xfs&m=154951612101291&w=2
 
and lingering in Darricks's tree:

    https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=reduce-eofblocks-gc-on-close

for years to ensure ->release doesn't too eagerly kill post-EOF block
speculative preallocation and then goes on to not let preallocation
on inodes with the append only flag set linger forever.

I'll also post a rebased version of Dave's patches from back then.

The first patch has already been sent standalone and as part of Darrick's
fixes series, but as the rest of the series depends on it I'm sending it
here again - third time's a charm.

Changes since v1:
 - fix a few commit log and comment typos

Diffstat:
 xfs_bmap_util.c |   34 ++++++++---------------
 xfs_file.c      |   73 +++++++++++++++++++++++++++++++++++++++++++++++--
 xfs_icache.c    |    2 -
 xfs_inode.c     |   82 --------------------------------------------------------
 xfs_inode.h     |    5 +--
 5 files changed, 85 insertions(+), 111 deletions(-)
