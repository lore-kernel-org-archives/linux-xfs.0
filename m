Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07484198826
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731939925; cv=none; b=n27KeXdZDCEp+wXc9RUc1H6tWwOQH6RLc2ZHDfNRgozuyT/4JXHp+spFeug6yKTKAo1Gie6AEq5/gDSlZ2XpIkiSmpL3p6UMERTxa5pUcpriTfKpnTisI5ZzjB2Xs9U1Im8JfS0SDLF1+t7/rpeVu74EanK5rgP4iQG7Wo20XOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731939925; c=relaxed/simple;
	bh=rK8e6sXcUsw1vwDFUgW/qKxINh2h7ikC6f/mP40V3/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIJuDFIFR1cYrEjWuUZnuS42NnoW06bAgACbmL4oJrk61aOx59V+U8gYor+HhFlL8lbamVvipDxdsMdEBuiDDzui1o2trePCL+nATXXfNeoh+QHgfQBFJvd2/0n+wYfl7hAXUCGr/yNtV5Cu7Dq1Mp0OHP5Z/TxZvU0rOudrfI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b8K3fcJC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8K3fcJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731939922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CgNjJCJ5RT1s/na/lzwDS0pYd3eEJJUrBHaovel6b+0=;
	b=b8K3fcJCKipXXiItaf8FzEc7n+9h5cf3Vj4XcNIXRPKP8z114/alxEa+gCyghBQOfWZC6o
	sL7YwQXOu+w5YokmF3I+g8Sp7PmFUs8DguSxUt4gdMt6Osb9Gm8A3YzDeuafRs9YJX432G
	+AO92drNksssIj284YLAH93eoGLlevI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-206-Byys57ivO7SXxlVK0AeZ6Q-1; Mon,
 18 Nov 2024 09:25:17 -0500
X-MC-Unique: Byys57ivO7SXxlVK0AeZ6Q-1
X-Mimecast-MFC-AGG-ID: Byys57ivO7SXxlVK0AeZ6Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 69DF31955F2C;
	Mon, 18 Nov 2024 14:25:15 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25BBE300019E;
	Mon, 18 Nov 2024 14:25:12 +0000 (UTC)
Date: Mon, 18 Nov 2024 09:26:45 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <ZztOpQwU0pRagGwU@bfoster>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzrlO_jEz9WdBcAF@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZzrlO_jEz9WdBcAF@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Sun, Nov 17, 2024 at 10:56:59PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 13, 2024 at 11:13:49AM -0500, Brian Foster wrote:
> > >  static bool
> > >  iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
> > >  {
> > > +	size_t size = iomap_ioend_extent_size(ioend);
> > > +
> > 
> > The function name is kind of misleading IMO because this may not
> > necessarily reflect "extent size." Maybe something like
> > _ioend_size_aligned() would be more accurate..?
> 
> Agreed.  What also would be useful is a comment describing the
> function and why io_size is not aligned.
> 

Ack.

> > 1. It kind of feels like a landmine in an area where block alignment is
> > typically expected. I wonder if a rename to something like io_bytes
> > would help at all with that.
> 
> Fine with me.
> 
> > Another randomish idea might be to define a flag like
> > IOMAP_F_EOF_TRIMMED for ioends that are trimmed to EOF. Then perhaps we
> > could make an explicit decision not to grow or merge such ioends, and
> > let the associated code use io_size as is.
> 
> I don't think such a branch is any cheaper than the rounding..
> 

True, but I figured it to be more informational/usable than performance
oriented.

IOW following the train of thought in the other subthread, would any
practical workload be affected if we just trimmed io_size when needed by
i_size and left it at that?

If not, then you could use a flag to be more deliberate/informative that
the ioend was slightly special in that it was modified on submission,
and then adjacent ioends would simply fail to merge on a flag comparison
rather than fail to merge on a contiguity check.

Of course if folks would rather just do the rounding helper thing and
leave it up to the fs to use it, then I don't see any fundamental
problem with that. I just find it kind of a subtle/quirky interface.

Brian

