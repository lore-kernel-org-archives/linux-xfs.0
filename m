Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53FD2135AD
	for <linux-xfs@vger.kernel.org>; Sun, 31 Aug 2025 19:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756670046; cv=none; b=G4xFSXH7b7udIFAsc0P3v2z0vWOZxQJH4itw7BRQcQPz1LPvZwy6cg10YEow7CRVYI8jAWzjC0eVUrbFqpCMai9eyPup+khKH1pQrKJ/If/Gw0uwmOXZ+Ki2nsIlgseZQTO44qv3oO1ahxUhjwYhzzy9yVhTMYYJoCVuAKINXnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756670046; c=relaxed/simple;
	bh=1scB1s7P0RNdMkqbf78vfLQf7OD8hPfhfTvdoxufbUk=;
	h=To:From:Subject:Date:Message-Id; b=Y05N+wXJlbUMk+K81cE7znIYXtemPtUjDKZ5uRoraKxqWgQ1HNCehiP5UmEHQjGEa5zoEfVjPOWNigHx7tJRfJ2/K1Uut8SRcf8K+3381EL43YbvGORXcmc6aOGOQyqljyxtlFbeuuyFsz+nD77vnTNm7OcxPsGbLM2kY8b6S+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=FSUqigh5; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="FSUqigh5"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:35660)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1uso7h-006Q6h-6J
	for linux-xfs@vger.kernel.org; Sun, 31 Aug 2025 19:53:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=T5wGzIDiSjT+jj2N5xyaaea3vZdcmGhMInjTHDAQYYQ=; b=FSUqigh5DY1aiLQGAHbiHUbiaY
	PguEt6AQEE83yx3OG50nwkwK7qA/I3XaV0upbnBVqsD2OERwOIl1zLsvdJH56dLceS6eb68EcZv4F
	mWK9vEnGZkCIfX6GfEV585iEpOwSOWIu+Gxb2w3xDhk5q9tvS+EIFz0qXLrxgDP/8+gg2DpdRcpWR
	Whz6Bnf8KnRYVwfPRH7Mhprc9fWXr0h3gGA/tdbALHoaWM47RcauH7GiEyjv0DITTy8oG6Y1ujKCF
	uw2Su8RyqSua4DiYEd8/ZVcEXCzRr0O+RtqnEzVCXiXnQkYJHrkplsGdN9tfrr68xinVHwqNwR51z
	oycI1eLA==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1uso7g-002Rig-0l
	for linux-xfs@vger.kernel.org;
	Sun, 31 Aug 2025 19:53:56 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.16.0-1_source.changes
Date: Sun, 31 Aug 2025 19:53:56 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1uso7g-002Rig-0l@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.16.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.16.0-1.dsc
  xfsprogs_6.16.0.orig.tar.xz
  xfsprogs_6.16.0-1.debian.tar.xz
  xfsprogs_6.16.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
