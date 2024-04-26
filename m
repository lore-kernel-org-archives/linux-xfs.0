Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708071E52A
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714135444; cv=none; b=tEDGCvmo1UxYcEJiXC4ZSkY0QTARkcFcFFuxvyUfvPwb0UHn8kvz6+c4owVDO8vkSV5kLi1OkhgnLyCERcEHFvGF+6BVvZURXIvr3UdPIORMThfJ+r4+Z/Dbi0OMd+O71wZ9uZ61ZwHrCRMXAYw81dUg5h2xlQ/dWGkG078nYpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714135444; c=relaxed/simple;
	bh=4osWF3z7TVSnKXwxzghbXZwzHfp+R/4Uz9B9jm/RxLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZXaVcfPXd1gvPC4GuJvY3Zg5JBmRMvOqPUFIefYb7tBXE0FIfRwrcgGRKtJ4y2+suSrUqsH4UVZAHt43WimDsZqbrB/yzdSvSASSJZzi4xTtictXI48WZJbneafWDc/qvYIDQ1P3zXeKLO5o1mtFvt+FxHtEJrEQLPYt/XEgldo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UbxOw73/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UbxOw73/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714135442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OCVM+mcR/zAidOTS4y72huxA4HPGOw6uU5hpLDITtQk=;
	b=UbxOw73/sPQsNstUs0rjLFprguPFtNxIC/RMHElArnkl/60WpUt2pGtPtU6qPFunOR+aZE
	PdRXwev2c9yXo8ftSrrwWFXInex6FGweDRHW7VGRIgMhJwbk9wf7cXgxLQjIghN1niI/vY
	o512K4r8/2NTTEW2qejWVegN3alBO38=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-O05rPKkQP2uQT5wmnySeHA-1; Fri, 26 Apr 2024 08:43:59 -0400
X-MC-Unique: O05rPKkQP2uQT5wmnySeHA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7791A802352;
	Fri, 26 Apr 2024 12:43:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11904AC6A;
	Fri, 26 Apr 2024 12:43:58 +0000 (UTC)
Date: Fri, 26 Apr 2024 08:46:13 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sam Sun <samsun1006219@gmail.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, djwong@kernel.org,
	chandan.babu@oracle.com, syzkaller-bugs@googlegroups.com,
	xrivendell7@gmail.com
Subject: Re: [Linux kernel bug] KASAN: slab-out-of-bounds Read in xlog_cksum
Message-ID: <ZiuiFfWEOCiO9wVA@bfoster>
References: <CAEkJfYO++C-pxyqzfoXFKEvmMQEnrgkQ2QcG6radAWJMqdXQCQ@mail.gmail.com>
 <ZipWt03PhXs2Yc84@infradead.org>
 <ZiphYrREkQvxkE-U@bfoster>
 <ZitF8eqWEYECruXo@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZitF8eqWEYECruXo@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Thu, Apr 25, 2024 at 11:13:05PM -0700, Christoph Hellwig wrote:
> On Thu, Apr 25, 2024 at 09:57:54AM -0400, Brian Foster wrote:
> > On Thu, Apr 25, 2024 at 06:12:23AM -0700, Christoph Hellwig wrote:
> > > This triggers the workaround for really old xfsprogs putting in a
> > > bogus h_size:
> > > 
> > > [   12.101992] XFS (loop0): invalid iclog size (0 bytes), using lsunit (65536 bytes)
> > > 
> > > but then calculates the log recovery buffer size based on the actual
> > > on-disk h_size value.  The patch below open codes xlog_logrec_hblks and
> > > fixes this particular reproducer.  But I wonder if we should limit the
> > > workaround.  Brian, you don't happpen to remember how old xfsprogs had
> > > to be to require your workaround (commit a70f9fe52daa8)?
> > > 
> > 
> > No, but a little digging turns up xfsprogs commit 20fbd4593ff2 ("libxfs:
> > format the log with valid log record headers"), which I think is what
> > you're looking for..? That went in around v4.5 or so, so I suppose
> > anything earlier than that is affected.
> 
> Thanks.  I was kinda hoping we could exclude v5 file systems from that
> workaround, but it is needed way too recent for that.
> 
> Maybe we can specificly check for the wrongly hardcoded
> XLOG_HEADER_CYCLE_SIZE instead of allowing any value?
> 

That seems like a reasonable option to me if you wanted to make it a bit
more limited to its purpose. You might just want to double check that
the size used in libxfs hadn't changed at any point previously, because
that 1. apparently wouldn't have been an issue up until the record
verification stuff and 2. the existing size-agnostic check in the kernel
would have still handled it (prior to being broken).

It might also be worth a separately named macro or something in the
kernel just for extra indication that this particular check is unique
and warrants extra thought on future changes. Not so much that I'd
expect the original macro value to change, but just that I suspect
something like that might have helped flag this logic as semi-special
and maybe helped avoid breaking it in commit 0c771b99d6c9. In hindsight,
maybe it would have been a little better even to just put that logic
into its own special fixup function or something. Anyways, just some
random thoughts..

Brian

