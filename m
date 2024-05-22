Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB26360
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 06:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716357701; cv=none; b=Nq3NIAShh2uVndLRsduIg9+3XG4ft4YuARLdD7jBF32gcsqrpU6oN7U6N2AbBYAX7q696sbcMt9T+ideQlvnCz9xauq8g5e82DOR3Pu73Z48QjOaw5y69MOqZrcyWDiUonkf97RmE/lP56YD/qsl05/W4AF43dTLTgd5pVIjIYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716357701; c=relaxed/simple;
	bh=l2LAqe3eB2nS8+yQgVDnpAZfIGt1OItuiXqyskxj4u0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=t/qZJi8EcM9hIboAwTP1Ds4r4BZDi4gRgWZH5dtrwSgtnOZwXC9OajUVYIOYPHXQgsYaABf0+jArOFbxKW2mG+Wblt4xLV3fekCx4JXVpSQR7A4S4IsvlWjsqt686O1qe33PTYZvys0+HAyC1MwSo3DBgZHd5N5T5wHpchCTqtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKZOyk4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKZOyk4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F68C2BD11;
	Wed, 22 May 2024 06:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716357700;
	bh=l2LAqe3eB2nS8+yQgVDnpAZfIGt1OItuiXqyskxj4u0=;
	h=Date:Subject:From:To:Cc:From;
	b=WKZOyk4kzAbg6rkAgYp26oetHRnlbKUKE2Z14d4X9C+Y3A9w/LlYzL1K4y4Lqa17b
	 esMeTBI+TS2qWyWHCS3twxTGTnXNmczgEcbYFCr+8M3NaYzCFEOaBeHD8B8V03o2kb
	 2hCRd+Dfmfe8qWA3Mr0y5RCKOKtbANb2gGRZEShrIkV6XaocxxHgexVIsloEb0o9dX
	 usO9xfzdcM8UyqylQRHa8+8qmKuA0ZWZw51gtC5Kfhl4i70CLDK1fhNwovW+lz84gH
	 AVmo6EB30RukFMPRSUM281asHXdNupsgeUIEJPyR+vA2cVyBkiFhPcU+h2mufdTS7x
	 thIpXmPrDEtBw==
Date: Tue, 21 May 2024 23:01:39 -0700
Subject: [PATCHSET] xfs: minor fixes for 6.10-rc1
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171635763360.2619960.2969937208358016010.stgit@frogsfrogsfrogs>
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

Here are some fixes for the stuff that just got merged for 6.10-rc1.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-6.10
---
Commits in this patchset:
 * xfs: drop xfarray sortinfo folio on error
 * xfs: fix xfs_init_attr_trans not handling explicit operation codes
 * xfs: allow symlinks with short remote targets
 * xfs: don't open-code u64_to_user_ptr
---
 fs/xfs/libxfs/xfs_attr.c      |   38 ++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr.h      |    3 +--
 fs/xfs/libxfs/xfs_inode_buf.c |   28 ++++++++++++++++++++++++----
 fs/xfs/scrub/scrub.c          |    2 +-
 fs/xfs/scrub/xfarray.c        |    9 ++++++---
 fs/xfs/xfs_attr_item.c        |   17 +++++++++++++++--
 fs/xfs/xfs_handle.c           |    7 +------
 7 files changed, 66 insertions(+), 38 deletions(-)

