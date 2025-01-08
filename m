Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807271DFE0F
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 09:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736328068; cv=none; b=o5bHSsfj3bwBQ6YifbuiaO+E9pjYt5ZOqYY0eji1hBNMIDxgax3QvPQeICPH7VoEG+FtpiArDG6shblb9NrNiICCnZ5uBXV9es/ZMONlbUszdXhj/72hxcHEWRshEIUSTqPd5KZ4BgHUFuWMex1xxnn+BkCbuog4yUHzoZCUT1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736328068; c=relaxed/simple;
	bh=4dFa+apfADPO5NjxKAePNvqDbsjAocpI/xn3Z4wf8gU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IqHRgy4h4/icEK6f+n2Wvo+d2U12X34DO1SrSu7qKM3EuXzgWKSuT//IIO9jG2t+lIqigLBQyhcPyInHKqQeq03EcpBJouQ2Jm3H0XHKYB5fH0TaxhzsTvHq9mguoG4nw+xBEL9tC/BRhsYgCHUg9i7Q8KsuCXAH+pp5IvTAaiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U3UhTEu+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U3UhTEu+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736328065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U02N/mwycE9TGYMvXNYK5UM8aFTGOrlwqNeTVu7Cat8=;
	b=U3UhTEu+6kVsGw/ACqoJnhg2ZLmn9KK35xeEYQKyu7vZBlD1MBspCFmKLd/e3ozqlYWMU/
	zb7Rxgx+JtFbH3pawVG383D0H5FJ0/88dBZh5unCc9ZV6ugPBo6gH4rp2sBl/HGPiRrTkm
	RwIqe9A1NWSPHVgFLWhi5x4sV9thoeo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-CycQYxdcMDCkCavp-o4niw-1; Wed, 08 Jan 2025 04:21:04 -0500
X-MC-Unique: CycQYxdcMDCkCavp-o4niw-1
X-Mimecast-MFC-AGG-ID: CycQYxdcMDCkCavp-o4niw
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385d6ee042eso9232051f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jan 2025 01:21:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736328062; x=1736932862;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U02N/mwycE9TGYMvXNYK5UM8aFTGOrlwqNeTVu7Cat8=;
        b=vCgnHOZV8DlzljOxMQk2+ecoGgxlL9QuklOuZtVTSfRvlYWlev6T/XxL1hUO8B7PXr
         jcHZrpYRxM1hE6R4zBCHgkQTWtPzyeQWLyCPT+l4FbPtjzxwNH9ZcYvmRdtK3YqVUoYY
         8riMRVVEJ6taZ7BQb1SMqvlwJRewRYyIgExekzJ5yY3BCJJfsll578weha8+F8+HJWjO
         FjHiCrB5AL6sf7YypfhvN11RP0iKqo/Maz5AU6dUXkXNhFPSfCKA136F/x9ksAOWwy6e
         OqQ2yYiF1S3PJtqp/42GWPw/URvcZXt92A0wD+B1ZoBFDcPEBIa+YHqHY7YiLKAZaocY
         80/w==
X-Gm-Message-State: AOJu0Yy3YI6zAl738n1H/VXQ2d8Oe0v+TP971fI4XnNLhoW+zmqpsAdv
	zi9PdWBF8thNlJV5KBXvzKXMNT0O49rVmnvIsWEmO35MsDfMWKQbvgqInNAweayy5PG85mlMzX5
	a0X0h9Tr/D+hqSkT9tUuU/NmRLQhbB/nByORkzq2MtDs/s3MddXKVO284bd+mRJf+
X-Gm-Gg: ASbGncu0av4J+d1sCBQIj0/slSI8erPCqEhRa0yrUwS8ZRVawgfPPPAY9y5AgLro5li
	ImnNLDed3guPPeW4Udc7t2UAVuOgRkk+JXNMTVH16iCUsKfkDKGsOIxcHLVp+8iUqdluz+dvhNH
	N1Vk8H+4nKmhn4IJ7a8d9QEZNjl5jueLIKRyuxtdVzAtrjF+pHJGPDDhEXIyGvKAKlCg4QMASiR
	wJCsRB3dSrcOGjG8QVdxNYq1ABCqix1dlnBKNOmOzZZu68GieMUijyt3+yBFa1/Pc2YW/3GRWUE
X-Received: by 2002:a05:6000:470d:b0:385:dedb:a156 with SMTP id ffacd0b85a97d-38a872cfdffmr1334302f8f.6.1736328062143;
        Wed, 08 Jan 2025 01:21:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYgwh2ISYIxDhiBEpyjPM0OxY0cfe23n9TEvSRPyw4JpC+0IMZlpRJULUuAWf/ZJhTwJVQVg==
X-Received: by 2002:a05:6000:470d:b0:385:dedb:a156 with SMTP id ffacd0b85a97d-38a872cfdffmr1334269f8f.6.1736328061710;
        Wed, 08 Jan 2025 01:21:01 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2e96365sm13903695e9.43.2025.01.08.01.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 01:21:01 -0800 (PST)
Date: Wed, 8 Jan 2025 10:20:59 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, david@fromorbit.com, 
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [RFC] Directly mapped xattr data & fs-verity
Message-ID: <j7barlm3iix22ytjuu5y5mptfqzjme5pfdxk2a3vgb43ukoqxg@uhbobs5fs2uz>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20250106154212.GA27933@lst.de>
 <prijdbxigrvzr5xsjviohbkb3gjzrans6yqzygncqrwdacfhcu@lhc3vtgd6ecw>
 <20250107165057.GA371@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107165057.GA371@lst.de>

On 2025-01-07 17:50:57, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 09:56:51PM +0100, Andrey Albershteyn wrote:
> > On 2025-01-06 16:42:12, Christoph Hellwig wrote:
> > > I've not looked in details through the entire series, but I still find
> > > all the churn for trying to force fsverity into xattrs very counter
> > > productive, or in fact wrong.
> > 
> > Have you checked
> > 	[PATCH] xfs: direct mapped xattrs design documentation [1]?
> > It has more detailed argumentation of this approach.
> 
> It assumes verity must be stored in the attr fork and then justifies
> complexity by that.
> 
> > > xattrs are for relatively small variable sized items where each item
> > > has it's own name.
> > 
> > Probably, but now I'm not sure that this is what I see, xattrs have
> > the whole dabtree to address all the attributes and there's
> > infrastructure to have quite a lot of pretty huge attributes.
> 
> fsverity has a linear mapping.  The only thing you need to map it
> is the bmap btree.  Using the dabtree helps nothing with the task
> at hand, quite to the contrary it makes the task really complex.
> As seen both by the design document and the code.
> 
> > Taking 1T file we will have about 1908 4k merkle tree blocks ~8Mb,
> > in comparison to file size, I see it as a pretty small set of
> > metadata.
> 
> And you could easily map them using a single extent in the bmap
> btree with no overhead at all.  Or a few more if there isn't enough
> contiguous freespace.
> 
> > 
> > > fsverity has been designed to be stored beyond
> > > i_size inside the file.
> > 
> > I think the only requirement coming from fs-verity in this regard is
> > that Merkle blocks are stored in Pages. This allows for PG_Checked
> > optimization. Otherwise, I think it doesn't really care where the
> > data comes from or where it is.
> 
> I'm not say it's a requirement.  I'm saying it's been designed with
> that in mind.  In other words it is a very natural fit.  Mapping it
> to some kind of xattrs is not.
> 
> > Yes, that's one of the arguments in the design doc, we can possibly
> > use it for mutable files in future. Not sure how feasible it is with
> > post-EOF approach.
> 
> Maybe we can used it for $HANDWAVE is not a good idea. 

> Hash based verification works poorly for mutable files, so we'd
> rather have a really good argument for that.

hmm, why? Not sure I have an understanding of this

> 
> > I don't really see the advantage or much difference of storing
> > fs-verity post-i_size. Dedicating post-i_size space to fs-verity
> > dosn't seem to be much different from changing xattr format to align
> > with fs blocks, to me.
> 
> It is much simpler, and more storage efficient by doing away with the
> need for the dabtree entries and your new remote-remote header.
> 

I see.

-- 
- Andrey

