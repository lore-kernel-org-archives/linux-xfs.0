Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7404C46DFE4
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791298133; cv=none; b=aXru/jBWd18+Tn0vocfyNBQSCosUxoQIGYgHER1Wskoi8hWLu6Lc8wgd8OKHFrtLfTQmNoMX6Qml4rPwT5CPsAPl28TyuAQx9Uv55G1SS18oifwusz7BcQT8FnOLldzhEFn99Dgv8aO/uQLwUXWf2cRbWxkI2Tb+p6qXKDjYZR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791298133; c=relaxed/simple;
	bh=vSlF5tkv+EgIepvcBEvlShyk3HHFJglscC4Sc1njBDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6uQf+59kknwZc4Mp2XP1PhgB6t2iLaeUbee0kCpECQ64ShglcS/FiMZCjH2zecDpPqstq/NspFKTDVVN6EVAE4rjLZhRifs3ZYngDORZjdH1DFtvZnb6aHlQyZ6HiFDYpRNw+km33f/ZbZ6pl+x4OXTE2tw8C2XO8TBiFdIL48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEUsvGgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEUsvGgn"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0C58A1F0089C;
	Tue,  6 Oct 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791298132;
	bh=FM3WdXdb+/N1utt/lS+W8u9n92N2EBAvUgQBuCl++ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hEUsvGgnHA9DBOHlqFqGTqbIU6STyOHFXbzm6LoyYBryvL0MfqcjsMXk04AvZt4ox
	 kh6gRfOz1jfUa0dL30Df3m+Qcw3y8BP8KPTnSiH/Rdpdlm4EU5ks+RWB9a/Hv39ms2
	 M7g6nNInnFGnKRaSg0XRMjWYifAhDyeMiEEzmTGS6k0fqaI9xqZBdMl0BlmQg3mcnr
	 QgLVsXcCRmwwdqI/mMaP1qvB4QaGVttJ0vcZh73pkjZnkIoSuOVuzTA4QzcmkAZTYQ
	 uaa3FFGbcT/cz7ZOCh4WiMuZt3w+6hNmQR8t2ciEzeshZQnmcuOBic3cjJ05yNcXC2
	 ptJuJrGsm3Q1Q==
Date: Tue, 6 Oct 2026 07:48:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Cc: "cem@kernel.org" <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Message-ID: <20261006144851.GX2705364@frogsfrogsfrogs>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
 <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>

On Tue, Oct 06, 2026 at 01:52:18PM +0000, Wilfred Mallawa wrote:
> On Tue, 2026-10-06 at 12:51 +0200, Carlos Maiolino wrote:
> > >  mkfs/xfs_mkfs.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > index 334367b8..fec43987 100644
> > > --- a/mkfs/xfs_mkfs.c
> > > +++ b/mkfs/xfs_mkfs.c
> > > @@ -6503,5 +6503,8 @@ main(
> > >  		exit(1);
> > >  
> > >  	libxfs_destroy(&xi);
> > > +	free(cli.xi->data.name);
> > > +	free(cli.xi->log.name);
> > > +	free(cli.xi->rt.name);
> > >  	return 0;
> > >  }
> > 
> > Hm, wouldn't perhaps be better to hook this into libxfs_destroy?
> > Although this would likely need some other extra surgery on
> > xfs_copy.c.
> > 
> > It just sounds weird to me to free the memory here 'after' we already
> > called
> > libxfs_destroy() here. 
> 
> Ah yeah.... I back-ported this off the xraid tree, where we have a bit
> more cleanup after libxfs_destroy() and I think it makes sense to do
> there but maybe not here...
> 
> > IIUC: cli.xi == &xi in this place, so freeing up
> > memory after destroying the struct using it sounds like a time bomb.
> 
> I can plumb this into libxfs_destroy() but as you mentioned, it will
> need changes in xfs_copy, xfs_db and xfs_repair because they track the
> argv pointers, but we can just strdup(). Does that seem okay?

I don't think this is better.  libxfs' init functions do not create or
assign the libxfs_init.{data,log,rt}.name fields, they merely reuse
whatever pointer the calling program set.  Only the caller knows where
that pointed to memory came from (stack, optarg, dynamic allocation) so
only the caller knows how to drop the pointer.

The original patch is more appropriate IMO but seeing as we're about to
return from main and terminate the process, why do we care?  And if we
do, shouldn't mkfs also free the other getstr() strings attached to the
cli struct?  And shouldn't the exit(1) paths do likewise?

(To be clear, my answers are "I don't", "no", and "no" but I could be
convinced.)

--D
