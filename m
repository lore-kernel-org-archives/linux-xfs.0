Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368D7302754
	for <linux-xfs@vger.kernel.org>; Fri, 15 Aug 2025 13:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755265973; cv=none; b=MbUsgWIVZZFvvt4IguD01Kqp6LAHmJdiLwxY5kKk0Mg+UxYzFYN46r8L4p6zWgmiJRjmSEzbI5Xi1HAIwT+e5BJOUfaSA4Z+NbBJss738Qzr7y5hLce5GgAQtLADrqqVXUQh+nElePCXF2yRUfALIrf2uYDmYjevuWWT8Qk5OIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755265973; c=relaxed/simple;
	bh=jdWmnfcJHsRUbWbYHasAQZVK+3SUClXquhvyrwDB7C8=;
	h=To:From:Subject:Date:Message-Id; b=FSA2YCi+QqV1efWM7U2P44hjyeMH++1RwoJ2wM6PbK338kxhAUcNa2HGzAQi6MzEOXsLEe2fp8u/p2ChohU/iqdt8ZTGYp5JMRJAkyUnqyGeNcxwh/gSp9Eor6ba/soOQea2bcZBYiAK8vLryhj+JmRRvcLicTT+cYZa1XUAHJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=Q3IBX52D; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="Q3IBX52D"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:36638)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1umurQ-006dWb-L2
	for linux-xfs@vger.kernel.org; Fri, 15 Aug 2025 13:52:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=e7JpYNn888rMnh7g79xEh+ptb9KPQfoPu4WW5AfJyOk=; b=Q3IBX52Dn/jPDCwoUVTj9PWgN1
	FChX5j2mL9E6kZSuQC6pAtPTXKLzgv8wXeV3YbzyiUFc6g5wZ71gkVvE7qmSOzRC0nwRZJE3SSjwJ
	WhiwKMeLYqQNOzlW+9WinTPWXN2zjAqCoMPBCQ0FdjhSUR+9vpXPUisJSziOq/tkh95pSfemtZtLu
	Atc88Iw0Fl3FqktECpuzn82/+rRA2kL2PL7NdQqPO+y3TS2MvPcx2IWpJ+nzvUY5QUvzQIx+cknJO
	gOej7z0xlykIoyjosCWMchXxlIOsInNJLxqVE7tC/+ydRNo/khZkfxz31Z2riOHVFeDPkM1qWop49
	0GY4/YpQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1umurP-0024uq-1X
	for linux-xfs@vger.kernel.org;
	Fri, 15 Aug 2025 13:52:47 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.15.0-1_source.changes
Date: Fri, 15 Aug 2025 13:52:47 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1umurP-0024uq-1X@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.15.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.15.0-1.dsc
  xfsprogs_6.15.0.orig.tar.xz
  xfsprogs_6.15.0-1.debian.tar.xz
  xfsprogs_6.15.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
