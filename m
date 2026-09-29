Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F54C52D2A9
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790695721; cv=none; b=emW5m4j35p/64TUK7DBBy9dYjApV0fhPONRNzjOySC3duAHb2zRm10Ha8MRAJKdGvA2pfey0PqnKA5WI8Vu/r/dKnCw/2XgfVrY1KhO0RghfC9Im6CU+JAlQZ83gyfGbQLM9bjUwi5xNsb1iYL+zjCqKJdgC1TIj9/oFun2bkJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790695721; c=relaxed/simple;
	bh=lT5DNkiqZFXmm9BCnKZFROKBIhbUv9FoH8dPHMItaG8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=o7+xqZC46vZJJSqSU9PjA9O3PHUrzVMejqlLTOzZx2psi7/V0Tm8L9HYf5fv8jEJXgo5b9lqlLKr+c+vbM1+OW2hKGEwT3LRdtbwbqEWslRWMonmeQgh3+3Ek0vHJJTY2zyspWi0yPb9LPQf0lwpKO7tSPtGTEBH/Udh4Rp+62g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gf8AJQdk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gf8AJQdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD13B1F000FF;
	Tue, 29 Sep 2026 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790695714;
	bh=60+0tr0PpftSPAHCNEzPRJDVHogDK+M33OXHKy/Ed00=;
	h=Date:From:To:Cc:Subject;
	b=gf8AJQdkchKVAhPYO2xlI4Kvr4UZ2VH6fAdJ4RJFf+HA1anQpC/+lNbRcUay0z4ng
	 +ViRQ+jDKs9erOlXLRVsPVJEdBiogtu8sWUjkkjsKus/Lgl+r5NJ4TAUlBgSV5w5TW
	 iqAGgymg4kgMBmZ3OEGuFO6xxnTQAN14ljQOC+ZVsNr+AZAFlWBLZ1uMVJW6tjWsRj
	 qAwqAzV613TSFggOGKL9XW2pwnjG3/SAhxNecE66l0JtrkCJHWh+3Yui3XIL2eEII5
	 Xm84+FDtO70KZLy8dPm9sUVP6lNSyJidp+NC20A7LaE5L+S/Y4qs0d/kQuD5/eOcuU
	 lht9NfyPfNByg==
Date: Tue, 29 Sep 2026 17:28:30 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, wilfred.mallawa@wdc.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to d67bdf8007b6
Message-ID: <arvZFF2QZmFey-wH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

d67bdf8007b6049f2e88a3ebc5de2c3209bae237

New commits:

Christoph Hellwig (1):
      [d67bdf8007b6] man: fix alignment of the rtstart field in ioctl_xfs_fsgeometry.2

Darrick J. Wong (3):
      [a594f085447f] xfs_scrub: terminate systemd services if the sysadmin unmounts
      [73662a3e91d4] mkfs: allow disabling quota flags
      [f2e443ce2107] xfs_quota: fix XFS_GETQSTAT parameter pointer

Wilfred Mallawa (2):
      [bc84c74ae73d] xfs_io: report rg_writepointer in report rg_info()
      [bf0ec1d8a2b6] man/xfs_rtgroup_geometry: add rg_writepointer field description

Code Diffstat:

 io/aginfo.c                           |  3 +++
 man/man2/ioctl_xfs_fsgeometry.2       |  2 +-
 man/man2/ioctl_xfs_rtgroup_geometry.2 |  8 ++++++-
 mkfs/xfs_mkfs.c                       | 42 +++++++++++++++++++++++++----------
 quota/state.c                         |  2 +-
 scrub/xfs_scrub@.service.in           |  3 +++
 scrub/xfs_scrub_media@.service.in     |  3 +++
 7 files changed, 48 insertions(+), 15 deletions(-)

-- 
- Andrey
