Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96021A00DF
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 17:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728666784; cv=none; b=p39lR8l3Ud96Bzr6OM3pOxY3BDU7WwHz8fu7G3YTCOQ2TuYzMTibqmwn/lhKszWvVShz3tnmkwmBkymkJv4wH/RlODUaS1m5i0i64NZ7YxLRcxNR5F0MZmxQmESLxaRkvx4euadjTCBGFYcQHognPoXTvHTFOdajURh/RfxxHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728666784; c=relaxed/simple;
	bh=84UJpo00BunE/Rhb5VjBM2R82vWUvAlukcp0iBu/3KM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E43hbMQVzQxVo+RYXbSkz4OyzTOAQo8kfwVpEA7OrC2CV7wbVX1rzqsRt+tN93NxWJ9KOWzDanNTgBLRhzVPdPEnQlBZSYhXKdooYgtlH6vJ/HZ6Bod/3NydBSVK/f2WDuwEDEjNfGgvjKi96Wl7xYxravvsAoLF816hFmsg368=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1xhxfR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1xhxfR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F81C4CEC3;
	Fri, 11 Oct 2024 17:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728666784;
	bh=84UJpo00BunE/Rhb5VjBM2R82vWUvAlukcp0iBu/3KM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d1xhxfR7Lpw1cNC6ROYBxxLIzOoBHwgyo+aI/hLCmDtRqZGVtsBG1j0xEy7ZFiL1D
	 +kXlN1GXW3U6fLE965nK0F9FMamYKsd3DV9iirtlM8eUsByveGbYkqVK53JJNENyaT
	 qiNYq8OEOP4dt51mDucan1ZpsVGsDVrvY25qbaoIaWUvIU+NYns1Q5bymvx5Y+02Ef
	 VR/2A9t5gL9dcwY3E2L12FnZ/OXbWD3YY2XmM2SzQY85cbY/k4Ztaco9O5wfmozTbt
	 174l66AAq1xpbgN4/+DQVwoE0ZL3JImdzV9QQuZJzBHKVrILkmLc2ArAG0jRrpt+DO
	 lj1ZvaTZqEPYw==
Date: Fri, 11 Oct 2024 10:13:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241011171303.GB21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
 <Zwkv6G1ZMIdE5vs2@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zwkv6G1ZMIdE5vs2@bfoster>

On Fri, Oct 11, 2024 at 10:02:16AM -0400, Brian Foster wrote:
> On Fri, Oct 11, 2024 at 09:57:09AM +0200, Christoph Hellwig wrote:
> > On Thu, Oct 10, 2024 at 10:05:53AM -0400, Brian Foster wrote:
> > > Ok, so we don't want geometry changes transactions in the same CIL
> > > checkpoint as alloc related transactions that might depend on the
> > > geometry changes. That seems reasonable and on a first pass I have an
> > > idea of what this is doing, but the description is kind of vague.
> > > Obviously this fixes an issue on the recovery side (since I've tested
> > > it), but it's not quite clear to me from the description and/or logic
> > > changes how that issue manifests.
> > > 
> > > Could you elaborate please? For example, is this some kind of race
> > > situation between an allocation request and a growfs transaction, where
> > > the former perhaps sees a newly added AG between the time the growfs
> > > transaction commits (applying the sb deltas) and it actually commits to
> > > the log due to being a sync transaction, thus allowing an alloc on a new
> > > AG into the same checkpoint that adds the AG?
> > 
> > This is based on the feedback by Dave on the previous version:
> > 
> > https://lore.kernel.org/linux-xfs/Zut51Ftv%2F46Oj386@dread.disaster.area/
> > 
> 
> Ah, Ok. That all seems reasonably sane to me on a first pass, but I'm
> not sure I'd go straight to this change given the situation...
> 
> > Just doing the perag/in-core sb updates earlier fixes all the issues
> > with my test case, so I'm not actually sure how to get more updates
> > into the check checkpoint.  I'll try your exercisers if it could hit
> > that.
> > 
> 
> Ok, that explains things a bit. My observation is that the first 5
> patches or so address the mount failure problem, but from there I'm not
> reproducing much difference with or without the final patch.

Does this change to flush the log after committing the new sb fix the
recovery problems on older kernels?  I /think/ that's the point of this
patch.

>                                                              Either way,
> I see aborts and splats all over the place, which implies at minimum
> this isn't the only issue here.

Ugh.  I've recently noticed the long soak logrecovery test vm have seen
a slight tick up in failure rates -- random blocks that have clearly had
garbage written to them such that recovery tries to read the block to
recover a buffer log item and kaboom.  At this point it's unclear if
that's a problem with xfs or somewhere else. :(

> So given that 1. growfs recovery seems pretty much broken, 2. this
> particular patch has no straightforward way to test that it fixes
> something and at the same time doesn't break anything else, and 3. we do

I'm curious, what might break?  Was that merely a general comment, or do
you have something specific in mind?  (iows: do you see more string to
pull? :))

> have at least one fairly straightforward growfs/recovery test in the
> works that reliably explodes, personally I'd suggest to split this work
> off into separate series.
> 
> It seems reasonable enough to me to get patches 1-5 in asap once they're
> fully cleaned up, and then leave the next two as part of a followon
> series pending further investigation into these other issues. As part of
> that I'd like to know whether the recovery test reproduces (or can be
> made to reproduce) the issue this patch presumably fixes, but I'd also
> settle for "the grow recovery test now passes reliably and this doesn't
> regress it." But once again, just my .02.

Yeah, it's too bad there's no good way to test recovery with older
kernels either. :(

--D

> Brian
> 
> 
