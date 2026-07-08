Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6762445BD4E
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 12:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515458; cv=none; b=cWBz/E1TUdy5p/v3YT9YsP05HDV76mjny9y1ZAL1/tIS5udDpKJRSjxIkz9o0gMYgXzfVCAuRhiDxl6qo2qdwzDcc8iGhQbDrFk0modg4DLG3KFFZcF0XBopR557v+fMrujkdUulpFWNI5oIJynt+JQ6jHiZMMMxkXE89cNQTeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515458; c=relaxed/simple;
	bh=qx28WPOpX5RtI8lHPd51gJ3ZRiBxsQrbnvWGpt+DWno=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=X341257Oi1myKF7Layb4lCOwGAHfLX2sW752E5F6u0Ft7DPKtFrbYWsXEq8vsyfT6NfuorE8K+ZEnBMr6MRgKahamkYW6qtXRUoPsVkaJ7t1mqW1pDVJ1tzVA4BDGVR6sFdLGPJca9BoNYYZJ96vp39CQDu2SZXit3ZYhUwJ8qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RzJKv68I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RzJKv68I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732171F000E9
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 12:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783515457;
	bh=02VJzBdN7UU6/TqteGi1salrQZykJGM0T+j8oscV05Y=;
	h=Date:From:To:Subject;
	b=RzJKv68I1GPTA2iEDoUnWz+Rjnou4xIm4upHI++gysp/+iARldctLz5GB2fbhSp0+
	 dqCI2r5RU4R47uIAF6HGjGRwWzg7RcIZBdoZrIh5KQ0scOPB+5c+knc4kLVkp6Euwv
	 z793ErFKPYCLqaXusVMhpI7uv3jk1DvKfCUQv0eR+c0nMSRbWU7zBaJmCiI8UhqXbV
	 Eqzers10TH4IhNUQqWr9+MOPXmAUBqmX9jQk/0+N9MUjI5aMaM/+0QOCJsL9cxA13r
	 J3CxHiDpGi96FGmRgDm5DFWgvcnBOYCPeoSWd3XgO9F51B/z7S9jttaXBJBcPRyRk7
	 XpW/nOIywT/uQ==
Date: Wed, 8 Jul 2026 14:57:33 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to f88caa121eac
Message-ID: <ak5IzfllG96zjEd9@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

This is the very same update as the previous announce, only change is a
missing Signed-off tag from one of the patches.

The new head of the for-next branch is commit:

f88caa121eac xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter

5 new commits:

Cen Zhang (1):
      [d128ffd2baa7] xfs: tie zoned sysfs lifetime to zone info

Jinliang Zheng (1):
      [f88caa121eac] xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter

Weiming Shi (3):
      [5b4396e12cb1] xfs: drop ASSERT(0) on unrecognized log item type
      [34dd2253414d] xfs: splice unsorted log items back to the transaction after the loop
      [2094dab19d45] xfs: fail recovery on a committed log item with no regions

Code Diffstat:

 fs/xfs/xfs_log_cil.c     |  2 +-
 fs/xfs/xfs_log_recover.c | 26 ++++++++++++++++++--------
 fs/xfs/xfs_sysfs.c       | 28 +++++++++++++++++-----------
 fs/xfs/xfs_sysfs.h       |  2 ++
 fs/xfs/xfs_zone_alloc.c  |  8 ++++++++
 5 files changed, 46 insertions(+), 20 deletions(-)
