Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853263CA4B8
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 09:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782723874; cv=none; b=A1awDl4Mu/kr/uUJio3aoamdY1Fc/4UqMFgXODKUphSvhvgCVOmDS1fWFvBeV/GwUlfTHpmOSMr1bKugRcWkgkc6o0WiE1Bew5UZYgWEAo2hVUCNvLUeEI1YfaHN6djuc+GXwnz6INumzsa+8qAboQHY6G8eydXY1/VfrxArR0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782723874; c=relaxed/simple;
	bh=0ctbb1h7PsB3CK0HbR6e+rkj94pjbSB0t73za2UrdE0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kotmik8Ft1ptpk51DGpFY/oYZ9jPpu4sonpFTwr2HIawXYp8kq04ytIuPM1/StRWn+2VTn7ooJvGqIcKfQ7Ys+9AA9DxjsUz17wWuiGDUzXrXASKoTKn4Ye42btBBjsJ2SUGtVMNcfXvoIvyBGW7JsvEEdS4TxrAdJQS4quv1zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9dUCPYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9dUCPYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFA11F000E9;
	Mon, 29 Jun 2026 09:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782723873;
	bh=y1GWAyd4q94MmaEecotrzyujjTFdfc9MTR8ToRLsOjA=;
	h=Date:From:To:Cc:Subject;
	b=E9dUCPYMGN/Zbn3yIKfNI7p8YZ45d2gJq0lfjv8YNedhMqLJxEScCRQoMVA+bPyB6
	 Or2rHm7D744MbqbFrZYBvTVSomCoW3jTJw1IOFmIZLKAiMmgb5WkI1eYpS3FUeNlZ5
	 XC1SNyPIpkqs0T7DElHbFhdp1iR/lefnRJkAZPQTQLZkkV9GATMF4pjMhwZxJAiMWo
	 iLGxXlFxv7fC1BlzIoEu2JNnE/lAx9bMqifJSzGLa5GWFTHRAge/pYeTbsoND7MJ/S
	 KFiY1xcCtNW4h0tyNQwydKDlUa0xPFgJaTxyr2gwqUVUewf3lN6ymGlPfwVtEWfBic
	 wX+zbXaBuM3tw==
Date: Mon, 29 Jun 2026 11:04:29 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, 
	liuhuan01@kylinos.cn
Subject: [ANNOUNCE] xfsprogs: for-next updated to 708b369bdf8f
Message-ID: <akI1Den0ablejlqZ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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

708b369bdf8f4f9b2824b9daa54a11df253b7b5b

New commits:

Darrick J. Wong (11):
      [64344c43430a] xfs_scrub: handle missing media verify ioctl failure return codes
      [2712427c08a5] xfs_scrub: report bad file ranges correctly
      [3e4bb144f657] xfs_scrub: handle media scans of internal rt devices correctly
      [c001fa7d4db4] xfs_scrub: track inode scan abort state with an enum
      [bc9371417a61] xfs_scrub: don't skip bulkstat batch when scrub_scan_user_files helper returns ESTALE
      [b6dba3d85ae5] xfs_scrub: warn about incomplete repairs if we never get to them
      [e2df9f9bb984] xfs_scrub: report external log space usage in phase 7
      [243048f90dd4] xfs_scrub: account only data extent tail after an overlap
      [baef30aabbd5] xfs_scrub: account for reflinked realtime file data
      [a4080cef33fd] xfs_scrub: don't leak the autofsck fsproperty handle
      [157d76940c3c] xfs_scrub: warn about difficult rtgroup repairs

liuh (1):
      [708b369bdf8f] mkfs: remove duplicate include of convert.h

Code Diffstat:

 mkfs/xfs_mkfs.c     |  1 -
 scrub/inodes.c      | 66 ++++++++++++++++++++++++++-------------
 scrub/phase1.c      | 10 +++---
 scrub/phase2.c      |  8 +++++
 scrub/phase6.c      | 10 ++++--
 scrub/phase7.c      | 89 +++++++++++++++++++++++++++++++++++------------------
 scrub/read_verify.c |  8 ++++-
 scrub/repair.c      |  5 ++-
 scrub/spacemap.c    |  2 +-
 9 files changed, 137 insertions(+), 62 deletions(-)

-- 
- Andrey
