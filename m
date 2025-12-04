Received: from mitropoulos.debian.org (mitropoulos.debian.org [194.177.211.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B1F2F99B3
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.177.211.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764864916; cv=none; b=uk7H5xDByNsQuvz6epRmcNHCsnws2K/3ACxdaxBhkSnB1ysxi7k51qG25Q+Nfu7XrevZdUOh+Fh54UYsgqXLFKIj5FApNEfpxuDzG+Kp9+eYof1Fdbalgr7AxaogIi093irJvngzhCkHkRzm0iGJ+a5FwLGj17ezcr1NItUrY9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764864916; c=relaxed/simple;
	bh=Nrg7rwn6uYFNqsm+p/gPBR/fee4nCMrnpd0QDh0XgP4=;
	h=To:From:Subject:Date:Message-Id; b=galHf1wRk0eVQVkO2ANLoPv5ad/nL0p5qOrWQoQAhhuPHZpDrqXx6/SXrfIFM0FG7rNgidpxE5ow0pc3pCtmrI4cb4omraf092OESMOBl9OUg95xJRH7+FarrdKNB6U+0TFcoa1JwYJ/A0jd7DqW1TKlCjM20frdoWrHnhKUB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org; spf=none smtp.mailfrom=ftp-master.debian.org; dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b=DnU1O/p0; arc=none smtp.client-ip=194.177.211.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp-master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ftp-master.debian.org header.i=@ftp-master.debian.org header.b="DnU1O/p0"
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:40568)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
	by mitropoulos.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vRBz6-004tzV-15
	for linux-xfs@vger.kernel.org;
	Thu, 04 Dec 2025 16:15:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=0enQjr0EuuGtiYU3yrbaIHQuDw2djQh21LGhJr2PQoE=; b=DnU1O/p0zcorWBMc1SU6nX3Vd+
	Mx45RT2OTWMe93GTgiSJ6BzQm3S/jUkpZLOKDfogx/OAh4yu62v2l6sj/uu0pU1h+t+Dun39nqo2v
	5WzGNfva4DEwvZjcNk24ZKCLrQiL7BYS1EO7QN8hmp3vSTOx54m8W8+DDg1lxBgs8L8tlWJ4t2v61
	pcBShxHTsQQfO51weyycBcY4b6cWOoS8AjLwCvDePmlH6VyB2kNkIQv9MHoMuJ7XTwDAgtPcXuioT
	BGs3sz6cWDsBaMNxB6nggW5jtUVQniEk9DkbJbcmAhSTLjqgsKiVOxvur3XAx3hcH0q6LlSrbHSUB
	xcdZh7JQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.96)
	(envelope-from <ftpmaster@ftp-master.debian.org>)
	id 1vRBz4-004eVk-1r
	for linux-xfs@vger.kernel.org;
	Thu, 04 Dec 2025 16:15:10 +0000
To: linux-xfs@vger.kernel.org
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_6.17.0-2_source.changes
Date: Thu, 04 Dec 2025 16:15:10 +0000
X-Debian: DAK
X-DAK: DAK
Precedence: bulk
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1vRBz4-004eVk-1r@usper.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

xfsprogs_6.17.0-2_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_6.17.0-2.dsc
  xfsprogs_6.17.0-2.debian.tar.xz
  xfsprogs_6.17.0-2_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
