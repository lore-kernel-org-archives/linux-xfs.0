Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E7E1D0403
	for <linux-xfs@vger.kernel.org>; Wed, 23 Oct 2024 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695915; cv=none; b=u5SlDNNYAxuRkkQx264aJhBu53N1edDnEc0+6S2bzJ6jknJ8FH4qIQRHUbS3bAoN/ySM9ax6vdBRLCbzaZwE5lMrmh0//uoZ1w6o0tWtVnUcCfApDiJoL3itzbWFKj4/QZ80we8iNEFCKd55gm9tDh/zC4uUxmFXqWc6dlrqL2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695915; c=relaxed/simple;
	bh=bCvtqtj0d6ztlgjD7BDCJsMe6K/ijXNHqbCZHuW5xOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqhsfsuZNCNh4rWOYvEfwYmUHK2KC55xcRRGMN7AiOKd8sFFQtEIuZ8fdj/U0rIyDm0L8LTKJJcDr8nXEhYYrnGo0bwQHvx5TunUZbNwu3cVO74GLkzbkHJVTGSTRYm+kjhMGXK4WX9k86PQgY1vhNp0hGvhRf0Ns21uS7L9YrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=df6n0GvD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="df6n0GvD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729695912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WMG0mOhsdG1FBtvhTk71proKe9RcBhwkTtjFkRlSLH4=;
	b=df6n0GvDkorQPUQ3bMpn1UTGSyNX8GAK5KBnlLRebWcw3l+cnrzVBlXquCh9PCRX+GrWHN
	j8h0dpAmnB//3J8OsE4CJ+okJXQMgQi12qkwyWrfFw3eUQy6RaEsJk5b2STCEcWY+9cCMx
	9eK97+c6WAz2edbrnqvIShB2pn8dJvQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-QTgEiHDpNAuEa44NCzVf2w-1; Wed,
 23 Oct 2024 11:05:06 -0400
X-MC-Unique: QTgEiHDpNAuEa44NCzVf2w-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC172195608F;
	Wed, 23 Oct 2024 15:05:04 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.135])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EBA4300018D;
	Wed, 23 Oct 2024 15:05:03 +0000 (UTC)
Date: Wed, 23 Oct 2024 11:06:30 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <ZxkQ9luXDGSvxpRq@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
 <Zwkv6G1ZMIdE5vs2@bfoster>
 <20241011171303.GB21853@frogsfrogsfrogs>
 <ZwlxTVpgeVGRfuUb@bfoster>
 <20241011231241.GD21853@frogsfrogsfrogs>
 <Zw1n_bkugSs6oEI6@bfoster>
 <ZxZZT0LpkINDmJOe@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxZZT0LpkINDmJOe@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Oct 22, 2024 at 12:38:23AM +1100, Dave Chinner wrote:
> On Mon, Oct 14, 2024 at 02:50:37PM -0400, Brian Foster wrote:
> > So for a hacky thought/example, suppose we defined a transaction mode
> > that basically implemented an exclusive checkpoint requirement (i.e.
> > this transaction owns an entire checkpoint, nothing else is allowed in
> > the CIL concurrently).
> 
> Transactions know nothing about the CIL, nor should they. The CIL
> also has no place in ordering transactions - it's purely an
> aggregation mechanism that flushes committed transactions to stable
> storage when it is told to. i.e. when a log force is issued.
> 
> A globally serialised transaction requires ordering at the
> transaction allocation/reservation level, not at the CIL. i.e. it is
> essentially the same ordering problem as serialising against
> untracked DIO on the inode before we can run a truncate (lock,
> drain, do operation, unlock).
> 
> > Presumably that would ensure everything before
> > the grow would flush out to disk in one checkpoint, everything
> > concurrent would block on synchronous commit of the grow trans (before
> > new geometry is exposed), and then after that point everything pending
> > would drain into another checkpoint.
> 
> Yup, that's high level transaction level ordering and really has
> nothing to do with the CIL. The CIL is mostly a FIFO aggregator; the
> only ordering it does is to preserve transaction commit ordering
> down to the journal.
> 
> > It kind of sounds like overkill, but really if it could be implemented
> > simply enough then we wouldn't have to think too hard about auditing all
> > other relog scenarios. I'd probably want to see at least some reproducer
> > for this sort of problem to prove the theory though too, even if it
> > required debug instrumentation or something. Hm?
> 
> It's relatively straight forward to do, but it seems like total
> overkill for growfs, as growfs only requires ordering
> between the change of size and new allocations. We can do that by
> not exposing the new space until after then superblock has been
> modifed on stable storage in the case of grow.
> 
> In the case of shrink, globally serialising the growfs
> transaction for shrink won't actually do any thing useful because we
> have to deny access to the free space we are removing before we
> even start the shrink transaction. Hence we need allocation vs
> shrink co-ordination before we shrink the superblock space, not a
> globally serialised size modification transaction...
> 

Not sure what you mean here, at least I don't see that requirement in
the current code. It looks like shrink acquires the blocks all in the
same transaction as the shrink. If something fails, it rolls or returns
the space depending on what actually failed..

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

