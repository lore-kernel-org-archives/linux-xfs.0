Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE8173511
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 21:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116453; cv=none; b=H9P7op6/OheveAQCSKlFeFWPI3xNE6SD8Zm2yyzSphikAHxOsy6Y1ERqBgJMFvIYmT4C2VVQKAaZ8u9GtOdBXLC1xwp52ZDjbOEGQtuyoW5orjgVxlRFI6R8Su2ORfhf1owROp9lJk62hkVEQEzOqAH1+vP88StzbqSFb9MtjgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116453; c=relaxed/simple;
	bh=JkBG3nFBB2Pc3MV7rG11PliWbRc63yb/koBwWpH21pI=;
	h=To:From:Subject:Date:Message-Id; b=tB1hd1y2++V2drSUyFBDsh3eoOQs6ydd0IMMC2OgAEUXKHRksFot8BpDwbFHObDsPzxOh160ym2h0a3H/w1Oj54mEjhATyoiLE+B4Rfygu2W0Fu2Z+6ERT2NZraAXqZPDQcrrFjh2MhNCuyXqY5MgDjcKiT7ghK/pxXyPNwudS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=uHMBB79i; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="uHMBB79i"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:47256)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s4S8R-00180r-3E
	for linux-xfs@vger.kernel.org; Tue, 07 May 2024 21:14:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=WS6UElS5QFjb4KU9+zNaVJb23F98fEme/5/Y2c2HuPc=; b=uHMBB79i/48xx5phl9QR/rsTVF
	aUWkI6JHqOLdY51Mt3JWHzd9gT5dHwV9evL75h4XZ+zkh0AJToIpIJEoC7YfeAEpeXICNQACtJ16A
	QW8e3u/z4n6ygoFk2TCnC3GxQJvjiOm+sxAAzNhl7d43eCncRI6PlJ3fiKEo09WFUdQgeML5lTMpI
	5QFnXERvMX2crMI/IRl8GenJhebadDOr7HSMddd4u98pWq/v8Vm4H3FN6DM6jDDasuwrjGstH6p+e
	O8U3oZ9+qaewy02zsJaaBLx3qPQIJNYx8lONwU7c3suJAJsjBrQHK9B5225CZ4Soz5L/vuuxYGQWN
	DG98iKUg==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s4S8P-001CqE-1v
	for linux-xfs@vger.kernel.org; Tue, 07 May 2024 21:14:01 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.7.0-2_source.changes
Date: Tue, 07 May 2024 21:14:01 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1s4S8P-001CqE-1v@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.7.0-2_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.7.0-2.dsc
  xfsprogs_6.7.0-2.debian.tar.xz
  xfsprogs_6.7.0-2_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
