Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59D52E427E
	for <linux-xfs@vger.kernel.org>; Mon, 16 Jun 2025 12:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077178; cv=none; b=g54y5EqvbAy1zt1iwroD/2Ex2lvWH4rGQsNZoEYmlhZphjzv+P+B9xnYHXbahC155bnM2j6rYDNcuG+aHCXbagmFmpdVM/Rxq/0yRRnqc0j7jb4kX8yRDbYalw7pcC2ux/6niEbXMs4Pib/00LdZzVWuZg6LW7lVeCRJRrjaP4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077178; c=relaxed/simple;
	bh=ezo9hjuKK6nDjMDfIEXPGxZ/b3zZojGM4BfltqBrkRk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eFsE+aMWyR2rNeZ9m88oT+N9sFCNRysrnaxkmUQx0+tBtem4mbANdcAvxpa38YRIZDGlEd9mjqnvC0F1x/UsCAncObuPlv8lcS827icdKThDDeeH9+cgy5SsS0J6s79foEUino/zKh6eLN2naBvBCHeW62keNdWsQanl5mMvVi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pKPGXkWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pKPGXkWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3815FC4CEEA
	for <linux-xfs@vger.kernel.org>; Mon, 16 Jun 2025 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750077177;
	bh=ezo9hjuKK6nDjMDfIEXPGxZ/b3zZojGM4BfltqBrkRk=;
	h=Date:From:To:Subject:From;
	b=pKPGXkWoNpl7GE4mm1osnY6e6TabnqEk4K7QO1i3kr3pjflI27za1H/4UogT4/o1f
	 h5QTNP63Dj0ay85IXaWArWSS/ANYLllLplXqgqbbsgkmhhBQKGYFk9hWm96qrFQrcA
	 aCE1o5l05CbatiNrjUUYWw9eQQtCRnNr7NQNL2yJWr99C5BPGoW1ZfWlytWibjQCxv
	 fGdQnb0loCcItjSt7BnkJs3apyu+Bh4d2ifkQsSKPQ1mQMnbTh0UFJDvc/vW9ki5CP
	 TzdjPQMaWNrxy8dgbOfxduq/j1tiaLDx7gBTaTKKVglVF5ORz0U1jr9Gr1Q/RWAj6v
	 u6aKUW4/wZaBQ==
Date: Mon, 16 Jun 2025 14:32:54 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to db44d088a5ab
Message-ID: <7orvevapbwzotmlktyf4fc7dehfmu6wyi565kctjyw6vdy3shy@bfmahmtlp7tn>
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

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

db44d088a5ab xfs: actually use the xfs_growfs_check_rtgeom tracepoint

6 new commits:

Christoph Hellwig (4):
      [b0f77d301eb2] xfs: check for shutdown before going to sleep in xfs_select_zone
      [a593c89ac5a4] xfs: remove NULL pointer checks in xfs_mru_cache_insert
      [df3b7e2b56d2] xfs: use xfs_readonly_buftarg in xfs_remount_rw
      [0989dfa61f43] xfs: move xfs_submit_zoned_bio a bit

Darrick J. Wong (1):
      [db44d088a5ab] xfs: actually use the xfs_growfs_check_rtgeom tracepoint

Markus Elfring (1):
      [19fa6e493a93] xfs: Improve error handling in xfs_mru_cache_create()

Code Diffstat:

 fs/xfs/xfs_mru_cache.c  | 19 ++++---------------
 fs/xfs/xfs_rtalloc.c    |  2 ++
 fs/xfs/xfs_super.c      |  5 ++---
 fs/xfs/xfs_zone_alloc.c | 42 +++++++++++++++++++++---------------------
 4 files changed, 29 insertions(+), 39 deletions(-)
