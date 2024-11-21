Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAFA55C29;
	Thu, 21 Nov 2024 17:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732209565; cv=none; b=hMKYTz9gwkzNMzDygBeueUhc8uUGwI9jAHeahmArTG+dLqCYenjGRN5o7q6ZNcMYisonoeAJObyxfLUfuW4HjRb10+I7cGTofBv1TlpK+cm6a6dM1C8Hbze0bIH1h0QwwJw10/08l7q0xNIVnjT0s2XVm5eud8H3P7ssVqZa88U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732209565; c=relaxed/simple;
	bh=O53DGaiH12AFmGIdHA8k/ruRsCJ7dyH0aBboaC/hrRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SauJsTLuSPLsjP82H/WiyPmriaAq9y5qXPdOKyTI1pWHllDcpsPCZwzs7IMbQAtYxYSmBFVJwYSJVtgPVOAjczXUT/Lj6jqIBJwSqB99OgiA74Rn90Hd+y+yDH1yixJEbxHfU20VKdAI6p4xWJTVj65AaBqCQFay5wnzHmGtZRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izVdAs+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izVdAs+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BE1C4CECD;
	Thu, 21 Nov 2024 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732209564;
	bh=O53DGaiH12AFmGIdHA8k/ruRsCJ7dyH0aBboaC/hrRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=izVdAs+Qs28jAFX3Jy7EnPVQGttNPSFmDLt3AZ/ZQCp5M1/36YjRNAJp4Q1pRh623
	 EkaYeUTZiEbZt1y+5KjGVcjNFg6WoGvlese/Xepo2OsU7vKovIMFxYEKFpNjhBFNqI
	 /HoCGHwQ8c7lgNcooOJ5G0cpB051LxGxXrfB5sLndNGUH9v2z3Dveiw5meHYgHsEt9
	 /Uq66m5zjUFY3+ZL4Q0HcQ034qsaS1d5n84UnMcFgGvS+9+TnKJSxYeXRL3qSZlYU0
	 pz+SmirtaKL6e+QgYI5mTKfOwEv5PeB/uA83wKmjejjcfJGWkWA5lNdKQqAb21HtV/
	 UZ+bBTeII8E0Q==
Date: Thu, 21 Nov 2024 09:19:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241121171924.GV9425@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
 <20241121101325.GA5608@lst.de>
 <20241121105248.GA10449@lst.de>
 <20241121163355.GU9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121163355.GU9425@frogsfrogsfrogs>

On Thu, Nov 21, 2024 at 08:33:55AM -0800, Darrick J. Wong wrote:
> On Thu, Nov 21, 2024 at 11:52:48AM +0100, Christoph Hellwig wrote:
> > On Thu, Nov 21, 2024 at 11:13:25AM +0100, Christoph Hellwig wrote:
> > > proper zeroout ioctl, which fixes my generic/757 issues, and should
> > 
> > It turns out then when I extrapolate my shortened 10 iteration run
> > to the 100 currently in the test it would take ~ 30 minutes.  I'm
> > not sure that's really a reasonable run time for a single test in
> > the auto group.
> 
> Yeah, perhaps I should adjust this one to use TIME_FACTOR too?
> 
> while _soak_loop_running $((10 * TIME_FACTOR)); do
> 	# timeconsuming stuff
> done
> 
> (and then you can SOAK_DURATION=10s to limit the runtime)

Oh, that's with your BLKDISCARD -> BLKZEROOUT change applied, isn't it?
On my system, 100 loops takes 96 seconds with discard and 639 seconds
with zeroout.

So yes, we should shift this test to use thinp.  I was going to say that
we should also make _log_writes_init skip the test if the block device
has discard_zeroes_data==0, but apparently it's now hardwired to zero
and (AFAICT) there's no way to tell if unmap actually zeroes even for
software defined devices like thinp where we *know* that works. :(

--D
