Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5802B14BFA2
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 04:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760503277; cv=none; b=quttUZzS/TZ7RjoxxrBLB/R5YCgLu+52EpBJnnS9SwZjS/rMmRSgcPo4QBT24KhFsz+2Zkn2+1oMrdXPiyOxoXAn+kCE19dfItPdapzlPX8GFPrFxld1PPtwkvtxEoglCtSC/qaUNTIHJINTeU8dvsnRToe+JoKpWUnKYSgLcm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760503277; c=relaxed/simple;
	bh=3hlLRm+n7ahBInFTy8ImN52BAKesuYDHUSuPWUDBP8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLFiZFgucqPhirm0YCrn2fo4eNud96Nag8P8W3jtnbk9tjm7AYRedMwBDqsmUrIPsysCzMLXtdpFo63EoZ5yWGrD8m78TYMw61N+2G0JaaHKLbrPpFO6b5tOk1i5wP0kGSjkU/7TxOdztIrgf5Zg9wizv87nyn4LltP5diTthkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 90DCA227A87; Wed, 15 Oct 2025 06:41:09 +0200 (CEST)
Date: Wed, 15 Oct 2025 06:41:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: remove xlog_in_core_2_t
Message-ID: <20251015044109.GD7253@lst.de>
References: <20251013024228.4109032-1-hch@lst.de> <20251013024228.4109032-7-hch@lst.de> <20251014220757.GL6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014220757.GL6188@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 14, 2025 at 03:07:57PM -0700, Darrick J. Wong wrote:
> > +	__be32		xh_cycle_data[XLOG_CYCLE_DATA_SIZE];
> > +	__u8		xh_reserved[252];
> 
> Just out of curiosity, why do we reserve so much space at the end of the
> extended header?  Wouldn't it have been more efficient to fill all 508
> bytes with xh_cycle_data?

That's something I asked myself when doing this as well.  Or if we're
so inefficient, why don't we at least put the cycle data into the same
offset for both the initial and extended headers.  Also why do we write
xh_cycle into the extended header and don't every read it?

> > +
> > +	__u8	  h_reserved[184];
> > +	struct xlog_rec_ext_header h_ext[];
> 
> Ok, so you're explicitly padding struct xlog_rec_header and
> xlog_rec_ext_header to be 512 bytes now, and making the xlog_rec_header
> have a VLA of xlog_rec_ext_header.

Yes.

> The log buffer crc is computed from the start of xlog_rec_header::h_crc
> to the end(ish) of the xlog_rec_header; and the first 256 bytes of each
> xlog_rec_ext_header, right?

Yes.

> > +++ b/fs/xfs/xfs_log.c
> > @@ -1526,12 +1526,8 @@ xlog_pack_data(
> >  		dp += BBSIZE;
> >  	}
> >  
> > -	if (xfs_has_logv2(log->l_mp)) {
> 
> Is the xfs_has_logv2 still necessary here?
> 
> What happens if log->l_iclog_heads > 1 && !logv2?  Or has the kernel
> already checked for that and aborted the mount?

l_iclog_heads is set based on m_logbsize, and xfs_finish_flags verifies
that it is never bigger than XLOG_BIG_RECORD_BSIZE for v1 logs.

