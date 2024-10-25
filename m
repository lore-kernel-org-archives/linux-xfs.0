Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8740DEEAA;
	Fri, 25 Oct 2024 03:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729826603; cv=none; b=u8k1HrdUMIn2qcwmPqvjOnXpRauJSLviYLwBMPaE2IknxNyKVMOBG2rMgwWNOmBsUtUMLjznIGO0VyW0M/579TckaiPF2hjjbS4yDhBA0TofG7+TxPSA2c/jvOpAhWC4eYVGbVx7GZJfjfQwMEgu8sJ74wFQ0bsxe32WNyT2OI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729826603; c=relaxed/simple;
	bh=OFrt+EnUsqS58OeExu0Jwrq5NlRY2kVWHa4qTHnZJmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yoro3YW/AhO5BW/5gqxvuXepMgihnzJMbR4ymBxXDgZRlYqSVWsaTJRSBehX1LXangdILuelUgSWSMeNOCElE4/+8xicAP5544sSXYl8iEbYEEFBEzjv1XBBnlQQg0k5m4mDOaP9CkIxasXHKfjuZ4T+hsUZ/Jm5FV1nfx/1EQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=sGeuIuZx; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="sGeuIuZx"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4XZSm01cjdz9spX;
	Fri, 25 Oct 2024 05:23:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1729826592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d8XmMsLK4w88MW6uHzw4ZPWNbF5R8ycyxflOPBeNcVI=;
	b=sGeuIuZxCfMaQsjHt3QHdnb8xXt9mkujGk/p0RdjpGo9da6KO/oT71K3VnFHwBJiWtpR4K
	xI5GfvgDQFRKtA5AWevWWYDgucmGLVWM+JzU3u5PAoNLmud+AuIVNjeFmOgp+JByfznoRx
	vRSsoWo17pVzntsiWB/EkGZyHAFro3Ywz8ONQoXoRO/tCKnz5Cw+StjLvkA28WbNr2/St1
	LhMtTQiSIYp4O1QuAG8SgI4gKb069XbCG/owv+hWNio9tdVRcnVZuXgd6nAR3+xdKb6IkH
	WPdmvZvNjoD1mymtS+P2hjzSqXEO4/hR0crSkxhFezwG8EVJJdTZsZ9NTropPQ==
Date: Fri, 25 Oct 2024 08:53:01 +0530
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>, fstests@vger.kernel.org, 
	zlang@redhat.com, linux-xfs@vger.kernel.org, gost.dev@samsung.com, 
	mcgrof@kernel.org, david@fromorbit.com
Subject: Re: Re: [PATCH 2/2] generic: increase file size to match CoW delayed
 allocation for XFS 64k bs
Message-ID: <vpivcgakglas5liy4wm2s7nr7pkwuqdl4dvfwocitzop6eezff@k7l462guqp63>
References: <20241024112311.615360-1-p.raghav@samsung.com>
 <20241024112311.615360-3-p.raghav@samsung.com>
 <20241024181709.GF2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024181709.GF2386201@frogsfrogsfrogs>

> > +++ b/tests/generic/305
> > @@ -32,7 +32,7 @@ quotaon $SCRATCH_MNT 2> /dev/null
> >  testdir=$SCRATCH_MNT/test-$seq
> >  mkdir $testdir
> >  
> > -sz=1048576
> > +sz=4194304
> 
> Hm, so you're increasing the filesize so that it exceeds 32*64k?
> Hence 4M for some nice round numbers?
> 

Actually we do a CoW write for sz/2 in the test. So I wanted sz/2 to
match 2M (32 * 64k). I hope that makes sense.

> If so then I think I'm fine with that.  Let's see what testing thinks.
> :)

:) All the other solutions might require fs specific changes, so I went
with this approach. Let's hope this works.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Thanks!

--
Pankaj
