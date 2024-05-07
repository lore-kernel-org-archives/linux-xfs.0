Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BA816D9B0
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 18:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715106931; cv=none; b=MFhQqY8V4sZCmRd0DhCCdwpuRk4Ysmp+fh8VAgJdplhKm/ox8ft5xkgB4nvY6xoUpqKzpc5ArlxmmNTeTiSP3oDTFZd3I2LjOyoMuUd31F+ZRx2CWpr6t8gj7gS0goXX/CRUbXk17OHisqy/l/NHLnXTeyUxETSCa0Rl8EJ806s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715106931; c=relaxed/simple;
	bh=T91L6dkkoD1YGYKKYQZ8kFKbodZVNzSnde2Ba86iBLA=;
	h=To:From:Subject:Date:Message-Id; b=NmYmMcwXoleanFfzwRMCx147H7t7+jxdbi3Zay1VYkoC97VgDGmDqUR12a6DCU6ztLsNIrN4jM2ahAc4PPgPucQgaDOJVwhmBuEzcSgaIIX26yeBIo6KcdhZRPZOFF6Vbw6eZuGXAX3xD2DGYsw/soAbuafWJFXo/QPlHudHVKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=hWE4kRRO; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="hWE4kRRO"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:38230)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s4Peu-0011OG-0r
	for linux-xfs@vger.kernel.org; Tue, 07 May 2024 18:35:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=m289D8/mSlVedb0yGjcfQMnfvtawiF5YIRIDoGLaLB8=; b=hWE4kRROH0sTt+m4r1z3Q4zoIk
	ccKknp+zm7Lch1ttwIF3pDCBLk27qH9DdWFIjLNgWJpZAm9ueDbkBu62WHhQ3sfd6Bh0yGNGxr6UD
	VvYhSOXSNHztzQHBlEUExZuDXVKyW1Hr+KWcgrgKZD0RM2h06SuwR9Of1balN7rXpcT6X+R332uVd
	LrBqugp4Yk2a98yrDSiDosuYMwadzNf4fN4zyBMrYyYWzWnG2uGtgjcGjQpsYc/vab5U3u6RSwnZt
	twutoYlyIN1ZaiJdQAUPish6lo0tIQ477/Pv0I9LtGnaza9M1Zk7OKdWibZjD10UZu7aI3O95xzm5
	w9WUFK9g==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s4Per-0014bh-Bu
	for linux-xfs@vger.kernel.org; Tue, 07 May 2024 18:35:21 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.7.0-1_source.changes
Date: Tue, 07 May 2024 18:35:21 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1s4Per-0014bh-Bu@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.7.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.7.0-1.dsc
  xfsprogs_6.7.0.orig.tar.xz
  xfsprogs_6.7.0-1.debian.tar.xz
  xfsprogs_6.7.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
