Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDA01BC4B
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 14:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715265908; cv=none; b=BUo90/pi8WTbAaeShd6AwTkTqyEgjLHLu4u69qOMdOeyWqtMglaXsBZrKnyDN5O/fkQCCSUAxtLe8E+D0s370sSZRVraq1K8Oe79TSDm8QGP5wLoJL7auXcXHiMFJpyLNY3CSwArlei0PCv6K9VMqUEw/NqW055IS+jLMvjwMZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715265908; c=relaxed/simple;
	bh=ThYBpHwjukrYClsTJKJy1PtHLsPvckt9pxwkDB5l62Q=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A8y1/8CdWsqm2NnWomZ6EVEhv+qBvDNn4yN6xhvQoviWxK/w2451VYgrR9FNs3TbiK20s1v9EEW4nT9tfBSlF1JCW6Y5mUpQPOhIIA7uvwv4A0w+LTwZW+yiAuIessg9KIMOBZ4s3tDWG/Uks4FVJ05cB+04mtpyA53krxDcHt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srrMNzJv reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srrMNzJv"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1s5516-005pE1-RE; Thu, 09 May 2024 14:45:04 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1070795: Processed: your mail
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1070795@bugs.debian.org
Resent-From: "Darrick J. Wong" <djwong@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: XFS Development Team <linux-xfs@vger.kernel.org>
X-Loop: owner@bugs.debian.org
Resent-Date: Thu, 09 May 2024 14:45:03 +0000
Resent-Message-ID: <handler.1070795.B1070795.17152657741386747@bugs.debian.org>
X-Debian-PR-Message: followup 1070795
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: d-i
References: <87jzk3qngi.fsf@hands.com> <handler.s.C.17152516831244576.transcript@bugs.debian.org> <20240509144020.GH360919@frogsfrogsfrogs> <171524693891.215341.12611976307409148291.reportbug@nimble>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1070795-submit@bugs.debian.org id=B1070795.17152657741386747
          (code B ref 1070795); Thu, 09 May 2024 14:45:03 +0000
Received: (at 1070795) by bugs.debian.org; 9 May 2024 14:42:54 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 27; hammy, 142; neutral, 35; spammy,
	0. spammytokens: hammytokens:0.000-+--UD:kernel.org,
	0.000-+--HCc:D*kernel.org, 0.000-+--HCc:D*vger.kernel.org,
	0.000-+--03am, 0.000-+--03AM
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1]:53462)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <djwong@kernel.org>)
	id 1s54z0-005okC-V9; Thu, 09 May 2024 14:42:53 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id A72FACE1B70;
	Thu,  9 May 2024 14:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18001C116B1;
	Thu,  9 May 2024 14:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715265762;
	bh=ThYBpHwjukrYClsTJKJy1PtHLsPvckt9pxwkDB5l62Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srrMNzJvy31nro6ROg0P9gQQ8vmMyX4Ofx7pRzdrEFg0cQ8Pjh63G+MbAwqyROh7z
	 OPiyJKmWkoRVLh9ZHr8et2Fey0oN6Whq1kG3JwGknYapdgvACywLNCJPz1YLns6kMP
	 HEOYql4611Infmbfd6HXkGXpc29Cvf8SmaILL1MwYOrDSWEZtrr8kbgccZcUWTrh89
	 qWw8q6FPSj8BiBC2hSMy1OK/xpLLt97h2oa9ypThTVAyaZ3OtQ8ecOFX7IpqEc57J2
	 hafFf3XJOprc09HHUyRm26Gncmb/HpOlV6LGAxw7rTQNTS9KzUwR2nuKcB0E//1SWE
	 USzc0MIhFmEIw==
Date: Thu, 9 May 2024 07:42:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Philip Hands <phil@hands.com>, Carlos Maiolino <cem@kernel.org>,
	1070795@bugs.debian.org
Cc: Debian Bug Tracking System <owner@bugs.debian.org>,
	linux-xfs@vger.kernel.org
Message-ID: <20240509144241.GI360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240509144020.GH360919@frogsfrogsfrogs>
Message-ID: <20240509144241._f_ZljIkrwI92wiWFYxK9_g4wmohTM7RXC_WC26xVA4@z>

[actually cc the bugreport this time]

On Thu, May 09, 2024 at 07:40:20AM -0700, Darrick J. Wong wrote:
> On Thu, May 09, 2024 at 10:51:03AM +0000, Debian Bug Tracking System wrote:
> > Processing commands for control@bugs.debian.org:
> > 
> > > tags 1070795 + d-i
> > Bug #1070795 [xfsprogs-udeb] xfsprogs-udeb: the udeb is empty (size 904 bytes) so does not contain mkfs.xfs
> 
> Yeah, someone needs to apply the patches in
> 
> https://lore.kernel.org/linux-xfs/171338841094.1852814.10756994414036094487.stgit@frogsfrogsfrogs/
> 
> and
> 
> https://lore.kernel.org/linux-xfs/171338841109.1852814.13493721733893449217.stgit@frogsfrogsfrogs/
> 
> which were not picked up for 6.7.  Unless the upstream maintainer
> (Carlos) goes ahead with a 6.7.1?
> 
> --D
> 
> > Added tag(s) d-i.
> > > thanks
> > Stopping processing here.
> > 
> > Please contact me if you need assistance.
> > -- 
> > 1070795: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1070795
> > Debian Bug Tracking System
> > Contact owner@bugs.debian.org with problems
> > 
> 
