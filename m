Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67818DF7E
	for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2024 07:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126783; cv=none; b=hO5dSS4fdiavjWGzL32PgrHEu8ZWLwsnoQuLA8RzoR2KmK6opGQpkVKBh7Hl8ginx247V6cY7HMP5vj1lf8chDq6HFfy0LYqI8paShwwHE9fN4VOgoIpj9uidU3Xwk62BakxLBE0zh+uHYNu7AcBUPEWPi2zyUuBNQeciuDttpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126783; c=relaxed/simple;
	bh=DAuzemJ/LgaH+QiaQaCAZOInoNfgpaQKdbJxqlVekBE=;
	h=To:From:Subject:Date:Message-Id; b=cDflL0qd3LZFZONtKDN7fSk4kTngpBKxxY5xU0+CYAxsv/TFYprZrhxOeU5CGLilh0NAkOxwHqRJ1lV1T8POljmGlM6pnldTX4s8oefdcmJmPwL0FJEw9kAnE5VLYWl07DiThKi0nEERievV1lQzPdicCVXLXI6bW9gMxH+Hptg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=BXj2N8/0; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="BXj2N8/0"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:54568)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1soeQV-006qVo-Kc
	for linux-xfs@vger.kernel.org; Thu, 12 Sep 2024 07:39:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=scMemI5U3LlxwyMuyt4TJNxKLmnfXpRAFc0w80Dyr4M=; b=BXj2N8/0akdeNIizIJlbwr6sR2
	8m4JjkGVSNRjTGm/F+Ctcm/9Wmdcujqa0StDHQ6mffLPYcQs6fsAl2Oyybq1KUo4ejgAK+ayOpaLs
	HyVAnFPUwiC7DpPpNRDCTujeT7La40bkmcoWhMUsHH1pbEC1x3MvfnydL7XeztROTpfDZrhF2bBeM
	N3YRHLE52YimRBghnf38IypaB6oev1gFTAR9XoFJMV1S+WxnjcoISJYhphVei5VKTvzfyUqsYaV8i
	gIFPOSrFSgunZFcMmQTaE7Yobih7IgvxUom4YqUH6QwcAn+h8rf3jHWw/muBtTH0ypSCp+528wSuR
	uGv5QL3w==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1soeQT-004IFm-9y
	for linux-xfs@vger.kernel.org; Thu, 12 Sep 2024 07:39:37 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.10.1-1_source.changes
Date: Thu, 12 Sep 2024 07:39:37 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1soeQT-004IFm-9y@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.10.1-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.10.1-1.dsc
  xfsprogs_6.10.1.orig.tar.xz
  xfsprogs_6.10.1-1.debian.tar.xz
  xfsprogs_6.10.1-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
