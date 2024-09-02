Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EF819CC0A
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301325; cv=none; b=KmTMn8uzaUsN4ew7sk16NJX9wkxOV2Ny2V7SfD6+HU+jlwXUTt2kbwM8PQPY1M5oVUvKdtxPJ+9tZ9SoAenyEDP1ENhLcTxuTtNzrLcQxvgngibH42HxP+l9glN6KOoHt4XPb8JTGoF71akD6SsiUjNDA6xEqktgBFYHM6aFpn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301325; c=relaxed/simple;
	bh=QtLyiD4ZCN2IMcw1cQ84gCKwIhc3AxN0UIUFA8WAVl0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vBYhc8V1ZVoat9HPryRxThDkavQEFtopd6AKRJVdg0Zmqea1MFtAbmrUNydBUCoB2+VdphQOSrlpa2l582RO/Vw/naaTSY7igoEIj2W4tNaqZg0qrptbVhnzzdNH+KhRErC9vYav/9CvSXhajko5AzEJj6mjjV52hd5w90X4+/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QVd/EJiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QVd/EJiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC64C4CEC2;
	Mon,  2 Sep 2024 18:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301325;
	bh=QtLyiD4ZCN2IMcw1cQ84gCKwIhc3AxN0UIUFA8WAVl0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QVd/EJiCPm2na1GE5Q/hg0tiqCOTLQ43aXYlkVeR0zXyDEauszTVu+lSdXvb7otMc
	 vEwVBq908POrJwz5CY5+VJKDs4Jr6d1XP4HT3+xfRzW9fW5mtWznaCxVYXA6CFiWWx
	 dfFmuhuiafelLSZsLTyniouAX77DdP543yuX+8y+Nnsfekd2pWVasa7ktz0fMQ7McR
	 GqiTBx2eZlL4Hnuc1U2hreAiV25l640H/rqqR4c2wUjoLIMPAkwLyfI0upf7yrKzVW
	 ITgZhXrTHBy9JFae7CczgYnnFZD0GG+2h2iwqQkh/HpeecrnyrkUFiyvePbY6cayeP
	 eyDDJzdMI+UTw==
Date: Mon, 02 Sep 2024 11:22:04 -0700
Subject: [PATCHSET v4.2 5/8] xfs: cleanups for the realtime allocator
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
In-Reply-To: <20240902181606.GX6224@frogsfrogsfrogs>
References: <20240902181606.GX6224@frogsfrogsfrogs>
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

This third series cleans up the realtime allocator code so that it'll be
somewhat less difficult to figure out what on earth it's doing.  We also
rearrange the fsmap code a bit.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rtalloc-cleanups-6.12
---
Commits in this patchset:
 * xfs: clean up the ISVALID macro in xfs_bmap_adjacent
 * xfs: factor out a xfs_rtallocate helper
 * xfs: rework the rtalloc fallback handling
 * xfs: factor out a xfs_rtallocate_align helper
 * xfs: make the rtalloc start hint a xfs_rtblock_t
 * xfs: add xchk_setup_nothing and xchk_nothing helpers
 * xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
 * xfs: replace m_rsumsize with m_rsumblocks
 * xfs: rearrange xfs_fsmap.c a little bit
 * xfs: move xfs_ioc_getfsmap out of xfs_ioctl.c
---
 fs/xfs/libxfs/xfs_bmap.c        |   55 +++--
 fs/xfs/libxfs/xfs_rtbitmap.c    |   33 ---
 fs/xfs/libxfs/xfs_rtbitmap.h    |    7 -
 fs/xfs/libxfs/xfs_trans_resv.c  |    2 
 fs/xfs/scrub/common.h           |   29 +--
 fs/xfs/scrub/rtsummary.c        |   11 -
 fs/xfs/scrub/rtsummary.h        |    2 
 fs/xfs/scrub/rtsummary_repair.c |   12 -
 fs/xfs/scrub/scrub.h            |   29 +--
 fs/xfs/xfs_fsmap.c              |  402 ++++++++++++++++++++++++++-------------
 fs/xfs/xfs_fsmap.h              |    6 -
 fs/xfs/xfs_ioctl.c              |  130 -------------
 fs/xfs/xfs_mount.h              |    2 
 fs/xfs/xfs_rtalloc.c            |  246 ++++++++++++++----------
 14 files changed, 477 insertions(+), 489 deletions(-)

