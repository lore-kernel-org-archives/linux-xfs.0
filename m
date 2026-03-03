Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E70738644C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564458; cv=none; b=NYRWPqnTETwjodfchMCrsCDRbHPWRdkxQOwI20INg7Q+xC1y22zmU0emt9WOo3F/ZB760TgP+3A51FUEhcT3sOQEugsi+XadKo9XMPuXK9yzoeJEJ19+u97KkciZYKVu1VpJcpQ4bk+o5ZBjG3Xc2AoL8c9J1+XwVm0H7CbepvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564458; c=relaxed/simple;
	bh=it2PhwAJzHrNlHtUMjkccT7SK9XvkAxfTeL33bwhIH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeCie7sRjp0MiMSXXX6EIRtR37UjQxNXd4BE0cyQGmRgw4qWSQQYCQHWRRC11yzUI0oAAhTdkTMPpsfxOTmZclsx9aDyXfyP+MReyO4tHFY32xIeNnkv9O6xP32UkXUXPjPC4D7xRGbw55pEBawErcCtk0zhM4jrhL9UYfWzPWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PcALQVBP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PcALQVBP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772564454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ro+alnpaYPBuJVhNA1DURbitqa28ZNy+hRQTskYZdWI=;
	b=PcALQVBPRragHkr+8VK96CPq2W0vDkIScliuhooMCYM+lT/VSleFBh07zeIMszu9D4ct3l
	bbXarcnIQ9AOT0o0w9tHwZZJf2XTp66/n2WK1XQm1BVd+XwYc1anpYi6/daHksGlnBwdW9
	aLlJLxrtqfPfUmO24FcuZpqPVQTCtm4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-hPzaIKoWPQyhOAS_b-hPUA-1; Tue,
 03 Mar 2026 14:00:51 -0500
X-MC-Unique: hPzaIKoWPQyhOAS_b-hPUA-1
X-Mimecast-MFC-AGG-ID: hPzaIKoWPQyhOAS_b-hPUA_1772564450
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF8851955F1D;
	Tue,  3 Mar 2026 19:00:49 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35C7B1956053;
	Tue,  3 Mar 2026 19:00:49 +0000 (UTC)
Date: Tue, 3 Mar 2026 14:00:47 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] iomap, xfs: lift zero range hole mapping flush
 into xfs
Message-ID: <aacv39AZ5P9ubOZ5@bfoster>
References: <20260129155028.141110-1-bfoster@redhat.com>
 <20260129155028.141110-2-bfoster@redhat.com>
 <aY6_eqkIrMkOr039@infradead.org>
 <aY9hY7TwgMXJNzkI@bfoster>
 <aaXesgEmu46X7OwD@bfoster>
 <aabyFY0l7GTEHnoQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabyFY0l7GTEHnoQ@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Mar 03, 2026 at 06:37:09AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 02:02:10PM -0500, Brian Foster wrote:
> > I got a chance to look into this. Note that I don't reproduce a
> > generic/127 failure (even after running a few iters), so I don't know if
> > that might be related to something on your end. I reproduce the other
> > two and those looked like straight failures to zero. From that I think
> > the issue is just that xfs_zoned_buffered_write_iomap_begin() minimally
> > needs the flush treatment from patch 1. I.e., something like the
> > appended diff allows these tests to pass with -rzoned=1.
> > 
> > Technically this could use the folio batch helper, but given that we
> > don't use that for the unwritten case (and thus already rely on the
> > iomap flush), and that this is currently experimental, I think this is
> > probably fine for now. Perhaps if we lift zeroing off into its own set
> > of callbacks, that might be a good opportunity to clean this up in both
> > places.
> 
> Note that unwritten extents aren't supported for zoned rt inodes, so
> that case doesn't actually exist.
> 

Oh I see. If I follow the high level flow here, zoned mode always writes
through COW fork delalloc, and then writeback appears to remove the
delalloc mapping and then does whatever physical zone allocation magic
further down in the submission path. So there are no unwritten extents
nor COW fork preallocation as far as I can tell.

I think that actually means the IOMAP_ZERO logic for the zoned
iomap_begin handler is slightly wrong as it is. I was originally
thinking this was just another COW fork prealloc situation, but in
actuality it looks like zoned mode intentionally creates this COW fork
blocks over data fork hole scenario on first write to a previously
unallocated file range.

IOMAP_ZERO returns a hole whenever one exists in the data fork, so that
means we're not properly reporting a data mapping up until the range is
allocated in the data fork (i.e. writeback occurs at least once). The
reason this has worked is presumably because iomap does the flush when
the range of a reported hole is dirty, so it retries the mapping lookup
after blocks are remapped and DTRT from there.

So the fix I posted works just the same.. lifting the flush just
preserves how things work today. But I think what this means is that we
should also be able to rework zoned mode IOMAP_ZERO handling to require
neither the flush nor dirty folio lookup. It should be able to return a
mapping to zero if blocks exist in either fork (allocating to COW fork
if necessary), otherwise report a hole.

Hmm.. maybe I'll take a look if we can do something like that from the
start. If it's not straightforward, I'll keep the flush fix for now and
come back to it later..

Brian

> The changes themselves look good.  I kinda hate the very deep
> indentation, but I can't really see a good way to fix that easily.
> 
> 

