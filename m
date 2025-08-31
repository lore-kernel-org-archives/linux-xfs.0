Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7BE21CC5B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Aug 2025 20:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756672625; cv=none; b=a8kwPuSTwgg/E0bvokanamSgUrXxVoyNzJnhvIQLF0arTA1mTTGEtOXdyh++h8xENcfx2DBgRRh829fN6F7c3LWJ7E+lU82OFMwkGXz7ZcCqumquwos2I4Y/1rOSd3uPwMFE7iUVEJ8hUyTPGZTs1fAXVhNgQyCNyarpI/ioJzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756672625; c=relaxed/simple;
	bh=VWDrXiTlKGMBCZ+wHyeZ2+uhZ+zg5cxhBHdlcROooZA=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=TLjsWNXRdyCFGkHDUd/ELlzK9wyvqBI07Mg8Spov8bg5cmGrb6kyQtbcVF6OoZBHiQwLiFRDNQq3qA9XcAJxiyCH7391SE4YuoUKJsbJGkAMcejM91kFkJMz43PKM0lLdbyU4bUNGv898ftk7UzAllRl//f5sJmcjxmmqQDNvh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=s/wXJncN; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="s/wXJncN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=VWDrXiTlKGMBCZ+wHyeZ2+uhZ+zg5cxhBHdlcROooZA=; b=s/wXJncNGRCPhsbyyiid83aF/H
	KBgPRl0FKyFD6q97ZqE38nv3IzWekoIcCLL4FB64LfCS6MbyiyyinzfnI4us8YXyE+yeRABHCusVs
	hmOUzAE4qSjKb3Rm/tHuOXZLgZFc04lBn2Kqxvb1ah7leYHmrCwetOgNbGRYHgqDc0RcpQsM494P9
	7CnEfrNqsNxCNLMIc2nCGQwPgDcJsRwYlm4K9bwOvajWPsDVJ9rU5uf1OoL/Np2SoRS4KzgV4z3PY
	EPsqopqT2HITrt3URL206EVjLh/0xLT7yMHnDVTWsS8CNKW401eMlGlWiFZ+WCoyD5H1tWhgdD6Qt
	pljLzZLg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1usonO-00A4vx-2B;
	Sun, 31 Aug 2025 20:37:02 +0000
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
To: Bastian Germann <bage@debian.org>
CC: linux-xfs@vger.kernel.org, debian-bugs-forwarded@lists.debian.org
Subject: Processed: Re: DeprecationWarning: datetime.datetime.utcnow() is
 deprecated
Message-ID: <handler.s.B1112588.17566725082401155.transcript@bugs.debian.org>
References: <feb251c6-3ea1-4ca6-841f-70ce6216a22f@debian.org>
 <175662646685.178172.185590202459851084.reportbug@turing.verdier.eu>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Sun, 31 Aug 2025 20:37:02 +0000

Processing control commands:

> forwarded -1 https://marc.info/?l=3Dlinux-xfs&m=3D175667185613391&w=3D2
Bug #1112588 [xfsprogs] DeprecationWarning: datetime.datetime.utcnow() is d=
eprecated
Set Bug forwarded-to-address to 'https://marc.info/?l=3Dlinux-xfs&m=3D17566=
7185613391&w=3D2'.
> tags -1 patch
Bug #1112588 [xfsprogs] DeprecationWarning: datetime.datetime.utcnow() is d=
eprecated
Added tag(s) patch.

--=20
1112588: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1112588
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
