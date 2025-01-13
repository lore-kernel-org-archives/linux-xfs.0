Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A39649659
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736778635; cv=none; b=D0JQKWdoGlZMEtXOWGAiXVR5uKx5KvCGVlB7d57WmoQbYKYNQEucrp+14KDsB/JMETq8kbIS6+7c01ic8+WLz3vHdkFhnkep+c6r8qYIa8y7PfiXZomzIPHK23VuOygDclxsM2qw7bMypPig/Z6kfVJsyGW1M5BiVSV0QUd6p50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736778635; c=relaxed/simple;
	bh=9lHtv41WfBHqxPAGbP2eFDWiw+yagEqdUTXfZNxRj94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kb2ENbFx5psSZvIK3kK05ucBGIShBzi+Kken280KWqeZiYbZyFtfkRUnCP3f+DRHPMIZm1tkj7Q/PmrO3f9BV4DWPWTj2GatXjKpFfi345gJr9IBU6XR6l24jc7TVUoC3j9ouW6a2gKkwKbmfjzRLell+NykW/HSVYOD37uS4Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X9Qm6Qu4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9Qm6Qu4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736778633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PDvnrJDJuqdMIlrb0MwQGV/3K965FnbNPmV/fgLqX1U=;
	b=X9Qm6Qu4/AJ6x702gt459Z8cnKX8kOadykXfIJqw1G2z9Br1gVThCD0sJyp4Csypzuhc5R
	KMvACdC6q6DnEprVGnLC7rE0lgNSslfjHLA1YsFE2cUgPL1L1NEpyGGrASNW7yJokossSr
	N4VWRyhqkyPP4rkeiixbLwM9jDJ/BLU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-w5fxO0rAM4KCWcrMIgOa9Q-1; Mon,
 13 Jan 2025 09:30:27 -0500
X-MC-Unique: w5fxO0rAM4KCWcrMIgOa9Q-1
X-Mimecast-MFC-AGG-ID: w5fxO0rAM4KCWcrMIgOa9Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DA761955DDB;
	Mon, 13 Jan 2025 14:30:26 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.118])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 956A63003FD3;
	Mon, 13 Jan 2025 14:30:25 +0000 (UTC)
Date: Mon, 13 Jan 2025 09:32:37 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFCv2 2/4] iomap: optional zero range dirty folio
 processing
Message-ID: <Z4UkBfnm5kSdYdv3@bfoster>
References: <20241213150528.1003662-1-bfoster@redhat.com>
 <20241213150528.1003662-3-bfoster@redhat.com>
 <Z394x1XyN5F0fd4h@infradead.org>
 <Z4Fejwv9XmNkJEGl@bfoster>
 <Z4SbwEbcp5AlxMIv@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4SbwEbcp5AlxMIv@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Sun, Jan 12, 2025 at 08:51:12PM -0800, Christoph Hellwig wrote:
> On Fri, Jan 10, 2025 at 12:53:19PM -0500, Brian Foster wrote:
> > processing.
> > 
> > For example, if we have a largish dirty folio backed by an unwritten
> > extent with maybe a single block that is actually dirty, would we be
> > alright to just zero the requested portion of the folio as long as some
> > part of the folio is dirty? Given the historical ad hoc nature of XFS
> > speculative prealloc zeroing, personally I don't see that as much of an
> > issue in practice as long as subsequent reads return zeroes, but I could
> > be missing something.
> 
> That's a very good question I haven't though about much yet.  And
> everytime I try to think of the speculative preallocations and they're
> implications my head begins to implode..
> 

Heh. Just context on my thought process, FWIW.. We've obviously zeroed
the newly exposed file range for writes that start beyond EOF for quite
some time. This new post-eof range may or may not have been backed by
speculative prealloc, and if so, that prealloc may either be delalloc or
unwritten extents depending on whether writeback occurred on the EOF
extent (assuming large enough free extents, etc.) before the extending
write.

In turn, this means that extending write zero range would have either
physically zeroed delalloc extents or skipped unwritten blocks,
depending on the situation. Personally, I don't think it really matters
which as there is no real guarantee that "all blocks not previously
written to are unwritten," for example, but rather just that "all blocks
not written to return zeroes on read." For that reason, I'm _hoping_
that we can keep this simple and just deal with some potential spurious
zeroing on folios that are already dirty, but I'm open to arguments
against that.

Note that the post-eof zero range behavior changed in XFS sometime over
the past few releases or so in that it always converts post-eof delalloc
to unwritten in iomap_begin(), but IIRC this was to deal with some other
unrelated issue. I also don't think that change is necessarily right
because it can significantly increase the rate of physical block
allocations in some workloads, but that's a separate issue, particularly
now that zero range doesn't update i_size.. ;P

> > > >  static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
> > > >  {
> > > > +	if (iter->fbatch) {
> > > > +		folio_batch_release(iter->fbatch);
> > > > +		kfree(iter->fbatch);
> > > > +		iter->fbatch = NULL;
> > > > +	}
> > > 
> > > Does it make sense to free the fbatch allocation on every iteration,
> > > or should we keep the memory allocation around and only free it after
> > > the last iteration?
> > > 
> > 
> > In the current implementation the existence of the fbatch is what
> > controls the folio lookup path, so we'd only want it for unwritten
> > mappings. That said, this could be done differently with a flag or
> > something that indicates whether to use the batch. Given that we release
> > the folios anyways and zero range isn't the most frequent thing, I
> > figured this keeps things simple for now. I don't really have a strong
> > preference for either approach, however.
> 
> I was just worried about the overhead of allocating and freeing
> it all the time.  OTOH we probably rarely have more than a single
> extent to process with the batch right now.
> 

Ok. This maintains zero range performance in my testing so far, so I'm
going to maintain simplicity for now until there's a reason to do
otherwise. I'm open to change it on future iterations. I suspect it
might anyways if this ends up used for more operations...

Thanks again for the comments.

Brian

