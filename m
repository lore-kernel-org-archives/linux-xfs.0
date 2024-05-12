Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BEB46430
	for <linux-xfs@vger.kernel.org>; Sun, 12 May 2024 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715534773; cv=none; b=LkuGspyAxWvKW2+mfpcKmw28j3Hdt538VR8Lz3QieykfQFT3GjUWWuN10Nt5wuppW3Fua0S28PdqN/jnIjiy8sa7JxgJjkRgVQQqivtRAZUfw0tyh0i5wJ5Bk/SUnSo1RSNx1E00F1FIgVZc3hUKNRVaPnN1CWcA1bCw+U/Rf/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715534773; c=relaxed/simple;
	bh=ViDFkjsmNOIWa1lcJjsWldMiwbQbvCtZO348wQ8C+0U=;
	h=To:From:Subject:Date:Message-Id; b=NK1xRK8iRPQpJJZ14MnCaCQRRiwC+2QUZD1BblfxCvdz0FTc0E6mD3AX6zckQpcQmHvDqN0jfqorZ1rGbAD8ak1rTIyQhIohrg+FpiIFfah8JALWn/q6DMYx+OSg69JROpdPTSWPuNua3eJIBZp84ztsIdAQBPJBtJJHAS7obP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=DKQzV11A; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="DKQzV11A"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:59058)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s6CxZ-006Pzp-VF
	for linux-xfs@vger.kernel.org; Sun, 12 May 2024 17:26:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ZMZEVn/25364zOVsWmd813BAXTpoW6vjuQ2hjfNf0uM=; b=DKQzV11ADVM5lcBZceN0rLvOmZ
	su3GZXEiKtF+Dk2pvBr7AxJj+wnl9Eka24NSchXuB7LeYS1p9ZBJgDQCNlUId+Z0DPZdKYZvFs1x8
	OXQitFTXBVouX6ciSHf1tYPvnyq6tcUWUpgfyEHhGCM3PFciJ2Pg2O4QHw3g9rHwNZEs7t20ka2DB
	++1sKL9WNg8JqfEDue4qQgvREyRN5gRua8YuPuGbuxc3Yimfv4eHH3fEBd0XvYs09YZRJlaGv9A2K
	Kzq7pjdTcd5Ds4+6TBrkPOltX72JsSFsbUg/2Qv2RE37MDHETkOrqJhoOQTd9/kFd9b8BNZbOP113
	x8DFkfFQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s6CxW-006kFS-Uw
	for linux-xfs@vger.kernel.org; Sun, 12 May 2024 17:26:02 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.7.0-3_source.changes
Date: Sun, 12 May 2024 17:26:02 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1s6CxW-006kFS-Uw@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.7.0-3_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.7.0-3.dsc
  xfsprogs_6.7.0-3.debian.tar.xz
  xfsprogs_6.7.0-3_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
