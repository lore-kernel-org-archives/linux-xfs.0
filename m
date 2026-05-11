Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21491301704
	for <linux-xfs@vger.kernel.org>; Mon, 11 May 2026 09:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778492956; cv=none; b=uVIZpoI5xojnUwJj/CWyLizZR5Rd+2Y3Vqn8kr69oFLpK2M8J6JE7wwFcTS/pDM9cOfMjuo6H0zB585sYlapkgxvtClSmT6p1/ariV2ip8JAj9/4BJbteWnbOb7pc9aZdKQSxWr9w5037it/vwVsPCjrBQf8nP4uKJ+hEXEIX8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778492956; c=relaxed/simple;
	bh=jYBL2hVSFCn4Gzb4dPOgiTcZd6b8TTFbEaUFKYqomsA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=o0pBDpiwLJWdqsH2PtTSUeqW5eSUGXn0gFsutZt5C5QZ95/eu67G8ik8t0iHaQLjctUrMKCE5IpDTVorYCcYbWyTyjpF2KjW86zbAb0I+5tCdD9BCrqLPLMMtoFsrxHAhBZZ4uKrz91lzIxNe1TljawQPgSyWkF2oIJnJ1GHi9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TL2flh0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TL2flh0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB233C2BCB0;
	Mon, 11 May 2026 09:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778492955;
	bh=jYBL2hVSFCn4Gzb4dPOgiTcZd6b8TTFbEaUFKYqomsA=;
	h=Date:From:To:Cc:Subject:From;
	b=TL2flh0nUyObm2aVOiLwTYFTOpge8RK4FLpt+XBNLJl+YceRZVuDubluvPGplYAO/
	 w7QB18n4jc8UcHAdmsp1q+0Z+FB6H0iY+OQCvFnAqiSTPsenf9oT3O+0iQrh8Wk+5q
	 LTLmnEf197AJm9Nn3rSMpN3Cy/cbofzpCBet2hiBG2bLF3Me9hNsNrfUWT/l5ECUsP
	 ZzNIOfyYm+4YKpEYW9yBlNmsZzmoE08QUbp4m7TDXQCNelOvVBt2DxNVsD1Yn7Q2PM
	 tRR6JxIEAFZ8SWZ4SzGf6zdkdPTUfkTfJ/3fVCWCmORXte/kGWbWMN9paQ/0GHqj2n
	 FE6Ub4b7lk74w==
Date: Mon, 11 May 2026 11:49:11 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, hch@lst.de
Subject: [ANNOUNCE] xfsdump: for-next updated to 7033f078face
Message-ID: <hak2oghhtol7jl6cmzefthzethlw5v7pg3v5bhjmlwlrq2yvmy@yjhaabpqairk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsdump for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

7033f078face411fe277c674048e987632ebf354

New commits:

Andrey Albershteyn (2):
      [523dea982158] xfsdump: fix permissions on files installed by libtoolize
      [7033f078face] xfsdump: update release.sh

Code Diffstat:

 Makefile                  |   3 +
 release.sh                | 197 ++++++++++++++++++++++++++++++++++++++++++----
 tools/git-contributors.py | 168 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 354 insertions(+), 14 deletions(-)
 create mode 100755 tools/git-contributors.py

-- 
- Andrey
