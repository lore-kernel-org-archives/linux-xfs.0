Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD8B2C0275
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 17:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760377870; cv=none; b=kmOrEX/UWwZjy1Ods6cUgh4TSsRrDre7bkD1GnxcYqFkDFj2gDsOljw+AksgYyF5MahBUq8tSpdPii6Y8PoTnL/NCpfUEHEbVLGAxWzzrs/Y+u633NUugZeKZMOzWJmLS6zFj+1VJ7cXeXOhHXfmjkeQOBRnMeHYXWwTaCLgNH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760377870; c=relaxed/simple;
	bh=GMp1nJ+GYWHugpMtuQ2nQSYV8rIMPNtCZeoPL1sfuYE=;
	h=Subject:References:Date:From:To:Cc:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZSGoyK+qoP/PJkBzn8vv1fdOHNseH02BsPDbHdKSKL0Ex/Yp/O24Mr3LySdcaF93aAJ76zkdPV48Uk9flTlc/kCLrMUdbvY58pmCCSOjCXt8KQIa5L4nJE1+t2CaXJ90hkODICLrxwKFFgCFr4OA1dWu2gS02fFgtY6vJA9S2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=fail (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPDnRUma reason="signature verification failed"; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPDnRUma"
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1v8MhJ-00ABcX-2m;
	Mon, 13 Oct 2025 17:51:01 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1112588: Processed: Re: DeprecationWarning: datetime.datetime.utcnow() is deprecated
Reply-To: "Darrick J. Wong" <djwong@kernel.org>, 1112588@bugs.debian.org
Resent-From: "Darrick J. Wong" <djwong@kernel.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-CC: linux-xfs@vger.kernel.org
X-Loop: owner@bugs.debian.org
Resent-Date: Mon, 13 Oct 2025 17:51:01 +0000
Resent-Message-ID: <handler.1112588.B1112588.17603777702426751@bugs.debian.org>
X-Debian-PR-Message: followup 1112588
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: patch
References: <feb251c6-3ea1-4ca6-841f-70ce6216a22f@debian.org> <175662646685.178172.185590202459851084.reportbug@turing.verdier.eu> <handler.s.B1112588.17566725082401155.transcript@bugs.debian.org> <175662646685.178172.185590202459851084.reportbug@turing.verdier.eu>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1112588-submit@bugs.debian.org id=B1112588.17603777702426751
          (code B ref 1112588); Mon, 13 Oct 2025 17:51:01 +0000
Received: (at 1112588) by bugs.debian.org; 13 Oct 2025 17:49:30 +0000
X-Spam-Level: 
X-Spam-Bayes: score:0.0000 Tokens: new, 18; hammy, 147; neutral, 21; spammy,
	0. spammytokens: hammytokens:0.000-+--UD:kernel.org,
	0.000-+--H*Ad:N*Bug, 0.000-+--H*Ad:N*Tracking, 0.000-+--HTo:N*Debian,
	0.000-+--HTo:N*Bug
Received: from sea.source.kernel.org ([2600:3c0a:e001:78e:0:1991:8:25]:41156)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <djwong@kernel.org>)
	id 1v8Mfn-00ABHV-1J;
	Mon, 13 Oct 2025 17:49:28 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C72244D13;
	Mon, 13 Oct 2025 17:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43329C4CEE7;
	Mon, 13 Oct 2025 17:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760377339;
	bh=GMp1nJ+GYWHugpMtuQ2nQSYV8rIMPNtCZeoPL1sfuYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VPDnRUmam+g9f0IuhwBn8eYtvozUv0tErMOmm2YrvA/vTXCWy765NjwtDELT/ZHrh
	 +a7HAwzdmkbxRNJATB4LtqnMFnEdxS5+l3I65qVZOnzNx3Fqj48Uf5VXBV7TbqpRK8
	 f8Otui1xblrrRuckGyX3rLzpXD25TKzBs17xnT9rEBNt66eZCMxPdNxU6ZgJdZWBik
	 X8kNCvFusiSpgkXKkMGrqy6ka/ha8jDail3uh8cg8zVbSH9FfaAtG/ws44AP3i8ibH
	 RulSGPoURMiQvEqLp7qSBBNyPXLsG6wYGXMQ1DITee9q9IgmQ8oUmbNYln1cdkcKRW
	 loupC79g9SFLg==
Date: Mon, 13 Oct 2025 10:42:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Debian Bug Tracking System <owner@bugs.debian.org>
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org,
	debian-bugs-forwarded@lists.debian.org, 1112588@bugs.debian.org
Message-ID: <20251013174218.GO6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <handler.s.B1112588.17566725082401155.transcript@bugs.debian.org>
X-Greylist: delayed 421 seconds by postgrey-1.37 at buxtehude; Mon, 13 Oct 2025 17:49:27 UTC
Message-ID: <20251013174218.78NYRZ46Q-G557ciMgE7zyQDQL_sauK6rzqyXf-ICmA@z>

On Sun, Aug 31, 2025 at 08:37:02PM +0000, Debian Bug Tracking System wrote:
> Processing control commands:
> 
> > forwarded -1 https://marc.info/?l=linux-xfs&m=175667185613391&w=2
> Bug #1112588 [xfsprogs] DeprecationWarning: datetime.datetime.utcnow() is deprecated
> Set Bug forwarded-to-address to 'https://marc.info/?l=linux-xfs&m=175667185613391&w=2'.
> > tags -1 patch
> Bug #1112588 [xfsprogs] DeprecationWarning: datetime.datetime.utcnow() is deprecated
> Added tag(s) patch.

The patch in

https://lore.kernel.org/linux-xfs/20250831202547.2407-1-bage@debian.org/

I think will appear in xfsprogs 6.17.

--D

> 
> -- 
> 1112588: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1112588
> Debian Bug Tracking System
> Contact owner@bugs.debian.org with problems
> 
