Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095174570D8;
	Thu, 23 Jul 2026 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819434; cv=none; b=JFaZgw3Uux3EWvVRV1tp01SKCeL0ifnU/BHp+wfqng4uJUD8OhcscJKlkXuinm9toxa8gXtXw+StEuoy4UTT0CT2jM70xuqRxagDwrJgrnDe9N5WYBchDSM+oyndNtKIZRLjymowzeWDe4kPheY5inuWTO2peagIOzzmv5qJMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819434; c=relaxed/simple;
	bh=A5wlV09DKogfe0kBBj1aY7u2FZprHmUb+qucsFiA9QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQlx+D1y4NOJ2XC0LNHCX9XOuE00l6fjZ0eWgNoMv2r8tWQ9yr+Yx2EUW/UPlN6ZsgtsCvv6dI3MFpG75/I6TlQ4SR2n0xmyX2GJB/hYqR5P6tud1Tl4iDlKXx5olzJMfzzqpiba9RL7YpKwUEIVhPYXPwvPAkceBx0PTUTzIxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UIi7wctx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UIi7wctx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 986581F000E9;
	Thu, 23 Jul 2026 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819422;
	bh=UZlemOYVIkQQ04wfQZGignsQrkbpEQViLHn6/sStVkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UIi7wctxBbUBSDvIE2MpZhrLz85CbbK/OQVDBO37A97wTjEe/yyUN0Eoad4mMD2hv
	 e4uc9pA4PxY+B9VoQlTAXAq+zZwMgBWmDTOV2ej0lsSRo8z/UociQ4M2fo6TlYktmT
	 B2HE/b9sIOtrUID1IRQfjygAYpmPcBHwvey9Cqg6ioeQBolYwc8XeztBu8EEnYG4Pk
	 Cu5A9FZnp2NrnnmvF2cBybgQCsKutA5VStVijh4KJ5Qg2ok6rlJevvYSLU6Fm4seFI
	 +jatj9UaFmX315wHwAIMj9kEBBKNQxos38d/W+kwFjSLhspRdXhfr1Lmo7WTcB37Cy
	 5wO3I5BR7w0Ug==
Date: Thu, 23 Jul 2026 08:10:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, changfengnan@bytedance.com,
	Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: decouple simple direct I/O reads from
 iomap_dio_rw
Message-ID: <20260723151021.GC7380@frogsfrogsfrogs>
References: <20260722124931.3159664-1-hch@lst.de>
 <20260722124931.3159664-3-hch@lst.de>
 <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
 <20260723045347.GA6641@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723045347.GA6641@lst.de>

On Thu, Jul 23, 2026 at 06:53:47AM +0200, Christoph Hellwig wrote:
> On Wed, Jul 22, 2026 at 12:03:49PM -0700, Joanne Koong wrote:
> > > +ssize_t __iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> > > +               struct iomap_iter *iomi);
> > 
> > Might be nice to have _read_ in this name as well, eg __iomap_dio_read_simple
> 
> Yeah.  I wanted the read out of the guts of the implementation, as
> most of the code is not strictly limited to reads.  But with the public
> API needing it, we might as well be consistent in the function naming.
> 
> > > +       if (!ret)
> > > +               ret = __iomap_dio_simple(iocb, iter, &iomi);
> > > +       if (ret <= 0 && ret != -EIOCBQUEUED)
> > > +               inode_dio_end(iomi.inode);
> > 
> > afaict, the inode_dio_end() error handling has to be done by
> > __iomap_dio_simple() to properly account for the synchronous case. I
> > ran into this earlier when doing the iomap_next_fn inlining. For the
> > synchronous case, __iomap_dio_simple() calls
> > iomap_dio_simple_complete() which calls inode_dio_end() even on
> > errors.
> 
> Yes.  Sashiko also reported that yesterday and I replied with a patch,
> but I now noticed the report and thus my reply only went to me,
> a sashiko-review list and Ted, but not everone else or the lists.
> 
> WTF?

Sashiko doesn't email the lists by default, and I don't think we want to
turn that on for the fsdevel firehose.

I sorta wish it did, but we all seem still to be struggling with what to
do with valid complaints about existing problems from sashiko that
neither were introduced by the patchset nor critically impact the new
code.

In the meantime I also don't like the "private review involving someone
else's dashboard" aspects either.  No cake, no eating. :(

--D
