Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C627CF30
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 22:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716418672; cv=none; b=nbZ8FhDnjLJxLy3ewGYDRvwz7ETpVjA02rSaWBVCTiDzCsakz1rEgMOefFYEPy5kJksvBduSBNPJW0Dk1CIIGSFssK6H2p9c/dpbge1Qi5edL1tI1imantzfMB1BMPX5NQtqWBf8rwT8QPYSTYVdeKNS7pggYXd0W3urO7ABJ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716418672; c=relaxed/simple;
	bh=2og4VhJmoFx2Cjfyp25+zkwbvZnznJ/wfnSSpye7wq4=;
	h=To:From:Subject:Date:Message-Id; b=C0TbxQDipI+YWpA7cFmzHb8h861VGylN0sjM0Dp/abKpbRDy9d5xiQg/twyViRoiVTv/dQPEfLkyyAg/BJvhaSzW0VIhm5aHrPBfDWri4gUgpcNzYGXf8BKr2ZLjQxlS8ijWpnTA/JS1t5m1NmzUeqjaEmDt7GRVfxlh0pHfQR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=QolHJCyN; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="QolHJCyN"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:54232)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s9uu3-00HFEy-Pz
	for linux-xfs@vger.kernel.org; Wed, 22 May 2024 22:57:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=lQdhDZBfsEhGN2iHfdoqOgpZsnhn8tVxZyZUjvzVKHM=; b=QolHJCyNzy3qdJP3rDiQJ64QrS
	leyaBadQJEiVOg7VhtN0EkTuXxWKZvYRES06nvA5zdrQyq3zDOoIBPkrKMLSAUIkvpt6SVlo5oTsB
	DcTL+W3qqAkpRL67Mx7EWTYniEtw5pYmt4aLFuPje9XsplmAsNBwdIbhige+N4KfK7d0oajyrzOrB
	MF31l03K9lkAY5auSCo0RSwQoD7Z3ZCLbbGZe8p2Z+tH3jvpRr/gS+SAZwu5Yi2Y3dml3vmupv+iH
	ZYP1DZhzflhO6WY+jhEjgRPkWnmnJBqAqs61vgBHdi4gu64ajzlm+rc7WjVaufYKhkX1qoZKGRiQs
	l5wAjdJw==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s9uu2-000nlq-Et
	for linux-xfs@vger.kernel.org; Wed, 22 May 2024 22:57:46 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.8.0-2_source.changes
Date: Wed, 22 May 2024 22:57:46 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1s9uu2-000nlq-Et@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.8.0-2_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.8.0-2.dsc
  xfsprogs_6.8.0-2.debian.tar.xz
  xfsprogs_6.8.0-2_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
