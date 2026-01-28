Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E61636EAB0
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 17:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769622530; cv=none; b=ooSUg66hE4MG7uO15EK8AdC748NQVJsCHYnBSL6MbxR3THQCb/fUmdLE3X0cWgkhI+ascWQcRG4fHtL2uQc2o/KKWGJFKu1qwBQLaoZtPKDOTPIKPTaXEQPWLJCVRSkwz7L1Jm2SwsTble2vmURVNAnaY7PO1fKs3a5sUeINsVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769622530; c=relaxed/simple;
	bh=HpTyesaiFZvqKNqY3XIjaN9KaMT+LAJSGVXU5lTQ3uI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfQUEPP8hvMyFY6uzY69bxrdLBtSosjMlw/5YdEtdRLOCoLNkLKubp53LB2C9tsCQWTyqjl3H2hvaZQ6fwW+RcCbpBEua+sUaLBhvssV37kdmfyWFuesBs0qt+uK5yQBWtnOkAfEsWqRmSizZQFTZ38kRfK1DALQ2El9dAopuoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVtEVWJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVtEVWJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC369C4CEF7;
	Wed, 28 Jan 2026 17:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769622530;
	bh=HpTyesaiFZvqKNqY3XIjaN9KaMT+LAJSGVXU5lTQ3uI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oVtEVWJYbh7mA692XFl0ji3nTq5zLSxsk/s/pOO/SMKuTMhumxcR5gBLQMOATknLd
	 17/Z22CyG2IDRsu2h6Ru8nlc05AdIQeRQzbW6vSRD9XnsRF8cXU2YcaXCrGFNUyAC+
	 4BQNNxql1AOHvwixTaSyAhlQX/KHO56e1d0cYdLWUDN+8ZZiDmfL18O4UWVCQYpsVb
	 tEY3pFtfdW94Ahn2dgYfu/AtM2mijEZpnIUglvYP3Tgoa9UBG6d66YRTCdSV2jwsDx
	 c1CXpm6ONR/QU7HePI5kYpYmNTFph4m5C8RD5dMXrJcsA0/7+gysUNVp/nCa5fTq32
	 FoRTKNgbMvOUQ==
Date: Wed, 28 Jan 2026 18:48:46 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: allow setting errortags at mount time
Message-ID: <aXpK9kqQQuvXfUu3@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-7-hch@lst.de>
 <aXnyfoEDhdHTIf-E@nidhogg.toxiclabs.cc>
 <20260128161142.GT5945@frogsfrogsfrogs>
 <20260128161351.GA12914@lst.de>
 <20260128161641.GW5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128161641.GW5945@frogsfrogsfrogs>

On Wed, Jan 28, 2026 at 08:16:41AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 28, 2026 at 05:13:51PM +0100, Christoph Hellwig wrote:
> > On Wed, Jan 28, 2026 at 08:11:42AM -0800, Darrick J. Wong wrote:
> > > Should we explicitly state here that the errortag=XXX will /not/ be
> > > echoed back via /proc/mounts?
> > 
> > Sure, I'll add that.
> > 
> > > Seeing as we recently had bug reports
> > > about scripts encoding /proc/mounts into /etc/fstab.
> > 
> > WTF?
> 
> I tried to remove ikeep/noikeep/noattr2/attr2 and someone complained
> that we broke his initramfs because Gentoo or whatever has this dumb
> script that "generates" rootflags= (and maybe fstab too) from
> /proc/mounts.

Ooohhhh, that thing...

For context:

https://lore.kernel.org/linux-xfs/176107134044.4152072.18403833729642060548.stgit@frogsfrogsfrogs/

> 
> --D
> 
