Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6941C5796
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 18:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728672010; cv=none; b=j5iDDCG0uSXV2RgNYoSchctLIwRRH+xAjmJWE4zVXVRtVeQ/PDZH2ZgBe0kFCdtd3S2Pql3dFwz36xvBZBVg7dSMCsJ/nenJffrCR/HweqNKpjRIsusLISzIibjiez0vXwBv6qzZBK04fwhbjRqBUYd35IriBeAAPJUKm8cpuRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728672010; c=relaxed/simple;
	bh=hPL0g9VVNlsvXc8pBda0BpGRJ4i65pxz37rs7xYeXds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oO1krtODCGxgCyKAf8nsUOEHY0ACh1b/JdctiQsAcvV9QnbPhInZRCuj+7kUTqAhLVmLMrf6mBz31y/hFBpwn8/45Gzj3LgomRAsSPq211LnDrBLuGz7DU91zYcOmnaDVM2U2GajGjxMd/NrbUv7UL77ohRP8QE7xeHKvDwxIO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C7qmAEk4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C7qmAEk4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728672007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bs1fgd5s6cY7QOMV++b5vwomwqhbDPiljQXLkyE0/RM=;
	b=C7qmAEk4eoR7jLfaxtt7p9jO9OEwmT0sUr03zidASnS1KZ6Vg9BXumG5SkLv5ctJ9JDMBI
	mjUuFMeBjyHPWjjuIyBg8M/J7BzV3DKgl6Pm5eSQooDzU/SahsJzxZwAcOIkoS5JQvkUaG
	kDsdHvK+IsWhlkwDvftpkkLPSo4yiSw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-UqqommKeP6Gfl3MJSIWY5g-1; Fri,
 11 Oct 2024 14:40:04 -0400
X-MC-Unique: UqqommKeP6Gfl3MJSIWY5g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E6271956069;
	Fri, 11 Oct 2024 18:40:03 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DA0719560AE;
	Fri, 11 Oct 2024 18:40:01 +0000 (UTC)
Date: Fri, 11 Oct 2024 14:41:17 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <ZwlxTVpgeVGRfuUb@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
 <Zwkv6G1ZMIdE5vs2@bfoster>
 <20241011171303.GB21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011171303.GB21853@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Oct 11, 2024 at 10:13:03AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 11, 2024 at 10:02:16AM -0400, Brian Foster wrote:
> > On Fri, Oct 11, 2024 at 09:57:09AM +0200, Christoph Hellwig wrote:
> > > On Thu, Oct 10, 2024 at 10:05:53AM -0400, Brian Foster wrote:
> > > > Ok, so we don't want geometry changes transactions in the same CIL
> > > > checkpoint as alloc related transactions that might depend on the
> > > > geometry changes. That seems reasonable and on a first pass I have an
> > > > idea of what this is doing, but the description is kind of vague.
> > > > Obviously this fixes an issue on the recovery side (since I've tested
> > > > it), but it's not quite clear to me from the description and/or logic
> > > > changes how that issue manifests.
> > > > 
> > > > Could you elaborate please? For example, is this some kind of race
> > > > situation between an allocation request and a growfs transaction, where
> > > > the former perhaps sees a newly added AG between the time the growfs
> > > > transaction commits (applying the sb deltas) and it actually commits to
> > > > the log due to being a sync transaction, thus allowing an alloc on a new
> > > > AG into the same checkpoint that adds the AG?
> > > 
> > > This is based on the feedback by Dave on the previous version:
> > > 
> > > https://lore.kernel.org/linux-xfs/Zut51Ftv%2F46Oj386@dread.disaster.area/
> > > 
> > 
> > Ah, Ok. That all seems reasonably sane to me on a first pass, but I'm
> > not sure I'd go straight to this change given the situation...
> > 
> > > Just doing the perag/in-core sb updates earlier fixes all the issues
> > > with my test case, so I'm not actually sure how to get more updates
> > > into the check checkpoint.  I'll try your exercisers if it could hit
> > > that.
> > > 
> > 
> > Ok, that explains things a bit. My observation is that the first 5
> > patches or so address the mount failure problem, but from there I'm not
> > reproducing much difference with or without the final patch.
> 
> Does this change to flush the log after committing the new sb fix the
> recovery problems on older kernels?  I /think/ that's the point of this
> patch.
> 

I don't follow.. growfs always forced the log via the sync transaction,
right? Or do you mean something else by "change to flush the log?"

I thought the main functional change of this patch was to hold the
superblock buffer locked across the force so nothing else can relog the
new geometry superblock buffer in the same cil checkpoint. Presumably,
the theory is that prevents recovery from seeing updates to different
buffers that depend on the geometry update before the actual sb geometry
update is recovered (because the latter might have been relogged).

Maybe we're saying the same thing..? Or maybe I just misunderstand.
Either way I think patch could use a more detailed commit log...

> >                                                              Either way,
> > I see aborts and splats all over the place, which implies at minimum
> > this isn't the only issue here.
> 
> Ugh.  I've recently noticed the long soak logrecovery test vm have seen
> a slight tick up in failure rates -- random blocks that have clearly had
> garbage written to them such that recovery tries to read the block to
> recover a buffer log item and kaboom.  At this point it's unclear if
> that's a problem with xfs or somewhere else. :(
> 
> > So given that 1. growfs recovery seems pretty much broken, 2. this
> > particular patch has no straightforward way to test that it fixes
> > something and at the same time doesn't break anything else, and 3. we do
> 
> I'm curious, what might break?  Was that merely a general comment, or do
> you have something specific in mind?  (iows: do you see more string to
> pull? :))
> 

Just a general comment..

Something related that isn't totally clear to me is what about the
inverse shrink situation where dblocks is reduced. I.e., is there some
similar scenario where for example instead of the sb buffer being
relogged past some other buffer update that depends on it, some other
change is relogged past a sb update that invalidates/removes blocks
referenced by the relogged buffer..? If so, does that imply a shrink
should flush the log before the shrink transaction commits to ensure it
lands in a new checkpoint (as opposed to ensuring followon updates land
in a new checkpoint)..?

Anyways, my point is just that if it were me I wouldn't get too deep
into this until some of the reproducible growfs recovery issues are at
least characterized and testing is more sorted out.

The context for testing is here [1]. The TLDR is basically that
Christoph has a targeted test that reproduces the initial mount failure
and I hacked up a more general test that also reproduces it and
additional growfs recovery problems. This test does seem to confirm that
the previous patches address the mount failure issue, but this patch
doesn't seem to prevent any of the other problems produced by the
generic test. That might just mean the test doesn't reproduce what this
fixes, but it's kind of hard to at least regression test something like
this when basic growfs crash-recovery seems pretty much broken.

Brian

[1] https://lore.kernel.org/fstests/ZwVdtXUSwEXRpcuQ@bfoster/

> > have at least one fairly straightforward growfs/recovery test in the
> > works that reliably explodes, personally I'd suggest to split this work
> > off into separate series.
> > 
> > It seems reasonable enough to me to get patches 1-5 in asap once they're
> > fully cleaned up, and then leave the next two as part of a followon
> > series pending further investigation into these other issues. As part of
> > that I'd like to know whether the recovery test reproduces (or can be
> > made to reproduce) the issue this patch presumably fixes, but I'd also
> > settle for "the grow recovery test now passes reliably and this doesn't
> > regress it." But once again, just my .02.
> 
> Yeah, it's too bad there's no good way to test recovery with older
> kernels either. :(
> 
> --D
> 
> > Brian
> > 
> > 
> 

