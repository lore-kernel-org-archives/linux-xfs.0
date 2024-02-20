Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172825A4DE
	for <linux-xfs@vger.kernel.org>; Tue, 20 Feb 2024 07:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708414108; cv=none; b=ImKLkk4cDmQ4tXkLAaF95OLsjqTmOCQNAbS1dYUSMpOBozz5b8Nr5a1rXIQJ+wENz+rMaJX5LqsxMjxmhc3TxAmtm/Kfp1srkuXTPwy047c/L33h6oI6l7V/RHfk5jX874TrU/JJnaTAdZiTqyNSANSbrdQcqI71XzWNiXhsGz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708414108; c=relaxed/simple;
	bh=q6ahpLKjRAameEnTjA3jBSt0db1kAGRG/e40JT+zpdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZO440JVWumNwQ+Rll4BBjxAoXgqixLFudLyDe+kfRlpZp1nExr3QkfXRc6sjgh+jWi6UyCRAesQpiMbnfpPQBPlNaDbugjhNxQ76fn5R0CnCwQvjHIOwmjdnudoZALlx9rugILS1PlLhm5Mr7XQ/lGzrVrK52Vve0F06xr2h0cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D5C5568C4E; Tue, 20 Feb 2024 08:28:21 +0100 (CET)
Date: Tue, 20 Feb 2024 08:28:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: split xfs_mod_freecounter
Message-ID: <20240220072821.GA10025@lst.de>
References: <20240219063450.3032254-1-hch@lst.de> <20240219063450.3032254-4-hch@lst.de> <ZdPiaP+tApjr4K+M@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdPiaP+tApjr4K+M@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 20, 2024 at 10:21:12AM +1100, Dave Chinner wrote:
> I don't think these hunks are correct. blkdelta and rtxdelta can be
> negative - they are int64_t, and they are set via
> xfs_trans_mod_sb(). e.g. in xfs_ag_resv_alloc_extent() we do:
> 
> 	case XFS_AG_RESV_NONE:
>                 field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
>                                        XFS_TRANS_SB_FDBLOCKS;
>                 xfs_trans_mod_sb(args->tp, field, -(int64_t)args->len);
>                 return;
>         }
> 
> Which passes a negative delta to xfs_trans_mod_sb() and adds it to
> tp->t_fdblocks_delta. So that field can hold a negative number, and
> now we pass a negative int64_t to xfs_add_fdblocks() as an unsigned
> uint64_t.....

This area is rather subtle.

For XFS_TRANS_SB_FDBLOCKS, xfs_trans_mod_sb expects enough t_blk_res to
be held to at least balance out the t_fdblocks_delta value, i.e.
xfs_trans_unreserve_and_mod_sb always starts out with a positive value
due to the t_blk_res, and then decrements the actually used block
allocation in t_fdblocks_delta, and then still must end up with 0 or a
positive value, and if a positive value is left it "unreserves" the
reservation per the function name.  Same for the rtextent version.

So we should be fine here, but the code could really use documentation,
a few more asserts and a slightly different structure that makes this
more obvious.  I'll throw in a patch for that.
