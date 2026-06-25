Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A48727707;
	Thu, 25 Jun 2026 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782406422; cv=none; b=gHSzfQ6ncKoqN6eFH/+7SWvMQAYQNWNFG40rMB07izsNFECzU/XfM4rpuq0fvn++0xCmZZudWRGBOvv5wudbaafDzL4lL4mEUYoaFqnwiSi8JnuHAI8iCEl9GAPyTg1saW1QxOr+gDSoKdxvcQze/LgV54LVO7OyRcDbo4NNdS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782406422; c=relaxed/simple;
	bh=9ki/XtnbHVh9Vz0uSdwBFSMy7eGGVC6HNYhoEmaCvZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M1zDH6x0safVHnGRzCUPHTOjGnHPmR5Xcq1bEqCW4+LCUzZvmatitSSlEEZQCH7k4QPzXNWgJn69xvYylclgQcvUgXY/oQm/NrgUld+EqqO8AEmpbDBbx9NPJ3zE2aotHQIc01EjfkgCagZgph1ZbYAV8+DxP4/gD5VkWd7jaHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odsMr+02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odsMr+02"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 08BB11F00A3D;
	Thu, 25 Jun 2026 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782406421;
	bh=h6t9Nwx78eovJxmrFXwQNqtgcUKJ2pyGLQ3YWCIlC7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=odsMr+024Rzi4D+QuDKWQElEi5xAXmh9dB4nS9cn8mSkGIQXBM350IQDQY0ogjfP0
	 gKcRQ82npdzs2EW1/E5Us7xGcOIxXKkje8jZJNB/d7XYRZ/G5wXKwdh+Y0VUJ1ylnf
	 4D53HeMwg0rXIdYm/kwgAgTwkkw7Lfyu9BslHL+ztCnAef8wyuoSgHARO4U8Ju5FYp
	 mSqlJwY+xO5gapH0/KmTsopZ5RWi7UPItNBH14KhcP7tekmyuf7Vz+QPCEGVFrqYF8
	 pW44++Hfz2oAgF//pSFPja9vt4PsgpS5FBLG5agjL0OjraXG8FTg1SyLjG70RrxRUq
	 y9ES4Bw/Fl4cw==
Date: Thu, 25 Jun 2026 09:53:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
Message-ID: <20260625165340.GA6078@frogsfrogsfrogs>
References: <20260619050937.444488-1-hch@lst.de>
 <20260619050937.444488-3-hch@lst.de>
 <20260624174404.GS6078@frogsfrogsfrogs>
 <20260625132251.GA24598@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625132251.GA24598@lst.de>

On Thu, Jun 25, 2026 at 03:22:51PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 24, 2026 at 10:44:04AM -0700, Darrick J. Wong wrote:
> > On Fri, Jun 19, 2026 at 07:09:29AM +0200, Christoph Hellwig wrote:
> > > This test currently disables log concurrency scaling, but even the
> > > data device concurrency scaling can create mismatching output on
> > > systems with a large CPU count.
> > > 
> > > Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > > ---
> > >  tests/xfs/216 | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tests/xfs/216 b/tests/xfs/216
> > > index 1749647c11f7..ce8bb528410b 100755
> > > --- a/tests/xfs/216
> > > +++ b/tests/xfs/216
> > > @@ -23,7 +23,7 @@ _cleanup()
> > >  _require_scratch
> > >  _scratch_mkfs_xfs >/dev/null 2>&1
> > >  if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> > > -	loop_mkfs_opts="-l concurrency=0"
> > > +	loop_mkfs_opts="-d concurrency=0 -l concurrency=0 -r concurrency=0"
> > 
> > /me notes that -lconcurrency is not compatible with -llogdev and the
> > loopdev is not formatted with SCRATCH_MKFS_OPTIONS, so this won't work
> > to disable the concurrency= mkfs options if fstests is being run with
> > SCRATCH_LOGDEV set.
> 
> Arrg.  I hate our option parsing mess.  Any good idea how we'd get
> the desired result?  Unless there's something easy I'd be tempted to
> leave it to the first person using an external log device and large
> cpu counts..

Yeah, that's me. :)

I just sent my latest batch of random fixes:
https://lore.kernel.org/fstests/178240619625.1665857.3954516357764795627.stgit@frogsfrogsfrogs/

I don't know that it's necessary to add -dconcurrency=0 for xfs/216
after that (it seemed to work for me) but I don't have any objections to
adding more:

if _mkfs_xfs_supported $loop_mkfs_opts -l concurrency=0 $loop_dev &>> $seqres.full; then
	loop_mkfs_opts="$loop_mkfs_opts -l concurrency=0"
fi
if _mkfs_xfs_supported $loop_mkfs_opts -d concurrency=0 $loop_dev &>> $seqres.full; then
	loop_mkfs_opts="$loop_mkfs_opts -d concurrency=0"
fi

--D
