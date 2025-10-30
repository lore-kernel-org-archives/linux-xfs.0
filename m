Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E8D324B3F
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 04:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761800070; cv=none; b=fFOut6a+vHz/DDwQZWGxVV+X/sJjgf2Yide+Rf40jGEo+8S/ydSVvkLE5H8WK8bkL0pfkzBWD0+bOtA12pJFP+mylWqnwZaAnhpa6beiJR17IGB03RssA2Yv9QM+Bs7NTA6fe6S5O0uob0wiJWeEP/yQhiGH8+CTs0zVKoyw9Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761800070; c=relaxed/simple;
	bh=VxZENKZkB6Z+YZgyLavSwJWdOW+IEJ+F18A1MxXcN5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsG02ZNYVzVghmq6GIjnTjBhXH7e1Gp7eHvxDoCLnYZBO78Z6/R8yddYvTgYDvmUO23oFX6clLvE0J8F8gBiqvhe40SxmprVy28fYCfubur8qxrXrUwsi3sIoWIKgliNtPEVtrRZndNReWPMTZCWmPp5pOLxm5N8ejGuVGOvWnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tlgmo2/W; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tlgmo2/W"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27eeafd4882so93065ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 21:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761800068; x=1762404868; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ej/auf+/EmPMyY6GqjKBQhQwJpW0Nqnj+K+f6BktHE0=;
        b=Tlgmo2/Wm9hutAIeSz4vU5YsTZNTyN3xDraA+m7VfEoqgfH3F38q2pD3IMe1HiaPLq
         kVM2q4++zCzHD4I1OHRRuKfZ8dlPMdqipeVzk9hyMMsv8n+VZ5dkwA32zp0l4+nMS50i
         laKQUIrUHXeqZkODCGEF7moR5hp4b2enn2mNyoLBRuSIikghXk9mbVfpcyaJHWYCX0BH
         Ru/b0BWyOmMOCVQe1GlArVfGajNy0aYi5WrIv//RyjOYClkZ1cdxD+NI10uTncx32WMY
         pCdf0105ls9dKoT6X0llI1lTvCzo9LTHh2d0QkDf5um89IHEfdFp0UXQMhjoyVHmzavT
         klFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761800068; x=1762404868;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ej/auf+/EmPMyY6GqjKBQhQwJpW0Nqnj+K+f6BktHE0=;
        b=FPJ/A7ZuKkKfsxAus2Qt7OfICPy9QVFwwY7WFhe1qVImn3i3hHiZoL5Xe/tjI8ZqAB
         BsDm4wHWeBXPOqcstHEZvzVOa4Xvm07Meukj10r3cMWzr4XLg3Z6mYhheVorgNNFGkdx
         QTzbU/2E6pPN70CBb5Qay1omeGELCxtJBVCYTKXoGtvH/AuSs16czWt7VGD9daZ4tuI9
         +HyEqpFEV7xYmCAzrcIzcFLxkw0fnwn9wHoXjw3t9RqzvxW3OHaQNzW5sdFtZDxN+Nzh
         v+4r6SuIBQksesEoYRwVVU2zUoesgWGUg2mKEUlgbHsNdVkFoE1Uub+zR1mbcfHCiicp
         vmMA==
X-Forwarded-Encrypted: i=1; AJvYcCUu8+gZpl9n3oRhleHEy5FYg10C6blG2s2kDPA3LHVA5TsLARyG607OEZnE1z3cO+kFuiTKXS76kxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWVyG6uZM1I3m1j3fxHPFCANJRGt5ULYkp9NvmaHwO+qXnql7G
	n/cFqQJ3GQT4C0dIlbyfmcPmI35KXOo/TYpQF20w04ryIPuyrOGr793Lle2nETLnmczHva0fqRr
	Fzm2VsQ==
X-Gm-Gg: ASbGncvfTaRlgrTVN5fnp2w1MpJSo3BrpzbEA+xKqcbQkHHbSGjN4tSAAPGe3Kf6zOx
	0+049GRVHb7ISDkPpups+C1CNR6qwvRys1cAzQb5tlvnBffbFhVUoAT12ngomlz+fXyMed+hvqh
	o2jS3INXtAFClDjtaoTYb5aMwBm0md2t6lso8OV/K2V5lcvaxspearW81Ooc84wkxNa4M3WL9nI
	AZP/6DfiaI3e9P8WI2I8yrcXSsFV7WiaegeBXaAqECxVkZIFapUJWeoMKkjr8N2u5ZZILZIwV4z
	uTonzK5/blmySvLeAjZy+ILwGlkQo00Be+zDPSCnm+UdrpaI54doM0jEak5s1oOY665C0e1jQTZ
	WVKzThpoAkEtHh0dgqcR+kDM5qoOQMJWCcphV30Okdl2ghW4LhXbVH1N7z3ap/B7ZWEGMXLnfmQ
	SQ8r2e6pbnjJ/SucXZ/uDE5rpf3SALQZbWN7PFzq1aVCC5bJNb3MAXge/aVGzLsUNjzqAt7dBcF
	IxW1LsvwMFACNoT4HyUo9PR7sGfFfMVpIk=
X-Google-Smtp-Source: AGHT+IF1aIVtDtqyINIaT4VsEA6+urTc/5YTHi0A6ZrXvPoa8CEW59KPabjqx3mO+bDkKlfEESX4Bg==
X-Received: by 2002:a17:903:22c4:b0:290:d7fd:6297 with SMTP id d9443c01a7336-294ee1aad86mr3315295ad.2.1761800067395;
        Wed, 29 Oct 2025 21:54:27 -0700 (PDT)
Received: from google.com (235.215.125.34.bc.googleusercontent.com. [34.125.215.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d2317csm170936075ad.48.2025.10.29.21.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 21:54:26 -0700 (PDT)
Date: Thu, 30 Oct 2025 04:54:21 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Keith Busch <kbusch@kernel.org>, Keith Busch <kbusch@meta.com>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de,
	axboe@kernel.dk, Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 5/8] iomap: simplify direct io validity check
Message-ID: <aQLvfayGPi1YezHV@google.com>
References: <20250827141258.63501-1-kbusch@meta.com>
 <20250827141258.63501-6-kbusch@meta.com>
 <aP-c5gPjrpsn0vJA@google.com>
 <aP-hByAKuQ7ycNwM@kbusch-mbp>
 <aQFIGaA5M4kDrTlw@google.com>
 <20251028225648.GA1639650@google.com>
 <20251028230350.GB1639650@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028230350.GB1639650@google.com>

On Tue, Oct 28, 2025 at 11:03:50PM +0000, Eric Biggers wrote:
> On Tue, Oct 28, 2025 at 10:56:48PM +0000, Eric Biggers wrote:
> > On Tue, Oct 28, 2025 at 10:47:53PM +0000, Carlos Llamas wrote:
> > > Ok, I did a bit more digging. I'm using f2fs but the problem in this
> > > case is the blk_crypto layer. The OP_READ request goes through
> > > submit_bio() which then calls blk_crypto_bio_prep() and if the bio has
> > > crypto context then it checks for bio_crypt_check_alignment().
> > > 
> > > This is where the LTP tests fails the alignment. However, the propagated
> > > error goes through "bio->bi_status = BLK_STS_IOERR" which in bio_endio()
> > > get translates to EIO due to blk_status_to_errno().
> > > 
> > > I've verified this restores the original behavior matching the LTP test,
> > > so I'll write up a patch and send it a bit later.
> > > 
> > > diff --git a/block/blk-crypto.c b/block/blk-crypto.c
> > > index 1336cbf5e3bd..a417843e7e4a 100644
> > > --- a/block/blk-crypto.c
> > > +++ b/block/blk-crypto.c
> > > @@ -293,7 +293,7 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
> > >  	}
> > >  
> > >  	if (!bio_crypt_check_alignment(bio)) {
> > > -		bio->bi_status = BLK_STS_IOERR;
> > > +		bio->bi_status = BLK_STS_INVAL;
> > >  		goto fail;
> > >  	}
> > 
> > That change looks fine, but I'm wondering how this case was reached in
> > the first place.  Upper layers aren't supposed to be submitting
> > misaligned bios like this.  For example, ext4 and f2fs require
> > filesystem logical block size alignment for direct I/O on encrypted
> > files.  They check for this early, before getting to the point of
> > submitting a bio, and fall back to buffered I/O if needed.
> 
> I suppose it's this code in f2fs_should_use_dio():
> 
> 	/*
> 	 * Direct I/O not aligned to the disk's logical_block_size will be
> 	 * attempted, but will fail with -EINVAL.
> 	 *
> 	 * f2fs additionally requires that direct I/O be aligned to the
> 	 * filesystem block size, which is often a stricter requirement.
> 	 * However, f2fs traditionally falls back to buffered I/O on requests
> 	 * that are logical_block_size-aligned but not fs-block aligned.
> 	 *
> 	 * The below logic implements this behavior.
> 	 */
> 	align = iocb->ki_pos | iov_iter_alignment(iter);
> 	if (!IS_ALIGNED(align, i_blocksize(inode)) &&
> 	    IS_ALIGNED(align, bdev_logical_block_size(inode->i_sb->s_bdev)))
> 		return false;
> 
> So it relies on the alignment check in iomap in the case where the
> request is neither logical_block_size nor filesystem_block_size aligned.
> 
> f2fs_should_use_dio() probably should just handle that case explicitly.
> 
> But making __blk_crypto_bio_prep() use a better error code sounds good
> too.

I realize this is a bit of a band-aid but here is the patch to fail the
bad alignment with EINVAL:
https://lore.kernel.org/all/20251030043919.2787231-1-cmllamas@google.com/

As for the more achitectural fix suggested by Christoph, I'm absolutely
out of my depth so I can't comment on that.

Cheers,
--
Carlos Llamas
