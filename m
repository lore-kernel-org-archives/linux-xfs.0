Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B90A181B8D
	for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2024 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718207839; cv=none; b=MBMuzzHk5t3l9athP1q8r3pEQOt8oa1DmLVCh6EKZ36LH8F+2mPffXvXqkTiCJXNLCz8+zpQVjcWsrtSdKyfRGLISsFV317kAQQ+Vclc3JTL2jneFY+pTF+fkozrom4q+7VhQVlUXJxAR6uxC+nLCKB9h5xp7saxptmB9t/D0dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718207839; c=relaxed/simple;
	bh=Y0EZ4/ScNzk23CHFb9YPmpM0MbZAna2N8AEZdREQ4WM=;
	h=To:From:Subject:Date:Message-Id; b=UsF9fR7kiccKMWGzlpoZnnLZm+9ztDcyNLHcVefHsLT/xXAHnPsbyEwMyyCxHjSLAj/F9gaBkaLBkPSq44AMP8udL9tARPZ3/batJRE08K0uW4TuDQpoDPfH6liEIfckIbw0UwwtlyC3WH1je1RDbjbx/ZBiqa/vXz3WEjI3cF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=aGVlZs3I; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="aGVlZs3I"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:45700)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1sHQLd-009NJs-F6
	for linux-xfs@vger.kernel.org; Wed, 12 Jun 2024 15:57:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=jpxY+cTS25HWY+XSTo8HHSILSP1bKj+D+GIASCKGhew=; b=aGVlZs3IGjU8KbThpLPgytHYTY
	aebjufjuGlJWowlW+H1FZK8MBjnp0k4+BjY928iBe5tC8gmtuun2ly0GLfK3xd73D/wUrbZBbiw71
	krMWVAWA7fkK0+RMB8IVBmHBrgwaK82x76KYmCOSd2QQSNZdwTZtauLByXbfbVbgGYPU6aOaWTBtJ
	9klo/FyppxMc9lTlJL+ohk6gTVOtAz2sCO4V5NLm+mZXuyW8AXTPPI75fjK4bZCFGDghEj0bAHetZ
	ZJGixFpfhvH+GI+9xUWOT4n6IE4ySjZiJIiByAVKelmo1xQSskT+y57vs2vg1TVEEq0cNHNXoQR+V
	MQglVNmQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1sHQLc-00AM0v-0Y
	for linux-xfs@vger.kernel.org; Wed, 12 Jun 2024 15:57:16 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.8.0-2.1_source.changes
Date: Wed, 12 Jun 2024 15:57:15 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1sHQLc-00AM0v-0Y@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.8.0-2.1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.8.0-2.1.dsc
  xfsprogs_6.8.0-2.1.debian.tar.xz
  xfsprogs_6.8.0-2.1_arm64.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
