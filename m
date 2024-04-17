Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2AC537E4
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713333324; cv=none; b=p7suKGCHaWYeXbvqkjEJO5wiqnF/i2x+FL8rq51VBB5YsWnF8/cIA8Pp0fdaCQvaeDjrp6iWVx+gjarRhdO+dghgxGD+n4TVmErGQzTG5gSjTY0MzXmcD/LXtkUu6KXoQDFTR53RBlfdmvyKRaFY7sYdc42OM67eGka5zrEOBqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713333324; c=relaxed/simple;
	bh=d25SWi9fRD0IJiGbi5USkQLSnRSyPWSSK3DzO9n0l9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OoRUmlZU3ql9WAyKDOfAYXsRFoZflLbPRurzDFIq0fQrTMsUDaq05FFSgdw6Zf/OtnlHi7AOjdMS6iFb8qOn9H1sfhnFoHghTBAD5CX1xwoecsqW4h6nIZY2oIRTW+LRSvd5vk0MPgcgduughrJgzgw3qbr7xn0Aicjg28yjxsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfAzklOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfAzklOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1937FC072AA;
	Wed, 17 Apr 2024 05:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713333324;
	bh=d25SWi9fRD0IJiGbi5USkQLSnRSyPWSSK3DzO9n0l9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QfAzklOjXdQDa099aotM1oz79wjKSiCYjPvFVyC4OvD21sQEEHZuuaSEzXIJK/LRi
	 Mm4qsRXwcPLJtNfok1wSamk349502OP6bCacsjx3AQMqsPGOl7DVrxJxdEGwKyDAvI
	 5lIX2hbbFe8YBUsd9woV6EjOS68eoEeGDIy/IkvyhDy5R1lp76VN4cTLd8d7Q6fWqF
	 ZuKSJ9s8+V5sSHOe22sL7xBLee/MDm8TtBNIexKB/KQkMO0aH+/72SNz6bN/0EzRWD
	 WdTdbLTX5T+K+j2uDSBudv4wITCs23sTwg08LlStYuvqcL+/CthVxWBDZJekxYAkEE
	 KEIOjA/psaFHA==
Date: Tue, 16 Apr 2024 22:55:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/32] xfs: Add parent pointer ioctls
Message-ID: <20240417055523.GQ11948@frogsfrogsfrogs>
References: <20240415194036.GD11948@frogsfrogsfrogs>
 <20240416044716.GA23062@lst.de>
 <20240416165056.GO11948@frogsfrogsfrogs>
 <Zh6tNvXga6bGwOSg@infradead.org>
 <20240416185209.GZ11948@frogsfrogsfrogs>
 <Zh7LIMHXwuqVeCdG@infradead.org>
 <20240416190733.GC11948@frogsfrogsfrogs>
 <Zh7OENwAEADcrcvr@infradead.org>
 <20240417052245.GP11948@frogsfrogsfrogs>
 <20240417052918.GA29248@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417052918.GA29248@lst.de>

On Wed, Apr 17, 2024 at 07:29:18AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 10:22:45PM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 16, 2024 at 12:14:24PM -0700, Christoph Hellwig wrote:
> > > On Tue, Apr 16, 2024 at 12:07:33PM -0700, Darrick J. Wong wrote:
> > > > Ohhhh, does that happens outside of XFS then?  No wonder I couldn't find
> > > > what you were talking about.  Ok I'll go look some more.
> > > 
> > > Yes. get_name() in fs/exportfs/expfs.c.
> > 
> > Hmm.  Implementing a custom ->get_name for pptrs would work well for
> > child files with low hardlink counts.  Certainly there are probably a
> > lot more large directories than files that are hardlinked many many
> > times.  At what point does it become cheaper to scan the directory?
> 
> Note that despite my previous confusion get_name is also called for
> directories to find the actual name they have in their parent.
> 
> An easy conservative choice would be to always look at the parent
> pointers for nlink==1.
> 
> All of that is for later, I don't want to delay the parent pointers
> series even further.

It won't; I'll need to test the default ->get_name implementation so
that I can compare it to the new one, which means I'll have to figure
out /how/ to test that.

--D
