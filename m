Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585444D2ED9
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 15:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781787; cv=none; b=dF6sQEqK6mWdOeQl2Jo8xGuiWPYF2WKBj7b/VAdF0fktKtNQsWjyW+Xd99Ajfxx0YmSmF7dB5I7jLJ9D0r5XmbucfiH86LlmqQENhfTRMv6Wk9WIhjemlYjuf4vLyWLhEFQZ/EzMN3daIuR/AOJbVVOVJyY9OuCts2fToOTHRiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781787; c=relaxed/simple;
	bh=APfa2xJt+sYG3/zBSqC1UKGf1NQD1K1FQkKETPuvV+8=;
	h=To:From:Subject:Date:Message-Id; b=YBVSFfnzfn4YF3eZ+hZw7ovtKMdbwC3YU72wSniitrsXN2qZNaLGDUc/5tGBdEnvctTI5uInl8IAxc3m3ZAGiAAxa8FFjPTquUZPuyUQkl7I/vkvN3BNotZGiKUWc0X3iCOKz6RJ73mj2j1YuvEs/Prp88ZQUpZ4/oYpcAdBNmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org; spf=pass smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=d+fMvwJq; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="d+fMvwJq"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1xBw8z-00CFfR-2t
	for linux-xfs@vger.kernel.org;
	Wed, 30 Sep 2026 15:22:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=Nc14M5662WT1Z7TLuC0h5Fa1iujfolW4ukF6axwvDI8=; b=d+fMvwJqaBzI0xPUVAIJM9bQQc
	1cJ028X+xoW5xMSV8f510giCyW/vWIdZoVEase2n+z6KE/TQMl8Dvwln18m4oCZOuLNKPWYonBUFL
	WtBrE565J94AZRAjYRWMho2/L2Rf9c8PZ0T3RnKQylJHOky4f5JsGiRAmcQx4Jrko4V8isLf87wkP
	WHYsfWvCbJGhqlNRKxPD5V20TsZKR8BVpuNoiHmWYqwUYKE/4oRNJJIcuEAWPuSt65TzViZkaZBAr
	pAKPbrz9DAwDeAZyd3rL5LBrQoa403WmCW+VYyKP69yyEJuGTB6VUJLLmkuOwUmu9hBz1hv4u0Swd
	l32LLT7A==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1xBw8y-00BwPc-2U
	for linux-xfs@vger.kernel.org;
	Wed, 30 Sep 2026 15:22:52 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_7.2.0-1_source.changes
Date: Wed, 30 Sep 2026 15:22:52 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1xBw8y-00BwPc-2U@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_7.2.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_7.2.0-1.dsc
  xfsprogs_7.2.0.orig.tar.xz
  xfsprogs_7.2.0-1.debian.tar.xz
  xfsprogs_7.2.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
