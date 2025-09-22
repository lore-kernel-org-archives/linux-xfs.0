Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01642D9797
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758544962; cv=none; b=LipralswREf1SkE0ODGfu4+DYlBj+nw+/+wzOk74PXtFfjlQcVowgUeLaeqmfUtCTlbgwWao4Myaib3QUTY3gZVANRClJZoz4r/Sz/mhXbUsnz0+NoM/yPVsiM5f5EUHwXG7PicgOfmmO1OrEHkf2RBAQoNlt0+R0tQvxnEbpTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758544962; c=relaxed/simple;
	bh=YNIc/2kuSnLMIuinU9KcM+JJLIZgWJEQvFzP9vfdlOA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=D4X7f9sxg2ybQIvHH3w+lfu4vBDir6YCXG77qgGXPO4idQ1L5cZVP6kREeAqZvTenhpBacaILk8OlNh8CFIDudo1XycN/HPSgq4S2eNbegjNAoAHnqzy1bNvQgSwfRg/kQDgOLwy3nFz+Tj7QmJFeruz0twAHDAfzeWBZ2SfpSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5uVw0bE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5uVw0bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B0FC4CEF0
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758544962;
	bh=YNIc/2kuSnLMIuinU9KcM+JJLIZgWJEQvFzP9vfdlOA=;
	h=Date:From:To:Subject:From;
	b=u5uVw0bEcdzRUKMZO1v9rEwRab2c+3k00n6x6lERoCHJs4iyEklOCxoT/Xls0vSEM
	 dyWRZmHKmvAGdGnpKaR6+TZ1jlEF83bspYog+dmBCYgByNaICTzWN5lQpbMOdPLlhw
	 /udkLhSHWeeT3QTR2kEnfOBiSDsq04BPsmm8CMicO0rtiihpxkVVOR0s4muSxo9EV6
	 VzHu+GBGRTm4grDhOxIzdUYJ9keBbx6HqdmnqxBR5UONJiAPRBqnUKhORNoXvDIukM
	 tpEzpuIBETRT9DkPz28TlZUAJpgs5SwnbcleaQVwiuJ4lZ6nTG8+J6IEm7QAc1YMAN
	 DHKyafHFQEHUg==
Date: Mon, 22 Sep 2025 14:42:37 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to fc0d192303bd
Message-ID: <7y5ykxcr675bnehecf6nu2wsvypfk6laqjjaeffopw32cmt7vr@j5cxkgzpwv4d>
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

fc0d192303bd xfs: scrub: use kstrdup_const() for metapath scan setups

3 new commits:

Christoph Hellwig (2):
      [42852fe57c6d] xfs: track the number of blocks in each buftarg
      [6ef2175fce30] xfs: use bt_nr_sectors in xfs_dax_translate_range

Dmitry Antipov (1):
      [fc0d192303bd] xfs: scrub: use kstrdup_const() for metapath scan setups

Code Diffstat:

 fs/xfs/scrub/metapath.c       | 12 ++++++------
 fs/xfs/xfs_buf.c              | 42 +++++++++++++++++++++++-------------------
 fs/xfs/xfs_buf.h              |  4 +++-
 fs/xfs/xfs_buf_item_recover.c | 10 ++++++++++
 fs/xfs/xfs_notify_failure.c   |  2 +-
 fs/xfs/xfs_super.c            |  7 ++++---
 fs/xfs/xfs_trans.c            | 23 ++++++++++++-----------
 7 files changed, 59 insertions(+), 41 deletions(-)
