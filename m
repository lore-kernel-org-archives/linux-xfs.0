Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC226AD7
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 05:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712121143; cv=none; b=ljULMywQqkppqpJWn8thwt37wHiR0v/aUco+JR6BZuT7FTuYA26PspDGcouzK40XY3pWEizljOji8KQ6Re5pezgh1j82EMG6sUSdBaUfb26F6v8UOWg5jAXOfvyhGXrk3QMPL52vALW9cHEF9oRIMfl/kPNNEDFKGJ1yzXq4saY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712121143; c=relaxed/simple;
	bh=h6q4k8cAWx7MqZtXkYY+m83l+3JR94Hk1Du3a/u1Fic=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gCa3RD73h6SLbOurIRnQfq8LrSjMuVX+XFJXPNNIf6Xy5E6mUVv+T8WRNz3eB3TynUqgJkX3XRHb3/+MBvxLHu0HnLJ8gNklQs+/dbQ24YQcAmbWeUcyqXN4kln9jYQlyNFUx36mJy2TvC+npgY3vZBU1qe+5zE8gdIPROfQwA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPGPTEDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPGPTEDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15C2C433F1;
	Wed,  3 Apr 2024 05:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712121142;
	bh=h6q4k8cAWx7MqZtXkYY+m83l+3JR94Hk1Du3a/u1Fic=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=sPGPTEDvC/woWHI61VR4RcgVeR1ZQ+KWuJantnNWeVPNlOhPEif1nE6O4w3ibEdcH
	 A1e/M44OMyejfBNcdBqb0nxNI+Iys8sJqvn9GOrdyskLGesyz8SMbZ79H56scKTy2U
	 1i3jn8boz6b5xvQk9y/2bRuX3f+kOP0KlET8Eh6Sj4GhBFFw4g4WKOCim5HIhFKSi7
	 6tVPyQbxUh9AoB464Jnbc6ueYndtmiac6p7Wxcqn2D3OBH6TlaE5wryqAh4kYjAF62
	 VGg9AJhT/MYENn23DftrlM/VA0TeI1+M/HJwBjPEio/zvZEDpzvW8aZfcqnkBnCIve
	 tG8SEaNpksolQ==
Subject: [PATCHSET v30.2] xfs: online repair of symbolic links
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Date: Tue, 02 Apr 2024 22:12:22 -0700
Message-ID: <171212114215.1525560.14502410308582567104.stgit@frogsfrogsfrogs>
In-Reply-To: <171150384345.3219922.17309419281818068194.stgit@frogsfrogsfrogs>
References: <171150384345.3219922.17309419281818068194.stgit@frogsfrogsfrogs>
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

The patches in this set adds the ability to repair the target buffer of
a symbolic link, using the same salvage, rebuild, and swap strategy used
everywhere else.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-symlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-symlink
---
Commits in this patchset:
 * xfs: expose xfs_bmap_local_to_extents for online repair
 * xfs: pass the owner to xfs_symlink_write_target
 * xfs: online repair of symbolic links
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_bmap.c           |   11 -
 fs/xfs/libxfs/xfs_bmap.h           |    6 
 fs/xfs/libxfs/xfs_symlink_remote.c |    7 
 fs/xfs/libxfs/xfs_symlink_remote.h |    7 
 fs/xfs/scrub/repair.h              |    8 +
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/symlink.c             |   13 +
 fs/xfs/scrub/symlink_repair.c      |  506 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.c            |   13 +
 fs/xfs/scrub/trace.h               |   46 +++
 fs/xfs/xfs_symlink.c               |    4 
 12 files changed, 609 insertions(+), 15 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c

