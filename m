Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C0A1C727F
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 12:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018357; cv=none; b=JvC1XxTwX8KVhFGqfRHnj7iC9O9pZZ4V/cydaLOEqk1GRswM17js4xZKL8eTrsYd6HmQWp/ACvztB1+9kZJVTghwO5feMclAh5PMRLiSVPjT2c4Jt00oxaqSwht9veKfi1skJ7FQYUFmkQ+izH/WLOtdbrf7spqPqpmfkNPfv5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018357; c=relaxed/simple;
	bh=YC2b8ZZapVHQhvJ95VhC4SYc08SGPSkdCEvRh6pqj1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lADvJ2/82I90mIAnY/p+aa3QKPedMyh/+LV6K04z+tzSlc4SAgHqueP2X/bi/QDOI9dqZaaKCDUzXPGJR/saBWiUchPcOoWY1/j2KWqVJgq1fauUf10eFnT1CPWXZYus0bXc6f7Jl9XqDI5RIbq1USNeLOQA4GmoLTKnRj+z4Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kc0/25x9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kc0/25x9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732018354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hpUA2P+VHS6kDgj8fvrIqHLf9yBH1F/Usc8v/TYorFs=;
	b=Kc0/25x9Hob8dbFERH6AKx9nGcV17CJB7jRcPv1DmCF3wloL3D+0jMEpDBtLHkjEM9Fkeb
	cIUK17YRtU4UgMat/zym8EVUvlinshhrFUi9XSm8A/euCEqvZXc7ra5G+fsHxZv6qQto1S
	aXo1Qay669yDbqt+MxJuhdJh/50G6jk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-xCftqsNuOmGKRhORtRwNDA-1; Tue,
 19 Nov 2024 07:12:31 -0500
X-MC-Unique: xCftqsNuOmGKRhORtRwNDA-1
X-Mimecast-MFC-AGG-ID: xCftqsNuOmGKRhORtRwNDA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3154C1956046;
	Tue, 19 Nov 2024 12:12:29 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B28A1956086;
	Tue, 19 Nov 2024 12:12:26 +0000 (UTC)
Date: Tue, 19 Nov 2024 07:13:59 -0500
From: Brian Foster <bfoster@redhat.com>
To: Long Li <leo.lilong@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>, brauner@kernel.org,
	djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZzyBB3gKU3kBkZdQ@bfoster>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzrlO_jEz9WdBcAF@infradead.org>
 <ZzxNygJUXTXd6H_w@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzxNygJUXTXd6H_w@localhost.localdomain>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, Nov 19, 2024 at 04:35:22PM +0800, Long Li wrote:
> On Sun, Nov 17, 2024 at 10:56:59PM -0800, Christoph Hellwig wrote:
> > On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> > > >  static bool
> > > >  iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> > > >  {
> > > > +	size_t size = iomap_ioend_extent_size(ioend);
> > > > +
> > > 
> > > The function name is kind of misleading IMO because this may not
> > > necessarily reflect "extent size." Maybe something like
> > > _ioend_size_aligned() would be more accurate..?
> > 
> > Agreed.  What also would be useful is a comment describing the
> > function and why io_size is not aligned.
> > 
> 
> Ok, it will be changed in the next version.
> 
> > > 1. It kind of feels like a landmine in an area where block alignment is
> > > typically expected. I wonder if a rename to something like io_bytes
> > > would help at all with that.
> > 
> > Fine with me.
> > 
> 
> While continuing to use io_size may introduce some ambiguity, this can
> be adequately addressed through proper documentation. Furthermore,
> retaining io_size would minimize code changes. I would like to
> confirm whether renaming io_size to io_bytes is truly necessary in
> this context.
> 

I don't think a rename is a requirement. It was just an idea to
consider.

The whole rounding thing is the one lingering thing for me. In my mind
it's not worth the complexity of having a special wrapper like this if
we don't have at least one example where it provides tangible
performance benefit. It kind of sounds like we're fishing around for
examples where it would allow an ioend to merge, but so far don't have
anything that reproduces perf. value. Do you agree with that assessment?

That said, I agree we have a couple examples where it is technically
functional, it does preserve existing logic, and it's not the biggest
deal in general. So if we really want to keep it, perhaps a reasonable
compromise might be to lift it as a static into buffered-io.c (so it's
not exposed to new users via the header, at least for now) and add a
nice comment above it to explain when/why the io_size is inferred via
rounding and that it's specifically for ioend grow/merge management. Hm?

Brian

> Thanks,
> Long Li
>  
> 

