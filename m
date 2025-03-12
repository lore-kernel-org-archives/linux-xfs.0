Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8660B1DE896
	for <linux-xfs@vger.kernel.org>; Wed, 12 Mar 2025 23:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741823999; cv=none; b=hERbED7sUOIphnGRoRBowN9ZBszoVOrQtwLGPWqs3dtqWWo3ZJXBAx6Qi/mpnVuielA+Y1NfGAgcIoEgMY/ryCh307+fIrUiX9HUwU7RkuIFrCd2jINxZOiF4JAn44PH1avBGr42LP7mbEUqKDdHYOlRa19HfFSOHLjxQcnr1sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741823999; c=relaxed/simple;
	bh=t0tZTSGtr4UWsHEiOdyc/1GE5qfFf7wDTtBzSRIEYng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ku70a5e87qRsagmho2Woz8qcQkSV9J245a5oV3wyIbcILXFL8W1yV0L2hX1ybaVRvpCeNtI3yx1Ye9ZfmOVPxNRQVcEWb6inin5uohFIe8eiLDQ6CWmwa2oQz3LiKXX4irIKmb6J6k81+DMTdar8SQ21j9ZNZOeEyGmDTJoSMoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=efgLDDwf; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="efgLDDwf"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-223594b3c6dso7044025ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Mar 2025 16:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1741823997; x=1742428797; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yytaLmBYctbIRkoKABXnhpi2qYihFcFQJbj0+Q55xFU=;
        b=efgLDDwfCH9znTe26cuC83tVPXAlx6Mu+UmDx7nv5tQ51iV887eFj1MvlRNyaQ3wZO
         PArU9JIPVeHbX1HzJ0gMVgAoFtoKBtV/VwKFrSMu1ahZ4CFofjLH5VszIFGkuDvsFBzC
         mvxmDQgJ62I10pY4ocxC6lh5cYOp3xZ9SE+ViL5Z034Lp4P7fyPy9hQ3o3lwmhLw1++d
         qaKr0o5iwwiqTvpVuEZMmTONsKvtVhx8C2F1Crrvxqr6+qJnu1hmKmJXHkosPJ7aDxTb
         77zjx/3ISpJ8P3AGxtSj73k1RKVcFcLn9Ru9GV1Jg+VYqXoRGtn/DdRHeAPEfOPyhv4+
         HvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741823997; x=1742428797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yytaLmBYctbIRkoKABXnhpi2qYihFcFQJbj0+Q55xFU=;
        b=APcqkQWXl0AzqZtMJQFzBD//SRvY8ZkvUvqDA7xX9z69zyN2U0zUe3DeGspp9td+bU
         hyeWr5yt9WlHu6uW6ZpmoU+uO4EiLtWgNahUG6P6GQYwcoIRmwB8M9zg82RzlBJI6TOZ
         86iTsgnMSlqVxzel5n6moYxyr6XZuIuus8E+7WLIoaGANjRYSfWyFMAOwR6t/9XzQZOc
         vOfpMvoe+7cg8bovnOXu0NseMip2FbeNbDBdcfYzqn4oqTPpbLpQpYgJSRa9h8r60Vmu
         qW1l9oZP5JFIUPCelj3dLSgfHv3q3NueNJpEWXWV45G+tyfrmbRU7w7hivLJjTFD0w/P
         BI7A==
X-Forwarded-Encrypted: i=1; AJvYcCWGUJ0uXLsWhdlkB6JeEOrFpDx48wPgEXkOesHCskN2LYFtQjA6E7tP1XnyJApJWO6QM/+U5ffrL/g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSknVNtByb+6Wc4tixPdmQWDXULBho37TFWfj1BnMWaWGJIm8w
	tQQWhYp4mEUf06c3Beiq93jWgCXo9nTgyxNIaxhRsieXVE2w1nqRru5VACTEudmp17bcwu2N/9h
	D
X-Gm-Gg: ASbGnctjzH8EwKlgXS884mDHPrPAo844MV1+hzzxw1bzoCPVU36IBlAccsgt3Npbw/p
	9Z/7lW4vBRbW/3j7/LyBCPmzLiMGEEeugyXTSLXwq7eaA2m30TerMm6nUIKXgBbsXUGGYulEKgq
	plX1QeSpau3QE7iWBFYKHuLj0Ue+Z2s5pctpaAoJzyUhFtDqEe0vKlccFLWlFLOd0BOeN5x6cSe
	uVPNVMhECg6h0LvasxHt7o0liVBdZfTENl1JbQtsmQ7EiHu3fgF4tbF0eToR9TE2avNsQUWQVDC
	+xVDnLbPDUb4WLCP+uw9X5cj3XOu1bBzdwwOkNu54+0IWZdbaRiVTQtQllbUlf7YDZnACn3tCTk
	rr1Y3ay42lZ+YaxbttvAsn1ns0eZV5GE=
X-Google-Smtp-Source: AGHT+IG4RCxcrmTYAq5F1HE82NxgYxY0Zc/jsHH0E4Gd1id1R+9jO5XGlN+xR0DEb3WE960pzuGqyw==
X-Received: by 2002:a17:902:e5d2:b0:223:66bc:f1de with SMTP id d9443c01a7336-22428a9810dmr352747475ad.21.1741823996781;
        Wed, 12 Mar 2025 16:59:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30138f8ca8fsm38113a91.31.2025.03.12.16.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 16:59:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tsVzN-0000000CMFO-0mqW;
	Thu, 13 Mar 2025 10:59:53 +1100
Date: Thu, 13 Mar 2025 10:59:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: John Garry <john.g.garry@oracle.com>, brauner@kernel.org,
	djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	ojaswin@linux.ibm.com, ritesh.list@gmail.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH RFC v5 10/10] iomap: Rename ATOMIC flags again
Message-ID: <Z9If-X3Iach3o_l3@dread.disaster.area>
References: <20250310183946.932054-1-john.g.garry@oracle.com>
 <20250310183946.932054-11-john.g.garry@oracle.com>
 <Z9E0JqQfdL4nPBH-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9E0JqQfdL4nPBH-@infradead.org>

On Wed, Mar 12, 2025 at 12:13:42AM -0700, Christoph Hellwig wrote:
> On Mon, Mar 10, 2025 at 06:39:46PM +0000, John Garry wrote:
> > Dave Chinner thought that names IOMAP_ATOMIC_HW and IOMAP_ATOMIC_SW were
> > not appropopiate. Specifically because IOMAP_ATOMIC_HW could actually be
> > realised with a SW-based method in the block or md/dm layers.
> > 
> > So rename to IOMAP_ATOMIC_BIO and IOMAP_ATOMIC_FS.
> 
> Looking over the entire series and the already merged iomap code:
> there should be no reason at all for having IOMAP_ATOMIC_FS.
> The only thing it does is to branch out to
> xfs_atomic_write_sw_iomap_begin from xfs_atomic_write_iomap_begin.
> 
> You can do that in a much simpler and nicer way by just having
> different iomap_ops for the bio based vs file system based atomics.

Agreed - I was going to suggest that, but got distracted by
something else and then forgot about it when I got back to writing
the email...

> I agree with dave that bio is a better term for the bio based
> atomic, but please use the IOMAP_ATOMIC_BIO name above instead
> of the IOMAP_BIO_ATOMIC actually used in the code if you change
> it.

Works for me.

> >   */
> >  static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
> > -		const struct iomap *iomap, bool use_fua, bool atomic_hw)
> > +		const struct iomap *iomap, bool use_fua, bool bio_atomic)
> 
> Not new here, but these two bools are pretty ugly.
> 
> I'd rather have a
> 
>     blk_opf_t extra_flags;
> 
> in the caller that gets REQ_FUA and REQ_ATOMIC assigned as needed,
> and then just clear 

Yep, that is cleaner..

-Dave.
-- 
Dave Chinner
david@fromorbit.com
