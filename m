Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC8DAD27
	for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732110563; cv=none; b=jS+DqAS1hCMLiXNrccp/V9jvoevvYA//CTsJrSo3wht+3WdTo+Bfnqr/kHRT2Ag1vq6UkDDICMscaWA9JvF/eF7lAEmLSZk7a/KiCze+vO9C3GkHvKZ5u/m5hFufwhj+TpRJPbB7M1K8m2Wz/CmAVMT1S5EXrI1SyGuxR+9yFzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732110563; c=relaxed/simple;
	bh=150lWrXa0KqLl0ZxIZp486s9CPXziqdVX+kOGzEyZos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7FjQ3TWCXQ3k20Ou0Hw6tusZeYYkuSLQaEceqmF9hQ1wy+it46nTEGWuS7mvtUKMAZLVHLRxteVzmrWUORwkoYJj8NKlUjXf31/N1uv0EXH7EIqTnDvJXd4E05kEP47xatNBxGrUnk/Hpn9Lou+FimjVgKNfNB/COJ8IZDUJw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I9/dpymx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I9/dpymx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732110561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HeywcOPpzlIds6I9Jm5ZpsIZ1EuzpLn2TbWYrz1tVa8=;
	b=I9/dpymxEmqsfgfLhsvMGCk+wF+4ckipo73B1zUOWzkgvCIBHFXUVfcmJPkgr5F96nwg6X
	maiVyhEGwzjo4evwef1tUYvXln7qmJ/YC/HuxnkEJLlpiLEAWrdGi4JBmdPCMPkHuLTh0B
	7J+zB/3hd16LsLcq/0NDW3ZvWkD1eZY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-2dWAFB0ANx6weFbIhwS-zQ-1; Wed,
 20 Nov 2024 08:49:17 -0500
X-MC-Unique: 2dWAFB0ANx6weFbIhwS-zQ-1
X-Mimecast-MFC-AGG-ID: 2dWAFB0ANx6weFbIhwS-zQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B521D1954B1E;
	Wed, 20 Nov 2024 13:49:15 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.120])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36D5D1956054;
	Wed, 20 Nov 2024 13:49:12 +0000 (UTC)
Date: Wed, 20 Nov 2024 08:50:45 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <leo.lilong@huawei.com>, brauner@kernel.org, djwong@kernel.org,
	cem@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 1/2] iomap: fix zero padding data issue in concurrent
 append writes
Message-ID: <Zz3pNTDwYImhuAkV@bfoster>
References: <20241113091907.56937-1-leo.lilong@huawei.com>
 <ZzTQPdE5V155Soui@bfoster>
 <ZzrlO_jEz9WdBcAF@infradead.org>
 <ZztOpQwU0pRagGwU@bfoster>
 <Zz2mTCq03SEjoUZV@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz2mTCq03SEjoUZV@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Nov 20, 2024 at 01:05:16AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 18, 2024 at 09:26:45AM -0500, Brian Foster wrote:
> > IOW following the train of thought in the other subthread, would any
> > practical workload be affected if we just trimmed io_size when needed by
> > i_size and left it at that?
> 
> Can you explain what you mean with that? 
> 

I mean what happens if we trimmed io_size just as this patch already
does, but left off the rounding stuff?

The rounding is only used for adding to or attempting to merge ioends. I
don't see when it would ever really make a difference in adding folios
to an ioend, since we don't writeback folios beyond i_size and a size
extending operation is unlikely to write back between the time an ioend
is being constructed/trimmed and submitted.

After discussion, it seems there are some scenarios where the rounding
allows i_size trimmed ioends to merge, but again I'm not seeing how that
can occur frequently enough such that just skipping the rounding and
letting trimmed ioends fail to merge would have any noticeable
performance impact.

But anyways, I think we've reached compromise that pulling the rounding
helper into buffered-io.c and documenting it well preserves logic and
addresses my concerns by making sure it doesn't proliferate for the time
being.

Brian

