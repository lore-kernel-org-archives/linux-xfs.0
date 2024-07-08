Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E512080031
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jul 2024 11:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720437165; cv=none; b=BLYQJvCYDsJECfXTWSmYZDIRG5zyMm1CBsZ+0Wde6a4xq2zXjM7cFis+Q/wS2YdYYbgD7j5MB8lNC2/u6Iz9aH3gS8S6B6qPfNI1cVMDbSDbznOlJ3exqPyWktVGob7jcR8vRIxd9QxTjUa2Mq3YaSZ58mabG4GOXhwgSyi5kfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720437165; c=relaxed/simple;
	bh=A2Amlxz9Q+VLZ+ZbVuZyhOzaRtPRJ07PVprnUekDnmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOYR5aTE47MuisP4jZ+hV0dL6ELQ2BteuZDDJPtoY5Y2YutPH2d/Tdr9mFzmEYaAOvkeK1W70HYBKnMcGVWgpZ0hBwMCfBaUQXJ5f8v43Fsu1S/RAUzea8yEdoNlN8jXedwoKGuwr4le4AZQqq4wtIvWHxtjYSHgsXSkJhm9iUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=SREvpOmE; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="SREvpOmE"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7515437ff16so2454234a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2024 04:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1720437163; x=1721041963; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mSy3YtVRLz8Qqrmq3FDZ7/bd/sxHOLhAnKAcU2qf1+s=;
        b=SREvpOmElyUxuPMoPV5gDO6lQycyumWwEg3q8ANSZf0dyj3h6Qv7zO71CZwm6JUSLG
         ANINJb9l1Kq0dUPvu99KnCYMX2wpGX+CxOiwCaBvkFtQc/aqeGWKfTUdg2ao+FPlIwDs
         lc4E+0Tsr6He4knX6DqPqngTxevPxq9qeF/mG9qnHInR95zcMyR3Wd+3IuKDqPePlwCe
         5ESXAbHFZ46NshUX82oaCdDBGy+U7IUe6qPb7WbiVmKGNnAbpdq3CqJo/xjDQNaOMKwG
         CZ305KFvgEA/I6RI2EhnfnN45lAVLtRRucq6RxmP12qlt5RtoaK2jEmP5gQtsq8fbwep
         R88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720437163; x=1721041963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSy3YtVRLz8Qqrmq3FDZ7/bd/sxHOLhAnKAcU2qf1+s=;
        b=gS9jGx/kfu0pR7bmtsR1Iw/A7eS+pzze5zgRgPClyprY+MSKgDJ8riZNwhze5WQ33h
         VBz4oqXVjGu819pq18cNq2S6DwQyaaYhiqN1fvZagaZXUtRbk9y5gnEuR/vH968QYdLC
         LhCdolNT/d2LEKaYKc1xzE0zWCWHBgYVBkkhoyKTT8GNi2cFh4hpfSwvXngdw8ppNG+K
         w6rmTQ1opVFMqA9QImcZVgKJJ+6wYu2L2n4JfBLH9Vd/NRVGenhdkmgJvN6Evzxx8HVi
         wkwjNxOYG4SdJbTUSLyYpWFtjmUwpPXdUWADYkm+Uunl5Kx1Jsq1Vrf8T3CF2u5OvdXk
         q4Qg==
X-Forwarded-Encrypted: i=1; AJvYcCXtDJQ35ZY9vUoDcdC2CrmVxyunNQzpFg+Hexk7oo1PoF1UxwCMbcvkDbnFNJfN5XHgyxzvOF4u5PgMnX4GovbhiJvXKQHPODIW
X-Gm-Message-State: AOJu0YxV264LgmGKSSbUE7jeqxkrMC5yhi1/LIBWf2Ek3eZyMn+inyH/
	U6PKqN0FUaanbre/iL1WETjElZT724LJVktkn9U8FEolryAVPZuJRsIm2hXiRFg=
X-Google-Smtp-Source: AGHT+IHfNuRXWdkd9A3TuADFoTsa8jBjnmvwH6ZaWhwnmXrfHwV8g/iNZoGZuUc1/0V1do1JY2onFw==
X-Received: by 2002:a05:6a20:7349:b0:1c2:74b4:a05d with SMTP id adf61e73a8af0-1c274b4a983mr2918085637.23.1720437163092;
        Mon, 08 Jul 2024 04:12:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fb48b1bb5bsm58699265ad.1.2024.07.08.04.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 04:12:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sQmIS-008S5V-1F;
	Mon, 08 Jul 2024 21:12:40 +1000
Date: Mon, 8 Jul 2024 21:12:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, djwong@kernel.org,
	chandan.babu@oracle.com, dchinner@redhat.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, catherine.hoang@oracle.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH v2 08/13] xfs: Do not free EOF blocks for forcealign
Message-ID: <ZovJqNFyHYRWRVbA@dread.disaster.area>
References: <20240705162450.3481169-1-john.g.garry@oracle.com>
 <20240705162450.3481169-9-john.g.garry@oracle.com>
 <20240706075609.GB15212@lst.de>
 <ZotEmyoivd1CEAIS@dread.disaster.area>
 <6427a661-2e92-49a0-8329-7f67e8dd5c35@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6427a661-2e92-49a0-8329-7f67e8dd5c35@oracle.com>

On Mon, Jul 08, 2024 at 08:36:52AM +0100, John Garry wrote:
> On 08/07/2024 02:44, Dave Chinner wrote:
> > On Sat, Jul 06, 2024 at 09:56:09AM +0200, Christoph Hellwig wrote:
> > > On Fri, Jul 05, 2024 at 04:24:45PM +0000, John Garry wrote:
> > > > -	if (xfs_inode_has_bigrtalloc(ip))
> > > > +
> > > > +	/* Only try to free beyond the allocation unit that crosses EOF */
> > > > +	if (xfs_inode_has_forcealign(ip))
> > > > +		end_fsb = roundup_64(end_fsb, ip->i_extsize);
> > > > +	else if (xfs_inode_has_bigrtalloc(ip))
> > > >   		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
> > > 
> > > Shouldn't we have a common helper to align things the right way?
> > 
> > Yes, that's what I keep saying.
> 
> Such a change was introduced in
> https://lore.kernel.org/linux-xfs/20240501235310.GP360919@frogsfrogsfrogs/
> 
> and, as you can see, Darrick was less than happy with it. That is why I kept
> this method which removed recently added RT code.

I know.

However, "This is pointless busywork!" is not a technical argument
against the observation that rtbigalloc and forcealign are exactly
the same thing from the BMBT management POV and so should be
combined.

Arguing that "but doing the right thing makes more work for me"
doesn't hold any weight. It never has. Shouting and ranting
irrationally is a great way to shut down any further conversation,
though.

Our normal process is to factor the code and add the extra condition
for the new feature. That's all I'm asking to be done. It's not
technically difficult. It makes the code better. it makes the code
easier to test, too, because there are now two entries in the test
matrix taht exercise that code path. It's simpler to understand
months down the track, makes new alignment features easier to add in
future, etc.

Put simply: if we just do what we have always done, then we end up
with better code.  Hence I just don't see why people are trying to
make a mountain out of this...

> Darrick, can we find a better method to factor this code out, like below?
> 
> > The common way to do this is:
> > 
> > 	align = xfs_inode_alloc_unitsize(ip);
> > 	if (align > mp->m_blocksize)
> > 		end_fsb = roundup_64(end_fsb, align);
> > 
> > Wrapping that into a helper might be appropriate, though we'd need
> > wrappers for aligning both the start (down) and end (up).
> > 
> > To make this work, the xfs_inode_alloc_unitsize() code needs to grow
> > a forcealign check. That overrides the RT rextsize value (force
> > align on RT should work the same as it does on data devs) and needs
> > to look like this:
> > 
> > 	unsigned int		blocks = 1;
> > 
> > +	if (xfs_inode_has_forcealign(ip)
> > +		blocks = ip->i_extsize;
> > -	if (XFS_IS_REALTIME_INODE(ip))
> > +	else if (XFS_IS_REALTIME_INODE(ip))
> >                  blocks = ip->i_mount->m_sb.sb_rextsize;
> 
> That's in 09/13

Thanks, I thought it was somewhere in this patch series, I just
wanted to point out (once again) that rtbigalloc and forcealign are
basically the same thing.

And, in case it isn't obvious to everyone, setting forcealign on a
rt inode is basically the equivalent of turning on "rtbigalloc" for
just that inode....

> >          return XFS_FSB_TO_B(ip->i_mount, blocks);
> > 
> > > But more importantly shouldn't this also cover hole punching if we
> > > really want force aligned boundaries?
> 
> so doesn't the xfs_file_fallocate(PUNCH_HOLES) -> xfs_flush_unmap_range() ->
> rounding with xfs_inode_alloc_unitsize() do the required job?

No, xfs_flush_unmap_range() should be flushing to *outwards*
block/page size boundaries because it is cleaning and invalidating
the page cache over the punch range, not manipulating the physical
extents underlying the data.

It's only once we go to punch out the extents in
xfs_free_file_space() that we need to use xfs_inode_alloc_unitsize()
to determine the *inwards* rounding for the extent punch vs writing
physical zeroes....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
