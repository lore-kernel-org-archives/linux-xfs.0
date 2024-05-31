Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C7278283
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 15:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717170197; cv=none; b=HuUnqLiZy2IOWr3LVRthuA8CCHof614qrnFN+ryaLxCNzl6eodyyOy7cCdn+9vR/l93dtgumdUb7bYpGQ79oLEmUPgd7l/GRVrUeG5HLCN6AS13QFqDBijFMy4mbZS3dDGnFhVM69jiI/MQD0jwf/Ic9swOBKcklLXhmffPIhLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717170197; c=relaxed/simple;
	bh=ZsIOxKV22FJ6iXiCvQJjYFYtwbFYGzH6I+9kQeeST7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIKJefaUAh1WUuZOKtNHTByzd0OvV07CXoXGq4SAgVUukaZ+vPjUU3Eer1IK7tQ4HdzsGaBz+azF7PpquxJJgAHrVMhoM6SFltN+7mj5JWvPuvrPBR+9cwmu6LIDhMJnW6KB7N3ohY1pGjaHhHYb2f9/Ne6Wd3fM4lIzqa7wHKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eks3K8lw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eks3K8lw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717170191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iIia4hHk5j/TSK1B8z38Y1m4YO2hmYbyc3O8mouCYWY=;
	b=eks3K8lwwVqX2LDusX8RnEIAz/wUN96GUe8gql/XtdNlS8LOhRCirginxw0psmG8Ktgd4p
	a961W+peAD7zbARtw9p3gYoT1aksauvvtW4d2RIJcmyy0qg3HBeke18zzgr6N3lGxhfeHe
	VAHD+EeXD8MtAchiHzZDkNw+NVtNMPI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-zdYf_3BGP_qfJtXTR9EL7A-1; Fri, 31 May 2024 11:43:05 -0400
X-MC-Unique: zdYf_3BGP_qfJtXTR9EL7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D56F5800281;
	Fri, 31 May 2024 15:43:04 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.96])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2DB540C6EB7;
	Fri, 31 May 2024 15:43:03 +0000 (UTC)
Date: Fri, 31 May 2024 11:43:22 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	brauner@kernel.org, david@fromorbit.com, chandanbabu@kernel.org,
	jack@suse.cz, willy@infradead.org, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [RFC PATCH v4 1/8] iomap: zeroing needs to be pagecache aware
Message-ID: <ZlnwGhuvUBLyiE6J@bfoster>
References: <20240529095206.2568162-1-yi.zhang@huaweicloud.com>
 <20240529095206.2568162-2-yi.zhang@huaweicloud.com>
 <ZlnMfSJcm5k6Dg_e@infradead.org>
 <20240531140358.GF52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531140358.GF52987@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

On Fri, May 31, 2024 at 07:03:58AM -0700, Darrick J. Wong wrote:
> On Fri, May 31, 2024 at 06:11:25AM -0700, Christoph Hellwig wrote:
> > On Wed, May 29, 2024 at 05:51:59PM +0800, Zhang Yi wrote:
> > > XXX: how do we detect a iomap containing a cow mapping over a hole
> > > in iomap_zero_iter()? The XFS code implies this case also needs to
> > > zero the page cache if there is data present, so trigger for page
> > > cache lookup only in iomap_zero_iter() needs to handle this case as
> > > well.
> > 
> > If there is no data in the page cache and either a whole or unwritten
> > extent it really should not matter what is in the COW fork, a there
> > obviously isn't any data we could zero.
> > 
> > If there is data in the page cache for something that is marked as
> > a hole in the srcmap, but we have data in the COW fork due to
> > COW extsize preallocation we'd need to zero it, but as the
> > xfs iomap ops don't return a separate srcmap for that case we
> > should be fine.  Or am I missing something?
> 
> It might be useful to skip the scan for dirty pagecache if both forks
> have holes, since (in theory) that's never possible on xfs.
> 
> OTOH maybe there are filesystems that allow dirty pagecache over a hole?
> 

IIRC there was a case where dirty cache can exist over what is reported
as a hole to zero range. I want to say it was something like a COW
prealloc over a data fork hole followed by a buffered write and then a
zero range, but I don't recall the details. That is all something that
should be fixed on the lookup side anyways.

Brian

> > > + * Note: when zeroing unwritten extents, we might have data in the page cache
> > > + * over an unwritten extent. In this case, we want to do a pure lookup on the
> > > + * page cache and not create a new folio as we don't need to perform zeroing on
> > > + * unwritten extents if there is no cached data over the given range.
> > >   */
> > >  struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
> > >  {
> > >  	fgf_t fgp = FGP_WRITEBEGIN | FGP_NOFS;
> > >  
> > > +	if (iter->flags & IOMAP_ZERO) {
> > > +		const struct iomap *srcmap = iomap_iter_srcmap(iter);
> > > +
> > > +		if (srcmap->type == IOMAP_UNWRITTEN)
> > > +			fgp &= ~FGP_CREAT;
> > > +	}
> > 
> > Nit:  The comment would probably stand out a little better if it was
> > right next to the IOMAP_ZERO conditional instead of above the
> > function.
> 
> Agreed.
> 
> > > +		if (status) {
> > > +			if (status == -ENOENT) {
> > > +				/*
> > > +				 * Unwritten extents need to have page cache
> > > +				 * lookups done to determine if they have data
> > > +				 * over them that needs zeroing. If there is no
> > > +				 * data, we'll get -ENOENT returned here, so we
> > > +				 * can just skip over this index.
> > > +				 */
> > > +				WARN_ON_ONCE(srcmap->type != IOMAP_UNWRITTEN);
> > 
> > I'd return -EIO if the WARN_ON triggers.
> > 
> > > +loop_continue:
> > 
> > While I'm no strange to gotos for loop control something trips me
> > up about jumping to the end of the loop.  Here is what I could come
> > up with instead.  Not arguing it's objectively better, but I somehow
> > like it a little better:
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 700b22d6807783..81378f7cd8d7ff 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -1412,49 +1412,56 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
> >  		bool ret;
> >  
> >  		status = iomap_write_begin(iter, pos, bytes, &folio);
> > -		if (status) {
> > -			if (status == -ENOENT) {
> > -				/*
> > -				 * Unwritten extents need to have page cache
> > -				 * lookups done to determine if they have data
> > -				 * over them that needs zeroing. If there is no
> > -				 * data, we'll get -ENOENT returned here, so we
> > -				 * can just skip over this index.
> > -				 */
> > -				WARN_ON_ONCE(srcmap->type != IOMAP_UNWRITTEN);
> > -				if (bytes > PAGE_SIZE - offset_in_page(pos))
> > -					bytes = PAGE_SIZE - offset_in_page(pos);
> > -				goto loop_continue;
> > -			}
> > +		if (status && status != -ENOENT)
> >  			return status;
> > -		}
> > -		if (iter->iomap.flags & IOMAP_F_STALE)
> > -			break;
> >  
> > -		offset = offset_in_folio(folio, pos);
> > -		if (bytes > folio_size(folio) - offset)
> > -			bytes = folio_size(folio) - offset;
> > +		if (status == -ENOENT) {
> > +			/*
> > +			 * If we end up here, we did not find a folio in the
> > +			 * page cache for an unwritten extent and thus can
> > +			 * skip over the range.
> > +			 */
> > +			if (WARN_ON_ONCE(srcmap->type != IOMAP_UNWRITTEN))
> > +				return -EIO;
> >  
> > -		/*
> > -		 * If the folio over an unwritten extent is clean (i.e. because
> > -		 * it has been read from), then it already contains zeros. Hence
> > -		 * we can just skip it.
> > -		 */
> > -		if (srcmap->type == IOMAP_UNWRITTEN &&
> > -		    !folio_test_dirty(folio)) {
> > -			folio_unlock(folio);
> > -			goto loop_continue;
> > +			/*
> > +			 * XXX: It would be nice if we could get the offset of
> > +			 * the next entry in the pagecache so that we don't have
> > +			 * to iterate one page at a time here.
> > +			 */
> > +			offset = offset_in_page(pos);
> > +			if (bytes > PAGE_SIZE - offset)
> > +				bytes = PAGE_SIZE - offset;
> 
> Why is it PAGE_SIZE here and not folio_size() like below?
> 
> (I know you're just copying the existing code; I'm merely wondering if
> this is some minor bug.)
> 
> --D
> 
> > +		} else {
> > +			if (iter->iomap.flags & IOMAP_F_STALE)
> > +				break;
> > +
> > +			offset = offset_in_folio(folio, pos);
> > +			if (bytes > folio_size(folio) - offset)
> > +				bytes = folio_size(folio) - offset;
> > +		
> > +			/*
> > +			 * If the folio over an unwritten extent is clean (i.e.
> > +			 * because it has only been read from), then it already
> > +			 * contains zeros.  Hence we can just skip it.
> > +			 */
> > +			if (srcmap->type == IOMAP_UNWRITTEN &&
> > +			    !folio_test_dirty(folio)) {
> > +				folio_unlock(folio);
> > +				status = -ENOENT;
> > +			}
> >  		}
> >  
> > -		folio_zero_range(folio, offset, bytes);
> > -		folio_mark_accessed(folio);
> > +		if (status != -ENOENT) {
> > +			folio_zero_range(folio, offset, bytes);
> > +			folio_mark_accessed(folio);
> >  
> > -		ret = iomap_write_end(iter, pos, bytes, bytes, folio);
> > -		__iomap_put_folio(iter, pos, bytes, folio);
> > -		if (WARN_ON_ONCE(!ret))
> > -			return -EIO;
> > +			ret = iomap_write_end(iter, pos, bytes, bytes, folio);
> > +			__iomap_put_folio(iter, pos, bytes, folio);
> > +			if (WARN_ON_ONCE(!ret))
> > +				return -EIO;
> > +		}
> >  
> > -loop_continue:
> >  		pos += bytes;
> >  		length -= bytes;
> >  		written += bytes;
> > 
> 

