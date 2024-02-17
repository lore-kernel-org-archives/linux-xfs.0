Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B94281E
	for <linux-xfs@vger.kernel.org>; Sat, 17 Feb 2024 12:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708172633; cv=none; b=G0VC2j6VoTGRM5OamEq23mtV9U9wJKN+E/hRLpOgwiVTN4eVVbxKhiXZoK8Ffe8rNmvKBH/YVRewNmzysqm2yJ0druJBDRYKKm7+WA5iWpMuKVBTNSBey/K1N4Jsc1jOtSlAEm0ssiEY2L8ZLJLlQFbaVrXzpVfEGw46dDtRfIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708172633; c=relaxed/simple;
	bh=8HMuWN8UqH+1h7/7f//CdmogG2GLr2w4Y3tXEukV+ZM=;
	h=To:From:Subject:Date:Message-Id; b=DR2ZNDeIqmzTCaGYnwzhZLi4PJRhTRCZDGX3WDf98fpiyXsxSDuj9UllPHw7MyGOqeVuz1AbYObt7+95J38PAMG4O/Wgn9nLJrv5VyBjVCtJzGN33Zlc6gnK8osaoELLKvFlu735GZaR+MH1Q7XoSYl9TpWUwJyxc83jjc4l8ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=v2pgWIIl; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="v2pgWIIl"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:42832)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1rbJjK-0079S1-Q6
	for linux-xfs@vger.kernel.org; Sat, 17 Feb 2024 12:23:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=VSAnK4xXZFc9AbcvjFmo0reWOTarbTByS06WBmCmvZc=; b=v2pgWIIlCQjfdXXn+bkJOKOfcc
	RLwgFpAV1AmUB2ENlTzGDqjIwaiA0+HO8ceegl7su5mkn2ggYYJiykpU8aZ3iZ+OX+9aSDZpV0Ixu
	VQwEI2EdeTB1H+rYAvVvEW6gVyHQjJQnW76Z5tD6JA+4nRoL7l7Jl82y/W5eeVqz7G9RC7PuzwrLc
	NvnoIgtEqO/IYQ+1kUYPxv4tqrHcNftwaO8a2oKBk7pavCIGc18i9+Wz4J+gv/KcABlHCrJbkw6lQ
	3h/PBqP06rPgv9UZLBYHpd0qYoqUqlKrKbQ8cXhg3DrCfILn2k9Rqz09Ssr5O37w6y9YaO2KqT5Ph
	VufQjqyQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1rbJjJ-007u91-BN
	for linux-xfs@vger.kernel.org; Sat, 17 Feb 2024 12:23:41 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.6.0-1_source.changes
Date: Sat, 17 Feb 2024 12:23:41 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1rbJjJ-007u91-BN@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.6.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.6.0-1.dsc
  xfsprogs_6.6.0.orig.tar.xz
  xfsprogs_6.6.0-1.debian.tar.xz
  xfsprogs_6.6.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
