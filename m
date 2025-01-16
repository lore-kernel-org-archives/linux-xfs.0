Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DC71DE2CA
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jan 2025 12:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737029839; cv=none; b=b8LXFUz+vAizlacqOhzNsCLWaa8ON5VsZJTN6txy0Fdo2LdiaVaktNvAAO99xC+mpEN09idlsIs/bNkE9+tUqQN14USZ+I9iq4Z0FIgxKCoCHOoEg5YxKlYLxh3dVvSCUFRPIjsB1RyUGqXOLMeWezt6rTt4eVDdSiNf7MsgZ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737029839; c=relaxed/simple;
	bh=b1HaO1u0wZGGEWWSiYjV6e0gpvleVVQWs4/hloAwdkk=;
	h=To:From:Subject:Date:Message-Id; b=NIFcP71LxOGNaPSSjxUhVjFLUkCu0Pgnz7UPJf+xbQrW/JLVkK2Dj/8rcRHVDivBkjrsXeT30+eJ8a4DF/+h0bWN+eNgWAn+8/eeIzF6T+805FqrkfjfJ35k1CLQDHMaVm1OkukDkwxAc/z97N8dAxWlpYQkCgBywXa88Tstglg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=cl40BZEY; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="cl40BZEY"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:55710)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1tYOo7-006Htv-Im
	for linux-xfs@vger.kernel.org; Thu, 16 Jan 2025 12:17:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hE5QriNaBPrnlSYmys94cuNlorB+t0q+tS8pDylb9N4=; b=cl40BZEYXe2kVLGUmxW4BOZlP5
	YxkHmR8hzgf9yn/vBlt7e2jvELGrSWC2KgZ1RdJpxNJQeMgVvS4dsYk3Dmvb7Z+7n1ogNitMDsBVW
	n0rCdqVFviGM2WCgNnJ7UrRxwFQwyUQpBAEjw+EhwcB3n0Hm7raFZDeGrVoexYAToS+ikMNZ7YdX8
	48jOtNQUKmIN7AcfXuZTvZ8tXbHfuRj81m62iolfvkZKlO/geIhBSH6VUR4SHRBTVW28bQLYT+I/a
	qTg1b0TvJcnDcgEqn67m8EsCzF1LTkPpygpzqTUqjIvw1+/t8iIGHGIKOtWx/mM1cUoMZ/jhBmC54
	eKkpgIrw==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1tYOo6-004JCl-A0
	for linux-xfs@vger.kernel.org; Thu, 16 Jan 2025 12:17:06 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsdump_3.2.0-2_source.changes
Date: Thu, 16 Jan 2025 12:17:06 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsdump
Message-Id: <E1tYOo6-004JCl-A0@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsdump_3.2.0-2_source.changes uploaded successfully to localhost
along with the files:
  xfsdump_3.2.0-2.dsc
  xfsdump_3.2.0-2.debian.tar.xz
  xfsdump_3.2.0-2_amd64.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
