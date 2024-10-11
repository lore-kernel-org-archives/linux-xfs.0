Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FEFCA6F
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 14:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728655269; cv=none; b=C3Y9VbKX9UqEbQjDn8SanqGpvjkL1MFkk+tNi3CLTk1pwFuzJt848h4N2X3auG3L0xULTWdRK/9em5yd3va1Xjn7vRPYYCyeVtEXce5aKchKoWc+OCr+PSxdKd8NChhgNuWNg2GOIYDOXB4CfOwuJ9ywdLlnSNlwEuZHIhGTQMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728655269; c=relaxed/simple;
	bh=9NoESXTgkx1LYGsXF0owQRvC9Kc7QlnMuTVkM930VFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WJZ61YvsyRMQuNChEU3aIVsHlrju3q58SWKFm3dv+TNqQJezEIQvdTKX5xiXO62DY5a4dgBcMb5AB6GvGXw8gfcdbp/B16wU4Ay417w7K4BsD3JN/sv8vWguxq2lyAWHFngf+6qWXlGMq3lcaTcXDNb9XaSH7Ykhp4DzEgo1DBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HLGIX+M7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HLGIX+M7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728655267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ypo8hdXVSCGjr6JdndLcPeZkSsoHdrR20MXlGs9DihM=;
	b=HLGIX+M7IcprLCm+mc/YunhyO7kFSRtFpxWic+e+CZrfIujN8+A8HagN96ACFM8v1zkPJl
	RVN9TTr1zXNn6Z8Z3Wn3q0aAtQR3UHJRmRMNYVr1qLvRsgcBdxGxChpnZ7kO+fNuCwUyUS
	Lkzp0P51gZoBIXWaLW0X9jT3A9pg7Ek=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-85-Rnjk_S1IOMeVHLJXT3j2mA-1; Fri,
 11 Oct 2024 10:01:03 -0400
X-MC-Unique: Rnjk_S1IOMeVHLJXT3j2mA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B12619560A2;
	Fri, 11 Oct 2024 14:01:02 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6565119560A2;
	Fri, 11 Oct 2024 14:01:01 +0000 (UTC)
Date: Fri, 11 Oct 2024 10:02:16 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <Zwkv6G1ZMIdE5vs2@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011075709.GC2749@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Oct 11, 2024 at 09:57:09AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 10:05:53AM -0400, Brian Foster wrote:
> > Ok, so we don't want geometry changes transactions in the same CIL
> > checkpoint as alloc related transactions that might depend on the
> > geometry changes. That seems reasonable and on a first pass I have an
> > idea of what this is doing, but the description is kind of vague.
> > Obviously this fixes an issue on the recovery side (since I've tested
> > it), but it's not quite clear to me from the description and/or logic
> > changes how that issue manifests.
> > 
> > Could you elaborate please? For example, is this some kind of race
> > situation between an allocation request and a growfs transaction, where
> > the former perhaps sees a newly added AG between the time the growfs
> > transaction commits (applying the sb deltas) and it actually commits to
> > the log due to being a sync transaction, thus allowing an alloc on a new
> > AG into the same checkpoint that adds the AG?
> 
> This is based on the feedback by Dave on the previous version:
> 
> https://lore.kernel.org/linux-xfs/Zut51Ftv%2F46Oj386@dread.disaster.area/
> 

Ah, Ok. That all seems reasonably sane to me on a first pass, but I'm
not sure I'd go straight to this change given the situation...

> Just doing the perag/in-core sb updates earlier fixes all the issues
> with my test case, so I'm not actually sure how to get more updates
> into the check checkpoint.  I'll try your exercisers if it could hit
> that.
> 

Ok, that explains things a bit. My observation is that the first 5
patches or so address the mount failure problem, but from there I'm not
reproducing much difference with or without the final patch. Either way,
I see aborts and splats all over the place, which implies at minimum
this isn't the only issue here.

So given that 1. growfs recovery seems pretty much broken, 2. this
particular patch has no straightforward way to test that it fixes
something and at the same time doesn't break anything else, and 3. we do
have at least one fairly straightforward growfs/recovery test in the
works that reliably explodes, personally I'd suggest to split this work
off into separate series.

It seems reasonable enough to me to get patches 1-5 in asap once they're
fully cleaned up, and then leave the next two as part of a followon
series pending further investigation into these other issues. As part of
that I'd like to know whether the recovery test reproduces (or can be
made to reproduce) the issue this patch presumably fixes, but I'd also
settle for "the grow recovery test now passes reliably and this doesn't
regress it." But once again, just my .02.

Brian

