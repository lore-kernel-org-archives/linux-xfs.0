Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C1C1A3AAA
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302587; cv=none; b=Ob2ZSv35NW3hxeCDr0rqsyA/rbriBdVQHAHPKdQCHWGVYd04nAf+U8MdGA2opNb1NXTtZXq57aEAKIx0tP7bK6uDB6P6wHWn4tpbvZ/v9Fn/y69B2CFOF5a0urejDmZtyVS58prQLkI2y4QvQjEJrsIFGzWZwpMf5EOmS1wNyKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302587; c=relaxed/simple;
	bh=U+0+R0IWijuWeDp/EvCRiQ/0/+fBhy7cbCZvbYsrumE=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=gVdNfv05k1XneZvNJB1/OYLbjnFCndXu5omL5Fhxmodur0HF6XvQh2VRa8HjaeJJf8PKG4NrYWx1ocH+HKOcQChU4ksyQqciBD5JmtFl8ZYMOQDUnwZmCWSEShbccPwZC6LiA6z6IIaf0MXbrp2Z4kHmO/MqdfoN3+YkeXAAde4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p+X7xE5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+X7xE5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F223AC4CEC2;
	Mon,  2 Sep 2024 18:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302587;
	bh=U+0+R0IWijuWeDp/EvCRiQ/0/+fBhy7cbCZvbYsrumE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p+X7xE5ktZK+LDk9vsC0aFCtBwZ1kfZHHSwWtihe/g5wexsm2QCTIqGmx+akemCdX
	 qR9Qj6314+lygL61ok36oOktV4+eKrv0QmqiF0K5+AlE6X3yQBM0RtAd/QYA68Aa6u
	 k0JnezdgQTVw9tTAciybtSmtyn9+hxghirKd18AIrZOV1CsOWWAfs6YCadF4u+uTFK
	 G9Fn4TNdqYR9/PFI4pP3qLg+6JUEEPT5Naqo76+fr8AIqDmu+nMjsoqG8+Ixv0A1py
	 In5fO7ggsq38ohceKhMAShRYgqe6Ii1qlzx2GVsc48nVraqidVhFsIf/Ln1tbTx/AK
	 QY+1INYsKSR7Q==
Date: Mon, 02 Sep 2024 11:43:06 -0700
Subject: [GIT PULL 6/8] xfs: cleanups for quota mount
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172530248455.3348968.4210083940459711589.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240902184002.GY6224@frogsfrogsfrogs>
References: <20240902184002.GY6224@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.12-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 2ca7b9d7b80810b2b45b78b8a4b4fa78a1ddc2dd:

xfs: move xfs_ioc_getfsmap out of xfs_ioctl.c (2024-09-01 08:58:19 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/quota-cleanups-6.12_2024-09-02

for you to fetch changes up to 2c4162be6c10d3bc4884c211ae4787fc84c4fe3c:

xfs: refactor loading quota inodes in the regular case (2024-09-01 08:58:20 -0700)

----------------------------------------------------------------
xfs: cleanups for quota mount [v4.2 6/8]

Refactor the quota file loading code in preparation for adding metadata
directory trees.  Did you know that quotarm works even when quota isn't active?

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (1):
xfs: refactor loading quota inodes in the regular case

fs/xfs/xfs_qm.c          | 46 +++++++++++++++++++++++++++++++++++------
fs/xfs/xfs_qm.h          |  3 +++
fs/xfs/xfs_qm_syscalls.c | 13 ++++++------
fs/xfs/xfs_quotaops.c    | 53 ++++++++++++++++++++++++++++--------------------
4 files changed, 80 insertions(+), 35 deletions(-)

