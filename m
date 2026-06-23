Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882D11E832A
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2026 09:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205959; cv=none; b=qromcRBVL9lxUsjSXv9fhkSj+gMdH6rinmDMWGG1Aj49n/bzGrF+gJl8v6LNcEC6qKw009iuE6rQDwjZ/mFXoyisvNdWOiHZguHJfDxXOSym9bIMBnbHfEdRMYCewQW7LctWuztn58LCA8X0PmaMfhUwrkultNhMAQ2nzIko7Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205959; c=relaxed/simple;
	bh=oU7XWTY7pdzR2BkFFHVvy5yu3+6GY3EkMWOLtRWJ1Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YV9zfsDsCyPuyjWTI5hXfe+t5JviG1+UK/H569sDD6wGt2BhgTjR5eXCJBxlIy2IpCl/67+A080Mcti9G0Z7uI9iyHK+NAy9shs0p1ifPRXKfFuoBiD/kgT0+z8mUcw1kAcUz8O7RXDMuQlsQ1xnxf4Q61xSH2M0imskyBhDIYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4ZDTObq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4ZDTObq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857CD1F000E9;
	Tue, 23 Jun 2026 09:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782205958;
	bh=yrlifq8NI34iuwVhjhymrL290j8MF+60pc9XWIEqVDU=;
	h=Date:From:To:Cc:Subject;
	b=O4ZDTObquwXB6jpt2iiXZdu3dfoFM+zxaVlm2T5UFgjayf2hal1zqzz0Bs7M2FSam
	 YHdj53nEby5pYfhZuvCBRY+UJO2jXt7O/ImDuU9Nc2sthcfe7/rOueMrFhWAK/SL8l
	 X0yzEj0Z1o67IXmjfcyEFLPFcZohfhPbSjkJDPMWvtYdYncz857WroAR2ocYRTuJGo
	 q84prjxBTzxyYcj2HFlWOd1/BZ2NVrtfaDsJR1yddCL5dSnJbp73b9nZlNyHFIxF7Z
	 uebYV2AneTbuQi+tgNBHnhN6fPXZ4CyynF32nsqbUglyuLwflfon3QnB2hgaXvSH9j
	 XFlqnMBQxyeKw==
Date: Tue, 23 Jun 2026 11:12:33 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cmaiolino@redhat.com, djwong@kernel.org, 
	linux-xfs@vger.kernel.org, msinguru@redhat.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to ec7424231d53
Message-ID: <ajpN3TSnda4cIA74@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
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

ec7424231d53b730149b4c49c16af37e7288f002

New commits:

Darrick J. Wong (7):
      [359eeef71fae] libfrog: fix buffer overflow in getparents path_to_string
      [5b0f430d8e59] xfs_healer: don't allow aliasing of mon_fd in setup_monitor
      [425126caa89c] xfs_healer_start: check listmount when doing a --check
      [577d6415adbb] xfs_healer_start: fix static checking
      [76ef8d90a3f0] xfs_healer_start: increase statmount buffer size
      [a0f50dec3540] xfs_healer: allow AF_UNIX socket access for xfs_healer instances
      [f6505519ef79] xfs_healer: don't put the slice file in LDIRT

Manognya Singuru (1):
      [ec7424231d53] mkfs: fix filesystem and log size units

Code Diffstat:

 healer/Makefile               | 10 +++++++---
 healer/xfs_healer.c           |  1 +
 healer/xfs_healer@.service.in |  4 ++--
 healer/xfs_healer_start.c     | 43 +++++++++++++++++++++++++++++++++++++++----
 libfrog/getparents.c          |  2 +-
 man/man8/mkfs.xfs.8.in        |  6 +++---
 mkfs/xfs_mkfs.c               | 14 +++++++-------
 7 files changed, 60 insertions(+), 20 deletions(-)

-- 
- Andrey
