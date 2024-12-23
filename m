Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D17183CCA
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989720; cv=none; b=TXDk3vBNg9g0YzzlcJKhzJbDUkM8Ibzat0F/B8xh61kOZjucM9fgG38N41P5X+gcivmtLD+95/7QQssh6mR21mfdPP+mdDGZdkmu35nHYyHOOHSWLC8j6x91K1WEU5g60nkKrDcIbxMMlQk4E2ZTCNDniQgmagLF3kWnrIxeVVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989720; c=relaxed/simple;
	bh=vkB9GK4mnq3DrWQZKcGI2eScEiqtoYafGM1mt5zCKDI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BVY/J+Y554WShst2XAQKbkYlaTxhGjEwDz7OkLhySfuw9voc5McWZV0HBrKFxK2H2pKrFmLWMleVsekLJymNsgXZGssRQQMU8zRrCj1+cdNRXDolpQvw4E747GHBxO41nsBTfFUIxSSlKh1Q2C/D8E/XYP1BwBOt6rDP7JgYBCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BhqhswAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BhqhswAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F490C4CED3;
	Mon, 23 Dec 2024 21:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989718;
	bh=vkB9GK4mnq3DrWQZKcGI2eScEiqtoYafGM1mt5zCKDI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BhqhswAcVEsQRmz51rsV4U9Nvx+BPxXgIRpWuxVU9IR+JlH0pbZCqpE8y9K9HZAdM
	 UTI2KQaCvHeZcJ4npA3OOTFhByRnWp+C0NtaK0oGoN0hwJR3VygciUOh7Khd1Hj27v
	 +DfplKsSv6+9lZbwmGN6LvigaXXV/L3XCuA6p0clYRAp3oOpgJkJiyWN8eToIXe4T4
	 60EBezxuXmnaIIZB2jDpVSqb3u7i7tuQ4qR3jzYB4QXg2ZFRIO9/rxKrY24swmBb+S
	 EI8/573zzEkVMLyYWXILAPuc6F6lA8BWpbJyj6PC0S6coHWOaBQf+gbW/6N/8x/rwq
	 3ANhgCymnRIxg==
Date: Mon, 23 Dec 2024 13:35:18 -0800
Subject: [PATCHSET v6.2 4/8] mkfs: make protofiles less janky
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
In-Reply-To: <20241223212904.GQ6174@frogsfrogsfrogs>
References: <20241223212904.GQ6174@frogsfrogsfrogs>
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

