Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71191CB332
	for <linux-xfs@vger.kernel.org>; Thu, 20 Feb 2025 14:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740063358; cv=none; b=trPebcoCICvNEVs/83UbgG/Nv4SPh3WspB9MMMVoIWeOmZmb1VUvSF8BYhY2OmhSVsPYZz0Yb16uG2/Kk8kgCzlrC9iWYFYHZqg8C7d/rNrt5tZmOB4iAbZhKOCDKdRrVtp0EianTM9Mkax0WwHUySFoR4iBuZMOjYDkB3tVbwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740063358; c=relaxed/simple;
	bh=emqtLvNALPmiTcQ3Ik62lKdn8OxDJ1NlfE+3b+1vMag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRzg9LIGB1GayBvyraiD3GMSwFKyKZek+tpeY9R16H0WqqN0I6KF/Q5KYjY7C3jVDKKw0gX+NPLROggQXxMVF9CoB8ltHm7YuiYOi9gCaM2DDyX2TIZabGNTlFQJhTCiGGnGmMNIQKqTmKhEXO9Uo0E3BMAw+q1kx8PzF087at4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdnn2UN9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdnn2UN9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740063355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rCsov8prd8heQb0uF1vmhgOVm4gP80hrFewU7CrwR60=;
	b=bdnn2UN9nOsAeJ68Hi8FizBlsubmVgirohaXmS7aU3SNOH/aJYpLDZ1m/QbsDbi0fFA12f
	E0rZdv16yaQ5TowgcE3s9T5Tb19dSemJiyboCVnnIsVOFTA+Lxl19/fRgh4PvwczJcs6xj
	QyY9wsCQ8uFd67mJf5/S7IFP3C9LIF4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-qEmkRRNFPhetdT5wL5JnNg-1; Thu,
 20 Feb 2025 09:55:53 -0500
X-MC-Unique: qEmkRRNFPhetdT5wL5JnNg-1
X-Mimecast-MFC-AGG-ID: qEmkRRNFPhetdT5wL5JnNg_1740063352
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D48418D95F1;
	Thu, 20 Feb 2025 14:55:52 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.79])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7990C180034D;
	Thu, 20 Feb 2025 14:55:51 +0000 (UTC)
Date: Thu, 20 Feb 2025 09:58:28 -0500
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 04/12] dax: advance the iomap_iter in the read/write
 path
Message-ID: <Z7dDFDXSi-gpw48O@bfoster>
References: <20250219175050.83986-1-bfoster@redhat.com>
 <20250219175050.83986-5-bfoster@redhat.com>
 <20250219223344.GJ21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219223344.GJ21808@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Wed, Feb 19, 2025 at 02:33:44PM -0800, Darrick J. Wong wrote:
> On Wed, Feb 19, 2025 at 12:50:42PM -0500, Brian Foster wrote:
> > DAX reads and writes flow through dax_iomap_iter(), which has one or
> > more subtleties in terms of how it processes a range vs. what is
> > specified in the iomap_iter. To keep things simple and remove the
> > dependency on iomap_iter() advances, convert a positive return from
> > dax_iomap_iter() to the new advance and status return semantics. The
> > advance can be pushed further down in future patches.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Not sure why this and the next patch are split up but it's fsdax so meh.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 

Heh.. mainly just out of caution and bisectability. The subsequent patch
took a bit of fighting for me to get right and this patch served as a
nice baseline to isolate changes in the DAX I/O path from the functional
iomap change, since this patch is relatively trivial.

Thanks for the reviews..

Brian

> --D
> 
> > ---
> >  fs/dax.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 21b47402b3dc..296f5aa18640 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1585,8 +1585,12 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  	if (iocb->ki_flags & IOCB_NOWAIT)
> >  		iomi.flags |= IOMAP_NOWAIT;
> >  
> > -	while ((ret = iomap_iter(&iomi, ops)) > 0)
> > +	while ((ret = iomap_iter(&iomi, ops)) > 0) {
> >  		iomi.processed = dax_iomap_iter(&iomi, iter);
> > +		if (iomi.processed > 0)
> > +			iomi.processed = iomap_iter_advance(&iomi,
> > +							    &iomi.processed);
> > +	}
> >  
> >  	done = iomi.pos - iocb->ki_pos;
> >  	iocb->ki_pos = iomi.pos;
> > -- 
> > 2.48.1
> > 
> > 
> 

