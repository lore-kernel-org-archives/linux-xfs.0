Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0853517E006
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724370986; cv=none; b=vCWYDiPrAfyOfqoqwiH46QBhw4fSa+OuPWrY8E3RjQg2DlohCma2Or9pZN6BCtY6D4RaedvA9fciXz5+jKaDm2olKmXkq+LiOxrqsOgXcC9mnRP7pzWsfwRWbaQoiTHiUTBL0tkIK553p7kdz3vB+VrrFOsEwJqOLz0yzoNHYag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724370986; c=relaxed/simple;
	bh=3tGLKUFAoCJt3CP7hBbkVE4gxmCotz8EQis/0XlRkU4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6qUeDm4sdtfChG09lLVT2DO1pz3/5neBVVB4pL8iqIKIP3yO/CPEeIbhshvxB/emjjVO4oq6iPUuZ87kQGMKH7r7HZDRbpOu61b6qsirFpIGvMGAqcc0vGIt/9lp3a+Ga+C5kZZnMKRH3EdqWD4Y4WRvc2/w13zQp6mm9rcXUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dkrao4X3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dkrao4X3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE33FC32782;
	Thu, 22 Aug 2024 23:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724370985;
	bh=3tGLKUFAoCJt3CP7hBbkVE4gxmCotz8EQis/0XlRkU4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Dkrao4X3X1lUm/TBgjTiD8+TEISpHo7CFNW7R5wsZu/k0VTtU3EQEHtgtnmYejfV/
	 BHkvLO1NTloGLnnt3ZrDTVNcfe14gvgED7a1WWq9aFRCMxffN19sdmA+Qr+jzRM1Fr
	 td77Qpjh/B+i+Dc0Rqmw4Z8aBMWXXQypQk6vSEML7QHSUJxO7XR7Ed7ZZhSa8AcIYW
	 bPxeDqlP1BLccBa1gXLvCHejWsW81CBi3PfMpxYORVA7lPGupGhVCnpv+SLVBq+oat
	 HhfT0l4m6KBIA5AyeOwtsDrtwl/c4kmc4u8lD+kAHmkpwZLgeJz9/aySIuTLyztwuS
	 L9Ueet1iiFpOQ==
Date: Thu, 22 Aug 2024 16:56:25 -0700
Subject: [PATCHSET v4.0 01/10] xfs: various bug fixes for 6.11
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, wozizhi@huawei.com,
 Anders Blomdell <anders.blomdell@gmail.com>, Christoph Hellwig <hch@lst.de>,
 willy@infradead.org, kjell.m.randa@gmail.com, Zizhi Wo <wozizhi@huawei.com>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
In-Reply-To: <20240822235230.GJ6043@frogsfrogsfrogs>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
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

Various bug fixes for 6.11.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.11-fixes
---
Commits in this patchset:
 * xfs: fix di_onlink checking for V1/V2 inodes
 * xfs: fix folio dirtying for XFILE_ALLOC callers
 * xfs: xfs_finobt_count_blocks() walks the wrong btree
 * xfs: don't bother reporting blocks trimmed via FITRIM
 * xfs: Fix the owner setting issue for rmap query in xfs fsmap
 * xfs: use XFS_BUF_DADDR_NULL for daddrs in getfsmap code
 * xfs: Fix missing interval for missing_owner in xfs fsmap
 * xfs: take m_growlock when running growfsrt
 * xfs: reset rootdir extent size hint after growfsrt
---
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 -
 fs/xfs/libxfs/xfs_inode_buf.c    |   14 +++++--
 fs/xfs/scrub/xfile.c             |    2 -
 fs/xfs/xfs_discard.c             |   36 +++++-------------
 fs/xfs/xfs_fsmap.c               |   30 +++++++++++++--
 fs/xfs/xfs_rtalloc.c             |   78 ++++++++++++++++++++++++++++++++------
 6 files changed, 114 insertions(+), 48 deletions(-)

