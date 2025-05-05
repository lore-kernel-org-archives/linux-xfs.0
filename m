Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFC977111
	for <linux-xfs@vger.kernel.org>; Mon,  5 May 2025 14:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746455760; cv=none; b=br9SevHKzZO569O7XXENcTy9bl69H6UyJQNB9w5vap0tBNS5YIS34JVQ9OO3YdftrkQfYBHYC2DwlxH1xum3+cvtyj0CQvtup4jk7BHdPFHhilSTNaTmnpBDai8QkMVu4aPYUXmK6xq61laCmGCTSHU3hnI7qOA3ZyWLBOXqBoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746455760; c=relaxed/simple;
	bh=EB6R8G8PZgrM2tl4wcQYRjs94RfwhxsaEcFx4/sxQX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SA2K5uLoUExrdBEmrFufy7UHajsbj0z3+BQRF8G9agTOjuaYMfiCDqgu2sHRIYwWSvXnSPLGgHN8E8J/66VXEAGZuVNBBh5bNb3Mv3lV5kOLyzmYkJ+jBnNSqW3lsbI+/hBcWn+JKPSZEnLBE5XqbQqTeLVKJdnLoU5hmq4RWP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rp0VOgLh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rp0VOgLh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746455756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xw2Ai3uFmWPxoQxoVT2kSQGHqsl/D1raQ+1ayXFN6Ic=;
	b=Rp0VOgLhwgVwb/F38A6acy7H08rfGZzk+YBko7Ys8bhnl2Bb0d6luSo2HY45euTMRYuYje
	ylMYNUoOTelFUP969oZS/Jiq++1T6e1pNHibbtMRLxsfY1wkP2SiT9hzqNmzBA8ugAzsYo
	wjDMAIsnVyElx0f2xKY8TXb9mL+hd80=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-F4Ag982_Ob-HM_QU2oxEkg-1; Mon,
 05 May 2025 10:35:53 -0400
X-MC-Unique: F4Ag982_Ob-HM_QU2oxEkg-1
X-Mimecast-MFC-AGG-ID: F4Ag982_Ob-HM_QU2oxEkg_1746455752
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A36201800ECC;
	Mon,  5 May 2025 14:35:52 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.112])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD1FD19560A3;
	Mon,  5 May 2025 14:35:51 +0000 (UTC)
Date: Mon, 5 May 2025 10:39:03 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] iomap: rework iomap_write_begin() to return folio
 offset and length
Message-ID: <aBjNh7AcyEJcub-b@bfoster>
References: <20250430190112.690800-1-bfoster@redhat.com>
 <20250430190112.690800-7-bfoster@redhat.com>
 <20250502200038.GR25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502200038.GR25675@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Fri, May 02, 2025 at 01:00:38PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 30, 2025 at 03:01:12PM -0400, Brian Foster wrote:
> > iomap_write_begin() returns a folio based on current pos and
> > remaining length in the iter, and each caller then trims the
> > pos/length to the given folio. Clean this up a bit and let
> > iomap_write_begin() return the trimmed range along with the folio.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/iomap/buffered-io.c | 26 +++++++++++++++-----------
> >  1 file changed, 15 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index d3b30ebad9ea..2fde268c39fc 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -793,15 +793,22 @@ static int iomap_write_begin_inline(const struct iomap_iter *iter,
> >  	return iomap_read_inline_data(iter, folio);
> >  }
> >  
> > -static int iomap_write_begin(struct iomap_iter *iter, size_t len,
> > -		struct folio **foliop)
> > +/*
> > + * Grab and prepare a folio for write based on iter state. Returns the folio,
> > + * offset, and length. Callers can optionally pass a max length *plen,
> > + * otherwise init to zero.
> > + */
> > +static int iomap_write_begin(struct iomap_iter *iter, struct folio **foliop,
> > +		size_t *poffset, u64 *plen)
> >  {
> >  	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
> >  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> >  	loff_t pos = iter->pos;
> > +	u64 len = min_t(u64, SIZE_MAX, iomap_length(iter));
> >  	struct folio *folio;
> >  	int status = 0;
> >  
> > +	len = *plen > 0 ? min_t(u64, len, *plen) : len;
> >  	BUG_ON(pos + len > iter->iomap.offset + iter->iomap.length);
> >  	if (srcmap != &iter->iomap)
> >  		BUG_ON(pos + len > srcmap->offset + srcmap->length);
> > @@ -833,8 +840,7 @@ static int iomap_write_begin(struct iomap_iter *iter, size_t len,
> >  		}
> >  	}
> >  
> > -	if (pos + len > folio_pos(folio) + folio_size(folio))
> > -		len = folio_pos(folio) + folio_size(folio) - pos;
> > +	pos = iomap_trim_folio_range(iter, folio, poffset, &len);
> 
> Do we still need this pos variable?  AFAICT it aliases iter->pos.  But
> maybe that's something needed for whatever the subsequent series does?
> 

Hmm.. well I have one more patch that moves the BUG_ON() checks at the
top of the function to right after the trim call above. I kept that with
the folio batch patches because it's intended to accommodate that the
next folio might not be linear. That still doesn't technically need the
variable, but I've kept one in places where iter->pos would be read more
than once or twice because I just find the code cleaner that way.

OTOH, it does look like the param to __iomap_write_begin() could go
away, so that drops another use. I'd still probably use a local pos
variable down in that function though. I'll see about tacking one more
cleanup patch on for that either way.

> >  
> >  	if (srcmap->type == IOMAP_INLINE)
> >  		status = iomap_write_begin_inline(iter, folio);
> > @@ -847,6 +853,7 @@ static int iomap_write_begin(struct iomap_iter *iter, size_t len,
> >  		goto out_unlock;
> >  
> >  	*foliop = folio;
> > +	*plen = len;
> >  	return 0;
> >  
> >  out_unlock:
> > @@ -967,7 +974,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
> >  			break;
> >  		}
> >  
> > -		status = iomap_write_begin(iter, bytes, &folio);
> > +		status = iomap_write_begin(iter, &folio, &offset, &bytes);
> >  		if (unlikely(status)) {
> >  			iomap_write_failed(iter->inode, iter->pos, bytes);
> >  			break;
> > @@ -975,7 +982,7 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
> >  		if (iter->iomap.flags & IOMAP_F_STALE)
> >  			break;
> >  
> > -		pos = iomap_trim_folio_range(iter, folio, &offset, &bytes);
> > +		pos = iter->pos;
> 
> I wonder, do we still need this pos variable?  AFAICT it aliases
> iter->pos too.
> 

This one I kept around intentionally for the same reasoning as the the
__iomap_write_begin() case discussed above. If it's accessed more than a
couple times or so, I find it easier to read and help clarify when/if we
might expect pos to remain unchanged.

Brian

> Aside from that, the series looks decent to me and it's nice to
> eliminate some argument passing.
> 
> --D
> 
> >  
> >  		if (mapping_writably_mapped(mapping))
> >  			flush_dcache_folio(folio);
> > @@ -1295,14 +1302,12 @@ static int iomap_unshare_iter(struct iomap_iter *iter)
> >  		bool ret;
> >  
> >  		bytes = min_t(u64, SIZE_MAX, bytes);
> > -		status = iomap_write_begin(iter, bytes, &folio);
> > +		status = iomap_write_begin(iter, &folio, &offset, &bytes);
> >  		if (unlikely(status))
> >  			return status;
> >  		if (iomap->flags & IOMAP_F_STALE)
> >  			break;
> >  
> > -		iomap_trim_folio_range(iter, folio, &offset, &bytes);
> > -
> >  		ret = iomap_write_end(iter, bytes, bytes, folio);
> >  		__iomap_put_folio(iter, bytes, folio);
> >  		if (WARN_ON_ONCE(!ret))
> > @@ -1367,7 +1372,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  		bool ret;
> >  
> >  		bytes = min_t(u64, SIZE_MAX, bytes);
> > -		status = iomap_write_begin(iter, bytes, &folio);
> > +		status = iomap_write_begin(iter, &folio, &offset, &bytes);
> >  		if (status)
> >  			return status;
> >  		if (iter->iomap.flags & IOMAP_F_STALE)
> > @@ -1376,7 +1381,6 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  		/* warn about zeroing folios beyond eof that won't write back */
> >  		WARN_ON_ONCE(folio_pos(folio) > iter->inode->i_size);
> >  
> > -		iomap_trim_folio_range(iter, folio, &offset, &bytes);
> >  		folio_zero_range(folio, offset, bytes);
> >  		folio_mark_accessed(folio);
> >  
> > -- 
> > 2.49.0
> > 
> > 
> 

