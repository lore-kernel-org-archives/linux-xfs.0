Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB0D204085
	for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2025 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740322460; cv=none; b=N+sA4ErEG51b2qspVYZDXe/bnkFax15PikWW4diTsDow9aNOmT8MHdwF5Fn+adhclB/T5zVpy0kUIocHAkpZjRDVfLwugbf0I5OydqrbA+XmXpsFWa17cINvYexummPrAkpnjg9sEyNrK39HhGo8Rqxd1obzVdXjnpo0trDSYmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740322460; c=relaxed/simple;
	bh=eBJTe17VKgG/yJAVdSALY3CS6Pg0ID5znfEM0kLd5HU=;
	h=To:From:Subject:Date:Message-Id; b=ApPmVF6sp1HZxnz1EfgJLHpSkHiHHIO6vCVUvWrHWyRExMOw7ugX53uWRx4RsC5wpkZ1CHJPP+m1EtPG2d6nYDZM0BSVcRNlocHdVl7XYpxhDch1SL1aOJFaNKnImz9puhArmGCDgxHN82HjXKKZY/LH/P8OzKuo0MCMkqZSdI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=hcTm6Cpw; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="hcTm6Cpw"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:49946)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1tmDMz-007rIo-Ka
	for linux-xfs@vger.kernel.org; Sun, 23 Feb 2025 14:54:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gCUzuV0diH/u0TlVvBJkyAX+PdH3vrqw4kvQV5bm2Gw=; b=hcTm6CpwVlRuNdclmbS9Hb9MfY
	Jxd/5QY8zyihwMNLLWcQR8KBzavJiO6CndZG4811UGUL6FvGbh1AF/6J2H3GFChFreITQtRwd1JYQ
	8PTwxjdUWeqNHVR1OHkO2yMaOWExGZ20Sqa3SECIKrpFxZIGhjk/DjsRwKLoJE6zQWDSFjEdxnDhv
	UNDGBlSpp4zpmmF8WYe/dS1NSFThAlV9tHyH1eFMMedK8E+yuYvsfQ+0UXwNXoY7LOwI36g9maZ45
	YB21WFYbLaQdahePFmjCdpGbkd2dDA5t3uNrBuP1laEOW8XE8l1TKjSKkXkf5+YJqL4pNyOln9U06
	/4iE0ogg==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1tmDMy-00DKBH-86
	for linux-xfs@vger.kernel.org; Sun, 23 Feb 2025 14:54:12 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.13.0-2_source.changes
Date: Sun, 23 Feb 2025 14:54:12 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1tmDMy-00DKBH-86@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.13.0-2_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.13.0-2.dsc
  xfsprogs_6.13.0-2.debian.tar.xz
  xfsprogs_6.13.0-2_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
