Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA4034575F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 10:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769511414; cv=none; b=qVnZ7yVJDcuX9gbMHh6GdVt3DB3ZYVBjpfcdwvv4WvD+QtzHEpIUzL+g6Z/fOvuRs3f+Ru9cBVnjb2PgCWC+kV/TReF7MV7OmmHMjjjgLwX/kRIfuc4mEX+mlOkV4EiTvUzMai/TFsaNsQm1oGas3apbvIPYIH+Qhtjb36ZsU1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769511414; c=relaxed/simple;
	bh=lDJRT7dQ3+Xw0hC19vxGGz0/dw1pZF3WgfchPMdQR40=;
	h=To:From:Subject:Date:Message-Id; b=Nrw9ddp0qk+Shb68oDCwh5gmKWI3HJhNTOxtK3SoBKLZs4TWRfRg5DGH5GWcJuR/riRjNqk18h7j+9u0uKnQXv7p37oVJ1w0WRZjJTfdBW92E+HuU5w/dY/xHoqtcuLOUrB6FG8mC2VpWPNe0Rd02XkiPyRRsMIKMtX5G1XfdB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=CYrNKWDH; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="CYrNKWDH"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:49222)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vkgkX-002Skg-1S
	for linux-xfs@vger.kernel.org;
	Tue, 27 Jan 2026 10:56:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=WqlyF0J/+5BFhZZkqP4h2LLKsUvvXaV0qOEJ0+1wfGY=; b=CYrNKWDH5ZTgQgxRJqzZ+fcBvF
	xAbg3wLn9cZf/fEgsectItFQrSW6oSa2qLVxJWKsC+OGe/vKnZnTRMP142sjKUlgI2UlqQ7TbCbcK
	kPl0utvI6PRMN07NsNodqOngeAQL8SFA797JtoTU4H3qCtv3VDpiajPIWiPOAbMU0Uw1A+yUw0QSP
	kGdfPQPKcgnpgES2HbBZdk0FkMKhocPFRx4vh1dIed7P9n6Bz4f6ljYkdOcbw8Ph9xqJuP47HBdSn
	+L0O7rMPgnup2WhIqPtDX//KMaV85X49BsUq7JQOlNPO6qMdPnXiK21BRkFUuzGeyx1x3G/VaxhwL
	oWkn6+uA==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vkgkW-000SoS-1r
	for linux-xfs@vger.kernel.org;
	Tue, 27 Jan 2026 10:56:44 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.18.0-2_source.changes
Date: Tue, 27 Jan 2026 10:56:44 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1vkgkW-000SoS-1r@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.18.0-2_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.18.0-2.dsc
  xfsprogs_6.18.0-2.debian.tar.xz
  xfsprogs_6.18.0-2_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
