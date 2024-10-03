Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B699D1E52C
	for <linux-xfs@vger.kernel.org>; Thu,  3 Oct 2024 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727968092; cv=none; b=t4Appn/J/ODGZA2ibRlWlJWUTP33IlRJNDwke6Qp1vySD7/fAukDxCW1TjD//wfw7Re5RZca2S7xma60fpRzGG71yGC0DnidY4apR5aGMbzgTWIpqonCNGiaKbVuhelVfZwsw2Sf9pZcnvJC/QfBNqvmnIyzLCTA0gqS9tag+1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727968092; c=relaxed/simple;
	bh=bYHbMDFdgJDEt8lUvQXp1KBTl3OYgaXTHCRAdASXRj8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=fo0HosYCx4nynaGUv9J8BaB9CbFlCM4XMfkujD4IWSwdnbyoVBx3nTiTGRrc3l/YsrX1vY4rZSmJc0DkHu/kBNXLcSB4kGsw2Lk57rg+rjaMljmbZqCXb405TrDB4MfSLwsXXKyqC13PgxL7yC9ScVO5zs3OWEkYO7MkBrWspvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YP4gTBuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YP4gTBuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263F4C4CEC5;
	Thu,  3 Oct 2024 15:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727968092;
	bh=bYHbMDFdgJDEt8lUvQXp1KBTl3OYgaXTHCRAdASXRj8=;
	h=Date:Subject:From:To:Cc:From;
	b=YP4gTBuCINrfGxWSXAjfKovKSUAdDgrvQ6DBLp1X87I9Z5zEqnD59lFBpYh12nN6A
	 9G6pZlIXIubV9vgnIwEEpSkwNRnkEWY2v//eqij7jWmgoqAE1hOHyYKZ4fLZ4OVzRv
	 v0oyVPvq8w3oBjF41dVzSje1EtuDjpsM1syxqV05GJMO681SVwZpcJQ/F8p4Ab1/sx
	 sNPibk/XWNwU0z1FXGLlGNEa9sLig6yqd2xK9Br8aDStdSAGMysGfpUONylnq+akls
	 0xg2EjBUEeVbJrONG4lcpgUpZggIEPmbFKRQIHIOHgvil+qnmKFB2xrT+v0aZ9y/cU
	 9srBqV3D8OhEg==
Date: Thu, 03 Oct 2024 08:08:11 -0700
Subject: [PATCHSET] fsdax/xfs: unshare range fixes for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: brauner@kernel.org, cem@kernel.org, willy@infradead.org, djwong@kernel.org
Cc: ruansy.fnst@fujitsu.com, linux-xfs@vger.kernel.org,
 ruansy.fnst@fujitsu.com, hch@lst.de
Message-ID: <172796802770.1129629.8841039898082413241.stgit@frogsfrogsfrogs>
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

This patchset fixes multiple data corruption bugs in the fallocate unshare
range implementation for fsdax.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D
---
Commits in this patchset:
 * xfs: don't allocate COW extents when unsharing a hole
 * iomap: share iomap_unshare_iter predicate code with fsdax
 * fsdax: remove zeroing code from dax_unshare_iter
 * fsdax: dax_unshare_iter needs to copy entire blocks
---
 fs/dax.c               |   49 +++++++++++++++++++++++++++++-------------------
 fs/iomap/buffered-io.c |   30 ++++++++++++++++-------------
 fs/xfs/xfs_iomap.c     |    2 +-
 include/linux/iomap.h  |    1 +
 4 files changed, 48 insertions(+), 34 deletions(-)

