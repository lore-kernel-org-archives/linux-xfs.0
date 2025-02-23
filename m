Received: from muffat.debian.org (muffat.debian.org [209.87.16.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E49C1FC7FE
	for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2025 08:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740298918; cv=none; b=MXiIPPDjC8PlHuZok6XVkVh6Msf3/dbsH8XTsBDu3LuDOLBY5QjN5cAaZFzOnzURYkATXi3s4MHTVbc8khFiUXz1mc1ApxQ7ympL5Qg0XLGJMynAP+tQzEiQiNhkr1p0Buwk5M0K4IZ4dXGpAt7QgcOJNz9qdUrH1d8zxIGN804=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740298918; c=relaxed/simple;
	bh=qdHEBR7dXfqNE2R4PMcGowHEd1uiLHDJGVKf7KR74WQ=;
	h=To:From:Subject:Date:Message-Id; b=BWvGcfjwpGMtlEAhoabuE+r4eC+meCduJpViYjQs/J7FrnBJgZNqs8lYu+m+hvMSa5nN2ZKe82M8ZNglzbVa9aLoG16Zqpkkp2zbShYxbtvlh3K6a7jKbBRCrKo2PWnk9pevi2MF9kVk4JAxvG+fkU+cZx6keasfjvCTYK6MANA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=Uddled67; arc=none smtp.client-ip=209.87.16.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="Uddled67"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:36190)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1tm6vg-005bHT-TZ
	for linux-xfs@vger.kernel.org; Sun, 23 Feb 2025 08:01:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=YHUVGmvvOzGE1FuxXEaZG4hhKqfBScaF7uOiLQWwynM=; b=Uddled679B4hyRQWVZOjBFxt1g
	I62CYuG0JpanRlSDyRKqYoMplJHEMqv8sCdTVEzFaXiLK07ZRA4Bgkc+ZqvceJoO+awpCus1CaItx
	BUxKdnXRiUYLL/zV8GHwTtF+Gd01gwkLkJcE79O01hScOEFT6eXBuzCXV9lLpKDgtcJ/RogswVqdo
	MvO7CU8wLeRzJ2Ca8jZfFIYzS6CTcZnkx7ZdTx4rHw07LxKU/RJUx8Nq1LOy6h7rxxTj9ZgSXQ3S2
	fm1aRUhqlx5Mnbo3ewHFJGjlu9DwmzrJsXjStJK29xsd6SSbLAjrnhumyVrDrbchoVmkYRYsP9yMJ
	Nbv7C80w==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.94.2)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1tm6vf-00D0GL-RP
	for linux-xfs@vger.kernel.org; Sun, 23 Feb 2025 08:01:35 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.13.0-1_source.changes
Date: Sun, 23 Feb 2025 08:01:35 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1tm6vf-00D0GL-RP@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.13.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.13.0-1.dsc
  xfsprogs_6.13.0.orig.tar.xz
  xfsprogs_6.13.0-1.debian.tar.xz
  xfsprogs_6.13.0-1_amd64.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
