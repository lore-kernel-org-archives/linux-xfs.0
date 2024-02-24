Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ED64A07
	for <linux-xfs@vger.kernel.org>; Sat, 24 Feb 2024 01:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738294; cv=none; b=POZH4XzsPu+ZrTd0oR4d+SL1Du+zTYsDawLSGdWPT3M++luQKGqGhHILNtDz5Mtiyd0o5x94Zpb6pH1CW7dVmFe5ckqguQ5DQx0q/0mLBRsJMPv8k4+g5Vmtp3c+GvGmjbrlb3RBuxK7tEmLNii4v/Fa4wBSL53LJG4ba6AWsew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738294; c=relaxed/simple;
	bh=U9olQcFxe+kYmPDtYLriwQWo3oAL9r+FtBkX3sr0Ws8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Q1T0C/Jr+Myb8darjqxFDRZZvYlb6rROx8zwEihVTwjFLC4XuEQ3fmkhfh/5B9gc7MIQ3TqRHJKtL09shavsZ6Jda9A5az6RYVVNGMIlKzyrr/f1uPGicIRdJV1YqEGFf7/6xN+etOoCsFbNx7X0MbE0gPrFAA7ePNvS2+oIzP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDTLmgvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDTLmgvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480B9C433F1;
	Sat, 24 Feb 2024 01:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708738294;
	bh=U9olQcFxe+kYmPDtYLriwQWo3oAL9r+FtBkX3sr0Ws8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hDTLmgvmOVixpRp4SM45DG3JokibzIDx5MROlQP0QtaY296DwSnQdmWpJUYB5GbzV
	 0fBU4TG9SnL6tSVdGUOrnoJruR8SJA9HWxm6MQQKYeMhj+cVY+dykL8qCcCaif/mXh
	 1PdSbsdl3nVt7UsyOdFld2eeThqz02IbB+ufhtniFR+mU2wUn4VZXnRVXWocIZntb5
	 k6jgr6kHr1wuGn4SbKWl/K0k2TgX2REnjGbaIJNbwjOmBcVpsjkzRXABe0XhFys3gP
	 wNRYs7jiDu6mCV1lNzKFQQF/Bmdsy0xnbWcwFXCd5Y8MLljfE0aeBmNV2Lwp2Yg84x
	 sg9MItC9tap+Q==
Date: Fri, 23 Feb 2024 17:31:33 -0800
Subject: [GIT PULL 10/18] xfs: btree readahead cleanups
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170873804279.1891722.10129509039878020958.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240224010220.GN6226@frogsfrogsfrogs>
References: <20240224010220.GN6226@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.9-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 79e72304dcba471e5c0dea2f3c67fe1a0558c140:

xfs: factor out a __xfs_btree_check_lblock_hdr helper (2024-02-22 12:40:59 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/btree-readahead-cleanups-6.9_2024-02-23

for you to fetch changes up to 24f755e4854e0fddb78d18f610bf1b5cb61db520:

xfs: split xfs_buf_rele for cached vs uncached buffers (2024-02-22 12:41:02 -0800)

----------------------------------------------------------------
xfs: btree readahead cleanups [v29.3 10/18]

Minor cleanups for the btree block readahead code.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (4):
xfs: remove xfs_btree_reada_bufl
xfs: remove xfs_btree_reada_bufs
xfs: move and rename xfs_btree_read_bufl
xfs: split xfs_buf_rele for cached vs uncached buffers

fs/xfs/libxfs/xfs_bmap.c  | 33 ++++++++++++----
fs/xfs/libxfs/xfs_btree.c | 98 ++++++++---------------------------------------
fs/xfs/libxfs/xfs_btree.h | 36 -----------------
fs/xfs/xfs_buf.c          | 46 ++++++++++++++--------
fs/xfs/xfs_iwalk.c        |  6 ++-
5 files changed, 76 insertions(+), 143 deletions(-)

