Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1139F1FC8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 01:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782781329; cv=none; b=aLZw2LIlnbumv+E4RcDmLWDPDavfonlqq/rDBsyONyvogLTrDJZUyveWFBANSATtDeQdvC3PzUD43RyXsS2heF76+xLHvjC69Ek5rfCotylJo3uR6rh8svEckc/TM8FfmKVl/aVpG3z5nBBLjY8rHxuBLdGiygFOFWd6AueYsTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782781329; c=relaxed/simple;
	bh=16n0CLL6Rae3otY4X3h3pznlbt1JDhPrHtnivwGAgEU=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=ZcUoew+CwRH3Ran4bDJyuJGSsXlbKtGxEc79m9YA46UNCmOCEALQLqX3OLtZ59IEyiS9sye9e0gIgCQ/3gN+RQkfoimeFFEQyGg40whPElRPHHGbvhkV82XTLpZmGYgNIF6o87d18DTN5nA7zPE3Xs13SjZOXFxFh95fF8HmQ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKXE/yRM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKXE/yRM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DD8A21F000E9;
	Tue, 30 Jun 2026 01:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782781328;
	bh=avbEiCGVZFJqTmO+0g4B3KR4wiTd2g4zIRDEMB7M6CA=;
	h=Date:Subject:From:To:Cc;
	b=PKXE/yRMuAZsoeIZ12kx3xxw7f7ngS2e/MZWffzYYdKPtkG8d980WgmsIMldBRVqs
	 GLDAJ2kOoRgexClGzK9QuuwI/TN7lcyGJpgoOFhFC7H/SQCKLqrkceBAmgZ+XXuywx
	 9+uq5fj6mddfYhMXct9c6Ijkv7NZP53JLgG0epF3jFYUdFMQbft3tJDVoxVr5cGmuR
	 3ZlNvqG1x3raLA8VQTw+v9vQ52VML++MRn64L5wBbHR68OKim1A8HrxI5C3vKRRbxV
	 K9s1KDFylaPrwM1hjIyuf1l6NP8XtbNqPUxu0bhfyM3oL8Q0ytFRRH7+Ou+VNzW+7Z
	 2ZhBABRQhFY2Q==
Date: Mon, 29 Jun 2026 18:02:07 -0700
Subject: [PATCHSET 2/4] mkfs.xfs: codex-inspired bug fixes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Here's a batch of mkfs.xfs fixes resulting from Codex reviews.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-codex-fixes
---
Commits in this patchset:
 * mkfs: don't redefine DIRT for protofiles
 * mkfs: fix PATH_MAX check
 * mkfs: fix symlink target length check in create_nondir_inode
 * mkfs: fix hardlink detection in directory import code
 * mkfs: PQUOTA shouldn't conflict with GQNOENFORCE
 * xfs_protofile: make nondirectory arguments actually work
---
 mkfs/Makefile            |    2 +-
 mkfs/proto.c             |   41 ++++++++++++++++++++++-------------------
 mkfs/xfs_mkfs.c          |    2 +-
 mkfs/xfs_protofile.py.in |   40 +++++++++++++++++++++++++---------------
 4 files changed, 49 insertions(+), 36 deletions(-)

