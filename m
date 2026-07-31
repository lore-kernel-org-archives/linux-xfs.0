Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADE8479882
	for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2026 18:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523238; cv=none; b=k3pU4aYFFaAnNlJswb+1YWaOT2hb/aTnIzSekuBRjy2OlNxGKcW4aV3q/AZaNpr3lAx303ZGeM0HMlRZWvNaFn9kIcNqHH1SBS1Oy30/EoNOAeCGIQ6SSyz3VrvFIvyNfrASvZHMRcMBgbh0swD4kWe67iFWN5AXx77Z7bsbAm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523238; c=relaxed/simple;
	bh=royan5AAOKo7x0XXGAURBY1ITuV3M4+dGtM1T4RrupE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfNSHxxwGucLPHm9dZouyZKKhwqHd0LdlPJh39hqHHLG32Z9w4P9rkzYxwjygUduKy4bzQiv7aamBQZQeT5bXt7E1Jg60l8PQvc1B5mSUGuIa+ILG97tC1B7J3Vo2qta16Byo5ghvTr4SIwVwl8YqxlcBkKqHIXOSf6G4kD8Wjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eroT8C5Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eroT8C5Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785523233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+B+5E+4mtNyNMX2Wkqslkn4eCgYc20LREj/9ZP4DGBc=;
	b=eroT8C5YUrBd68mgnAwV6WooSnc20BU/OBI1n/NB7TyaYik5uu5aDh9ph5HfA2GcI3LSVq
	Re2LrevtGvhHC/xs8iBb0NpCfqTfYLHpXVppH27FwXCjJuTYh1/DcXMfzF4I/HfgIawlWU
	i1opRxyxBfQ2frOTKbE+FI7nONIMX/k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-wZktdE6RP7WwT5YGIQKMmQ-1; Fri,
 31 Jul 2026 14:40:32 -0400
X-MC-Unique: wZktdE6RP7WwT5YGIQKMmQ-1
X-Mimecast-MFC-AGG-ID: wZktdE6RP7WwT5YGIQKMmQ_1785523231
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34EFC180048E;
	Fri, 31 Jul 2026 18:40:31 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.193])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D4C21956089;
	Fri, 31 Jul 2026 18:40:30 +0000 (UTC)
Date: Fri, 31 Jul 2026 14:40:28 -0400
From: Brian Foster <bfoster@redhat.com>
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [External] : [PATCH 1/2] xfs: set minleft correctly for sparse
 chunk errortag allocation
Message-ID: <amzsHKUyUyfkFZw_@bfoster>
References: <20260731163337.152522-1-bfoster@redhat.com>
 <20260731163337.152522-2-bfoster@redhat.com>
 <920b94f6-9d07-488f-9a11-7e00f7f6612a@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <920b94f6-9d07-488f-9a11-7e00f7f6612a@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, Jul 31, 2026 at 01:02:50PM -0500, Mark Tinguely wrote:
> On 7/31/26 11:33 AM, Brian Foster wrote:
> > The errortag instrumentation for forced sparse chunk allocation
> > jumps straight to the allocation path without setting args.minleft.
> > minleft is unconditionally set to ->inobt_maxlevels for the normal
> > allocation path. Lift the assignment to the initial args setup so
> > it covers all possible paths.
> > 
> > Assisted-by: LLM
> > Fixes: 1cdadee11f8d ("xfs: randomly do sparse inode allocations in DEBUG mode")
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >   fs/xfs/libxfs/xfs_ialloc.c | 10 ++++------
> >   1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index ffcdd1f691fd..633b2d6e42c5 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -733,6 +733,10 @@ xfs_ialloc_ag_alloc(
> >   							igeo->maxicount)
> >   		return -ENOSPC;
> >   	args.minlen = args.maxlen = igeo->ialloc_blks;
> > +
> > +	/* Allow space for the inode btree to split. */
> > +	args.minleft = igeo->inobt_maxlevels;
> > +
> >   	/*
> >   	 * First try to allocate inodes contiguous with the last-allocated
> >   	 * chunk of inodes.  If the filesystem is striped, this will fill
> > @@ -764,8 +768,6 @@ xfs_ialloc_ag_alloc(
> >   		args.alignment = 1;
> >   		args.minalignslop = igeo->cluster_align - 1;
> > -		/* Allow space for the inode btree to split. */
> > -		args.minleft = igeo->inobt_maxlevels;
> >   		error = xfs_alloc_vextent_exact_bno(&args,
> >   				xfs_agbno_to_fsb(pag, args.agbno));
> >   		if (error)
> > @@ -804,10 +806,6 @@ xfs_ialloc_ag_alloc(
> >   		 * Allocate a fixed-size extent of inodes.
> >   		 */
> >   		args.prod = 1;
> > -		/*
> > -		 * Allow space for the inode btree to split.
> > -		 */
> > -		args.minleft = igeo->inobt_maxlevels;
> >   		error = xfs_alloc_vextent_near_bno(&args,
> >   				xfs_agbno_to_fsb(pag,
> >   					be32_to_cpu(agi->agi_root)));
> 
> 
> Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
> 

Thanks..

> I got the patches backwards...I agree we need to increase the minleft in
> the other patch by 4 blocks (2 btrees * 2 for the level increase) but I
> wonder why can't a full size inode chunk also split the by-count and
> by-block btrees and the inode btree allocation also be short when fixing AGFL?
> 

Yeah, I had the same general question in the original report. I'm not
sure it can't happen for full size chunks. I was kind of taking it for
granted that sparse inodes seem required to reproduce this just by
virtue of smaller allocations and the allocator maybe having enough slop
in the various calculations to gate it otherwise, but I'm not confident
in that having now looked more through this code.

Perhaps Matt can comment on if or how hard we tried to reproduce this
with full inode chunks..? I'm curious.. was the creation of the
reproducer based on a detected flaw in the code (LLM scan or
something?), or a low space stress test or something were this problem
just happened to fall out..?

If we could reproduce or manufacture this with normal inode chunks, then
I suppose that would lend more credence to a more generic solution
within the allocator.

Brian

