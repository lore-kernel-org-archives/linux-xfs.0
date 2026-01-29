Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB6635292A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Jan 2026 22:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769725100; cv=none; b=ojggciVcU8KS0eXD2dw9610sBsJe/sczpmWFfXWpDPueRleeU6SIBgJy4z9oJJSHTCM1aPbB6uHjNiBuFoFZBbs9CLnAFgXlnhXQnWalD3Vr0p151LFeZeUFrE+PRupzCU0rQlyprqypv6N/LYCtq28l9lZpMQLLXLKq5mhHPLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769725100; c=relaxed/simple;
	bh=jipQX2RJSotdSG3Jt6QE03v93AC5MGQriW6amT6dfys=;
	h=To:From:Subject:Date:Message-Id; b=PbDkmFI4c7qearV42REXzNEWOwY4okHtLc91oXot8L/gz/e5ykqIupUax8vMIiI9eorM72A6dVR1lcGPshR6v1Zwm2efHo+nPCHJo+9PbWttP8co/FrcyzajSL48WVJCXVrD765LVyOd9uhYCRB71Z/Y0cS+uEjEshAE/aVC5eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=KH9PLm81; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="KH9PLm81"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:39780)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vlaLA-0055Wg-2O
	for linux-xfs@vger.kernel.org;
	Thu, 29 Jan 2026 22:18:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=9zVncHKUIPkDVkPbJsEtu6b6Dz3IJuqxvFEgfdutbFE=; b=KH9PLm81z97SNmsyz5tE7i4FpO
	dGVgn24a8+Yb3y1YQcE9Ic7N0ACuUJvIIWu5H8QPbrlITj1erpBvgGWCniBX1NZxFoSCx+Cbf2RIO
	i2r0L6z1NabV3u6QP24yfxDQEFYAv2f54I7D2Qcl1Bf8unFBEPoQy++4uFiJ7GrPD7PMQcgKgFnWe
	JcwN5lV9oUcvAhlQKjjSNMAIFCO4gfGpqS8ABgXKZ9198J9E4ooR6AfP9qyc8PMAP3/RNc47HY/7W
	xhf3BTgfDHlbjBF9zPlxIbvsx2cdYVEpqd0woVCSxjD+d+2lMnQcODzQUH8yB0DVmIpadWPXr6Ghi
	emdXBABQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vlaL9-002qpL-2n
	for linux-xfs@vger.kernel.org;
	Thu, 29 Jan 2026 22:18:15 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.18.0-3_source.changes
Date: Thu, 29 Jan 2026 22:18:15 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1vlaL9-002qpL-2n@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.18.0-3_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.18.0-3.dsc
  xfsprogs_6.18.0-3.debian.tar.xz
  xfsprogs_6.18.0-3_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
