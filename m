Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5892D881E
	for <linux-xfs@vger.kernel.org>; Sun,  8 Jun 2025 19:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749412629; cv=none; b=Urw9E2JYWA4F+HsUpUOsPYcjYBgSrJ/Lr4UX3kMX9FOo/NpuZ/MsWvWUYYR/o4CIvk7oD03PVxwxngKBm7ppTURvyIR499khSbt+HVyFZ0Kg16pCxOUHbhKkkdDW0r/nQAtnAy0yh7vgiaSKXjWM2Iegdq9bQsIN1pR4c5TdgQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749412629; c=relaxed/simple;
	bh=EEdPBPX73i3TXN3Ypk4AaAQsCyEcM0u4agBaNxMWhPg=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=L8gWKb10N6I9Ar4oPvyeFkg8GXydAoxfIhGIx9jwnNQZ+GS82isk679y2ttE46w9GTofOz9sMMuQ3m6HiH5Ku+wEI26gNH9LDrVFuRteoPySJ1skSCQJTmMoH5XeENtuKRQ6pB84HKax/jT1GbqzR0r9ldkQYYw6HV0WLHxCR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=Fm9Mo8TR; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="Fm9Mo8TR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=EEdPBPX73i3TXN3Ypk4AaAQsCyEcM0u4agBaNxMWhPg=; b=Fm9Mo8TRKsS6z4qrDCjgPyqQJf
	6fh4shXHA8F6kDmyTlRXOBXqnFNtUFFqwVquUmHQL2+ZCWTV90Nc7mT1ZEX+5yAC9tqbQ2HUREbMC
	2Gf1lAX+xgN0+EmN1rm9Ii0nUtY25tmYvHIrto6d7+c3KwXD7UVM6aJ1e4+p6RnQniIcpKqKbg5Fc
	MrtJYdwvNzhf1Lx12L2NQPemOOepqoPs0rJoa2PoWD0GhAgZ6/Bjw7pET45lhy6n/uYv+J+FHvnC/
	A932XCA4fH0ybwVwg7Kt5cbCaIUUFPxAp97NYhWB1PJlGHbMubP9akyVUnqsbKbhiDYbpaJ4tVcJu
	LPF12o4g==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1uOM8b-007WN7-3D;
	Sun, 08 Jun 2025 19:57:02 +0000
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
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-xfs@vger.kernel.org, tytso@mit.edu
Subject: Processed: Re: bugs.debian.org: Filesystem scrubbing gets
 overhand by using both cron jobs and systemd timers
Message-ID: <handler.s.C.17494125341791884.transcript@bugs.debian.org>
References: <20250608194000.GA1041370@mit.edu>
X-Debian-PR-Package: src:xfsprogs src:e2fsprogs
X-Debian-PR-Source: e2fsprogs xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Sun, 08 Jun 2025 19:57:01 +0000

Processing commands for control@bugs.debian.org:

> reassign 1107480 src:xfsprogs
Bug #1107480 [src:e2fsprogs,src:xfsprogs] bugs.debian.org: Filesystem scrub=
bing gets overhand by using both cron jobs and systemd timers
Bug reassigned from package 'src:e2fsprogs,src:xfsprogs' to 'src:xfsprogs'.
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
