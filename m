Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51D880C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 00:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713227415; cv=none; b=FPqHsXv3y9v1l2ciQbx5joCCutbhaSxq4xJnA2/k26OzDBPmSuhH+ddTP9nETVq1vgNkj45cMB9hf9+eJPIXx75BxM/qKpfPXnxijW8zzo3rFzUSaoUPJsd9jZytKr8/1fHwbKfrBOs/GimtOqlJ08vr+ITj52jdHJSvgylmcys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713227415; c=relaxed/simple;
	bh=wmQgdrhkb7nCdD13c8QmBA8PoCAz/Tr8/ad7ni+hiso=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=nsUtAu/uV1YupxldjVoX/5sKfpyQuzxo41zbXTFU4ojp+kuwReza063MOhZrD86yRWHaXxRo6rFuTlj1M0I8tQoggLfC5sr+xMcJJk40ClKBOj4sLgku6pKiqsRTqkE/rxGf0DQgcNAGrdTpzdWjq+iB20aBt7/8RMPhexrtguI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPeJCPaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPeJCPaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8633C2BD11;
	Tue, 16 Apr 2024 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713227415;
	bh=wmQgdrhkb7nCdD13c8QmBA8PoCAz/Tr8/ad7ni+hiso=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iPeJCPaHcAyfiVEBdyNIv9ArvwfykTC7gVIpM9qj/MRmKZIPC9y9NWYxT1ATZORgU
	 fyfEgbqfp3jaxMNhEZiT0vPemiW5z6w4hGKNIJxsBJymYWRju54h2kq9yYSvrCKt//
	 6VXFa5XIPL+MK+ldY/fKUFUczJSKXK9xoLjyOSG0Ya9ZQwvLuTeJXiFzL2QfeMRng5
	 yrFjzTL9LnAun+uz/4A2EczfaXZnhkQ1v2YOwdVLSED5IgIE/+In4p4kzGzVD7x5qv
	 iQLXVzxYpPL0VTizmqrytoB7+/EQDxmLe81aLcky/k8P95dEX82V+hENxieRl59NFx
	 T1+BZ/yeYl2EA==
Date: Mon, 15 Apr 2024 17:30:15 -0700
Subject: [GIT PULL 11/16] xfs: online repair of symbolic links
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322718349.141687.12197636853097567311.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240416002427.GB11972@frogsfrogsfrogs>
References: <20240416002427.GB11972@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 73597e3e42b4a15030e6f93b71b53a04377ea419:

xfs: ensure dentry consistency when the orphanage adopts a file (2024-04-15 14:58:57 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-symlink-6.10_2024-04-15

for you to fetch changes up to 2651923d8d8db00a57665822f017fa7c76758044:

xfs: online repair of symbolic links (2024-04-15 14:58:58 -0700)

----------------------------------------------------------------
xfs: online repair of symbolic links [v30.3 11/16]

The patches in this set adds the ability to repair the target buffer of
a symbolic link, using the same salvage, rebuild, and swap strategy used
everywhere else.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: expose xfs_bmap_local_to_extents for online repair
xfs: pass the owner to xfs_symlink_write_target
xfs: online repair of symbolic links

fs/xfs/Makefile                    |   1 +
fs/xfs/libxfs/xfs_bmap.c           |  11 +-
fs/xfs/libxfs/xfs_bmap.h           |   6 +
fs/xfs/libxfs/xfs_symlink_remote.c |   7 +-
fs/xfs/libxfs/xfs_symlink_remote.h |   7 +-
fs/xfs/scrub/repair.h              |   8 +
fs/xfs/scrub/scrub.c               |   2 +-
fs/xfs/scrub/symlink.c             |  13 +-
fs/xfs/scrub/symlink_repair.c      | 506 +++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/tempfile.c            |  13 +
fs/xfs/scrub/trace.h               |  46 ++++
fs/xfs/xfs_symlink.c               |   4 +-
12 files changed, 609 insertions(+), 15 deletions(-)
create mode 100644 fs/xfs/scrub/symlink_repair.c

