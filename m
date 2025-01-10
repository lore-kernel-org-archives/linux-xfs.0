Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816C14400
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 17:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736531251; cv=none; b=tApq6MIyswi83H9vcCrgCJJ/A0hfunWVpAGn4TJCRYkCJZWBxt1yDzabawOzEpV6iD441UKw/qB+Yeeafd6CtDMN1Njt+DZz5AsRlD6RPh2s8OrKytOFpynmvP/2aNwGVjVTRwK5/U2vbzcjQY9FhFXi2EOiVtptjEhBxAubcG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736531251; c=relaxed/simple;
	bh=VA/FKVaR7GDaTjWGL/f1mEoRzaU+PasyCwGNPKsYBmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=do/iYCzxlbfrl2GAedJS9EHVLIq9fUhRa+KmRQFsuBYX45M/xkCin/LX4fy+hssEme7ELDZigh2B61mrHZlJ6ihxA4Mhuq/jAvXCZLPsDft/NKmyKJFizQLjgxproxww+H94npzQKgkmmqnooSReGSrs2X2HIqTX3r9PFyaFrdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ne3VIh/K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ne3VIh/K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736531246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gOTrqMQsxIH8YdctTiVSqzH2gAuMUYhGSSBs9tYVQ/w=;
	b=Ne3VIh/KFQmGWxa+SnE1trOB3UXIQ7xVInQ9NhSL9ZCB5tVmeEEOvKIpPXwy3c8l65OrFW
	pjxe3pkZIp1kFLSykndXMUU0bjAc0PDjhR9ueEPi5D7gT1C2BzrXO26YPRAKwGcH9SxW1N
	FyXNmvHWAA/DkBZzM6HrJFC8AXVjW9A=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-44-qWVstE7AN12Sv5ngYgnJmw-1; Fri,
 10 Jan 2025 12:47:24 -0500
X-MC-Unique: qWVstE7AN12Sv5ngYgnJmw-1
X-Mimecast-MFC-AGG-ID: qWVstE7AN12Sv5ngYgnJmw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1D4819560AF;
	Fri, 10 Jan 2025 17:47:23 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.122])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E805630001BE;
	Fri, 10 Jan 2025 17:47:22 +0000 (UTC)
Date: Fri, 10 Jan 2025 12:49:29 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] iomap: factor out iomap length helper
Message-ID: <Z4FdqZpGRokcyh96@bfoster>
References: <20241213143610.1002526-1-bfoster@redhat.com>
 <20241213143610.1002526-3-bfoster@redhat.com>
 <Z390h2_8AmSQp_7R@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z390h2_8AmSQp_7R@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Jan 08, 2025 at 11:02:31PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 13, 2024 at 09:36:06AM -0500, Brian Foster wrote:
> > In preparation to support more granular iomap iter advancing, factor
> > the pos/len values as parameters to length calculation.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  include/linux/iomap.h | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 5675af6b740c..cbacccb3fb14 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -236,13 +236,19 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
> >   *
> >   * Returns the length that the operation applies to for the current iteration.
> >   */
> > -static inline u64 iomap_length(const struct iomap_iter *iter)
> > +static inline u64 __iomap_length(const struct iomap_iter *iter, loff_t pos,
> > +		u64 len)
> 
> __iomap_length is not a a very good name for this, maybe something like
> iomap_cap_length?  Also please move the kerneldoc comment for
> iomap_length down to be next to it.
> 

Ok, seems reasonable, though I think I'd prefer something like
iomap_length_trim()..

Brian

