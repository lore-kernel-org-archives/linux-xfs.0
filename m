Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490DC30EF66
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 09:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769766721; cv=none; b=uxPJE9qvJmFoqPU1BgZ9pHSdUaZ1ZSUs0wBGqBoHVVg7hl2QfruYorAMMFKtOoTutM4bML1Lqlral3en2dcXuByDUBHvD/8THVSM6RCrNNK8zGs4dL03cpEBpSlkeNSzKzjQWbEPk0RINnBKTsKpuy3maB3omO072FCEqqLLWHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769766721; c=relaxed/simple;
	bh=MoEBHH7mNiv8D0mppUHA97Xh3PuJkrcGgQQmv3Db2wU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DbtrShme9CaJcjsoifph0UrbdWJm1ZaKVGTKpjdkejA05mkCut79ZUTXIzQVG9deGXKfikzEkhccPC0Wckg5W+HjxBwfT/wU18g10Hsd3QsFYBBMM4712e9ZZMdRYJ87xT3WZJhbX/LlbP2OvAbzceNhqk7qjjGI/CS4AX4KyQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cas1E4zL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cas1E4zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C3FC4CEF7
	for <linux-xfs@vger.kernel.org>; Fri, 30 Jan 2026 09:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769766720;
	bh=MoEBHH7mNiv8D0mppUHA97Xh3PuJkrcGgQQmv3Db2wU=;
	h=Date:From:To:Subject:From;
	b=Cas1E4zLvLfiZ+HMOsOBytez1m/OPXDi3yg7ywkLEr4x0/0XiE1DsPJ5mJOTnUhEX
	 KJAfmiWEn5gd1L3UIxIfAZLvfVBLUFv7dbhfzYfNsSdcIb+QUFrtEN8OHNULu/AG60
	 DNWKkPL/C39DVT8uiA5IJAc4aHE2/3gj77gB5qvHeLZZypH1NwLuZgne898eCvLUML
	 gGmSvTgSLRsFFtsWTVWV5fTC5DwYUcihZtIN2/d+JeUfSfhZzfMGqoTeSBtg0qrURe
	 VFZpvaXAUhajl1HQTRvJAXE24mdbI+Dv6vIUe7YfEp/LRBj6bAA1N+Acgl20GZFVeS
	 4M0eXkhY254EA==
Date: Fri, 30 Jan 2026 10:51:57 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to e33839b514a8
Message-ID: <aXx_DDaya-iXruPI@nidhogg.toxiclabs.cc>
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

e33839b514a8 xfs: add sysfs stats for zoned GC

12 new commits:

Christoph Hellwig (11):
      [9a228d141536] xfs: fix the errno sign for the xfs_errortag_{add,clearall} stubs
      [394969e2f9d1] xfs: allocate m_errortag early
      [b8862a09d825] xfs: don't validate error tags in the I/O path
      [e2d62bfd99b6] xfs: move the guts of XFS_ERRORTAG_DELAY out of line
      [4d8f42466a3b] xfs: use WRITE_ONCE/READ_ONCE for m_errortag
      [2d263debd7f1] xfs: allow setting errortags at mount time
      [32ae9b893a1d] xfs: don't mark all discard issued by zoned GC as sync
      [06873dbd940d] xfs: refactor zone reset handling
      [41374ae69ec3] xfs: add zone reset error injection
      [edf6078212c3] xfs: give the defer_relog stat a xs_ prefix
      [e33839b514a8] xfs: add sysfs stats for zoned GC

Raphael Pinsonneault-Thibeault (1):
      [44b9553c3dd0] xfs: validate log record version against superblock log version

Code Diffstat:

 Documentation/admin-guide/xfs.rst |   8 +++
 fs/xfs/libxfs/xfs_defer.c         |   2 +-
 fs/xfs/libxfs/xfs_errortag.h      |   8 ++-
 fs/xfs/xfs_error.c                | 142 ++++++++++++++++++++++----------------
 fs/xfs/xfs_error.h                |  23 +++---
 fs/xfs/xfs_log_recover.c          |  27 +++++---
 fs/xfs/xfs_stats.c                |  12 ++--
 fs/xfs/xfs_stats.h                |   8 ++-
 fs/xfs/xfs_super.c                |  20 +++++-
 fs/xfs/xfs_zone_gc.c              |  72 ++++++++++++-------
 10 files changed, 202 insertions(+), 120 deletions(-)
