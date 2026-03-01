Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9A74315A
	for <linux-xfs@vger.kernel.org>; Sun,  1 Mar 2026 16:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772383148; cv=none; b=V/bil5qkJGTSewYBj3/ugsG8ijRhmmCS52MnnvYkPdaQgOs8voTxi4ImIjHJ3KmaSHeCap+l0tr2xUCYoZpyiHImI1vMCpMHBRmuh8KMPB7yR9yn79GFbKbkoDwvz2rrxk1ebbq7Cst7Om4w592jbIjrjStqg1x8SK4slBGrcJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772383148; c=relaxed/simple;
	bh=3UKrX9IBmd+GmZv5dP/3VzeuKSgDIeADLcZIX0hL1jM=;
	h=To:From:Subject:Date:Message-Id; b=R9IGPDEhjzE9VGMopQKCF2UUSTiSI00rKI+oguVi2CGdL4vLTP36BeDoJV6BXPdJOMwWsszCoFMKn631GZ9aN750jlD6K07k5DmUShrsm/YYP+lngiLl1YrMHiCQOmraodEzBOWwMcZ8bW4WNolmroQ71UwOtsaXvPaCqpFuzoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=kk5yuhYO; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="kk5yuhYO"
Received: via submission
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vwjov-0048WB-17
	for linux-xfs@vger.kernel.org;
	Sun, 01 Mar 2026 16:39:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=pl4zZ7AUmE0YewSK3QZOcu/7aZwzUBXZymUuSXvGMrc=; b=kk5yuhYOBuVZbeMKttUj4TueNu
	cnWJXjsqFPXrq7roWtJuBtbSUfxYSlL5k1mUaLBOSS4lOeR2JoaLW8t/ImaZJcRKikfHyLu0rQuho
	KZx8FUvhuf50PpRJEnJ8YVQe1lLyXOaVbLZq0B3di6S7S/0+URHQofeKYbWXjiq328NnMEhguA5eJ
	Pc9bcScPbMRrAiKoNv90yFrQbsDqeN37ZJd6MAwwVRgppDK0eun5+iMhClq7tzOp78EOF7YirZlHg
	yvGbZK7WNobon3zokYM0+3xE0y2g9b0LdiHDagbTPw1G3BhyOnOKVh7qeIg7FtRYT7gaLAGAgvphG
	K6K1PYlg==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vwjou-002WWv-1G
	for linux-xfs@vger.kernel.org;
	Sun, 01 Mar 2026 16:39:04 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.18.0-5_source.changes
Date: Sun, 01 Mar 2026 16:39:04 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1vwjou-002WWv-1G@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.18.0-5_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.18.0-5.dsc
  xfsprogs_6.18.0-5.debian.tar.xz
  xfsprogs_6.18.0-5_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
