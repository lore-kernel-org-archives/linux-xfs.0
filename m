Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57687433E74
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783025084; cv=none; b=GUEYmLUlAuW+RS6XET17BfhTWA0U7EyNSqNePjLIIQh3S9rdBgkjv8uXPC/RKCOsYQDwrRV0RDBteH+NuPS+Snv20FI4a7PB3EDlWuhIcbgM4BE/uWICDUXlFk6u87E47xjod7TOdLwvKIoH9jFtZCgQkSEbtZO79ch+vmlkvrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783025084; c=relaxed/simple;
	bh=H7Uvw3XFZL08ToXL0JgTT+QTjghgckDWbFMSGCLtLxA=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=LrhWjNaHxToVPoBd85Kpmhffwcp/8IrlxAN1keEzD4artxApIqXrp6VXrXkeari/RWBfH3H0C8a/pGwQXXfcwiFLh+PhJyVegfWQHS6mu+8iNO+uL2Ez8PCotuXISK/afpwgEz9vbEQgDTszQ/Vr5qaLLpQySDP7wil96Zrpvmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bugs.debian.org; spf=pass smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=Yg348NvO; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="Yg348NvO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=H7Uvw3XFZL08ToXL0JgTT+QTjghgckDWbFMSGCLtLxA=; b=Yg348NvOg4wFreMAIRPEDjIneX
	V4pU0nZrO8Sf6wWlBFQP7njB1JVQ0AfBEG4gXhbqWG93lnB37T2S5uWTc+QR0eSF5ib/3Vx/U35UP
	fzEWuxpRwAiL6TtivZGG8yNEndASs/a5ZpmtBXX/unf7T94zcT3eE62+TCit8b6OP7pqudK29myU+
	PVOp8eUjtZksFVfm5dPVfOP71uWvai0cex3QjBVoTxO7EF0AgvnBASCiCEvuxrPf1nBX6up6zXdrA
	MvoeBHdQY3EhWBytSIofAR+lx0OOOwh03KTUyzSdVzVfAtokthb9cIGrWR5Pw9T2JGNEqlboMOB5m
	x6iZE2UQ==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1wfO7j-00FSZn-0k;
	Thu, 02 Jul 2026 20:35:03 +0000
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
To: Adrian Bunk <bunk@debian.org>
CC: linux-xfs@vger.kernel.org, debian-release@lists.debian.org
Subject: Processed: unarchiving 1116595, fixed 1116595 in 6.19.0-1,
 tagging 1128511
Message-ID: <handler.s.C.17830243713682752.transcript@bugs.debian.org>
References: <1783024369-277-bts-bunk@debian.org>
X-Debian-PR-Package: xfsprogs release.debian.org
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Thu, 02 Jul 2026 20:35:03 +0000

Processing commands for control@bugs.debian.org:

> unarchive 1116595
Bug #1116595 {Done: Bastian Germann <bage@debian.org>} [xfsprogs] Packaging=
 issue: xfs_scrub_all_fail.service NoNewPrivileges breaks emailing reports
Bug #1128087 {Done: Bastian Germann <bage@debian.org>} [xfsprogs] xfs_scrub=
_all_fail.service: fails to email report (might be similar to bug #1116595)
Unarchived Bug 1116595
Unarchived Bug 1128087
> fixed 1116595 6.19.0-1
Bug #1116595 {Done: Bastian Germann <bage@debian.org>} [xfsprogs] Packaging=
 issue: xfs_scrub_all_fail.service NoNewPrivileges breaks emailing reports
Bug #1128087 {Done: Bastian Germann <bage@debian.org>} [xfsprogs] xfs_scrub=
_all_fail.service: fails to email report (might be similar to bug #1116595)
Marked as fixed in versions xfsprogs/6.19.0-1.
Marked as fixed in versions xfsprogs/6.19.0-1.
> tags 1128511 - moreinfo
Bug #1128511 [release.debian.org] trixie-pu: package xfsprogs/6.13.0-2+deb1=
3u1
Removed tag(s) moreinfo.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1116595: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1116595
1128087: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1128087
1128511: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1128511
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
