Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF95F1C7008;
	Thu, 12 Jun 2025 17:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749750479; cv=none; b=Cvveu2ZZY/9ADd4UTeLaGj3gRmygt9ZhqahAcl6kML4t4+vnWR0NCIc1CpMC4X5JUVwmkT83m4eDMQTyarbdHkgiP2SsSc/jhGwbB3ZBuu0QPxYYi80ZrIi6m1VZRzN3+oV+3gcrgKSp1Xj7KPjx8rVDAQo8WIGvUduenHi5i/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749750479; c=relaxed/simple;
	bh=Xr7h5sgLBAq5c98CFNpNNyXcjNXOca4cQZlnqqoFx1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jhk2iR2UBW2HoAc3wvkCCEkgXmaJHXkHrPRYJOeXm0cAR5qKTVo2qW3XrXkMnH+G/yTRhhy1DnAEHCaoHCnX2dDeiMB8rYuglRdad36EHWOkcjxUDHOCY63ZfKrO07K+MeRVlKCDg+NUikQ9/IJ2dcefjWliuT9uqV6dV6OH97E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLlmMTWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLlmMTWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51EBC4CEEA;
	Thu, 12 Jun 2025 17:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749750478;
	bh=Xr7h5sgLBAq5c98CFNpNNyXcjNXOca4cQZlnqqoFx1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eLlmMTWue/D/6vodV8mf2C3XaRhfVY1r5Jf7ITtcbU0+GZe1cQvly8WWXQvCgTNiN
	 uoK9OgLqbzEK31aOcdLEkLHoQUxXGzwsS0fW+jIrMbUv7D9kGqJvg4SRnISQhnH1a0
	 ZinKCoDqq2cZtn/AjDWJpx7HK8MqKTiDlZr/oVB1Fi1u+moB2joeumj2mWwDBzBVam
	 W2t3sUjOtWpfunF4qJAvOPkR79e4quvAGp4QZ2reKQsjm6rhm+42uXVRbppYa2tEtX
	 HZSwnko0BtzKB+HAalHaPUNdjqiq5VHSfiyj45r0+Nr1qnEFObeSZ/V/RMPm8BwQfx
	 IrRNdtqEIfkDg==
Date: Thu, 12 Jun 2025 10:47:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: Unused event xfs_growfs_check_rtgeom
Message-ID: <20250612174758.GN6179@frogsfrogsfrogs>
References: <20250612131021.114e6ec8@batman.local.home>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612131021.114e6ec8@batman.local.home>

On Thu, Jun 12, 2025 at 01:10:21PM -0400, Steven Rostedt wrote:
> I have code that will cause a warning if a trace event or tracepoint is
> created but not used. Trace events can take up to 5K of memory in text
> and meta data per event. There's a lot of events in the XFS file system
> that are not used, but one in particular was added by commit
> 59a57acbce282 ("xfs: check that the rtrmapbt maxlevels doesn't increase
> when growing fs"). That event is xfs_growfs_check_rtgeom, but it was
> never called.
> 
> It looks like it was just an oversight. I'm holding off from deleting
> it as it may still be valid but just never been added. It was added
> relatively recently.

Yes that's a bug.  Will send a fix shortly.

--D

> -- Steve
