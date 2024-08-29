Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF04A92D
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 00:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724891173; cv=none; b=bwzCO6CaGia9tESzwL0A1kWFDtjGVANZh3WGXhSJJJo+9BwfPetXAafpjQHeuteFfhJrJ3y33zswB4WOpRdOW/n3WQHGcXJOHAjsHnE3cPN0PmYiFc5e4NrZrnoMKQ6wztY0Ee3NOdbtbdQGRsTW6eiwhIG5qno6I4kgcXufG50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724891173; c=relaxed/simple;
	bh=K1d/WUZ4pOKxANz0DULKzq+kcV63Y4w1/msuGSDcIVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4bXg3iJnbTOgpST6EgsAEuBRwCjCPf+vwLYa27hNWteQzn3DHqiaZLAhGQVWPEiPVmulwTWFOyMdidmvjTfyt0ByqQADQCv7Fy3wpmIvFeD8/aLWsfPPz60T4vCp7n/2y3Tx8Kr+DkUQpeX/GrUmD2DHdscnKSOOvQo8NMA2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fea1I5SS; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fea1I5SS"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-714114be925so86355b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 17:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724891171; x=1725495971; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aDl7WV9PIU1Ylz3knVbmxW+WadHaiTsg11xyR01+C6A=;
        b=fea1I5SSqpGQPN5BA7t2+LdQvtOwNxZEtU5bSdOsdOTXX6LrA14C2YbheU3qy0b2vr
         CeB7QJfNdjVR7blrrTX4S74n+3m72BrekKMM+BD01AF1Eq/V1dFcht+XjVKx1gnkOa0b
         M8KvIgzOfxZ6+QiDaFFNNTXsokLl+ap+GCDe6r6EXUXUel4NKSM3xr64TpoaHExi8hdC
         l9qZJPs1SxH0HZWfzk7Jwcdp6ovxdUaWrruQLk8Yc6fSzzt24BS8AsvxHfz45lsJ1XiY
         EXhew/K6TH08IAWQOJpyER7r/oBtWGAsg8KzR8dFddb8l2W1zoId5kIEYvsJ4RnCfmIz
         pb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724891171; x=1725495971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDl7WV9PIU1Ylz3knVbmxW+WadHaiTsg11xyR01+C6A=;
        b=tE+YKc6C82df53y0970BJ+8Jf9EszTAZrjnQeYngbKcijxY6A60XDC3VGoPwDKPTtx
         LM2aGA+79fFnRBl7mtvGaNcPAA/63s821tTI1as4TQNBZ91bfXE51BdzrTyinDFSd9OW
         OKyK1F8HqmDaV9NK6Y5jlrNOO2WbMjtW8WhDuZ43S81r0iHHz1iLAnCwlkpc+ol93JqX
         XyXYap4bdmBm35FxxACosOxNYlH4i85uqUUvvKDZ58/QYbVMzvXY/P5T97U/ctk39RIk
         hqPUWlsN85Bz43oOhuLpH0ENveDu1v+PHOdDmCah53H8j2CyB7MDLIngERnfBTiBhgq2
         19Nw==
X-Forwarded-Encrypted: i=1; AJvYcCXJ8R89Slv8tyhU/cFdoU5yzKVmPQSSYFI3ptoZYZOnz/tDLvk33I+M3cs2+cSUux9oftIJpvBqG2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTsTh5/WP5JAmL9UC5nL70n+RcxNvcGo/sYJshl3wkvRN+n5BV
	Sn4csrzqc2yDxnKzC3wutZoFkZxomH4rLKXtGLC8rKXoYy3M9h3NTx1sAARP8RM=
X-Google-Smtp-Source: AGHT+IHtMGZ5dwq/G++8goWGSggK8qMkgd1A7WBvV0JXwQNpPjeIAgv7hDatqCac3ZndUFp7PBvzRg==
X-Received: by 2002:a05:6a21:8cc8:b0:1c6:9e5e:2ec4 with SMTP id adf61e73a8af0-1cce10fe522mr1117151637.50.1724891170770;
        Wed, 28 Aug 2024 17:26:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-715e569ecc8sm55098b3a.140.2024.08.28.17.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 17:26:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjSzH-00GK6O-01;
	Thu, 29 Aug 2024 10:26:07 +1000
Date: Thu, 29 Aug 2024 10:26:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH v2 2/2] iomap: make zero range flush conditional on
 unwritten mappings
Message-ID: <Zs/AHi/UwAQ1zVdj@dread.disaster.area>
References: <20240828181912.41517-1-bfoster@redhat.com>
 <20240828181912.41517-3-bfoster@redhat.com>
 <20240828224420.GC6224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828224420.GC6224@frogsfrogsfrogs>

On Wed, Aug 28, 2024 at 03:44:20PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 28, 2024 at 02:19:11PM -0400, Brian Foster wrote:
> > @@ -1450,19 +1481,27 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
> >  		.flags		= IOMAP_ZERO,
> >  	};
> >  	int ret;
> > +	bool range_dirty;
> >  
> >  	/*
> >  	 * Zero range wants to skip pre-zeroed (i.e. unwritten) mappings, but
> >  	 * pagecache must be flushed to ensure stale data from previous
> > -	 * buffered writes is not exposed.
> > +	 * buffered writes is not exposed. A flush is only required for certain
> > +	 * types of mappings, but checking pagecache after mapping lookup is
> > +	 * racy with writeback and reclaim.
> > +	 *
> > +	 * Therefore, check the entire range first and pass along whether any
> > +	 * part of it is dirty. If so and an underlying mapping warrants it,
> > +	 * flush the cache at that point. This trades off the occasional false
> > +	 * positive (and spurious flush, if the dirty data and mapping don't
> > +	 * happen to overlap) for simplicity in handling a relatively uncommon
> > +	 * situation.
> >  	 */
> > -	ret = filemap_write_and_wait_range(inode->i_mapping,
> > -			pos, pos + len - 1);
> > -	if (ret)
> > -		return ret;
> > +	range_dirty = filemap_range_needs_writeback(inode->i_mapping,
> > +					pos, pos + len - 1);
> >  
> >  	while ((ret = iomap_iter(&iter, ops)) > 0)
> > -		iter.processed = iomap_zero_iter(&iter, did_zero);
> > +		iter.processed = iomap_zero_iter(&iter, did_zero, &range_dirty);
> 
> Style nit: Could we do this flush-and-stale from the loop body instead
> of passing pointers around?  e.g.
> 
> static inline bool iomap_zero_need_flush(const struct iomap_iter *i)
> {
> 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> 
> 	return srcmap->type == IOMAP_HOLE ||
> 	       srcmap->type == IOMAP_UNWRITTEN;
> }
> 
> static inline int iomap_zero_iter_flush(struct iomap_iter *i)
> {
> 	struct address_space *mapping = i->inode->i_mapping;
> 	loff_t end = i->pos + i->len - 1;
> 
> 	i->iomap.flags |= IOMAP_F_STALE;
> 	return filemap_write_and_wait_range(mapping, i->pos, end);
> }
> 
> and then:
> 
> 	range_dirty = filemap_range_needs_writeback(...);
> 
> 	while ((ret = iomap_iter(&iter, ops)) > 0) {
> 		if (range_dirty && iomap_zero_need_flush(&iter)) {
> 			/*
> 			 * Zero range wants to skip pre-zeroed (i.e.
> 			 * unwritten) mappings, but...
> 			 */
> 			range_dirty = false;
> 			iter.processed = iomap_zero_iter_flush(&iter);
> 		} else {
> 			iter.processed = iomap_zero_iter(&iter, did_zero);
> 		}
> 	}
> 
> The logic looks correct and sensible. :)

Yeah, I think this is better.

However, the one thing that both versions have in common is that
they don't explain -why- the iomap needs to be marked stale.
So, something like:

"When we flush the dirty data over the range, the extent state for
the range will change. We need to to know that new state before
performing any zeroing operations on the range.  Hence we mark the
iomap stale so that the iterator will remap this range and the next
ieration pass will see the new extent state and perform the correct
zeroing operation for the range."

-Dave.

-- 
Dave Chinner
david@fromorbit.com
