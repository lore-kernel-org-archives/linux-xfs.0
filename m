Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8719C1D6DD4
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 20:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738787114; cv=none; b=RLMego7fuzyQtcPsn/clP4XrDrq/Jg667xvfCK5lpCUQ9jgvssl8iuFnsAlHLJAk26d1PFGMXxyaRUy3nWNw+5pGdG2iA1fXVmXLs2xDga7/fTJYbquS2/jHjuFHouHhnjI7BKhqokvFNdVdpORcEpxU7l0rp8gMrkEaR8Y+n4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738787114; c=relaxed/simple;
	bh=y/2NvVX2i0xJu8eDUkHz/Cnr+Ovxo5e6swckZfHCzZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNe4rpMSbMXrDWQQ/67lVNchVaNiZW8wcem9eaEA6ZdOCPjS/TLp+yp3r28w+vqgOiStty2ZiIe50HWbREEvtzbLS/6cL3RrHC/EUUtsDEelsEJRxUjcIdQR7zvE+lyr/DoJLM/aG3+jp1VLkR/dYaebRjpLghWQ0vNNF2obaDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XpDlkrJC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XpDlkrJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738787111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKWUKlQeFRtrc/aYAbNT7uztxfgG+kxou6xZ6sInWHw=;
	b=XpDlkrJCYR4RIIl5b1cSPf8ovbo6OzjG0m6IGZx2UMtdzE//U6wfYRhVQRAytTjEDTrbu0
	67LS5wy0/DolMiTi1/e9k9/jpmlEHMSnlbw7N/lscCVciXKbx6s5/uNcAcceSUFLdBFIx/
	ME37Y9ATzeKbVo9Cue8h59iUE69hyCM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-dDgkHZ3WPti2h2Grg5w-UA-1; Wed,
 05 Feb 2025 15:25:08 -0500
X-MC-Unique: dDgkHZ3WPti2h2Grg5w-UA-1
X-Mimecast-MFC-AGG-ID: dDgkHZ3WPti2h2Grg5w-UA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F9301956089;
	Wed,  5 Feb 2025 20:25:07 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.48])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B1AB1800570;
	Wed,  5 Feb 2025 20:25:05 +0000 (UTC)
Date: Wed, 5 Feb 2025 15:27:31 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 09/10] iomap: advance the iter directly on unshare
 range
Message-ID: <Z6PJs8RvbcfNJNcC@bfoster>
References: <20250205135821.178256-1-bfoster@redhat.com>
 <20250205135821.178256-10-bfoster@redhat.com>
 <20250205191610.GS21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205191610.GS21808@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Feb 05, 2025 at 11:16:10AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 05, 2025 at 08:58:20AM -0500, Brian Foster wrote:
> > Modify unshare range to advance the iter directly. Replace the local
> > pos and length calculations with direct advances and loop based on
> > iter state instead.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/iomap/buffered-io.c | 23 +++++++++++------------
> >  1 file changed, 11 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 678c189faa58..f953bf66beb1 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -1267,20 +1267,19 @@ EXPORT_SYMBOL_GPL(iomap_write_delalloc_release);
> >  static loff_t iomap_unshare_iter(struct iomap_iter *iter)
> >  {
> >  	struct iomap *iomap = &iter->iomap;
> > -	loff_t pos = iter->pos;
> > -	loff_t length = iomap_length(iter);
> > -	loff_t written = 0;
> > +	u64 bytes = iomap_length(iter);
> > +	int status;
> >  
> >  	if (!iomap_want_unshare_iter(iter))
> > -		return length;
> > +		return iomap_iter_advance(iter, &bytes);
> >  
> >  	do {
> >  		struct folio *folio;
> > -		int status;
> >  		size_t offset;
> > -		size_t bytes = min_t(u64, SIZE_MAX, length);
> > +		loff_t pos = iter->pos;
> 
> Do we still need the local variable here?
> 

Technically no.. Christoph brought up something similar in earlier
versions re: the pos/len variables (here and in subsequent patches) but
I'm leaving it like this for now because the folio batch work (which is
the impetus for this series) further refactors and removes much of this.

For example, pos gets pushed down into the write begin path so it can
manage state between the next folio in a provided batch and the current
position of the iter itself. So this pos code goes away from
unshare_iter() completely and this patch is just moving things one step
in that direction.

> Otherwise looks right to me, so
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 

Thanks.

Brian

> --D
> 
> >  		bool ret;
> >  
> > +		bytes = min_t(u64, SIZE_MAX, bytes);
> >  		status = iomap_write_begin(iter, pos, bytes, &folio);
> >  		if (unlikely(status))
> >  			return status;
> > @@ -1298,14 +1297,14 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
> >  
> >  		cond_resched();
> >  
> > -		pos += bytes;
> > -		written += bytes;
> > -		length -= bytes;
> > -
> >  		balance_dirty_pages_ratelimited(iter->inode->i_mapping);
> > -	} while (length > 0);
> >  
> > -	return written;
> > +		status = iomap_iter_advance(iter, &bytes);
> > +		if (status)
> > +			break;
> > +	} while (bytes > 0);
> > +
> > +	return status;
> >  }
> >  
> >  int
> > -- 
> > 2.48.1
> > 
> > 
> 

