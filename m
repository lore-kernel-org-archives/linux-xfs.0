Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207633B813C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789483848; cv=none; b=egJlywjZ0kSew6cZULfBGZ7JFAxryUhPT8mjXmDx6palX6XkuM17sfcrS+As4Vv3yMg8P3WnMvS7oFKA35PIeaZntfV0JjFo1L8g185j1yS1NAeOSqJXseXZemj0Luqmk88er3BV7PRu2gv5bDenzqpZjoHm+YHecKa7AOGI3xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789483848; c=relaxed/simple;
	bh=LfxqOLxijW1dybAAPfl1T4lXUbXjHDM4k9NOvBhGdQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQDcv/+QluD4nu90w+YUjol304clf97w5SDu7PhMwBf6oOSpWNKLaQQyqg0UlLL4JfgG+PdtWoN+gIZHPRgSb7OCORxvYsX5WFIcnbyJfaTarm7IURz0Fwu0SSf+MFdW4ABsXXSvUso9jhe+I0/tgIyDr36O7f4cir/saV37/lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iIE12/N/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIE12/N/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A893A1F000FF;
	Tue, 15 Sep 2026 14:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789483846;
	bh=f9Nat9XvVq6BwCAke2yjM2+27iXmoD405HGMc+ATCrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iIE12/N/eLt+rzjiH/2JMfOMNtpC0D68cN+bEJxk3c+8OUHIXCJZh7K7Cs2sy7EzN
	 kvy9IjgfwwZsgG3pZoNfz5rMFAwJ6qiY8b6X/S5U4I7oxqwS4veigfFERrWhJ4cXxu
	 iJhj4ByM84nv+SBVCj3BogeJMzTJSkN0SrjIu++kJkdfTA6EyEhR2HncdBf85i2TBd
	 G/qImNy15iDiI/VFPE3FlzJOuTjQODthZ+SjPRi0SHFiY0bQOCb3e4BsynzC9UgwvK
	 Rc/Si/DaTy/cq2cNNQ24eu5OfuAfpJGsI3xHnNp85Y2o1eAW04+CyOPFh1FGuqgQ05
	 cDPh3OKmqR8BA==
Date: Tue, 15 Sep 2026 07:50:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.garry@linux.dev>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [bug report] fstests generic/774 hang again
Message-ID: <20260915145046.GC2705364@frogsfrogsfrogs>
References: <aqkP9CTUvlC2YCIb@shinmob>
 <98190f62-ccc3-49df-934d-f168e293c485@linux.dev>
 <aqkv-2opTlWD6bzU@shinmob>
 <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed224f94-f605-4be0-8a0a-0b3d481e46ae@linux.dev>

On Tue, Sep 15, 2026 at 03:48:13PM +0100, John Garry wrote:
> On 9/15/26 12:48, Shin'ichiro Kawasaki wrote:
> > On Sep 15, 2026 / 11:00, John Garry wrote:
> > > On 9/15/26 10:34, Shin'ichiro Kawasaki wrote:
> > > > I observe the fstests test case generic/774 hangs, when I run it for xfs on 8GiB
> > > > TCMU fileio devices. Actually I once reported this hang symptom in last October,
> > > > and Darrick and John kindly took some actions [1]. Since then, the hang
> > > > disappeared and I have not observed the hang almost one year. However, my test
> > > > system started reporting the hang again last week.
> > > > 
> > > > [1] https://lore.kernel.org/linux-xfs/cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2/#t
> > > 
> > > This was the series to resolve, I think:
> > > https://lore.kernel.org/fstests/176279908967.605950.2192923313361120314.stgit@frogsfrogsfrogs/T/#t
> > > 
> > > As an experiment, can you reduce the file size further, like:
> > > 
> > > --- a/tests/generic/774
> > > +++ b/tests/generic/774
> > > @@ -29,7 +29,7 @@ aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
> > >   fsbsize=$(_get_block_size $SCRATCH_MNT)
> > > 
> > >   threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
> > > -filesize=$((aw_bsize * threads * 10))
> > > +filesize=$((aw_bsize * threads))
> > >   depth=$threads
> > >   aw_io_size=$((filesize / threads))
> > >   aw_io_inc=$aw_io_size
> > 
> > Thanks for the response. I repeated the test case 100 times with the change
> > above, and I did not observe the hang. The change looks avoiding the hang.
> > 
> > > 
> > > > 
> > > > FYI, here I attache the kernel message [2].
> > > 
> > > Is mainline baseline hanging, i.e. v7.3-rc2?
> > 
> > I will try this out tomorrow.
> 
> thanks
> 
> About the kernel code, I am wondering if using IOMAP_DIO_FORCE_WAIT for
> CoW-based atomics could help avoid this issue as we seem to be bogged down
> in lock contention.

Which lock is being contended, anyway?  It looks like the ILOCK?

--D
