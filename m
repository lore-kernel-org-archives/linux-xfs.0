Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737FA215771
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 11:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745581600; cv=none; b=gVJVqbOScny7LcvSk2B1iaS5qeq7mS5PN6V0zqkOO7d/7ET17y//Tlrh3OPHQtISfdyVr33qZvf52beTnBKZsBcP8rBk8+t0iF6db+0/jcAzsP4JH/Kyb0GcHZuOASY4I1YN9ydp4HzHEbxRqGSMbpgiWjy+0yRsZKHTAjxopDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745581600; c=relaxed/simple;
	bh=ha3eL2O/D2nXMKYgrhiLqMHDvtAaf5yIu652AaHJ5bo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I7yLrLePIGgbhKNUh6BDIIKcW4f568BpOIl4r6KuqHD9jVf8eVFs8gIUeZsOi8TXalZlvmpZIonDcIn5nsalAR+5ut3BYs9bVy3VNYYutT3nINsB/+BplbZ49FGNfEI8U6oVKX3mJdGBasLvs4nXFGZ3vOHUDyp1+o1ENQMNRLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=syxliSVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="syxliSVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A03C4CEEB;
	Fri, 25 Apr 2025 11:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745581599;
	bh=ha3eL2O/D2nXMKYgrhiLqMHDvtAaf5yIu652AaHJ5bo=;
	h=Date:From:To:Cc:Subject:From;
	b=syxliSVC9XkS37WmK33XFr+cCZz1xAvnBfGL1hJi5lRVaPN6JgC1TUyru6G/jafp9
	 ffvclUxQiuQQyOZIQ3tpX2cm37KMW2DQwU8YPzGV1OMP/LEv7y1Lx359bMqBqlPh8a
	 Jo4AbIJ3sWTgHIgQ3NGyC9JBTEQ/UOIEDV+Izva6qcYDkKZCfocSRskcnbLO13oX4p
	 vBZsb11+R8ggiAaWRo3zpJ3uapIzotmLTlq+vdbln1QJWS/5pCZ54JCIZ05ceOCLRk
	 gtzrATkxqMeOUf95K47LgplR/zY4pqY1/WrY6c2DAeaW81an3ADQ1uMNH1N51U4pYW
	 4rbwll6J6YQrA==
Date: Fri, 25 Apr 2025 13:46:36 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.15-rc4
Message-ID: <gohn2hjkdz2mm4nwedb5lc7djyitnv2h3mna6s55hg2qeafjff@lmd6u77nii2v>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

This contains a fix for a build failure on some 32-bit architectures and a
warning generating docs.

An attempt merge against your current TOT has been successful.

Thanks,
Carlos

The following changes since commit c7b67ddc3c999aa2f8d77be7ef1913298fe78f0e:

  xfs: document zoned rt specifics in admin-guide (2025-04-17 08:16:59 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.15-rc4

for you to fetch changes up to f0447f80aec83f1699d599c94618bb5c323963e6:

  xfs: remove duplicate Zoned Filesystems sections in admin-guide (2025-04-22 16:05:24 +0200)

----------------------------------------------------------------
XFS: fixes for 6.15-rc4

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Carlos Maiolino (1):
      XFS: fix zoned gc threshold math for 32-bit arches

Hans Holmberg (1):
      xfs: remove duplicate Zoned Filesystems sections in admin-guide

 Documentation/admin-guide/xfs.rst | 29 ++++++++---------------------
 fs/xfs/xfs_zone_gc.c              | 10 ++++++++--
 2 files changed, 16 insertions(+), 23 deletions(-)

