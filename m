Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D542046B1
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 20:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738699967; cv=none; b=S1+eZ6yVwaDCjPrBWNW9Fopf+3q8MFeNa/H8JKetIR3YBfBnUCtHcrx5nX58LRRiU6hwJnvhhmoZiUu+BESAVBarI46XsLTERJBU8qaMiYSFadoltV8MjU1e0v2WYPteA/UN30xxh3AlZFP6rR68UQDOLdPpvxHxzWtgRVHyox8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738699967; c=relaxed/simple;
	bh=ZNpDW47ZwJRfd5juonz+KhxN5D0K/9JonKH7PFYBTXA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJx8bA2pczhr71EyipwrjN3ShCPl50XAfATT8FXBii65bxF2KnguUGlpY4fvEaBV3lXrSihDVPQksSq+5R8m6UDxRRCps//V+W88A91u/QS+ZJC5dASvKbEy9lprKBPS11l8hD2N80n06lpTAoyeq9nMHsL6mAnZgdp5OA7FyMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y9rmLlzI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y9rmLlzI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738699964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mIyppWYvJ3bM7feOJ1OCGhytewxAHTi+RJR0pVnCasU=;
	b=Y9rmLlzINks5dQ5b6neSe3R2s4ObQqDbRWa9A2BSBf95tQAayWtpPbsb/leA31v4ra9UCx
	Ut7FM/8WUiO3D+I/shfFqgcFZEkUIZ2ggAv08VGE034BWcXUsxop2b15hlEkNOK57D8gJn
	9qkBa8c0vNczdYzMlBQPwyj+DHzT8Jg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-689QQHlRP9OKopZdsXcnnw-1; Tue,
 04 Feb 2025 15:12:41 -0500
X-MC-Unique: 689QQHlRP9OKopZdsXcnnw-1
X-Mimecast-MFC-AGG-ID: 689QQHlRP9OKopZdsXcnnw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BB3119560BB;
	Tue,  4 Feb 2025 20:12:40 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.48])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B5A030001BE;
	Tue,  4 Feb 2025 20:12:38 +0000 (UTC)
Date: Tue, 4 Feb 2025 15:15:04 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 05/10] iomap: lift iter termination logic from
 iomap_iter_advance()
Message-ID: <Z6J1SJCM1wpjxBpL@bfoster>
References: <20250204133044.80551-1-bfoster@redhat.com>
 <20250204133044.80551-6-bfoster@redhat.com>
 <20250204195220.GE21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204195220.GE21808@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Feb 04, 2025 at 11:52:20AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 04, 2025 at 08:30:39AM -0500, Brian Foster wrote:
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
> > ---
> >  fs/iomap/iter.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
> > index fcc8d75dd22f..04bd39ee5d47 100644
> > --- a/fs/iomap/iter.c
> > +++ b/fs/iomap/iter.c
...
> > @@ -89,8 +84,18 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> >  		return iter->processed;
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
> >  	ret = iomap_iter_advance(iter, iter->processed);
> > +	if (!ret && iter->len > 0)
> > +		ret = 1;
> > +	if (ret > 0 && !iter->processed && !stale)
> 
> How can ret be greater than zero here other than the previous line
> setting it?  I /think/ this is the same as:
> 
> 	if (!ret && iter->len > 0) {
> 		if (iter->processed || stale)
> 			ret = 1;
> 	}
> 
> but then I wonder if it's really necessary to reset the iter state on
> error, or if we've finished the whole thing, or if we've done no work
> and didn't set STALE?  What do you think about:
> 
> 	ret = iomap_iter_advance(...);
> 	if (ret || !iter->len)
> 		return ret;
> 	if (!iter->processed && !stale)
> 		return 0;
> 
> 	iomap_iter_reset_iomap(iter);
> 	ret = ops->iomap_begin(...);
> 

Two thoughts come to mind...

The first is that I'm really trying to be as incremental as possible
here to minimize possibility of subtle issues that might come along with
subtle changes (i.e. like when we do or don't reset, etc.). If you
wanted to tack this on as a followon cleanup, I'd have no issue with it
in general. But that leads to...

The second is that I have a followup series to convert the rest of the
iomap ops to use iter_advance(), after which the iomap_iter() advance in
the logic above goes away. So it might be best to defer this sort of
reset and continuation logic cleanup to after that..

Brian

> --D
> 
> > +		ret = 0;
> >  	iomap_iter_reset_iomap(iter);
> >  	if (ret <= 0)
> >  		return ret;
> > -- 
> > 2.48.1
> > 
> > 
> 

