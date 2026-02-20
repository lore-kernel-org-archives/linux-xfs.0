Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870962857F1
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 17:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771608159; cv=none; b=OHQl/7Dw01TpijhSMHAiFQf3Jfbf5Wn2qzi/bqqJRoc7ncnwMIIevG5BHMhPX8xUsrPMNl5V13diyFb+QZ/lt3rZb/AdT5WZhPsKLTie08mrxGuBkqZws5DQ5Nzc6bJEEC+E+ztq85fUEOTd4vLgXhzM1VGDZJX5Y++rjRNxyz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771608159; c=relaxed/simple;
	bh=czac0w0NqFs/pJSV1V3ebQnZRffsUSomVYcx6UeVago=;
	h=To:From:Subject:Date:Message-Id; b=X4hMHZF7hVi7dXnUEWeIjZJZP5GmgYk2dJX1Ow9fJ9wqMgNgwgBWjthpFeRCeBlwYuexR62OP2c7OKwVYhxIkWaWq6LExDzgCbmj3xntcv2PbH/x/nQT+mGsri9cno3itEtPmxl9g6OQJQj/Y0Bjs3WblB5xuo7bXjHtG9Sogu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=eCeuRues; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="eCeuRues"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:57562)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vtUD2-00BlbK-0B
	for linux-xfs@vger.kernel.org;
	Fri, 20 Feb 2026 17:22:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hn41/7lwVpwWI605lyI8ELUGuL5vdsuah3+MUAiJoAs=; b=eCeuRuesLOBNNDqZZbimYk3xyk
	oZ8PijkyksMkv9h3LEhEisaVzLp3TAPm+/6GM/k4UWJg3/JuRaqhZj1KE4Q3706hTHcEserxldPKR
	hc951oDPVi2JYTPtT2lkCeZIwTpW1OuraJINgiG0/qsnWT9fskaQ2cPwEeIwDkdvznh5W4HZXFHgn
	v+3VWI+2QhvD6haUyS4hzOXjHvtzw1EQyNG+XzCNtIbPTLZv028A37oFC7eyLff3vw/tA8Pv6MbKv
	11wMkMUhzVSHunmU7oV8WPKLXWBftxNZRSYxFfM2cZqC8AVX9QSce3UzMFuNtCIphMcAdmdSDDq6D
	Tf/KC3Ww==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vtUD1-00B4r9-0l
	for linux-xfs@vger.kernel.org;
	Fri, 20 Feb 2026 17:22:31 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.18.0-4_source.changes
Date: Fri, 20 Feb 2026 17:22:31 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1vtUD1-00B4r9-0l@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.18.0-4_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.18.0-4.dsc
  xfsprogs_6.18.0-4.debian.tar.xz
  xfsprogs_6.18.0-4_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
