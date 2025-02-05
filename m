Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD92846F
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 20:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738786974; cv=none; b=jZoUzaeNWpoxVG0FhBvrTqSN+0QbL6wGGwklFk9/fxehRmDAntLGtyU0EIQubtxKQIILAb6Oe85zKI/OszV5lcc/6a3IgwasiMlhI/EVtppJVLE/vJfktZQq17FworbPGOxOVaW82x0cUP4MxLiFz9gmfHQp32Ok7FSXp60aG5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738786974; c=relaxed/simple;
	bh=Qp+t79MCWZvkpWI2Sm7YEGgWsCeuddGq6i8DQX4BsQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K6eWLmScPfvX4fBaWrEjNzwkz7YyJXcBfTdMqlWWrJxfoDNmAUSrT7vHNnQMQKMPkflvUUwrbmjvOc2A+scwF4MQGUy+1IWnpgQoA7ili95KappYuLOYKQI34yRZJ5/mzT5J3h3s7xlzE/J2JavClVuVUdq6I/J+9X/GfaWjM+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MVVcF4Ag; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MVVcF4Ag"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738786971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0a2ZPC3pMR3QJ0Ff5h2GUZm4IVrRwMvif2xyDuXNK8A=;
	b=MVVcF4AgjENsMzyYR8TwkZnUB1E610dIzTerYiPk/TYzt8YIXxQUgqdJocQHaX1VVfpxDM
	snebIaF/pmLHI0ULd+e3P4oDrtV/3uY/Y8HIIGqgQiI+s22kdvPy4iypIAoVls6ABGJltG
	kuXRTHTkQmTN6na16ptytJoeZNDsalk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-t5G572JLM7K9I5f4Ry4AQA-1; Wed,
 05 Feb 2025 15:22:45 -0500
X-MC-Unique: t5G572JLM7K9I5f4Ry4AQA-1
X-Mimecast-MFC-AGG-ID: t5G572JLM7K9I5f4Ry4AQA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AAFD1800879;
	Wed,  5 Feb 2025 20:22:44 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.48])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75FEA1800570;
	Wed,  5 Feb 2025 20:22:43 +0000 (UTC)
Date: Wed, 5 Feb 2025 15:25:03 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 05/10] iomap: lift iter termination logic from
 iomap_iter_advance()
Message-ID: <Z6PJHxl5v0lRlano@bfoster>
References: <20250205135821.178256-1-bfoster@redhat.com>
 <20250205135821.178256-6-bfoster@redhat.com>
 <20250205190020.GP21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205190020.GP21808@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Feb 05, 2025 at 11:00:20AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 05, 2025 at 08:58:16AM -0500, Brian Foster wrote:
> > The iter termination logic in iomap_iter_advance() is only needed by
> > iomap_iter() to determine whether to proceed with the next mapping
> > for an ongoing operation. The old logic sets ret to 1 and then
> > terminates if the operation is complete (iter->len == 0) or the
> > previous iteration performed no work and the mapping has not been
> > marked stale. The stale check exists to allow operations to
> > retry the current mapping if an inconsistency has been detected.
> > 
> > To further genericize iomap_iter_advance(), lift the termination
> > logic into iomap_iter() and update the former to return success (0)
> > or an error code. iomap_iter() continues on successful advance and
> > non-zero iter->len or otherwise terminates in the no progress (and
> > not stale) or error cases.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/iomap/iter.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> > index 1db16be7b9f0..8e0746ad80bd 100644
> > --- a/fs/iomap/iter.c
> > +++ b/fs/iomap/iter.c
...
> > @@ -91,8 +86,18 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> >  		return processed;
> >  	}
> >  
> > -	/* advance and clear state from the previous iteration */
> > +	/*
> > +	 * Advance the iter and clear state from the previous iteration. Use
> > +	 * iter->len to determine whether to continue onto the next mapping.
> > +	 * Explicitly terminate in the case where the current iter has not
> > +	 * advanced at all (i.e. no work was done for some reason) unless the
> > +	 * mapping has been marked stale and needs to be reprocessed.
> > +	 */
> >  	ret = iomap_iter_advance(iter, processed);
> > +	if (!ret && iter->len > 0)
> > +		ret = 1;
> > +	if (ret > 0 && !iter->processed && !stale)
> > +		ret = 0;
> 
> I guess I'll wait to see what the rest of the conversion series looks
> like...
> 

It's not fully tested yet, but FWIW here's what I currently have in
iomap_iter() after the remaining conversions:

	...
        ret = (iter->len > 0) ? 1 : 0;
        if (iter->processed < 0)
                ret = iter->processed;
        else if (!advanced && !stale)
                ret = 0;
        iomap_iter_reset_iomap(iter);
        if (ret <= 0)
                return ret;
	...

Note that iter.processed should only be success (0) or error here and
hence I was planning to subsequently rename it to iter.status.

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 

Thanks.

Brian

> --D
> 
> >  	iomap_iter_reset_iomap(iter);
> >  	if (ret <= 0)
> >  		return ret;
> > -- 
> > 2.48.1
> > 
> > 
> 

