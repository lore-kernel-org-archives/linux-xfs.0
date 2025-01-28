Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C671581F1
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 05:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040783; cv=none; b=BQnaj9VAZjwdksoBH9CgZnCSLjSwZr7dN6d8h/vpRzqZOW5iCEULiz9VHetCJXILj+CtrwHujotKNGzriCJ/8DUqWXXdwNixGQwumQUI07sNed2slfdDWQa+6GcsRcHhZ0cjF0wBs8TAHp6PyNI0Sle8HWnmUdm6+J9P6P425vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040783; c=relaxed/simple;
	bh=kgB3Cm79KK5LcPcQrr0wUK4wV37D1ebkS6RHQvS6cZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SynArBgjdZhAJ3L0V9q87YWcNPHU8Qq6SNizLtIVXVB2mWOeO1djGMFIX8MUngZtdmpCqrAIk1FEQqvkVwxGSTx6FVX5S8+9tjwh4MMTO5/0UpuNbcOvdVPL+QB92HvAXvP3QNkt1RK9H50bnvxmRczfFjKdKPVLBEF9Rks6uoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8111A68D05; Tue, 28 Jan 2025 06:06:14 +0100 (CET)
Date: Tue, 28 Jan 2025 06:06:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, djwong@kernel.org,
	dchinner@redhat.com, linux-xfs@vger.kernel.org,
	"Lai, Yi" <yi1.lai@linux.intel.com>
Subject: Re: [PATCH] xfs: remove xfs_buf_cache.bc_lock
Message-ID: <20250128050613.GA18688@lst.de>
References: <20250127150539.601009-1-hch@lst.de> <Z5fqPyqU4KTSMGyh@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5fqPyqU4KTSMGyh@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 28, 2025 at 07:19:11AM +1100, Dave Chinner wrote:
> Ok, so now we can get racing inserts, which means this can find
> the buffer that has just been inserted by another thread in this
> same function. Or, indeed, and xfs_buf_lookup() call.

Yes.

> What prevents
> those racing tasks from using this buffer before the task that
> inserted it can use it?
> 
> I think that the the buffer lock being initialised to "held" and
> b_hold being initialised to 1 make this all work correctly,

Exactly, the buffer is inserted with the b_sema held and b_hold
initializes 1, aka locked and held.

> but
> comments that explicitly spell out why RCU inserts are safe
> (both in xfs_buf_alloc() for the init values and here) would be
> appreciated.

Sure.

> >  struct xfs_buf_cache {
> > -	spinlock_t		bc_lock;
> >  	struct rhashtable	bc_hash;
> >  };
> 
> At this point, the struct xfs_buf_cache structure can go away,
> right?  (separate patch and all that...)

Yes.  And in fact I think the per-pag hash should also go away, as with
the per-bucket locking there is no point in it.  I've had this patch in
my testing runs for a while, which I think is where we should be
going:

http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=890cd2cd255710ee5d3408bc60792b9cdad3adfb
