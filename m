Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABC91A682B;
	Mon, 19 Oct 2026 00:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792370342; cv=none; b=gKiu/AXk3UzEz5Di7f6Al4QSKxjo6DlFCL3RT43+E3BOErA0RQk8fsyHISUov798L8XH6AGFz+bTRGd27pS4YZGJiL1+tX9r7wVAZKKg2WU31djwoPiTItcTObV8E+yV4bH/OBT1/jEvDLA9j0owPRQmyUjVkJcnfm1gTx2p0kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792370342; c=relaxed/simple;
	bh=iTAU7Z/FVjQDXJ79nJbFiM64zT2NzjOrxU6Up1/777Q=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ve62OAcGq7RoFRnwk8YwXWzzzFDLLcG3fbSE6rH6u8h00wdW3Wt2/iPdnA/BasVYF0AzvVjNR/Ki53vPIl1qgyiCS0xJraYc7WeAaFJ9mO30g3kDU7LOloePNz/YVQjLCjWqBdrEwFla19cU3lN13XQ9KdP38TyJ9A/EW7Oi/BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHezdVGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHezdVGc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 42E761F000C4;
	Mon, 19 Oct 2026 00:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792370341;
	bh=Gf/XssmHO0esWQvkBTP1Aq6T9AXyBuDYPkDHYkZgwlQ=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=VHezdVGcbMO+KmIjAq6ZNsISylCdOeeuk02cHrFABtlvjEfeGq3tKV2RmKNl4wT4T
	 OcxfU5G/62tK44lXBw34+ojxuf51eFeOaBg79KdcvIMti0F2h9VLcOmsLaULIEX1hE
	 KeIGTf/5lEtua+c8+WD38VUgr/1Wxlz+lBEqHCh6wG7TTy4wuvBL3VWNYfY2iBCNTV
	 W4IWDJG3QW33V+iLE1orSam8gB87HzFHDYzOzQ8feSc1r++P8GNah2Lgh/VLAmXdXe
	 /9kdX7bzv9K0d3S4B9/nA/5itlTliNVQ50uofQFwIxyXZ/9bZDIzWl/EdiBLj9Ak/f
	 Ws0eAIoqaAirg==
Date: Sun, 18 Oct 2026 17:39:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	fuse-devel <fuse-devel@lists.linux.dev>,
	fstests <fstests@vger.kernel.org>
Subject: Re: Farewell!
Message-ID: <20261019003900.GU107868@frogsfrogsfrogs>
References: <20261016160037.GA107919@frogsfrogsfrogs>
 <atN8YUvYy0VyvFBm@MacBookPro>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atN8YUvYy0VyvFBm@MacBookPro>

On Sat, Oct 17, 2026 at 03:47:13PM +0200, Gao Xiang wrote:
> On Fri, Oct 16, 2026 at 09:00:37AM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > After 14 years at Oracle and 23 years working on Linux, I've decided to
> > take an extended break.  Today, October 16th, 2026, is my last day.
> > 
> > I don't have any immediate plans to drop the djwong@kernel.org
> > forwarding, though ultimately that's up to the sysadmins to decide.
> > 
> > I have very much enjoyed working with you all, and I'm proud of what
> > we've accomplished together.  Good luck!
> > 
> > --Darrick
> 
> Hi Darrick,
> 
> It is still a bit of a surprise for me to hear this news, although
> things seem to be changing so quickly these days.

I know, right? :)

> Thank you for all the chats online over the years. I've always enjoyed
> them. I wish we'd had a chance to meet in person.

Me too.  I hope some day things will calm down across the Pacific. :/

> I hope you have a great and well-deserved break.

Thank you!  And I wish you the best in your Linux (or other!) endeavors!

--D

> Best Regards,
> Gao Xiang
