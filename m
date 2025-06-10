Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6DB28ECD9
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 12:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749557661; cv=none; b=ut5k8gT5nQjw8CAD1utZj4G2KDbrkB178kGC+v3tP9JvB+g61rkkGLH0+JxcvTxQhKugtqVUN34DB/WfmLmtvxNNueCT5ov7nxadh/tpJZ3QTy1D3EkpCmqE00gSAPfVELlCpSwRuahQqYk6PoAiVOfv9+QsZ/7hwRSCyUrFzmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749557661; c=relaxed/simple;
	bh=V+guWLZ69vqifZlQbMS6D4nJY9iyL6sjXj+IsHTPcxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uf7GEhIF2oBS1vw/qvn6r57LYYnGfgaEYa80rSiRycUFK2Lmk53Xay7h84Yi7l04TqFapjlKr4H1skof7A6kAokjFCh3DNOFu8xY/jv3a4Xlju+7bsuAASwcWrHUXExJkB+wpgV7GoREYH7OeGGtq9+WQnkwqDqtRu2lPZI5sRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TtF4eHZv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TtF4eHZv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749557658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7M2KXkYboJQV8WZTt83MZ+x4H8up8eCNZ6BOoJSfhd8=;
	b=TtF4eHZvuwBczyVbFE678xf00H9GFe5n67NvvGn7qmylYFY5B6Xv4ikncTQov7+s22tfdk
	EwEcEuNnP68XNlnGEIN/i3wwqbjlU1lgyo7EizOmYHiaDFOI8GVC273dCEcnNLiy+ZbWTA
	mb61pPoTJ8a8rdg+ixqdE3E7BqxCNj8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-395-Uc6vkY5tOoe8unqS1MkvTw-1; Tue,
 10 Jun 2025 08:14:12 -0400
X-MC-Unique: Uc6vkY5tOoe8unqS1MkvTw-1
X-Mimecast-MFC-AGG-ID: Uc6vkY5tOoe8unqS1MkvTw_1749557651
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 636CD1956080;
	Tue, 10 Jun 2025 12:14:11 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.100])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A06F19560A3;
	Tue, 10 Jun 2025 12:14:10 +0000 (UTC)
Date: Tue, 10 Jun 2025 08:17:45 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/7] filemap: add helper to look up dirty folios in a
 range
Message-ID: <aEgiaXohtmidV3T9@bfoster>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-3-bfoster@redhat.com>
 <20250609154802.GB6156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609154802.GB6156@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Jun 09, 2025 at 08:48:02AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 05, 2025 at 01:33:52PM -0400, Brian Foster wrote:
> > Add a new filemap_get_folios_dirty() helper to look up existing dirty
> > folios in a range and add them to a folio_batch. This is to support
> > optimization of certain iomap operations that only care about dirty
> > folios in a target range. For example, zero range only zeroes the subset
> > of dirty pages over unwritten mappings, seek hole/data may use similar
> > logic in the future, etc.
> > 
> > Note that the helper is intended for use under internal fs locks.
> > Therefore it trylocks folios in order to filter out clean folios.
> > This loosely follows the logic from filemap_range_has_writeback().
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> You might want to cc willy directly on this one... 

Er yeah, I'll do that for v2.

> > ---
> >  include/linux/pagemap.h |  2 ++
> >  mm/filemap.c            | 42 +++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 44 insertions(+)
> > 
...
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index bada249b9fb7..d28e984cdfd4 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -2334,6 +2334,48 @@ unsigned filemap_get_folios_tag(struct address_space *mapping, pgoff_t *start,
> >  }
> >  EXPORT_SYMBOL(filemap_get_folios_tag);
> >  
> > +unsigned filemap_get_folios_dirty(struct address_space *mapping, pgoff_t *start,
> > +			pgoff_t end, struct folio_batch *fbatch)
> 
> This ought to have a comment explaining what the function does.
> It identifies every folio starting at @*start and ending before @end
> that is dirty and tries to assign them to @fbatch, right?
> 

Yep, or at least every folio that starts before end. I'll add a comment
and incorporate all the followup feedback. Thanks.

Brian

> The code looks reasonable to me; hopefully there aren't some subtleties
> that I'm missing here :P
> 
> > +{
> > +	XA_STATE(xas, &mapping->i_pages, *start);
> > +	struct folio *folio;
> > +
> > +	rcu_read_lock();
> > +	while ((folio = find_get_entry(&xas, end, XA_PRESENT)) != NULL) {
> > +		if (xa_is_value(folio))
> > +			continue;
> > +		if (folio_trylock(folio)) {
> > +			bool clean = !folio_test_dirty(folio) &&
> > +				     !folio_test_writeback(folio);
> > +			folio_unlock(folio);
> > +			if (clean) {
> > +				folio_put(folio);
> > +				continue;
> > +			}
> > +		}
> > +		if (!folio_batch_add(fbatch, folio)) {
> > +			unsigned long nr = folio_nr_pages(folio);
> > +			*start = folio->index + nr;
> > +			goto out;
> > +		}
> > +	}
> > +	/*
> > +	 * We come here when there is no page beyond @end. We take care to not
> 
> ...no folio beyond @end?
> 
> --D
> 
> > +	 * overflow the index @start as it confuses some of the callers. This
> > +	 * breaks the iteration when there is a page at index -1 but that is
> > +	 * already broke anyway.
> > +	 */
> > +	if (end == (pgoff_t)-1)
> > +		*start = (pgoff_t)-1;
> > +	else
> > +		*start = end + 1;
> > +out:
> > +	rcu_read_unlock();
> > +
> > +	return folio_batch_count(fbatch);
> > +}
> > +EXPORT_SYMBOL(filemap_get_folios_dirty);
> > +
> >  /*
> >   * CD/DVDs are error prone. When a medium error occurs, the driver may fail
> >   * a _large_ part of the i/o request. Imagine the worst scenario:
> > -- 
> > 2.49.0
> > 
> > 
> 

