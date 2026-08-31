Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175493C4B8E
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 23:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218790; cv=none; b=gjQPMrLmVZcmlkDUgxsaNvMkdhfXlkVQsCByItvDX2J5KVNyE4k1AeEOVXF+5CESyDP845SPvEJNDBSWjQB9+u3Oc0FFr4uybsubqHXmOxw4lsd7+25azkqWbRZiO9o8cD9Xbw+FOMB2JVtB5CzAqrtVZsh9BBZrOOrsuVooCQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218790; c=relaxed/simple;
	bh=jAllLebqCaGlNmmmV4UHOCZag6XKtEy6EneGxjsR61s=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=BTMnsPkEQWWI1gAnXyS2pWEq7u9hLfzaXgR3xQwLMuGIczdlyGAc6pt/mEr4S+JFh7gucs1JbUMc2lieTjZhgxyXa4xnM0i8E0y2dE5VWi7h1FY0P/Uayyd5vG+olSSHu1yXZ2nB9URey3w13GtphYQQu+3rwpHnHYm03dGJRQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VawqoDbh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VawqoDbh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E2D571F000E9;
	Mon, 31 Aug 2026 23:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788218789;
	bh=x09cQqzrmhCVZxjRkGoVTWNeZNQhABgmt5hG7IeA5m4=;
	h=Date:Subject:From:To:Cc;
	b=VawqoDbhHwTIc6ETTBltq/5c/Lwvw4JEaeML+vPSkhpCA24nLM4xSIvCBGKTPiwSE
	 Tc/eOC0mRIfRCGebrePaXgtEpBXJJxw0IgAkRUmBChK0bIF7rBzZj5L8LOIjNR26T6
	 51/sX/Gff929L1KERFzQr5sPryP+p1HY1mYt283vv3lHiIgIsUVC0lP9/uRFvcw8fX
	 obEbm0QHz9OqsZn9n5MlH/2T1Nv2Hndy3FVaonouWT42FFOIgIBDuqFrF0lHhLVngm
	 63XsOB+Txo22iEs2vjoJzVT/x6BuiYuvBKgXok8D8FqAjVI95TAx/bMMbv6BbZDbB4
	 jlGi0euSY9QvA==
Date: Mon, 31 Aug 2026 16:26:28 -0700
Subject: [PATCHSET 2/2] xfsprogs: generate mkfs.xfs config files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
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
 * xfs_admin: print configuration file for mounted filesystems
---
 libfrog/fsgeom.h        |    3 
 db/info.c               |  193 ++++++++++++++++++++++++
 db/xfs_admin.sh         |   15 ++
 libfrog/fsgeom.c        |  376 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/mkfs.xfs.8.in  |    6 +
 man/man8/xfs_admin.8    |    7 +
 man/man8/xfs_db.8       |    6 +
 man/man8/xfs_spaceman.8 |    6 +
 mkfs/xfs_mkfs.c         |   62 +++++++-
 spaceman/info.c         |  136 +++++++++++++++++
 10 files changed, 798 insertions(+), 12 deletions(-)

