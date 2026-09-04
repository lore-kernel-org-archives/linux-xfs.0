Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094AE3B28D
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 01:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485398; cv=none; b=OqTrnDgK0vQTsedp0utdHeSS5TJyzO+u69je+maURKDV95bV1hgTm0/OsJekLbtFDqWV55oKBjbbYwNpNrJBslqxUMsmvUjNaftNOjU9bOBA2NNnEUfAcWT60wrGvkqcoDKNZgFpJHiARWSUwcEHLvf5hdpdE1gRN/zbndhSitw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485398; c=relaxed/simple;
	bh=o5qwvg0Q5JoPYdhRJ5PvV7xqskc0sPrn+QyDCiN+lSM=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=GjD5vdDSHTXWsA/pTyhnCzOjx0AHt7F31NuQycIlssjYZpsjCiw6m9T2As80Epu59fGOWdj/rMWOrYAO7+Euprhr4tfY2CXcYcOE7LUq3oTJTIzw0t5PLcW3RRW7iz5doLhpJ//84+75O1TJcxbx46u0TJdV2+rz8tfJxCHw7bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksiES4q0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksiES4q0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D27F1F000E9;
	Fri,  4 Sep 2026 01:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485396;
	bh=5IfVnOrT9aMx1mirtq2x2Zt8O04qJEJaOZuypoQfj6o=;
	h=Date:Subject:From:To:Cc;
	b=ksiES4q0WScBMvIlxiMyhncikJJzGLHovtJ4/FwrnF0AbU1CyiuIJGUURgJHpBQEZ
	 nye9DDx6bbsVa7ZA7unhKpabB2w0D9I4OKyX8mfbVorbQRzJ3XOWV8RmSBJmjtr+/W
	 Hh/00Dc0iwwuZ+cV7NEN09NV0hkcWOz3pZe/9nSga6Hysk6hm0QQTZLppqGJzAAcIY
	 eO8ACWMAtzD7RIH0HD0GHe8Qu7rgpTXxKKByaqBokxBMPdoP69Rp2j0gx6Qzt8cBjp
	 r2AZSz17dX4jyA6VwYiiNaErpiM0k+Y/YPDxcggTvBvtL0nUdiJzXejIzkgJTbwOJT
	 M4qy6SuE/QLYA==
Date: Thu, 03 Sep 2026 18:29:55 -0700
Subject: [PATCHSET v2] xfsprogs: generate mkfs.xfs config files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@infradead.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Message-ID: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Every year, we generate a new mkfs.xfs configuration file to match the
stable feature set of that year's LTS kernel.  Right now I just do this
by copying the old configuration file and tweaking the values by hand.

Instead, let's create some library code that can emit the same
configuration variables that we've been shipping for some years now,
and hook that up to mkfs/xfs_db/xfs_spaceman so that we can generate
them either from the mkfs defaults or pre-existing filesystems.

v2: add rvb tags, add the defaults file patch from before, add a few
more feature bits for spice

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=generate-cfgfiles
---
Commits in this patchset:
 * mkfs: automatically upgrade autofsck earlier
 * mkfs: print config file for a given mkfs configuration
 * xfs_db: print configuration file for mounted filesystems
 * xfs_spaceman: print configuration file for mounted filesystems
 * makecfg: handle metadir quota options
 * makecfg: handle old V4 options that are almost always on by default
 * xfs_admin: print configuration file for mounted filesystems
 * mkfs: allow specification of default options via configuration file
---
 libfrog/fsgeom.h        |   12 +
 db/info.c               |  192 +++++++++++++++++++
 db/xfs_admin.sh         |   15 +
 libfrog/fsgeom.c        |  482 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/mkfs.xfs.8.in  |   24 ++
 man/man8/xfs_admin.8    |    7 +
 man/man8/xfs_db.8       |    6 +
 man/man8/xfs_spaceman.8 |    6 +
 mkfs/xfs_mkfs.c         |  220 +++++++++++++++++++--
 spaceman/info.c         |  183 ++++++++++++++++++
 10 files changed, 1113 insertions(+), 34 deletions(-)

Unreviewed patches in this series:

[PATCHSET v2] xfsprogs: generate mkfs.xfs config files
  [PATCH 5/8] makecfg: handle metadir quota options
  [PATCH 6/8] makecfg: handle old V4 options that are almost always on
  [PATCH 8/8] mkfs: allow specification of default options via
