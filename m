Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC05B54654
	for <linux-xfs@vger.kernel.org>; Fri, 15 Aug 2025 12:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755262013; cv=none; b=Jvit740DGNJNCIyvT5c1TRTBp3Yxw33NtBbA0uaaVa0dMudDqKE/xJIGoI0CoxK55/dWilXfufJgv3anhMWjQiGwid3qK2nXurNt5Jn8sWcPdHKsw0VeBcKf0XQXlS43pxYh7dW1fY3P2qKFS5FTZeEeHpkQ5NcvtiwV9/nTk9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755262013; c=relaxed/simple;
	bh=VPhP7ihBsN7RU2GPk7n1HGrq1Oj39G5jukmV35sTpyk=;
	h=To:From:Subject:Date:Message-Id; b=p8bP+nSD9fPJpBpvJqU8c18XTrLadsZDc7sdFv8U8Uz8x8nm0HlouxxBdXssK9VBy+wk1pN6hWIgWoD+fVQgUXJWGktBgPl8nVn6sUDhMsVbYNUw5bi1MPupMV1znZjdWhvgt2/F+jZ4iOTT/tUDCBd6i7fDdR8L6YP3dM39UrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=TeFifLkK; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="TeFifLkK"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:36266)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1umtpY-006aQ5-Do
	for linux-xfs@vger.kernel.org; Fri, 15 Aug 2025 12:46:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=MQcIOQrYjTJjYriTNoHTMBVWAlZEgsNJIdj9cmlyz3A=; b=TeFifLkKhgHRCYJOUbeEiHWEz2
	9oa684ORlPTsbvAr08YF+/1lc9SCM4jT2FfFrq0WOO8ncA+R3DBEcbJZb1VnzqYUOIaWm9Ag5WF/8
	SLmD5PjuE3x+DRQ27NYeNUIg8BNO6FDi/rOgcFhw6vsX/q6mxs1UCj3Pu/rYB2RoWF2pf96IduhKh
	OWdzJF/bVrdCFoCGlOJt4rcB1XIWfoaYvF71ICz/xxxX2vZguoEQ6r/pwDtn2Ap11YOMvAtNSHDN1
	cp1jQbCXmQwMGBSYjmSSx1WTFkzLyubTww6Prrfvar3DVlm0JsTbJIBda0gr9uWvBG1UAlDdvtZcm
	2ug7FZhw==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1umtpW-0021MW-2g
	for linux-xfs@vger.kernel.org;
	Fri, 15 Aug 2025 12:46:46 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.14.0-1_source.changes
Date: Fri, 15 Aug 2025 12:46:46 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1umtpW-0021MW-2g@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.14.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.14.0-1.dsc
  xfsprogs_6.14.0.orig.tar.xz
  xfsprogs_6.14.0-1.debian.tar.xz
  xfsprogs_6.14.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
