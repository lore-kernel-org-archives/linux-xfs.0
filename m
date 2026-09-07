Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8530340680F
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 06:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763202; cv=none; b=CW4zgFNICfHS3K036bW7EjOYP/Xp71ATmibv7t+8Shvc0xwkgF6Bi2X6XAoDnRcG45bgAL/m0BPg3YVIPBs/qcSny3UDldOyP7sRgR2BuspIN1TZE3kAr3ZIMeOrlCNPTAIDhBfg/vO5CroohqcKkYHXSTl0Tx9cu25xqz3eiuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763202; c=relaxed/simple;
	bh=4JuMM/vo5a7l/z5reWA67enzqmR0GdCxjh1UbKxCIy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jczCR5ev69+I2S6yjdncQknguZlFdWxQDh21gYU2EFPeOdKxsDmi86b26YYWQYf8W7M5kNQ4s50NIZnnmT6tSCFtHR4Bcir0Rh8KsjlFGk/CneI2N9do14cj59oongPQvIZHEzIu5KdQ97o1QQ1BiH8irp87v/ovHmuEZQEhwGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DE9CyXf2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DE9CyXf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E6C1F00A3A;
	Mon,  7 Sep 2026 06:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788763201;
	bh=BfZUX+OLgnCO7M12iGXMhwGQv9YFzNHwPSDQKeSmaSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DE9CyXf2vMAMxx8QyOSwvZ9KgSfbI8NQ/SsvqUwmiFUILUYwj7gCedYLQ4xniKAi7
	 ywYs0bLeAabsFJW4Pcq1s8WqJiLpJtLr5kwI3PWZNdjZclrwNP4oBOp6hh6bGF7Fy3
	 BgAwBZQHIuYZrSqOaGLNYRZq+p/HKUAvJxyTQ6RY8FUsjS2TcJ5gH7slW3+J3C3OMP
	 Jp7SE3reDRgLmqSKkhyRifj8wEOqMKVrKU1WWqpP8wt83adfi406cP28I0EJjupHgl
	 NVf2Ri414rbQCdseid97eA5dZWbfbPgJGQmIrje8S7yKhBPdRcHxoJkLVfntAlbMqd
	 1+irG2lM8VZGA==
Date: Mon, 7 Sep 2026 08:39:57 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] xfs: add xfs_error_report the ability to display
 an error code
Message-ID: <ap5cC9SQ2c3RbwfJ@andromeda.toxiclabs.cc>
References: <20260904113231.1408890-1-cem@kernel.org>
 <20260904113231.1408890-2-cem@kernel.org>
 <20260905010851.GE1933798@frogsfrogsfrogs>
 <ap5T_Pcvk4QAMcWb@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap5T_Pcvk4QAMcWb@infradead.org>

On Sun, Sep 06, 2026 at 11:04:44PM -0700, Christoph Hellwig wrote:
> On Fri, Sep 04, 2026 at 06:08:51PM -0700, Darrick J. Wong wrote:
> > > @@ -387,6 +388,10 @@ xfs_error_report(
> > >  		"Internal error %s at line %d of file %s.  Caller %pS",
> > >  			    tag, linenum, filename, failaddr);
> > >  
> > > +		if (error)
> > > +			xfs_alert_tag(mp, XFS_PTAG_ERROR_REPORT,
> > > +				      "Error Code: %d", error);
> > 
> > /me wonders, should the error erport just go in the "Internal error..."
> > message above?
> > 
> > "Internal error $tag ($error) at line..."
> 
> Yeah, that seems much easier to follow.  Maybe make it conditional on
> an error being passed.
> 
> > > +extern void xfs_error_report(const char *tag, int level, int error,
> > > +			     struct xfs_mount *mp, const char *filename,
> > > +			     int linenum, xfs_failaddr_t failaddr);
> 
> .. and let's drop the pointless extern here while we touch this.
> 
> > > -			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
> > > +			XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, 0, log->l_mp);
> 
> Overly long line here now.
> 
> 

Thanks both for the review. I'll work on it and send a proper patch
later on, I need to finish a case for xfstests first, then I'll move to
this one...
