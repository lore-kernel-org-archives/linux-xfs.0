Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794327619;
	b=09yw6MtCE8tAD0haqYY2qLpu1AN4hXd9+lB7rzZ3hpUef4KwuTir4nReLsgJDfmrU2CN
	 rSilmGI3r4Hn3vxZGMmXFEEb2Ge7wIcbvLeR/Y0CMB9pgszNiXS/cWIeDyIvVwLAS5iu6
	 pBIrvZ6njpkIpuh9VIAlaW/eEPsuq0bvmk3ErUiYHKWiCoMCx0qEpesp1rl68Yl0YerU3
	 qOq0NMIR69hGXHbpp8O1rcVh13Ixyzo7F8SvdsTBZqbD2nQ7BuK26yhU5d/wTMhgvfmOh
	 +F0ApnF86zWAtGlTrGxOjBevw6Rm9OtzgzrRWfQSTPdw6MtOGZ3wb2nEYNu50BgrRlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794327619;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=uD8brRZ6NhEhZf7Ohpm3p1eo9xt+uUFMCAjlE2jfXYw=;
	b=GF7w/jhJRbfsCKtFTMZzqAkr8pUC4kjQnJtclF9zfMxn2/THknW/dFy0AQlxHvxDql8U
	 BiiyznmUn/V4P6LeeRgueawWRYm8zes1GqHvFdmiA84H4xqgCtsONHT06CaLUkaJBYKPW
	 JySJzAJPFedhPxI9VujFra41v4Ur/ZRmAh67fpGgcqGOZatsCN8GvO74jV5E8dbxqN67U
	 auo7EfxBShkPmFlhqEh5MhBZw7m+n6lznjLuHCyBIua8pERQkg8MwJEdWteCwCz7ncqfu
	 Luni4nbpctLPYGDFIts2U/2hp8mC92EYiA+hOckNhmx64kQSEpcy6fpD5iu/4foghPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=anGj+TRh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15757606A320;
	Tue, 10 Nov 2026 16:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=anGj+TRh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 933BC1F008A4;
	Tue, 10 Nov 2026 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794327618;
	bh=uD8brRZ6NhEhZf7Ohpm3p1eo9xt+uUFMCAjlE2jfXYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=anGj+TRhnPRQbp7GojeRuleSn4ciBMuqfdFS2uhl+C0+nAoSdsrGM2/L0E3GjIfT7
	 PqdCz6qFRtM+RdU03RPaUu8iKsdU0T8lW9ETK2JwOlRg0OBP5CeO5y6EIOqT6RYVDu
	 8ybx9W872vcbFBhojiVeleU/yx5SrDkjM2OGIJ1HG0eKda4d6vvsiloL7H52mrHBvV
	 +Z3e6UGYY1XNVqJgzrvUXnpp7VXceeg+GxmrCgt8gZcpqObYCmAm2TnoQuhqG+jGhT
	 MqV6XdbOhutRPcAviLZ81pLOiRshCIyWcIsdDuuruzniV0jv6P0/CI/y9Y+oBx1Mj3
	 /GcB2ijroonnQ==
Date: Tue, 10 Nov 2026 17:20:13 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chris Mason <mason@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, Theodore Tso <tytso@mit.edu>, 
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 05/10] fs: validate atomic writes after O_APPEND and
 limits
Message-ID: <avNDv46qWTau08Ng@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <20261109235111.14129-6-mason@kernel.org>
 <avLhEEZjDdQha7ul@nidhogg.toxiclabs.cc>
 <5a3ef1c0-2a03-4d53-89fa-71319d2f938d@app.fastmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a3ef1c0-2a03-4d53-89fa-71319d2f938d@app.fastmail.com>

On Tue, Nov 10, 2026 at 10:26:02AM -0500, Chris Mason wrote:
> On Tue, Nov 10, 2026, at 4:41 AM, Carlos Maiolino wrote:
> > On Mon, Nov 09, 2026 at 06:51:16PM -0500, Chris Mason wrote:
> >> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> >> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> >> aligned.
> >> 
> >> XFS and ext4 call generic_atomic_write_valid() on the range that the
> >> caller passed. But generic_write_checks() changes the range later:
> >> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> >> then fill only a part of a new block, and still map the whole block into
> >> the file:
> >> 
> >>     block size 4096, i_size 512, O_APPEND
> >>     validated:        0 to 4095
> >>     written:          512 to 4607
> >>     new blocks:       0 to 8191
> >>     stale below EOF:  0 to 511
> >> 
> >> The fix used here is to validate an atomic write in
> >> generic_write_checks(), after its range is final, and to refuse one that
> >> was cut. XFS no longer picks the path of an atomic write by the
> >> alignment of the range that the caller passed.
> >> 
> >> Fixes: f096207d3276 ("xfs: Validate atomic writes")
> >> Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter")
> >> Signed-off-by: Chris Mason <mason@kernel.org>
> >
> > Sashiko caught an issue on this patch (and some of the next ones) worth
> > investigating in depth.
> >
> > In this one it says it may cause ext4 to silently convert an atomic
> > write into a buffered non-atomic. I know that ext4 tends to move from
> > DIO to buffered IO by default, but silently dropping atomic doesn't seem
> > right in this case.
> >
> > Looking through the report and the code it indeed seems a valid
> > possibility in some FS configurations as ext4_dio_alignment checks may
> > cause ext4_should_use_dio to return false (dio_align == 0 cases).
> >
> > Giving ext4's special fallback, perhaps just leave the
> > generic_atomic_write_valid check in place for ext4?
> 
> This was actually in the notes and I didn't follow up on it, sorry.
> 
> Claude suggests Tal Zussman's (cc'd) patch:
> 
> https://lore.kernel.org/all/20261012-ext4-atomic-no-fallback-v2-1-c4b30c60e500@columbia.edu/
> 
> Which fixes these cases and is already reviewed by Jan.

Oh, sorry, I missed that. If that's already reviewed, even better. If we
even have reviews for that... no need to mess up with different
approaches IMHO.

Thanks for the pointer

> 
> Carlos's suggestion also fixes sashiko's bug, but leaves open
> the (pre-existing) bug where the offset is ignored in O_APPEND
> ATOMIC math.
> 
> Last option is to just duplicate Tal's related hunk (below), that's
> my least favorite.
> 
> Ted?
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 6750d46fe31c..32c789fb2982 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -612,6 +612,9 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  			inode_unlock_shared(inode);
>  		else
>  			inode_unlock(inode);
> +		/* There is no support for atomic writes on buffered-io yet. */
> +		if (iocb->ki_flags & IOCB_ATOMIC)
> +			return -EOPNOTSUPP;
>  		return ext4_buffered_write_iter(iocb, from);
>  	}
>  
> 
