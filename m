Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC42474C08
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 12:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716293126; cv=none; b=im05y4nepgIDKBPeiDKYZSCWJRD+DxmH9e4/yYurU8myO+3ek87g/bAskzOF6qXCoao/62dJO4zBVAl0SIIP7qheNnXWn/JZCxz/jzD2MRrUuhA04traVXVa4g7Y5SK3K6JEwt0U/AivxtB67wkW6v3MUvh+A/lwSOeTJs63L10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716293126; c=relaxed/simple;
	bh=4WrSsotPucOrQ5hXFohlI2St1Xy03c/5Sq9kFzMjz0g=;
	h=To:From:Subject:Date:Message-Id; b=l2V8eLtr69kafiNmMaNY/1jnBIxFXSmNEy+KvasO7l72akk3ylw4bdIGjWd//Yf9jvxX15F+pm/XXElCMeTD6W7w122fg52q8P+YAHwnpjBQDT1pCuvjU28jFzIzTugxGm1MECuhb0vTI18SLl4AaIaydHt/+bo+BE+JxDsY08Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=U+ZOIpp7; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="U+ZOIpp7"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:58316)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s9OF3-00Ftkt-VV
	for linux-xfs@vger.kernel.org; Tue, 21 May 2024 12:05:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=yVF/pf18AJHulb/QyN18Hw1C3VDxFc9PopgPYr0dLjU=; b=U+ZOIpp74d/iJtYjTR3GYu3tcT
	MFSkw2Edac5kGTZv/q7Mx25zhg3DrnMVF+f8sWWQ5XSDLUG+QanEJQFhWwQtkYw3MJanu8o558s8J
	q1CyEK+4SLcH4wQQOaPoSsa9sHFdwXps+1+4Th7OJxzOzClZSxF9pGfSyG8u8e5hPUKexVlxo5CIl
	3/3K4AmDG7jBVv6vaFEWTIAbpw56p+SsHPl9D+Ol5PYPGLD4jMHJmp3sqwmOAI669ZNGV5H6rBIEI
	Svw7VlUFVHKOZEt2JkE+YpQHIRNfjFdkwsTUT2/bcb4PUAKnXFg39U1n46ymj5m54Ypnz2hS+rIaY
	BO3crEZw==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1s9OF2-00GhRS-Gp
	for linux-xfs@vger.kernel.org; Tue, 21 May 2024 12:05:16 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.8.0-1_source.changes
Date: Tue, 21 May 2024 12:05:16 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1s9OF2-00GhRS-Gp@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.8.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.8.0-1.dsc
  xfsprogs_6.8.0.orig.tar.xz
  xfsprogs_6.8.0-1.debian.tar.xz
  xfsprogs_6.8.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
