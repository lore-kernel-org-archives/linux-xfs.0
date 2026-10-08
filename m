Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A955B3EE1F8
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 11:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458416; cv=none; b=fOGE7TrBU8PBhm4OL/B7rZM8Kwq6sc2Zs22GnHeCyZrD9O8DVbrmt69elce3lreFnZsfR0BQUor36kCbkvGBqMKsX/JI2WflMUL23rJcnQ87iS4bIPWwZrdcbcCNVN8+kwpuHXjRP6BVitnuBoxJ99MfxRXFh4zbhcrT7kifrZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458416; c=relaxed/simple;
	bh=if4x0FQdjF5IRiWzHAgEEPF5B5483rDpL0QUMOI7cS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJRYOd+nSmOk9xZWUobA8hy5nBSA79CyGLkC8gdATU7NYnnmIaBRrYFaL51ho0so70tiFc1bdwYAOXJ5ErEndjG0kRuhlC983Y+ZfM14yqIF6FiQ5Uo5vBxfdAkpOauLNXMbvdNYMuvV317N+QAp0jHv7QqXLROEIym4thYccMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cniJ+iTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cniJ+iTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18A51F00893;
	Thu,  8 Oct 2026 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791458415;
	bh=lgJWHFuH8L3cP7z+LLBA44p7QZRZbXIT50revCLGNO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cniJ+iTVYrKLhpFNmuBQsHBdo/5S+wCLg76HJUT8KWmxKeLf1DTLX/zDJj/c579+P
	 XrQuLPrK/A1qkkcmuveIa2TTpahHh5qq2B/ryeOnPpis6x27Jr5+BOksV4965Lub3N
	 SX/cjFhvghWF+bQWZe3EinxRbTtgoqH2ObCnzVU52ulQlH3bHg3ZmRCy+1cVIw+Efh
	 b/ypqCgFhk1Bviz7K8D1Ynrt1EO/rZCY489p1/dMLwVb1ra3udsN+hoMqxG06zUVku
	 72vR1qbWlb8LTB0vAtMPTsIMktu5NKo/eX0qi6c0ORYHxoyVPOqSD86bNdf1hAhUjh
	 XpbU4pX50eMQQ==
Date: Thu, 8 Oct 2026 13:20:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [xfsprogs] mkfs: fixup memory leak on exit
Message-ID: <asd7554UisFwlOsc@cronus.toxiclabs.cc>
References: <20261006101232.357124-2-wilfred.opensource@gmail.com>
 <asTQdEMkpzc7_tSd@cronus.toxiclabs.cc>
 <75bc883c4d45a514aaad949dfe301c3f2a79112a.camel@wdc.com>
 <20261006144851.GX2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261006144851.GX2705364@frogsfrogsfrogs>

On Tue, Oct 06, 2026 at 07:48:51AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 06, 2026 at 01:52:18PM +0000, Wilfred Mallawa wrote:
> > On Tue, 2026-10-06 at 12:51 +0200, Carlos Maiolino wrote:
> > > >  mkfs/xfs_mkfs.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > > > index 334367b8..fec43987 100644
> > > > --- a/mkfs/xfs_mkfs.c
> > > > +++ b/mkfs/xfs_mkfs.c
> > > > @@ -6503,5 +6503,8 @@ main(
> > > >  		exit(1);
> > > >  
> > > >  	libxfs_destroy(&xi);
> > > > +	free(cli.xi->data.name);
> > > > +	free(cli.xi->log.name);
> > > > +	free(cli.xi->rt.name);
> > > >  	return 0;
> > > >  }
> > > 
> > > Hm, wouldn't perhaps be better to hook this into libxfs_destroy?
> > > Although this would likely need some other extra surgery on
> > > xfs_copy.c.
> > > 
> > > It just sounds weird to me to free the memory here 'after' we already
> > > called
> > > libxfs_destroy() here. 
> > 
> > Ah yeah.... I back-ported this off the xraid tree, where we have a bit
> > more cleanup after libxfs_destroy() and I think it makes sense to do
> > there but maybe not here...
> > 
> > > IIUC: cli.xi == &xi in this place, so freeing up
> > > memory after destroying the struct using it sounds like a time bomb.
> > 
> > I can plumb this into libxfs_destroy() but as you mentioned, it will
> > need changes in xfs_copy, xfs_db and xfs_repair because they track the
> > argv pointers, but we can just strdup(). Does that seem okay?
> 
> I don't think this is better.  libxfs' init functions do not create or
> assign the libxfs_init.{data,log,rt}.name fields, they merely reuse
> whatever pointer the calling program set.  Only the caller knows where
> that pointed to memory came from (stack, optarg, dynamic allocation) so
> only the caller knows how to drop the pointer.

Yeah, that's mostly why I thought we'd need to re-wire a bunch of stuff
which is probably not important.
> 
> The original patch is more appropriate IMO but seeing as we're about to
> return from main and terminate the process, why do we care?  And if we
> do, shouldn't mkfs also free the other getstr() strings attached to the
> cli struct?  And shouldn't the exit(1) paths do likewise?
> 
> (To be clear, my answers are "I don't", "no", and "no" but I could be
> convinced.)

Leaving them as-is is fine for now, might not be fine in the future, I'd
say if we are leaking them, we should fix it, even if it's falling to
the end of the program.

> 
> --D
> 
