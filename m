Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2C3B66E
	for <linux-xfs@vger.kernel.org>; Sun,  8 Jun 2025 11:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749381905; cv=none; b=JkzPSNIte9W/f2EyzKGuBrWfAsUR7PXzwKtwtlE1DroQK+ACgqW1HI3ztEqVNdUe0JwgO0xYtJqJI7rMiKaL5CJ97KhQHB9N7+sk/qk7gba/mqMgrbuCr7zqeI53XdPj6CE6VUleAAREbBRXsCwRgp4U8DmjCr677t0prCe9Hw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749381905; c=relaxed/simple;
	bh=sws6AKjOAAfSoZXqcbmGVsqrX+axxmOs5m+4BxPozqU=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=Ay1sTtMxBKQA1jmrV2yqBg2mtzEs6BN70LD0s+A0yJiAGRv7pBqgVGcv+p4aOXpxl9vacDHwDWFYV3GtMQyVK589DmqfykfxPsViuFEJ3h2YlItFWbZKKWU06Im/q8LrnkbdwP0LU5ka1oZAfKuYlaKq1m/yZ/zODXiGhrsD5M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=JQaSFxd2; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="JQaSFxd2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=sws6AKjOAAfSoZXqcbmGVsqrX+axxmOs5m+4BxPozqU=; b=JQaSFxd26hQxLvMIc4CI5mjjiL
	RvjPPnbKoJyaTEyky4aGE6eefyoH1JYNq9VRv+ad3tNcFFuHifglQpD5QsRDhYFB33JkItoZRrTib
	FsMWqx17LZJShbFhpc6p6/qXRWScUaPkANuoV9q5mC51DvyNlB2GDFAE6dHVviSgXZxre2z3Y1Cvq
	7dQRJSMbKHfiauvkndBXQUt4wK3U3K6zeIDpY4UJVobZ9c/pUF17cnGShDTGVkzf03KqOghtp2RIw
	XfJSgb4O505vSh2vp+oBG/m47JULJ0qvB9vtSsH1LoqRW6w2wr2tDs0u5ioNrzZu4e4V0jsfSzgHP
	sJe4cH9Q==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1uOE97-005h53-1Z;
	Sun, 08 Jun 2025 11:25:01 +0000
X-Loop: owner@bugs.debian.org
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
To: Chris =?UTF-8?Q?Hofst=C3=A4dtler?= <zeha@debian.org>
CC: linux-xfs@vger.kernel.org, tytso@mit.edu, owner@bugs.debian.org
Subject: Processed: reassign 1107480 to src:e2fsprogs,src:xfsprogs
Message-ID: <handler.s.C.17493817771354753.transcript@bugs.debian.org>
References: <1749381763-1562-bts-zeha@debian.org>
X-Debian-PR-Package: bugs.debian.org src:xfsprogs src:e2fsprogs
X-Debian-PR-Source: e2fsprogs xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Sun, 08 Jun 2025 11:25:01 +0000

Processing commands for control@bugs.debian.org:

> reassign 1107480 src:e2fsprogs,src:xfsprogs
Bug #1107480 [bugs.debian.org] bugs.debian.org: Filesystem scrubbing gets o=
verhand by using both cron jobs and systemd timers
Bug reassigned from package 'bugs.debian.org' to 'src:e2fsprogs,src:xfsprog=
s'.
Ignoring request to alter found versions of bug #1107480 to the same values=
 previously set
Ignoring request to alter fixed versions of bug #1107480 to the same values=
 previously set
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1107480: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1107480
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
