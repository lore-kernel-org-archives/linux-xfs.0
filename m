Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B28C27F736
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760467991; cv=none; b=lrhzqCwGxpPIq13pFhwyEymGfXQUST4gIYF/6UaEEZp1qQmRHJ+m5YaPrFVQUUhs0KO1lUnNAWNNY8usOB/4tWS0bgQNnTXrGDM5h4J4QZFj29Py4qtmvv6w/IiKX6IpdzQnUL62RQ1favOLiHaZFRoUx3gMCBtjmft3sArjK7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760467991; c=relaxed/simple;
	bh=8q5LrSMyW9xx7xxgyfvkgm7fvxRMSAG/G0p25PX1CSU=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=io/2cDIrkUg2MwMCik9ZpNu/67FL0uZypgCYiI4jMCp2iCKV2A5ZVQRx3n0kD8sjZrKgrAZ/9ebnFD45ZmkSaM2ZFlqm3Lh7htOkULwuY9AufpgMzvaYFGoLSck4cHNF+cFeEvh2SaKenFMro5DIF10dJNCYQKxlM5UTrGUmWfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=BnXrQw7s; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="BnXrQw7s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=8q5LrSMyW9xx7xxgyfvkgm7fvxRMSAG/G0p25PX1CSU=; b=BnXrQw7smg+2Q5JKSYE/uKNhH/
	JW7hhgQF7UvOHPj1q6lsdiw8Ggex9rq6xEe4MZfktO37vgXGA8w2Jc4Eb8ViTvJDQ1/AO4QhT2wNJ
	jLDlx4tso5EPxZ/K927k13A4gCn645b03BXxk+JU07kasG0WfwWcQH8hpLC4ppQQZZBLj4W2I1dw+
	ejI+/O/aaOUzaib8VIk1bvpHP3L1jxZ35uH7stBJkLD2st33OgslFrNFXP631Ye7E619V7pHzEuwK
	EIQtHf9/N2+gqZ+hggsn8yeWZDSUJ4zjCvNqWtCokhD5eVMMMlvMta792GU8Rt6ItImy0+CdsmEN9
	XnJg0Fyg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1v8k8s-00FFEY-0k;
	Tue, 14 Oct 2025 18:53:02 +0000
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.510 (Entity 5.510)
Content-Type: text/plain; charset=utf-8
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: Bastian Germann <Bastian.Germann@gmx.de>
CC: linux-xfs@vger.kernel.org
Subject: Processed: Debian Bug#1117890: xfsprogs: warning logged to system.log
Message-ID: <handler.s.B1117890.17604679363633116.transcript@bugs.debian.org>
References: <trinity-5642e09b-4e08-423e-83a5-340542847944-1760467926379@trinity-msg-rest-gmx-gmx-live-654c5495b9-8h8ng> <E1v7qdR-00000002uQg-0kaS@tucano.isti.cnr.it>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Tue, 14 Oct 2025 18:53:02 +0000

Processing control commands:

> retitle -1 xfsprogs: Support for systemd option CPUAccounting has been re=
moved
Bug #1117890 [xfsprogs] xfsprogs: warning logged to system.log
Changed Bug title to 'xfsprogs: Support for systemd option CPUAccounting ha=
s been removed' from 'xfsprogs: warning logged to system.log'.

--=20
1117890: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1117890
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
