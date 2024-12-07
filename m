Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423E438B;
	Sat,  7 Dec 2024 00:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733531452; cv=none; b=uJ0WxBmwRws6/wU36oTaTwpFfFjAe5gWJB+pxoyYKn3jkqQVXIr4dOdfcuNKDyA3jnKTGt++/rt3IAdET3KrnJbbdr43HEpbLVIyHsUYTGdcpGA8onM566p7PBKxi7j2jtnnbaifGkDwEHNoKuPM23GmpVKtzhathLbN84yZTm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733531452; c=relaxed/simple;
	bh=+EGBjFJJTK4YCjQXXE0VSHIzdvb1UvaTtYYmrpOlino=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tyUq6ldONQCOhpaKSQo72RVt+WCNqEVTrpTZJNxLN/XwDmUk+YYulrKN412eg2BHwNDcFsdlUVdcmDkzQ6N4wQcaskaj0ayRSJPVCky2PwsqON9yTUMT08SIuEoH++cwCeyWmv2xRDNRA2yjntQWv/LQV5fPcjC0CvTwSro9NRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pG+Ea8g7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pG+Ea8g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC8AC4CED1;
	Sat,  7 Dec 2024 00:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733531451;
	bh=+EGBjFJJTK4YCjQXXE0VSHIzdvb1UvaTtYYmrpOlino=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pG+Ea8g7Cx621oJRU4d9Ehbw9ry3VOj7FIYCp4OuLuCrRZjRdxnFFLIGtjRDHmR13
	 uJ1XtE7YsGU3/lI/wGlGxXdTDf7s43bVHC+bDOJZ7H2nmNfAxymENZkyx2xK/Tx5pY
	 XamwteqjLA5bPmCGDJikY+UGvHcIrYMk24IDOs7umE5UP4gKmO9j27FC+x+EWU1i8n
	 R13F+2vv8rk+wtVwuobyRLrg+wKiIqSn1rFvgbqfBgJeZKvsmrGdyqeFS8YI2Tfexp
	 S24MDxO8cWhia7WS7ftNcpLIYqerzdqMUUeMcKuhO52PKJaUIGVHBK7Hhbp32iM4G1
	 Lr6MxYP/rDsfw==
Date: Fri, 06 Dec 2024 16:30:51 -0800
Subject: [PATCHSET v3] xfs: proposed bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: jlayton@kernel.org, hch@lst.de, stable@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <173353139288.192136.15243674953215007178.stgit@frogsfrogsfrogs>
In-Reply-To: <20241207002927.GP7837@frogsfrogsfrogs>
References: <20241207002927.GP7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here are even more bugfixes for 6.13 that have been accumulating since
6.12 was released.  Now with a few extra comments that were requested
by reviewers.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=proposed-fixes-6.13
---
Commits in this patchset:
 * xfs: don't move nondir/nonreg temporary repair files to the metadir namespace
 * xfs: don't crash on corrupt /quotas dirent
 * xfs: check pre-metadir fields correctly
 * xfs: fix zero byte checking in the superblock scrubber
 * xfs: return from xfs_symlink_verify early on V4 filesystems
 * xfs: port xfs_ioc_start_commit to multigrain timestamps
---
 fs/xfs/libxfs/xfs_symlink_remote.c |    4 ++
 fs/xfs/scrub/agheader.c            |   71 ++++++++++++++++++++++++++++--------
 fs/xfs/scrub/tempfile.c            |    3 ++
 fs/xfs/xfs_exchrange.c             |   14 ++++---
 fs/xfs/xfs_qm.c                    |    7 ++++
 5 files changed, 76 insertions(+), 23 deletions(-)

