Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB033EDAAD
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779971352; cv=none; b=WpybHqcCiPhbbV7H/GFQTTGjSck4FeOkRYDiEA7hNhEYzPV7YeAaciMRKTwttGHohEHGkq0juR1GCa6/lyrNFljX2ju2J17koZCQsu7tRFqXgkxKXT8Xk8AlQYZOCkOp9xcuRgWhOWZBUCWeovKJkX8C2pYcpNj9Ic/Owpbhr9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779971352; c=relaxed/simple;
	bh=dN4QtAdl8dPE5Pb5U6TJ84l/hQBItVNZNJrweGSQRu4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=D0Dke1i2qtUjjTqttB9WaJWiqT3RFhicG0lrQ8g6IYzbgeUxeU8PK5vZ+OsrCt1zkRkr/J6g2htjIjrI0olFlJnNFWj6qtDXop+FCzgi4tAE9FMwTlSUtxlG9umQCc4Rb4CqZ5TBRurNwlFaoUPjdFpowlScRuKDlxFf85oGdzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAuYOICt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAuYOICt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F031F00A3A
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779971351;
	bh=dCTEehwApwSYpfEm2pCSmjE3sw/wIAeEDfBH8KsByUU=;
	h=Date:From:To:Subject;
	b=gAuYOICt/NJkvJT1lIBIrA1Y77HHdYXFNFgz+l1f6I+KKejJ6gsUWgp0wrKQpjM95
	 11lA2HpaLSCY9n4JhI9sQB5GD/26LwYk4MUFCElbZBvk6czrY0XAsDi6LVatV+rgx7
	 ahM1oBq0c5pZRSrGSAm5V9UJz5PXEkMwT78ySww/UPXR6bJoH7TEDYFrf6/svYAorr
	 74Om7uW/AxgFX/nvbIzpb8nhKrY+Q+G0DC3gWgBwJyYGa+fVetUEySQFKCaH1dyWRE
	 irr8s/9ynp9/mHvmm3AYGRhRQW+wjbldpS/bR2pUy2aiDRd4hinoE7IpVuMxwmqrTL
	 G0fY3fla0/NzA==
Date: Thu, 28 May 2026 14:29:08 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to c1b17bee804a
Message-ID: <ahg08ifd5q_jOkCL@nidhogg.toxiclabs.cc>
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

c1b17bee804a xfs: Remove mention of PageWriteback

9 new commits:

Christoph Hellwig (3):
      [32da0ae8defd] xfs: drop the RTG reference later in xfs_ioc_rtgroup_geometry
      [2c5bcddde423] xfs: factor rtgroup geom write pointer reporting into a helper
      [c53f9b627a6c] xfs: abort mount if xfs_fs_reserve_ag_blocks fails

Dai Ngo (2):
      [ed47e798adcc] xfs: fix use of uninitialized imap in xfs_fs_map_blocks error path
      [92ad95ab8dc7] xfs: fix overlapping extents returned for pNFS LAYOUTGET

Hans Holmberg (1):
      [6f4d98bb8b4d] xfs: handle racing deletions in xfs_zone_gc_iter_irec

Matthew Wilcox (Oracle) (1):
      [c1b17bee804a] xfs: Remove mention of PageWriteback

Yingjie Gao (2):
      [f92659c50b76] xfs: fix error returns in CoW fork repair
      [c734e8bf321d] xfs: fix rtgroup cleanup in CoW fork repair

Code Diffstat:

 fs/xfs/scrub/cow_repair.c | 12 +++---------
 fs/xfs/xfs_ioctl.c        | 47 +++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_mount.c        |  7 +++++--
 fs/xfs/xfs_pnfs.c         | 11 +++++++----
 fs/xfs/xfs_reflink.c      | 14 +++++++-------
 fs/xfs/xfs_zone_gc.c      |  2 +-
 6 files changed, 50 insertions(+), 43 deletions(-)
