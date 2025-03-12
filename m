Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEA81B0406;
	Wed, 12 Mar 2025 23:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741821031; cv=none; b=DKAHUWrrDWmTsggYt4WWxUd8knXGvKu6tBTFALqtkVuc1gpJE5kg5AqFKPHHmRgpYXNCxzXXoF9/TmbC3WtnMz1cXoHrRt/QCPpvLBLUVTJAeO5GJiHZMiHzZpA55OXiP72hw8CVk0Hk/VTvUmC82fjbiDhNA58ribiOzm9Ebco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741821031; c=relaxed/simple;
	bh=Ixs7udQQv3kNJo4JQ3W8IgW8eYlnlkZOkIjXWUD5d1E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWmIOUX/zBGhL2F39JcppzvEO33AMUZht8PKUg1hiI9TlzCYFx7+9LYqHZy5oXl43DvyfOSDHjDRDr0s5FgkFd9jugQDldvjqhsOaXqlqNFqxjE857vSriCtBhtrkgq4khQGB0Z8VvT6ncnzB3N+Dii/8PX5CykiKxYzCDoOg7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LceK9wri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LceK9wri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89051C4CEDD;
	Wed, 12 Mar 2025 23:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741821030;
	bh=Ixs7udQQv3kNJo4JQ3W8IgW8eYlnlkZOkIjXWUD5d1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LceK9wri+czEJNiJ4Rnovuj9xb3q4Jxxta2A667p6/XJ2DErSIxXRTs97s5VK1yg7
	 R6ln2NNf1qGUjlnuvgi72hEkR5dgJJtyQ/Ar42miB+0RSYLFKA7EnmQDhY9ntlKh3Q
	 7E4VG6W0OgP0bSt2doDAt98rufeZKl1c/gkv5mvCgFU2nYbez6GBI4gbgEhjvG4vW+
	 9odXw57YtVkKvScnsC0dxHkd+rAuGYIwp8xnJuUNQf4Fy3wjoprY0DXp/UNVmW7Dyg
	 lEWdeFbP3/S6Txroa9XrLIN7vkCUrgXdFbgETX0j8MLzybBWZK2n2CkakWESt6FxPE
	 kaLyrqVHeFs7w==
Date: Wed, 12 Mar 2025 16:10:30 -0700
Subject: [PATCHSET 2/3] fstests: test handling emoji filenames better
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174182088871.1400612.1677368898700125822.stgit@frogsfrogsfrogs>
In-Reply-To: <20250312230736.GS2803749@frogsfrogsfrogs>
References: <20250312230736.GS2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Ted told me about some bugs that the ext4 Unicode casefolding code has
suffered over the past year -- they tried stripping out zero width
joiner (ZWJ) codepoints to try to eliminate casefolded lookup comparison
issues, but doing so corrupts compound emoji handling in filenames.

This short series amends the Unicode testing in generic/453 and 454 to
examine these compound emoji.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-emoji-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-emoji-fixes
---
Commits in this patchset:
 * generic/45[34]: add colored emoji variants to unicode tests
---
 tests/generic/453 |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/454 |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

