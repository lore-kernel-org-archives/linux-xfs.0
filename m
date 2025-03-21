Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679D813B59B
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742574660; cv=none; b=lzxuZH2ML+PO//DveWfWZUAFfnj5I3VPfkLRlfeibewK5krB3OBvaXt57VxdoFlJ3ie4krM0eHS1k9X4G/rPMdPkb+7ZzvxtB+N2og9d5OHcZjeNKaG3MHkqGi28YvgfY+NhzKrTeYDTSSSjAUZGYgsUt+MwnFFcD8aDLLntMz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742574660; c=relaxed/simple;
	bh=3h1fHokV8iz5vUxoVIuG9h3wd49aHE3GxK28e6lxAAw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZOjQ2tvS25r8fvx/BF3or6hRDa5YD6qzxuQmo50yLSrgwmnFMOftzQ1uLn2l8wfaC7YDD/4zKnPvkyNhp301niCUS+bPFwKMKmimc7Dg+zrzcahA4xobvxDkPpDhvaODY+nMnmqgX/kcD0VrjQ3bCuXw856fkYfMYWZp4XTrXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RerzGXVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RerzGXVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31120C4CEE3;
	Fri, 21 Mar 2025 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742574660;
	bh=3h1fHokV8iz5vUxoVIuG9h3wd49aHE3GxK28e6lxAAw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RerzGXVejrksyKp+2gwJo1aG/3vf3BJtG2wgEmkxEcOxQEVqhVHrzMp4C64Nfiggo
	 kASisbxg+vNyO0BGTpYjljpJqPHDyBwnXA1xrWd6BpirWxGUkgNTF592+RAqMDzjCx
	 TDBDs05PbAMS78ZhbKT4hfgPhRj4aV/XdPnYXrZNGJ0yD6dB0F++rO3CnEumJVvmwg
	 dgTWwC3Q0+0AnyaDFzScc5VN8WM0iRQI9psCBrO5+WpFdHq/DsISylSEFzMG7lAERA
	 GqOeUXLZKwef9ScDfXVxPY8gVAWu+KJ7wOiz2DGNj1M0DZV702lssSaTTdb5rV9BIK
	 DPE6C/9BCKI6g==
Date: Fri, 21 Mar 2025 09:30:59 -0700
Subject: [PATCHSET 2/2] xfsprogs: random bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
In-Reply-To: <20250321162647.GN2803749@frogsfrogsfrogs>
References: <20250321162647.GN2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a pile of assorted bug fixes from around the codebase.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
Commits in this patchset:
 * xfs_repair: don't recreate /quota metadir if there are no quota inodes
 * xfs_repair: fix crash in reset_rt_metadir_inodes
 * xfs_repair: fix infinite loop in longform_dir2_entry_check*
 * xfs_repair: fix stupid argument error in verify_inode_chunk
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/dino_chunks.c     |    2 +-
 repair/phase6.c          |   41 +++++++++++++++++++++++++++++++++++++----
 3 files changed, 39 insertions(+), 5 deletions(-)

