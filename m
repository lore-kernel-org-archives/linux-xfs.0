Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC0F36C593
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 16:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780484; cv=none; b=HNINGW08OuSuW7+vf1QDQdeae+TCg4gPEAWaeQm5cQBDuunIseUFkayYI2g5Nt87GXN7LiCiEp52gQciRqL7Il8hk0c0+iiRxES4Jo8HNjhnyC2VTgU+9XSUME555GEQOyaO49FLbduTMT5VWJd0BfiyoYYscd3O8g98OvXWHQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780484; c=relaxed/simple;
	bh=ZyCJ4FPKFKmkAcNLhe5PsaiDrH2WiVIidCHX2TQjBdY=;
	h=To:From:Subject:Date:Message-Id; b=T2MxcAz2R954DZJuBYt3O2pToXA0eXamErIogkPZmbl8CuVRsK3iXezVXdVPB+15lwIiOV/c3rqOq3UYtkvIT3foZ+silXbqeuo8wfV31EJJZg5SoWZO06IWCftgRYgQsXy5wPwq3XSXg/LLd8CDSsfs0GxifHs3j0YPy6oQ9Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=wyeIAbVF; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="wyeIAbVF"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:33046)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vQpUi-003SRE-2N
	for linux-xfs@vger.kernel.org;
	Wed, 03 Dec 2025 16:14:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=K6CzcIrgkAVG9xOPf6nUmmWWklDYJWKgiXA7/iy1xJ4=; b=wyeIAbVFKi8n6qPUO1nuHzbz9D
	iWdyWh9jUVc7rS7tm1wTVnJCAyHhZ4VC6TScZYKxjEayX/lKJjH4Wc5PwZrBCVIDJHhbrSEB435Xa
	n8T7XWEP1RkvNIjPvH9Qb23NoHejzcZsolQOtV2hhcTd7DE0VFYCvtRIpWZHLvP836xIjB7dDXhhB
	UThNtgd5zn5Sy8iIRjRjNJEkJL3OWQmh7FDHWf0GuvIzxY03EpF/D+xvVrR1DRvvkaGkgJp4GkMm9
	aWnEQ+u2sqeTNlVYJW10R42wveCgegeezfKUQT50yTXuf1+C1ETF2ilyLex79VHfrz5uWVw8VLaU1
	dyDj7CjQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vQpUh-003XlT-2m
	for linux-xfs@vger.kernel.org;
	Wed, 03 Dec 2025 16:14:19 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.17.0-1_source.changes
Date: Wed, 03 Dec 2025 16:14:19 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1vQpUh-003XlT-2m@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.17.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.17.0-1.dsc
  xfsprogs_6.17.0.orig.tar.xz
  xfsprogs_6.17.0-1.debian.tar.xz
  xfsprogs_6.17.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
