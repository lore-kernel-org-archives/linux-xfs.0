Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D7117C98
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 00:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334073; cv=none; b=m5z3OdJmKFC5BkC0zgmTaS+O3ECT1gve0yUNJJfABFrqFdNKWhWFgvqZvKLnzMXCGFV4mm3QQQ0ZyyDIevvcAgBEt2RypJujUbFwpzh3n7Nd2f1I3XOFfLYlwGxikSyRTiCNX3n7XR/HM0ThMbIPi1CbEVahQFuSjFAWBQ8wW1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334073; c=relaxed/simple;
	bh=t7Nmb9hzqrDpy38fji1BPNbQWobD5y0NihfxIyT9e8E=;
	h=To:From:Subject:Date:Message-Id; b=YjFtMDGBCO87o5GD3t1EVtlBLnh7zfdM/Drejx3LP+tYXsy2Volr0Ta56mvkSiai92OImetl5eeD7R9cckV1TqrTdIyMMNe94HT7TERWJ7g9Mh1zN9eCFvra1pMqsaPRnmJJP9khYqirSW7iUdhRiMdJsB5epZXWf/zIVkp7Q3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=d/iwP9/P; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="d/iwP9/P"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:35544)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1t6Iw2-007aAw-9q
	for linux-xfs@vger.kernel.org; Thu, 31 Oct 2024 00:21:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=tPVSWCb4SWhfd08BLROIUSSlQadqVPeADWV+AK4MYMk=; b=d/iwP9/PIn0XUlNzNeVEDLUNBZ
	uHpwBlDj3XpOvzpABpbBbqmZFeqOxZ0emD50KymorSQpTq1rKTaK+U/uMzvX66wRf/M5DL9612/93
	6O6Zc3oZixtcciYpIk2zCXKNmUB013ED+r2gDZW8Lj2RfgSBK4dDOPLF6/g54phnAj3Roxpvi+KNv
	pSA3iZKmZlRy9NL5D0ufN8vpwyMyvWp/KZtxZD7XfVGX7inGzi2Cw+4aHKI+wmaQDJuB2DWrbNcim
	ULlrd4Yy2GDncB70Vt5LMtbSOknnU1RJc9hN7u6+nol4KFaFaeFIL9SYdcumbKfrK89sC+R9ZjjDC
	xZ59UW7w==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1t6Iw0-00BJgj-MV
	for linux-xfs@vger.kernel.org; Thu, 31 Oct 2024 00:21:08 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.11.0-1_source.changes
Date: Thu, 31 Oct 2024 00:21:08 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1t6Iw0-00BJgj-MV@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.11.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.11.0-1.dsc
  xfsprogs_6.11.0.orig.tar.xz
  xfsprogs_6.11.0-1.debian.tar.xz
  xfsprogs_6.11.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
