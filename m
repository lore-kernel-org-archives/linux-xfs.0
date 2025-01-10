Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B962063F3
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736531478; cv=none; b=I+5PI4nsTnYjce3YwHvZhyjBlKixhp1YDhqYvkk2yjOpHnYzIm1SqSuQIVAUgKMDEg1LI/IJ+xrTeOG+BJ1Vx5paA4DosqV9xu8BW/4AuaQcZRtrQ6N7ziG77p2ZLpU1QpH0yYuGkv1UpnziOr+6v2FtS6GMjJZjrs4Da3ECRDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736531478; c=relaxed/simple;
	bh=DA6OXgu/BuzxifV01FDF+2gYTcC8fij95DNW78iDfsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZyrndC7RYyPxKHmKJFN6mPHA9R4QeQf9KJKt5lGdAiTKC8AwAYslXXfxdG6XDO3opY9KXR0lANIGs53zcZbZtNw2hOmJL7sn/Yz/dou6kae3sSCtyaj/74c2guzx0G5aMX0fPcveSE+a1qBnUdHTtppqjjqgkHzST8L4YNL22w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQ+pq6Xt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQ+pq6Xt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736531475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2G9Li3NQ2IyuchxyLdq53IFYQWPeg05G9IsZevdsA1g=;
	b=cQ+pq6XtbZyJK5pjqRjx0MSsi5IwwaCjVWvfYQ1HYbyhrCi0E3G9hP9ZirMPF2WKNoLsvE
	x8zKZXwmEf58PIS7zhL0mUGoG9/2DcM3XwTMjKYWHZYnams3qp6SXTDAwxBFHNHqxRlXmc
	z/8M2VPzUMuQauELM+Z20fmPoPZZOEo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-281-DuwoW5TtN-yKpoIYISg0bA-1; Fri,
 10 Jan 2025 12:51:13 -0500
X-MC-Unique: DuwoW5TtN-yKpoIYISg0bA-1
X-Mimecast-MFC-AGG-ID: DuwoW5TtN-yKpoIYISg0bA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 071E4195608A;
	Fri, 10 Jan 2025 17:51:13 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.122])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 421651955BE3;
	Fri, 10 Jan 2025 17:51:12 +0000 (UTC)
Date: Fri, 10 Jan 2025 12:53:19 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFCv2 2/4] iomap: optional zero range dirty folio
 processing
Message-ID: <Z4Fejwv9XmNkJEGl@bfoster>
References: <20241213150528.1003662-1-bfoster@redhat.com>
 <20241213150528.1003662-3-bfoster@redhat.com>
 <Z394x1XyN5F0fd4h@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z394x1XyN5F0fd4h@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Jan 08, 2025 at 11:20:39PM -0800, Christoph Hellwig wrote:
> Just a bit of nitpicking, otherwise this looks sane, although I'd
> want to return to proper review of the squashed prep patches first.
> 

Yeah.. I mainly wanted to send this just to show the use case for the
iter advance changes. I'll look into tweaks for the various
nits/comments.

...
> > +	while (filemap_get_folios(mapping, &start, end, &fbatch) &&
> > +	       folio_batch_space(iter->fbatch)) {
> > +		struct folio *folio;
> > +		while ((folio = folio_batch_next(&fbatch))) {
> > +			if (folio_trylock(folio)) {
> > +				bool clean = !folio_test_dirty(folio) &&
> > +					     !folio_test_writeback(folio);
> > +				folio_unlock(folio);
> > +				if (clean)
> > +					continue;
> > +			}
> > +
> > +			folio_get(folio);
> > +			if (!folio_batch_add(iter->fbatch, folio)) {
> > +				end_pos = folio_pos(folio) + folio_size(folio);
> > +				break;
> > +			}
> > +		}
> > +		folio_batch_release(&fbatch);
> 
> I think I mentioned this last time, but I'd much prefer to do away
> with the locla fbatch used for processing and rewrite this using a
> find_get_entry() loop.  That probably means this helper needs to move
> to filemap.c, which should be easy if we pass in the mapping and outer
> fbatch.
> 

I recall we discussed making this more generic. That is still on my
radar, I just hadn't got to it yet.

I don't recall the find_get_entry() loop suggestion, but that seems
reasonable at a quick glance. I've been away from this for a few weeks
but I think my main concern with this trajectory was if/how to deal with
iomap_folio_state if we wanted fully granular dirty folio && dirty block
processing.

For example, if we have a largish dirty folio backed by an unwritten
extent with maybe a single block that is actually dirty, would we be
alright to just zero the requested portion of the folio as long as some
part of the folio is dirty? Given the historical ad hoc nature of XFS
speculative prealloc zeroing, personally I don't see that as much of an
issue in practice as long as subsequent reads return zeroes, but I could
be missing something.

...
> >  static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
> >  {
> > +	if (iter->fbatch) {
> > +		folio_batch_release(iter->fbatch);
> > +		kfree(iter->fbatch);
> > +		iter->fbatch = NULL;
> > +	}
> 
> Does it make sense to free the fbatch allocation on every iteration,
> or should we keep the memory allocation around and only free it after
> the last iteration?
> 

In the current implementation the existence of the fbatch is what
controls the folio lookup path, so we'd only want it for unwritten
mappings. That said, this could be done differently with a flag or
something that indicates whether to use the batch. Given that we release
the folios anyways and zero range isn't the most frequent thing, I
figured this keeps things simple for now. I don't really have a strong
preference for either approach, however.

Brian

