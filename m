Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E2438AC97;
	Wed, 24 Jun 2026 08:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782291587; cv=none; b=sStYNrrdl+wjUc71SEu/yjzpccfcjLGe+ZXp+TIhqZdD41qcORjdaomoBKsmRJOf6Hu4RANCliA+vaxSP3pZty9FEn1ZKQu1SUBjmKKvyHkqD4ZiflE4FXSgDN5hTIhJjTM6/3wC7o2MzkRLPU/aWttFf8663VAzj3Jz2OGakq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782291587; c=relaxed/simple;
	bh=/0Sz/YOr0sVnKyQmmyAwFm230F+4bjpS+AEXLTRDbdU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rezDc5tGrTfiPwJAum21uTOfwSjmPrRK8nRapoED8dNm+pmQN+GHH09EPdAUUkkiJP36GyTcagS9FVm1+2nWTeatB16qLeCCHfY4I2TbV6EXlPG4VOmOwkL9+LQGTMRpBohhKuDPizaBJlis9NzdclbFat4C5ZoL0XG8f8JTZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ahzIbRZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahzIbRZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54151F000E9;
	Wed, 24 Jun 2026 08:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782291583;
	bh=H7dnvEvzEKYGFsUTzy9ti4ZW1NJZkg7pmn7MPJihWl4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ahzIbRZIetUQgFo/22vOgZ+uJ+97WPRTt/pD3GlCEztRscpy02/0ux3ViqsxEjkwO
	 easG6XV6XLRJJVyWE9Z9050kasspIvARRFZ+l6aqhTOBnE1iiYMWKHWeJ+rVNV9mfJ
	 xI+jJfGnaFu71F5uEdtDR6kUbrg2DaN18xdzdDOmCGP4fORzHuSNP16EfO9WJAjZwJ
	 zOiIG4gJkvSO6uM5Z8Kyiu1r10iziRQCVv4wj5mgXjIxk2KAFL19/uqEkRlXia6V/1
	 p+iVRA8Y3rG9f/KUr9NezdPkNUNKX4KZKRf7iTlHbxXfa5t5CMQKTcD5pm+yjhkN0N
	 dYZZAtdBS9Ghg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19A2E39EF964;
	Wed, 24 Jun 2026 08:59:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH v9 01/22] fsverity: report validation errors
 through fserror to fsnotify
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <178229157279.2577930.17428386350924230713.git-patchwork-notify@kernel.org>
Date: Wed, 24 Jun 2026 08:59:32 +0000
References: <20260428083332.768693-2-aalbersh@kernel.org>
In-Reply-To: <20260428083332.768693-2-aalbersh@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, djwong@kernel.org,
 linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-ext4@vger.kernel.org, hch@lst.de, linux-btrfs@vger.kernel.org

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Christian Brauner <brauner@kernel.org>:

On Tue, 28 Apr 2026 10:33:07 +0200 you wrote:
> Reported verification errors to fsnotify through recently added fserror
> interface.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,v9,01/22] fsverity: report validation errors through fserror to fsnotify
    (no matching commit)
  - [f2fs-dev,v9,02/22] fsverity: expose ensure_fsverity_info()
    (no matching commit)
  - [f2fs-dev,v9,03/22] ovl: use core fsverity ensure info interface
    (no matching commit)
  - [f2fs-dev,v9,04/22] fsverity: generate and store zero-block hash
    https://git.kernel.org/jaegeuk/f2fs/c/07d09774e2bf
  - [f2fs-dev,v9,05/22] fsverity: pass digest size and hash of the all-zeroes block to ->write
    (no matching commit)
  - [f2fs-dev,v9,06/22] fsverity: hoist pagecache_read from f2fs/ext4 to fsverity
    (no matching commit)
  - [f2fs-dev,v9,07/22] iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle fsverity
    (no matching commit)
  - [f2fs-dev,v9,08/22] iomap: teach iomap to read files with fsverity
    (no matching commit)
  - [f2fs-dev,v9,09/22] iomap: introduce iomap_fsverity_write() for writing fsverity metadata
    https://git.kernel.org/jaegeuk/f2fs/c/36a36c4cac91
  - [f2fs-dev,v9,10/22] xfs: introduce fsverity on-disk changes
    (no matching commit)
  - [f2fs-dev,v9,11/22] xfs: initialize fs-verity on file open
    (no matching commit)
  - [f2fs-dev,v9,12/22] xfs: don't allow to enable DAX on fs-verity sealed inode
    (no matching commit)
  - [f2fs-dev,v9,13/22] xfs: disable direct read path for fs-verity files
    (no matching commit)
  - [f2fs-dev,v9,14/22] xfs: handle fsverity I/O in write/read path
    (no matching commit)
  - [f2fs-dev,v9,15/22] xfs: use read ioend for fsverity data verification
    (no matching commit)
  - [f2fs-dev,v9,16/22] xfs: add fs-verity support
    (no matching commit)
  - [f2fs-dev,v9,17/22] xfs: remove unwritten extents after preallocations in fsverity metadata
    (no matching commit)
  - [f2fs-dev,v9,18/22] xfs: add fs-verity ioctls
    (no matching commit)
  - [f2fs-dev,v9,19/22] xfs: advertise fs-verity being available on filesystem
    (no matching commit)
  - [f2fs-dev,v9,20/22] xfs: check and repair the verity inode flag state
    (no matching commit)
  - [f2fs-dev,v9,21/22] xfs: introduce health state for corrupted fsverity metadata
    (no matching commit)
  - [f2fs-dev,v9,22/22] xfs: enable ro-compat fs-verity flag
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


