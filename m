Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BAB4A33F2;
	Thu, 10 Sep 2026 14:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789050801; cv=none; b=QTsxTGQnUq7sxWAKr3L/AeInNAybG/XWdeUFmHv2MhIfINrZP60P+sEX8jV7Luvv/FqP+WfwFRMP0/OPvJG2KgpsR1TLGxcZOZv/jDHVWbbPuTLF1OveT/7KImvYTW/ENjIpnNGjSNjX2bvGoPiqK/4PPyQvDzmQUrnIpORj6oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789050801; c=relaxed/simple;
	bh=8XWRRLV2HR24ylLN3H1VmWSQ6C0zZbfBPSjYabPYmLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwxXGcHRvO9A+tLnjiahLFZgRMh+oRPkuenRuXAxjUAXGYxboT7JWQ99N6zBbqvRRAOEFqz7TCq8yYJCsZEvM+9xeR/mqa1kSdghZOkZ9956OZI1cluUSuwSfkYc7XP+Y3sHg7zEddiQVt8il/kN8FLnx8NuzExJBAjPXtdqnXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uashi8xG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uashi8xG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7B71F000FF;
	Thu, 10 Sep 2026 14:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050799;
	bh=TADwm44F09CllzbRucnWI3RtVVnc0ea3GpRzJrnWysk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uashi8xGWW99JfKicBIoQML8tSEy+b/ywABs9KtJndfRXi9IXbUpOMaoqS+2rdYym
	 iPt3g+x5dGchLsfdgrbss5+NF5XFKmexlECZ+i9lJJnB0cRI9ktHOmlgYlIHopAj8U
	 4beLNezgUIr8slnCI3cqR1ep0NZdUXpTfx02ae9eHaOaSIgHHP6S9uigVHH9k9/kDR
	 jOdjI1aEtTA1k5ClrfpyS0Gojx2PeNzQr1L9dH+24+8Dx/p3XBwW6GM1807EedRGAp
	 c0vnjxyP1Pgvc9gJM3wuR8IiU2SlY/HC8WOwz1YZ52Kw/m9B8OirzvbryNH+tX02I6
	 hN76CqhPfagdA==
Date: Thu, 10 Sep 2026 16:33:14 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Shigeru Yoshida <syoshida@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Deepanshu Kartikey <kartikey406@gmail.com>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: take hm->lock in xfs_ioc_health_monitor() before
 insert
Message-ID: <aqK-SLzgrgzGMrwP@andromeda.toxiclabs.cc>
References: <20260906144629.17009-1-kartikey406@gmail.com>
 <20260907045150.GI1933798@frogsfrogsfrogs>
 <aqI7LFBkAhMSaDnx@infradead.org>
 <aqJ6yulX3XBEoj4u@andromeda.toxiclabs.cc>
 <87y0d99q8y.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y0d99q8y.fsf@redhat.com>

On Thu, Sep 10, 2026 at 10:42:53PM +0900, Shigeru Yoshida wrote:
> Carlos Maiolino <cem@kernel.org> writes:
> 
> > On Wed, Sep 09, 2026 at 10:07:56PM -0700, Christoph Hellwig wrote:
> >> On Sun, Sep 06, 2026 at 09:51:50PM -0700, Darrick J. Wong wrote:
> >> > On Sun, Sep 06, 2026 at 08:16:29PM +0530, Deepanshu Kartikey wrote:
> >> > > __xfs_healthmon_insert() asserts that hm->lock is held
> >> > > (lockdep_assert_held), but xfs_ioc_health_monitor() called it right
> >> > > after allocating hm, before ever taking the lock, triggering a
> >> > > lockdep warning.
> >> > > 
> >> > > Take hm->lock around the call.
> >> > > 
> >> > > Fixes: b3a289a2a9397 ("xfs: create event queuing, formatting, and discovery infrastructure")
> >> > > Reported-by: syzbot+ccdf3469f5f653bff7ac@syzkaller.appspotmail.com
> >> > > Closes: https://syzkaller.appspot.com/bug?extid=ccdf3469f5f653bff7ac
> >> > > Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> >> > 
> >> > Heh, I added a patch just like this one to my own tree.
> >> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> >> 
> >> Can we get this queued up ASAP?  It's also causing a lot of failures in
> >> our zoned XFS CI.
> >> 
> >> 
> >
> > Done. It's in for-next already. Not sure if I'll manage to push the
> > attrs fsblock fix yet this -rc, but this one will go to Linus on
> > Saturday
> 
> I noticed that the second mutex operation in this commit was
> accidentally left as mutex_lock() instead of mutex_unlock(). I've
> sent a fix as a separate patch ("xfs: fix double mutex_lock() call
> in xfs_ioc_health_monitor()"). Feel free to use it if it helps.

Thanks for the info, something went pretty wrong with b4. I didn't touch
the patch manually and somehow it got twisted when I pulled it.
I'll figure it out what went wrong but first let me fix this...

This shouldn't be in the tree at all, so I'll remove the patch for now
as this has not been pulled into the linux-next.


> 
> Thanks,
> Shigeru
> 
> 
