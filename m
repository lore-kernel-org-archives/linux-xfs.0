Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1674D22C6DC
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527663; cv=none; b=ZQfbdaY9uwmmHokKDUgHyD2OUgy0CAugn2vJCTrN4hVy1aSIIo0UwZZ+Zlw8XOOU4NB7CD8QUcNwk6I71+iOdWnzUqIW+p6+vmk9x/SG3Mli88w/E5YPaIxnSwPcWZZ14q1dBomrMl43nCx4++ZklEM3k8ZOueZQZ5KYhKiiwmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527663; c=relaxed/simple;
	bh=vkB9GK4mnq3DrWQZKcGI2eScEiqtoYafGM1mt5zCKDI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QwRVdTnLuxqyVGmLrT8YDrrE8dVgcen5JjF63SX7I0JQewLO0o2im2jESqUu6cufs2R4++IL5nnUNAFK0HIFKcWYnnBNeL2A8e7pWYFMW492uMKBoPiXjZwowKxE9dqutjYqswIH4TWMAez2pmBSPUtWBq9+w2kJk6+kkPN5NAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqioSQZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqioSQZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDC9C4CED1;
	Fri,  6 Dec 2024 23:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527662;
	bh=vkB9GK4mnq3DrWQZKcGI2eScEiqtoYafGM1mt5zCKDI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XqioSQZyHg2R5JPY8SCel8f/hmvdVhI8hDHCuVSuaq1vQxjmKMWO0ITsulj+CIC1R
	 1rV2i/ZTgCxcL17hgbH7gscPYMnCnA+/iTvmY/Sd+qNp2pyDNfnva/76xn2yHm51b9
	 tv/hbvdknaPrIuKyJW85D3IFcbgpNX+VcNt3HWsb9Pu5dLKGTr8fh//eOalvLxdQj8
	 jvK+yBeP0diAx4ZlZ5nGaCtQJVADh2gz8p+Uj3gAASPeqm/aTyj9u8icL9Gti/ncWH
	 sbZanAFvpfzi29B43cTdHQqXTRClm7xPsDsNDfbld6JO8WhmsZh+TI8lUFjxTtN+jv
	 VIk2SmcBWwcqw==
Date: Fri, 06 Dec 2024 15:27:42 -0800
Subject: [PATCHSET v5.8 4/9] mkfs: make protofiles less janky
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
In-Reply-To: <20241206232259.GO7837@frogsfrogsfrogs>
References: <20241206232259.GO7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here are some minor improvements to the protofile code in mkfs.  First,
we improve the file copy-in code to avoid allocating gigantic heap
buffers by replacing it with a SEEK_{DATA,HOLE} loop and only copying
a fixed size buffer.  Next, we add the ability to pull in extended
attributes.  Finally, we add a program to generate a protofile from a
directory tree.

Originally this code refactoring was intended to support more efficient
construction of rt bitmap and summary files, but that was subsequently
refactored into libxfs.  However, the cleanups still make the protofile
code less disgusting, so they're being submitted anyway.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=protofiles

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=protofiles
---
Commits in this patchset:
 * libxfs: resync libxfs_alloc_file_space interface with the kernel
 * mkfs: support copying in large or sparse files
 * mkfs: support copying in xattrs
 * mkfs: add a utility to generate protofiles
---
 include/libxfs.h         |    6 +
 libxfs/util.c            |  207 +++++++++++++++++++++++++++--------
 man/man8/xfs_protofile.8 |   33 ++++++
 mkfs/Makefile            |   10 ++
 mkfs/proto.c             |  269 ++++++++++++++++++++++++++++++++++------------
 mkfs/xfs_protofile.in    |  152 ++++++++++++++++++++++++++
 6 files changed, 557 insertions(+), 120 deletions(-)
 create mode 100644 man/man8/xfs_protofile.8
 create mode 100644 mkfs/xfs_protofile.in

