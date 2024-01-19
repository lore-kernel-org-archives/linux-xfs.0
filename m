Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F503C17
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 07:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705648375; cv=none; b=ttMPyC5Kqng0LHAwwLMZxHGaYVp99yLNI9P+XaNnwkEm2X084tWLPXCBCf0gRlq7Ha7uQFo6QZaEHSPuNQcZlK0cAExZNqCeV/J2hD48E5Ls+I4KgIi1yawB/gOSF2OfGlfHCaVlfXQpe0cUd7s3sPVT+8GYOWYjNRMoqjdJlpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705648375; c=relaxed/simple;
	bh=EqNADm31PhYaK76uDvvIjsr7KqsTeswUNtOWubgA9gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnXBIKT98QJPS8SMR2i+fnP7jYqN4coL+a1SNZkodzKuVKgT7Mqd4FwBWOdiV8ax01tJEPKIdVEG95JSpGFWE0JKGzV81w6M6iKIN3OqKUTknUuwY1QcvayVXP25SVSxnDQkEb9TUvXzyEJpbtNxcMiUKhJHcoXKed5iENdtts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EWO/p/In; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EWO/p/In"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6db05618c1fso525830b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 23:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705648373; x=1706253173; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o2rGo4E9Z6Imu0yMI8hCIg6A3l8W17KcdQeDBavO3jI=;
        b=EWO/p/Inrm8i0NiyQsbzJgqu41580FtTDpxgoZo5bo22sMoatLxtO7BdYGEIGvUt5C
         E2NwyOrJ2PfstJ0NCTVNVgfb6gmQHg+mcKoB2vSJ2B8xsFgI4eWQMPGR+Xyd8fO2EmOd
         9aZUpUJjpfvEBZcugLXkhAHdSf4LRUHyrCdZqjJpIkVGZQNi8fYT1MwrIUCiBgpuubRW
         oZblXc07UoGdA3wwk34DEtFS3oGoCFJRqtS8cFCMiLofe389oq5obJQ8DMI5Yr+dHZy4
         uqkRye6xJNoonmTyY4o9H2ySxj7eCRfxZyMtz0WPUf4F5t9HnkrS30A72qyyFk43r7iV
         854g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705648373; x=1706253173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o2rGo4E9Z6Imu0yMI8hCIg6A3l8W17KcdQeDBavO3jI=;
        b=fgEZ3Oe1+BEkSjRbDLxd9CnkW2xLrR3RxM4IHV/6dhIk26Gspmi7kg2DDvD7hMkFc7
         k5mdwSWc4eKgGOyJdFlAceXEapyR1SZpmFyxDISg4/6Ko7mDNYUR0qbBtvQEfP/uajkJ
         bTcubinwvZnJ2WvPokqj4bnHao1GN0cdcR46dmOSdSKIMlViNTVKqK24v78lnPHeklfa
         ZZkm90oD3znaqqBYJBbRhL53Ums6/UvkKwgEfXiT97qraNefJ/Gj0d+rWwHCO+0MxT30
         0IwsZkgMBs2WPel4A3otIPOF0w1qrvHL0rAy488u6VMGA9pcJufDaby6QUoakPQVgYxw
         dpNQ==
X-Gm-Message-State: AOJu0YzNIxvAwWMkURFQEdRedz8GrQEpTFjQEQIxJXqRpcTYf5b7Npz/
	dJ7p3rO5NmuhIB6wMDs3NP44Lo9/Y6hA3f10YM212eDeVj7L5XmwQoqn72n8dyo=
X-Google-Smtp-Source: AGHT+IGg02vRJ90ZoWhm6XmrZ6hN65lib3+C3Y9NWWso++OQcw3k7dwytv7T3EhpMSdT0Gz3SaJmMQ==
X-Received: by 2002:a62:6381:0:b0:6db:7543:6952 with SMTP id x123-20020a626381000000b006db75436952mr2319535pfb.52.1705648373101;
        Thu, 18 Jan 2024 23:12:53 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id u6-20020a056a00124600b006dbc5569599sm339002pfi.10.2024.01.18.23.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 23:12:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rQj3Z-00CMIL-2t;
	Fri, 19 Jan 2024 18:12:49 +1100
Date: Fri, 19 Jan 2024 18:12:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: convert buffer cache to use high order folios
Message-ID: <Zaog8du8DJ5u1Ert@dread.disaster.area>
References: <20240118222216.4131379-1-david@fromorbit.com>
 <20240118222216.4131379-4-david@fromorbit.com>
 <20240119013100.GR674499@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240119013100.GR674499@frogsfrogsfrogs>

On Thu, Jan 18, 2024 at 05:31:00PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 19, 2024 at 09:19:41AM +1100, Dave Chinner wrote:
> > +/*
> > + * Allocating a high order folio makes the assumption that buffers are a
> > + * power-of-2 size so that ilog2() returns the exact order needed to fit
> > + * the contents of the buffer. Buffer lengths are mostly a power of two,
> > + * so this is not an unreasonable approach to take by default.
> > + *
> > + * The exception here are user xattr data buffers, which can be arbitrarily
> > + * sized up to 64kB plus structure metadata. In that case, round up the order.
> > + */
> > +static bool
> > +xfs_buf_alloc_folio(
> > +	struct xfs_buf	*bp,
> > +	gfp_t		gfp_mask)
> > +{
> > +	int		length = BBTOB(bp->b_length);
> > +	int		order;
> > +
> > +	order = ilog2(length);
> > +	if ((1 << order) < length)
> > +		order = ilog2(length - 1) + 1;
> > +
> > +	if (order <= PAGE_SHIFT)
> > +		order = 0;
> > +	else
> > +		order -= PAGE_SHIFT;
> > +
> > +	bp->b_folio_array[0] = folio_alloc(gfp_mask, order);
> > +	if (!bp->b_folio_array[0])
> > +		return false;
> > +
> > +	bp->b_folios = bp->b_folio_array;
> > +	bp->b_folio_count = 1;
> > +	bp->b_flags |= _XBF_FOLIOS;
> > +	return true;
> 
> Hmm.  So I guess with this patchset, either we get one multi-page large
> folio for the whole buffer, or we fall back to the array of basepage
> sized folios?

Yes.

> /me wonders if the extra flexibility from alloc_folio_bulk_array and a
> folioized vm_map_ram would eliminate all this special casing?

IMO, no. The basic requirement for a buffer is to provide contiguous
memory space unless XBF_UNMAPPED is specified.

In the case of contiguous space, we either get a single contiguous
range allocated or we have to vmap multiple segments. The moment we
can't get a contiguous memory range, we've lost, we're in the slow
path and we should just do what we know will reliably work as
efficiently as possible.

In the case of XBF_UNMAPPED, if we get a single contiguous range we
can ignore XBF_UNMAPPED, otherwise we should just do what we know
will reliably work as efficiently as possible.

Hence I don't think trying to optimise the "we didn't get a
contiguous memory allocation for the buffer" case for smaller
multi-page folios because it just adds complexity and doesn't
provide any real advantage over the PAGE_SIZE allocation path we do
now.

> Uhoh, lights flickering again and ice crashing off the roof.  I better
> go before the lights go out again. :(

Fun fun!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
