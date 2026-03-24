Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4CE38C43F
	for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2026 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774372725; cv=none; b=S4+H8kErCsa84f3T1OiuITXwVPMJdyxXE1F2GClZ5nmS4ujKUiGoG0xEQ4bS9LQ3hnp+LkWgTgBMIfoZ2qjf+GueoRwH0AgFRVCTqR7tHLeshe56QlMu4Y0O3bRq7rRbexB6SWO9KChxFrO2pKqubipZMhgdkTck7Ae7So1SAVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774372725; c=relaxed/simple;
	bh=dsRMjn7T4oUtVid1puXv59OiYp31TjrvPxye79CtEKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUGzsVtm+Hz4i099sIHdLf2+QvSNA9nM6bDKGcPZgKlDSz6gHQ3hpawrgSRw3z9FJtlh8cS6hF17dVfjJfeQqXLhGB8tBnEYX2ZsOsnPLBEhmBKxxiYlDPWNU8/aa0SNc55jtHvZVHmey2Pnw3xPpZ3CPwAEt/4tIGJLj+acvtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLjQmO97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLjQmO97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F127C19424;
	Tue, 24 Mar 2026 17:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774372724;
	bh=dsRMjn7T4oUtVid1puXv59OiYp31TjrvPxye79CtEKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kLjQmO97MbXvjVjG2Ohtb/uqJwbG6+nPLDJkHnNTkJ5HfJKW1FztGNKxjV5aQTHbx
	 bFzHP4AOrMOPwZKZaPdAotMdlbHY/gzgf9pkLVxAsnzFXSTcEvI4yceA3QfwvUPBTz
	 EsAY6BCL73XR55p9xIvP5SEJzdZ5FzJss1xWcqyYLGXoHyet2o5CYY6Q8dqIssux0b
	 GElUpQfze/gBD6O7Ar5GZPYHCdJz6eRsffowiQmepFfx1enYnuKk3sD9IuYhUvtKGR
	 lfCoDKiKD9mv3FW9Lk/UbyQQQzJNBBRNQP7e3NbjBsLAMQYQ5gTPQklNN07EctWN37
	 mbRQNVBtV9qIA==
Date: Tue, 24 Mar 2026 10:18:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/40] libxfs: port various kernel apis from 7.0
Message-ID: <20260324171843.GR6223@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
 <177429120775.2266274.16124276962731944084.stgit@frogsfrogsfrogs>
 <acIsSch9HdMG0P64@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acIsSch9HdMG0P64@infradead.org>

On Mon, Mar 23, 2026 at 11:16:41PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 23, 2026 at 11:41:48AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Port more kernel APIs from Linux 7.0.
> 
> A little nitpicky, but this suggeste they were all added in Linux 7.0.
> At least kmalloc_array is much older than that.

I'll change it to:

"Port more kernel APIs from Linux as of 7.0."

> > +#define kcalloc(n, size, gfp)	kmalloc_array((n), (size), (gfp) | __GFP_ZERO)
> 
> Overly long line.

It is?  On my system it only hits column 78.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
