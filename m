Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EC528F941
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 12:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749557871; cv=none; b=dwSS1DWhPQykatKjASyW00PJWVb5ErbcOEFJ+FsoxjcXffc0N87XKFdoeqtlMY0vDt5hrI0jF/pTE4K4rbFJQffZ+k19/qEOXoDdQDqxd2bCJc/hm701X6HS8Qgu2aU+O0xVJ7fUZFPaYyuZHcPw0npFMKsNLrFgR4JU2vRr6VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749557871; c=relaxed/simple;
	bh=WR1IvjKce/LjzRZOcbtmWruofFOuKxjHeqIAxYhXmbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D8gPbZmijBOrXgEKGT/BLp4qmoSKdCB3ZmwSBdLn2U4nSSTJwJsPSIkKZUtur/fop9ecW4F4vPyf0W1FPN28NTdusQKqkFjW7hSZB5p1Kw6wISOxmjzfB/3mrgtBqw7oQKl6zB32GnfqljnrMImxPlnJ/YsXK68MFWU0Bs8VXFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fiIq8X/C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiIq8X/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749557869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y/6IzAqLESSIhSDCeJuIE6lmtZtXtjyDSciPHX9jJ0I=;
	b=fiIq8X/C/4uhFc08OQQTyFCsBHCZ/A6kpUOlHK7bVq/geRGCC1m1JWuOT9cdqHGHxHThAQ
	y0i6rRT4aU/3w2GidqsLxdsZDhKlt3xlVhr2ZTBTm4aqvTh8PLi/8fACdCi9Y4mWW0IW4y
	6qP/3QAcZHNQPNnuo3YYsDdjSjyV25k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-hoz5Q-XIM8CfhM5YiT0kww-1; Tue,
 10 Jun 2025 08:17:45 -0400
X-MC-Unique: hoz5Q-XIM8CfhM5YiT0kww-1
X-Mimecast-MFC-AGG-ID: hoz5Q-XIM8CfhM5YiT0kww_1749557864
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE4191800366;
	Tue, 10 Jun 2025 12:17:43 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.100])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B368830001B1;
	Tue, 10 Jun 2025 12:17:41 +0000 (UTC)
Date: Tue, 10 Jun 2025 08:21:16 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] iomap: optional zero range dirty folio processing
Message-ID: <aEgjPCJ0hi0oew4y@bfoster>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-4-bfoster@redhat.com>
 <20250609160420.GC6156@frogsfrogsfrogs>
 <aEe0G8a8qL2CjgOg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEe0G8a8qL2CjgOg@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Jun 09, 2025 at 09:27:07PM -0700, Christoph Hellwig wrote:
> On Mon, Jun 09, 2025 at 09:04:20AM -0700, Darrick J. Wong wrote:
> > > +	if (iter->fbatch) {
> > > +		struct folio *folio = folio_batch_next(iter->fbatch);
> > > +
> > > +		if (folio) {
> > > +			folio_get(folio);
> > > +			folio_lock(folio);
> > 
> > Hrm.  So each folio that is added to the batch isn't locked, nor does
> > the batch (or iomap) hold a refcount on the folio until we get here.
> 
> find_get_entry references a folio, and filemap_get_folios_dirty
> preserves that reference.  It will be released in folio_batch_release.
> So this just add an extra reference for local operation so that the
> rest of iomap doesn't need to know about that magic.
> 

Exactly.

> > Do
> > we have to re-check that folio->{mapping,index} match what iomap is
> > trying to process?  Or can we assume that nobody has removed the folio
> > from the mapping?
> 
> That's a good point, though  as without having the folio locked it
> could get truncated, so I think we'll have to redo the truncate
> check here.
> 
> 

Hm Ok thanks, I'll take a closer look at that..

Brian

