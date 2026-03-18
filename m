Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E41339861
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 11:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773835148; cv=none; b=aWIIRgcdQXW4gPdlXXkyttm6OllnHxQ6D+tg7cz3HnM0rRcF8Xu0F8M6S6lDSLDVV/Gsfjm55/mw/8KlFbHEWTgLGWoXdP9u1CspjBsvyX4whvfowMG7ZYCOLGhgUbCYOVDTcbwwLtAC4Qd2jM5LDnYlBPLEKO4WhhyVCILPeE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773835148; c=relaxed/simple;
	bh=YJpciRz7X7XGfck6OE3OizTs16VfhxnfrFNkgUlun4w=;
	h=To:From:Subject:Date:Message-Id; b=cWnbDIPVTD1vmI7F4ApV0FhkgOU4Itz7MUm/tn4RFTghWa7tQcBRnPKq8DE/9QNVHyMMCUFgl1vrjen/GXWdgSL42qjLb/CQ+8j8z9RUgIscjlvaFpw4m8us2oeOAfEWBYfhK6FHTumYupk4VZ2i+c3EtoHMPZb6gwfk5VINNZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=OmmhwV8I; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="OmmhwV8I"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1w2pYJ-006NPS-0x
	for linux-xfs@vger.kernel.org;
	Wed, 18 Mar 2026 11:59:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=3+A8hjKz8ZeoWrHnSNJ7lmxodloFp066tlsYmO6/n1Y=; b=OmmhwV8IBkShJIUP87ayKaMvCF
	7oK7oawyAvB4cFneuJAKushl4i6PfWSTKM32K3+oCldTMcjB00OT4XqM77t+czJx1+EdS7BdjeelX
	1Mp5h0KsVntdWCQYRoOAWgNv4N3qYDzf/xxNMfb61NrhvGVM5FYzQsh53ima+2u7YzTQeQLMH4LLz
	Fmec0Yn7Jin/RajXIgvVo5EPNU62quxmOjYbN9mKzeiN8zdvVSnPRNrA5NJzpQ6kWdT8dnpb0jQRO
	snhf1x2t77fayxvEiNj4++Ilr+o6LSB6KaI/UWGIv75JhmzwzvHXhzPiq60gax70UfIdo4OtPhTWf
	yguvpXVg==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1w2pYH-005gmb-1P
	for linux-xfs@vger.kernel.org;
	Wed, 18 Mar 2026 11:59:05 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.19.0-1_source.changes
Date: Wed, 18 Mar 2026 11:59:05 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1w2pYH-005gmb-1P@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.19.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.19.0-1.dsc
  xfsprogs_6.19.0.orig.tar.xz
  xfsprogs_6.19.0-1.debian.tar.xz
  xfsprogs_6.19.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
