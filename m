Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E3B55884
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 21:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718832799; cv=none; b=tLur4QpE40CDgWdawjz1ePezT2328mvJSGEJqzRdFFkGPekU57ageTh1xptkZ4tWUN7Dz8SvyYFOOH4GpzGSGlyZzGyaKlyd/RakEGD7pVnSExYh0qCFvJ9XP2uIgCAO4qYC6f4+U4hQM+uxdqVpre/uSwvfhkwqvGakSjDKUww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718832799; c=relaxed/simple;
	bh=YfLFWxxGUm5jLEHA5qHYjNDrthU7k4a+GlJ8k9WFNh0=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=graR5fQUeJb5IHa+0U1hn9AIyDpMVEhJu4vrg+BoBoVpfCQSW3E+mfV53QO1eiWhGMLHJMR09aPcvCrguwwPZsEsaPPMoRu0fqmOTkVchQUPY3T8117QOLUZvQv/Jg94DN1zFTk6GbN8y5Kg8USVImb4CknS/KfE4KA9+jsclLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=ZNxb5mqX; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="ZNxb5mqX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=YfLFWxxGUm5jLEHA5qHYjNDrthU7k4a+GlJ8k9WFNh0=; b=ZNxb5mqXJEe0AjuNWQoLMIOvin
	O3QNS+fq0kaozSrVt9StAfmFInXXgbLslpPQMBc733fR/n8Et2X/NM848QgdUTIRGz27ktVjpPDx4
	gqMNWhcBILsFovvKEyyJoaZ7iKFxSYJI/h0oqU2T9gLA0fIgg8seAob+m8ggbQpf5G82gZULezcIg
	EX4YhIQLl6kBnKTg9otLuTmE06R/sMw5AmgcMbkzioGLwgAJREKJCS7YdTP1iWHHI87WXMcgwrHjN
	b3IxJEw/EVmyAU8q+UFR+Hfk3vFSl+h4dtsct7wybqcKXQftRzGAHUbRlhijXhAN4Do4bDdE4u0+h
	udbgh8pA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1sK2vU-00BrQP-5P; Wed, 19 Jun 2024 21:33:08 +0000
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
To: Chris Hofstaedtler <zeha@debian.org>
CC: linux-xfs@vger.kernel.org, nathans@debian.org
Subject: Processed: Re: Bug#1073831: xfsdump:FATAL ERROR: could not find a
 current XFS handle library
Message-ID: <handler.s.B1073831.17188327152826728.transcript@bugs.debian.org>
References: <ZnNOJtgGQ2M4DciV@per> <20240619112859.26ekvlxkt4sb5jt2@debian>
X-Debian-PR-Package: xfslibs-dev src:xfsdump
X-Debian-PR-Source: xfsdump xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Wed, 19 Jun 2024 21:33:08 +0000

Processing control commands:

> reassign -1 xfslibs-dev
Bug #1073831 [src:xfsdump] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
Bug reassigned from package 'src:xfsdump' to 'xfslibs-dev'.
No longer marked as found in versions xfsdump/3.1.11-0.2.
Ignoring request to alter fixed versions of bug #1073831 to the same values=
 previously set
> found -1 xfslibs-dev/6.8.0-2.1
Bug #1073831 [xfslibs-dev] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
The source xfslibs-dev and version 6.8.0-2.1 do not appear to match any bin=
ary packages
Marked as found in versions xfslibs-dev/6.8.0-2.1.
> affects -1 src:xfsdump
Bug #1073831 [xfslibs-dev] xfsdump:FATAL ERROR: could not find a current XF=
S handle library
Added indication that 1073831 affects src:xfsdump

--=20
1073831: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1073831
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
