Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4A03D1713
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 08:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783932580; cv=none; b=n6EUFgJ1hcMOWt2S7Rq//hDs1wWYXwPh3MAk8As6Yw0knUetC+KSfy2iWp6Uj78fhN5jJtS2+C+WLimmFWMjQpFf2fgXF3NP0HVhqovcYtVWuLjhvjAadKmnbjKiGaeFvivmpWYG4d5FW2B4PF2QnO53vZL9xNDkuxbPGVnr7Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783932580; c=relaxed/simple;
	bh=+YHZrBp5xPqR5VQtuKSj4UJuQ6zCjUTahsz6aVpQQtA=;
	h=To:From:Subject:Date:Message-Id; b=SNsOU1qyJw4rOXwWVm7tIkq5XrQbo/KvE+CXPCUYSWxDoihdF6jkUL1hSm6hzIVmFwzg7XRbhdZ9BahxFRbIJ2Q+BS+c9avjU5okXIbniK1CpAjdRgM6Lg0hIMtS+9m/uS6tkVUQayviWh4KCoInl0bZuQk727rq00TS+jzb5mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org; spf=pass smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=c+OjQo9f; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="c+OjQo9f"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1wjCM1-001sBZ-1K
	for linux-xfs@vger.kernel.org;
	Mon, 13 Jul 2026 08:49:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=w8t/0UIgBw3vVapDszA/GwBdgIbJgFQ1hfBzOGwBsDM=; b=c+OjQo9f4wctB/mw9E22JuLLus
	RNNvdAf+4hCJDqPhC237/wuHK/ZdjhxXzF7NXnuKPE/maIVJJzqE9JTSU7EqS1yrqlDFKC96K+b71
	49fabcLsutvryRAABmGbKX8Te3wKTHaKy64Le/ZPYvc+LcHTDA/l1hCBn+sAF5HD3tsei1fjE9qx6
	m5yOSFs23t5XnWuHC8JuZ9yxRBbiVfurwvOfkgveeeND+295JHIUAel4Y512v9/dDu6oKHSqbZqIo
	Pw9XqU4Cnzidmz/f8si2CG3ooJleBiyOIHY6xIro85Ua02Tk/6ff7o45D55Kl1FwYpIC3DX29GFpq
	oSCyt9ng==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1wjCLz-001m3Q-2h
	for linux-xfs@vger.kernel.org;
	Mon, 13 Jul 2026 08:49:31 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.13.0-2+deb13u1_source.changes
Date: Mon, 13 Jul 2026 08:49:31 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1wjCLz-001m3Q-2h@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.13.0-2+deb13u1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.13.0-2+deb13u1.dsc
  xfsprogs_6.13.0.orig.tar.xz
  xfsprogs_6.13.0-2+deb13u1.debian.tar.xz
  xfsprogs_6.13.0-2+deb13u1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
