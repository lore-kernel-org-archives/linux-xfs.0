Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D533806DC;
	Thu, 10 Sep 2026 06:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789021355; cv=none; b=RT/te5bfsuxOnX6rToiaFlzQ8F+GVocpc8zNWfafeLrwtgIbR4B5FXaUxzVyzAQChzSxcktn4wRNjRHFxvYq2tjtjw9THjUWGbBtNxsY89KjYjO17+SIXY6xJHmpivsExTy2rUTNKwyfs4hnh5+IC8DjrVNpop84Wadfnrr8zC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789021355; c=relaxed/simple;
	bh=mkeiTvKTAihxIl6PAzBtRsybubQc3yUr1TIxifXGUg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gL7SmgjbiOTa7cpVxp/jIffnA00ghueuh4gr3FbF0+1GJcwe23BcTBHAt92rLW51rkL+Mvy+VX7+zARY7cDVmOPUrzbDSgAR2YNs+1r9dYDkehPy0ZVMMUTI/ZM/eUyDEJa1Nwh1IzpruZRL2Onw3CQ2UZf6885LTSmKVs++/8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdZHKe9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdZHKe9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB351F00898;
	Thu, 10 Sep 2026 06:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789021354;
	bh=5BZiRfgZS7AHrUZdRWzjthAwvtJgIbGDrAxL38OF6ic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JdZHKe9NiMo82a6NUcOqXfuDd7fNeg6Y6bzkp+Ia3KAcREaXQBwHiv/42IE2drha1
	 gjUSf2dRPeC+GmDEk2LZc07nyl/XlXbPwyQBmG0Y5KqcUde74It105wAx2bfizmjmn
	 +GbP+QOdFrijdjnPRTqgmMxVaiFv9FT59xYJ9trfoQ/Fi7gO3R/D7kIyGOJ50mdyB4
	 PUrf6bfOc+CKR9qKQ0BmmFk/11lvPX37IVSZqWnavz1PQwV48Fe6ilAYU3odUM7/kb
	 fEqZsPk4XPMRu1n7yMdKo2GO//8kTiS7QFdGPMNCcId/XAsBO6AxP6DwBUQ0bs/aog
	 novGsAnNYDY0A==
Date: Thu, 10 Sep 2026 08:22:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Deepanshu Kartikey <kartikey406@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
Message-ID: <aqJMije5UTBb1w__@andromeda.toxiclabs.cc>
References: <20260906144629.17009-1-kartikey406@gmail.com>
 <20260907045150.GI1933798@frogsfrogsfrogs>
 <aqI7LFBkAhMSaDnx@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqI7LFBkAhMSaDnx@infradead.org>

On Wed, Sep 09, 2026 at 10:07:56PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 06, 2026 at 09:51:50PM -0700, Darrick J. Wong wrote:
> > On Sun, Sep 06, 2026 at 08:16:29PM +0530, Deepanshu Kartikey wrote:
> > > __xfs_healthmon_insert() asserts that hm->lock is held
> > > (lockdep_assert_held), but xfs_ioc_health_monitor() called it right
> > > after allocating hm, before ever taking the lock, triggering a
> > > lockdep warning.
> > > 
> > > Take hm->lock around the call.
> > > 
> > > Fixes: b3a289a2a9397 ("xfs: create event queuing, formatting, and discovery infrastructure")
> > > Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
> > > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> > 
> > Heh, I added a patch just like this one to my own tree.
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Can we get this queued up ASAP?  It's also causing a lot of failures in
> our zoned XFS CI.
> 

Yes, give me a few minutes and I'll have it today, ready for the next rc
