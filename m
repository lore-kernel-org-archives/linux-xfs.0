Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC822116E7;
	Wed, 27 Aug 2025 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756310182; cv=none; b=MEgs1ZRTlsPGHSmd+Vjkj8p6qzAOoxOEFztsAgeF62/WhTkxYGE1mKiqtGbPU67QnjvlBbyw70aFWH4GQSJbh4E4pVoDPuYxnZTNYBn4QGMWlpQ0ePKMiTvFDzny+/6uEml+eWm3xW63IMuCSeJ8mB64WKmkJkJoq2Jr23tToPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756310182; c=relaxed/simple;
	bh=E332t6OVei1PrXs7bFwzaapdIzJ0sL3jKj74PlWIlNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kEyK2Tw6v+Zf6B5CJF9GEJU6k8FtybROWxnrLe/UiI7vxM8yJ2hSaQNsfWXd8GSOC2xi2s32X5lehCiVXNxUWszkh6HrYKTHcus6TpVrjYj7QfS9lpBqS3KECvt0r2Ko9SDF9nb4j2hQSooSQUQgKTwhQ+CSlKhjMxuzefAvfCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSUeez9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSUeez9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C40C4CEEB;
	Wed, 27 Aug 2025 15:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756310181;
	bh=E332t6OVei1PrXs7bFwzaapdIzJ0sL3jKj74PlWIlNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fSUeez9F4689JhIn/zNJgSBVr/BIUJ0t0c4aHmJt4a4KaOhKCmpEBvBn9gxuEd6UJ
	 xhOqVMxqtp0sf3crCyZXMKBf0v9cRo3lKtH98H4zjBpy7+M8uuompTFOxy39VjJI4n
	 B1pbHCT4T76BmQVVhFSkA1quvUANG3oIxFoKOR7x423GwQiuzFQykN4z0dqUm1bg5F
	 EPaFNpJg7yVrTWxhlTQmQMicA/JJr40bKIeM238yG8QjzMSJkzbneTbiDoPFKJe3I7
	 6E9e2NOWR/p6BVHiuk4rDZREcajFdvptFiIXtyoe1s8pwpCJyJJK31phQ2dWp2Wurl
	 jovnmcOYd9PIQ==
Date: Wed, 27 Aug 2025 08:56:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: do not propagate ENODATA disk errors into xattr code
Message-ID: <20250827155620.GA8117@frogsfrogsfrogs>
References: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>
 <20250822152137.GE7965@frogsfrogsfrogs>
 <aKwW2gEnQdIdDONk@infradead.org>
 <20250825153414.GC812310@frogsfrogsfrogs>
 <aK61FCz0wgz1s2Ab@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK61FCz0wgz1s2Ab@infradead.org>

On Wed, Aug 27, 2025 at 12:34:44AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 25, 2025 at 08:34:14AM -0700, Darrick J. Wong wrote:
> > > +	case BLK_STS_NOSPC:
> > > +		return -ENOSPC;
> > > +	case BLK_STS_OFFLINE:
> > > +		return -ENODEV;
> > > +	default:
> > > +		return -EIO;
> > 
> > Well as I pointed out earlier, one interesting "quality" of the current
> > behavior is that online fsck captures the ENODATA and turns that into a
> > metadata corruption report.  I'd like to keep that behavior.
> 
> -EIO is just as much of a metadata corruption, so if you only catch
> ENODATA you're missing most of them.

Hrmm, well an EIO (or an ENODATA) coming from the block layer causes the
scrub code to return to userspace with EIO, and xfs_scrub will complain
about the IO error and exit.

It doesn't explicitly mark the data structure as corrupt, but scrub
failing should be enough to conclude that the fs is corrupt.

I could patch the kernel to set the CORRUPT flag on the data structure
and keep going, since the likelihood of random bit errors causing media
errors is pretty high now that we have disks that store more than 1e15
bits.

> > >  	if (bio->bi_status)
> > > -		xfs_buf_ioerror(bp, blk_status_to_errno(bio->bi_status));
> > > +		xfs_buf_ioerror(bp, xfs_buf_bio_status(bio));
> > 
> > I think you'd also want to wrap all the submit_bio_wait here too, right?
> > 
> > Hrm, only discard bios, log writes, and zonegc use that function.  Maybe
> > not?  I think a failed log write takes down the system no matter what
> > error code, nobody cares about failing discard, and I think zonegc write
> > failures just lead to the gc ... aborting?
> 
> Yes.  In Linux -EIO means an unrecoverable I/O error that the lower
> layers gave up retrying. Not much we can do about that.

<nod>

--D
