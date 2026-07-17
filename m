Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C35E3E556C
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 08:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784278499; cv=none; b=n0JYffWTtfxzMihO+9m3nAkNP2Zc7aqfQPfSB07pmSFP+AAEvWkK8p5YuBfUyc683JJx9+PxubVfVoQ0qONuAzXVmLu14oeTrVbkY/FlP4F6Xyy8csM+YANjhYgcd65lQ+vxU6sPr2pOrSA2N13jwO7Idrewvuw55EOph3uECDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784278499; c=relaxed/simple;
	bh=mLenCLLSU0ZJME4gcay/u0FYckKxkQ85S+GMBYuEldQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I4KNR1wKlCzYN/p2ttEJRX0r5sMx/Yc3tbHOwXbLZMDinoWnM0s7Jf2NxrkWw/ZgMFllwvqYXW/QXMHzIDP9S9DdLOF656Q50yHg/Rb+TdjeM2JTs2S/v1/fiUhncyTvxF3vr+OTqHnDAAo0ZoOE1g7WGCd3hSALmqtzIKw4HfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=flTe1yyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="flTe1yyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDE61F00A3F;
	Fri, 17 Jul 2026 08:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784278497;
	bh=87XtAkw+tCPYwVTGaXGZyqa70OukWE/XMq/y7O0iuRo=;
	h=Date:From:To:Cc:Subject;
	b=flTe1yyurXkWPFg93EJoCtolbgTjspUhp6iimf1vBLg2AR0+XrxMaASUCthhKjRsR
	 ww409wiYVxI6hmj/XjM5cfPKMddslj+gFuwKF+3PttKaET9ARexOCffqGGweUa5TCa
	 lxjyTU7OYWVLJCiV8Z4z0Uzg9MY/cMaNop/br893HnzbSAnsZ7N80O+2A/MKe1DK72
	 wi1tERPsO93jfapY+io87HNLoBabSCbGfanFpbkWVfao02+uPQ4JpIlcS2P4wFyDin
	 ZKY9AJibt0tvMypzXYxAwAsZpeeDLmq5eDsqUcMlAGb1Mtr/lsNedxct54gWX6hGVO
	 YGpijefnwpJlg==
Date: Fri, 17 Jul 2026 10:54:52 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org, hch@lst.de, p.raghav@samsung.com, 
	rallenh@hotmail.com, yi.zhang@huawei.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 2525ce2aa93b
Message-ID: <alnttbpthqqEdTJQ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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

2525ce2aa93b6e490207839a96f240ae8b03386a

New commits:

Allen Hewes (1):
      [2525ce2aa93b] xfsprogs: healer: install targets one at a time

Pankaj Raghav (1):
      [ac14db9cd430] fiemap: add a nosync option

Code Diffstat:

 healer/Makefile   | 4 +++-
 io/fiemap.c       | 9 +++++++--
 man/man8/xfs_io.8 | 2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

-- 
- Andrey
