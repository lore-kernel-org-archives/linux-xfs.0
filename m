Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154731859
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 05:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718861610; cv=none; b=XyMDtcHVS4sc6XWuXVIAe/17Adm5BcQRw0m8aWJGI7eQcMcDXmuwCxlQheyhWpk24gZ2aBTeL3uUn2yq9J6HdJftW28hX/RfGxo3TurYhsKBd42ZtZvzilLQS8IUNcbMbnsXxsxa337ujSou9hI0IHwCCHwrXA7AVSSr1JeJfw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718861610; c=relaxed/simple;
	bh=bjDZ2rErWH0QQycFh0RuypRIzSU1rMV0xh1swFLCFwk=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=qVQPh7Ty4ZVXr4eggZelsEYK7txhHQ99OYEYEmQNKjsQzXKQ3BzXooYXdAmGpZRizeomjcKnnpGihgHp2Qrfmwq7S+SMR2nz88vV0c3LRU5AR+knmqU9hBpdnbMTQBYh6h6Gpc5sED4de3UhvNQ/NWkI4ED3qp5etLdlLMECxDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=V32S70vJ; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="V32S70vJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=bjDZ2rErWH0QQycFh0RuypRIzSU1rMV0xh1swFLCFwk=; b=V32S70vJoCOs4HT4vu21MRBgJi
	F59XmmGpx6OVXs45ss4PdT1UxdUE4BDgwIZNoBr50ClRXQLsKO6+NYPemEkVJuQf/g2zk/H4D9qzB
	RAMNVMsRvSySYDUGt/ilL6Wt5vMMLlvNTwiFzxj7EYIdHd8BDqLFBmscUB1LeAt30C4qaakkyTmHJ
	fzyfKcrR/GdpNSjQI+4k7xk2kDFn6QelXOevWzwL32Yu0BQOsm6ici4sGk4M6mBDROW59ajYBjrXw
	C5sHmHAomXHo8sophBuW1Kj//3MZyqurq6z3V/LyzCY/NGN7yybfxCR0rigBzGnkQx9xI26uBmBcI
	ux644/vQ==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1sKAQ1-00CoT7-7U; Thu, 20 Jun 2024 05:33:09 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: Andreas Beckmann <anbe@debian.org>
CC: debian-on-mobile-maintainers@alioth-lists.debian.net,
 linux-xfs@vger.kernel.org, jfs@debian.org, agx@sigxcpu.org,
 bernat@debian.org, debian-med-packaging@lists.alioth.debian.org,
 debian-multimedia@lists.debian.org, dr@jones.dk,
 pkg-privacy-maintainers@lists.alioth.debian.org,
 debian-xml-sgml-pkgs@lists.alioth.debian.org,
 team+pkg-security@tracker.debian.org
Subject: Processed: tagging 1071837, tagging 1071931, tagging 1071934,
 tagging 1071838, tagging 1071832, tagging 1071860 ...
Message-ID: <handler.s.C.17188615123053551.transcript@bugs.debian.org>
References: <1718861509-739-bts-anbe@debian.org>
X-Debian-PR-Package: src:libpam-ccreds src:libxslt src:aircrack-ng
 xfslibs-dev src:axc src:monkeysphere src:clamz src:chntpw src:libaacs
 src:libbdplus src:fis-gtm src:abiword
X-Debian-PR-Source: abiword aircrack-ng axc chntpw clamz fis-gtm libaacs
 libbdplus libpam-ccreds libxslt monkeysphere xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Thu, 20 Jun 2024 05:33:09 +0000

Processing commands for control@bugs.debian.org:

> tags 1071837 + sid trixie
Bug #1071837 [src:chntpw] chntpw: Please use pkg-config instead of libgcryp=
t-config to locate libgcrypt
Added tag(s) sid and trixie.
> tags 1071931 + sid trixie
Bug #1071931 [src:libaacs] libaacs: FTBFS against libgcrypt 1.11
Added tag(s) trixie and sid.
> tags 1071934 + sid trixie
Bug #1071934 [src:libpam-ccreds] libpam-ccreds: FTBFS against libgcrypt 1.11
Added tag(s) sid and trixie.
> tags 1071838 + sid trixie
Bug #1071838 [src:clamz] clamz: FTBFS against libgcrypt 1.11
Added tag(s) sid and trixie.
> tags 1071832 + sid trixie
Bug #1071832 [src:aircrack-ng] aircrack-ng: FTBFS against libgcrypt 1.11
Added tag(s) sid and trixie.
> tags 1071860 + sid trixie
Bug #1071860 [src:fis-gtm] fis-gtm: Searches for libgcrypt with libgcrypt-c=
onfig
Added tag(s) trixie and sid.
> tags 1071932 + sid trixie
Bug #1071932 [src:libbdplus] libbdplus: FTBFS against libgcrypt 1.11
Added tag(s) sid and trixie.
> tags 1071937 + sid trixie experimental
Bug #1071937 [src:libxslt] libxslt: FTBFS against libgcrypt 1.11
Added tag(s) trixie, experimental, and sid.
> tags 1070892 + sid trixie
Bug #1070892 [src:abiword] abiword: Please use pkg-config instead of libgcr=
ypt-config to locate libgcrypt
Added tag(s) sid and trixie.
> tags 1070903 + sid trixie
Bug #1070903 [src:axc] axc: Please use pkg-config instead of libgcrypt-conf=
ig to locate libgcrypt
Added tag(s) trixie and sid.
> notfound 1073831 xfslibs-dev/6.8.0-2.1
Bug #1073831 [xfslibs-dev] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
The source xfslibs-dev and version 6.8.0-2.1 do not appear to match any bin=
ary packages
No longer marked as found in versions xfslibs-dev/6.8.0-2.1.
> found 1073831 6.8.0-2.1
Bug #1073831 [xfslibs-dev] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
Marked as found in versions xfsprogs/6.8.0-2.1.
> tags 1071941 + sid trixie experimental
Bug #1071941 [src:monkeysphere] monkeysphere: FTBFS against libgcrypt 1.11 =
(and next libassuan)
Added tag(s) experimental, sid, and trixie.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1070892: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1070892
1070903: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1070903
1071832: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071832
1071837: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071837
1071838: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071838
1071860: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071860
1071931: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071931
1071932: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071932
1071934: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071934
1071937: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071937
1071941: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1071941
1073831: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1073831
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
