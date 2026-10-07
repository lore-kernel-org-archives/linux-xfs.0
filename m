Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2B33C73C1
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 20:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791405341; cv=none; b=FWnPuqQt7LcV8JeTxNZKT4mlsbLW1kTdzfcOxbu+jU4cLzZCgWtHjWUOt3jYI8q/GBi6pglyDc10LF41WKe7RsT2tv+uS8e5tiwdlsOW3nKFV6K7Emsd6nDO7WqdVuaVeYOKWCi0G19HUtZyuWYdHeIOdeDdpqgz1bhv5c0HgTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791405341; c=relaxed/simple;
	bh=23doTaXivkIXP4msqrlCDoHEsIQOPPUp9LwIxom7knY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyLNHJgCIqkbHPHwkutTKz9MVt2AxVq2rLG9jKGLZnhExHtilTfRVX0/r3c+ngATDILQJdwxkwqKDZz1krmGsEOhGQ+9J+JnBVNbQqrlEmstNV7xECAEz3K9vhB7t9HCEogbOVxqe/UWzMOQj8UzOxvx6WDTtNZ8wFvXzIFPDy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rfes1OaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rfes1OaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01541F000FF;
	Wed,  7 Oct 2026 20:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791405340;
	bh=LkhwP3YrKwwlbuUkKhuLWdb33CFj7cfMd75ZQd8FiaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rfes1OaCJFgOYBrs8IVu/jnpFz+WLcqdYwAH6sY1utNOxJoFV2xBNHU2/WZS0jGN+
	 mepfE3KMVymZ0/cSNl9n1oJG84+ReZ1d+xOZfM7hnDFPIx1+LQdJd60+XzRdoRgxl2
	 GTjL7vF1aq5uW01HN7XeJXdJVGPhTWGk76Q9NoZCayA2K192V3znPPPsMlpZeVtW/y
	 0DhejdPjDX43xDQYCY2TadLAFjm0pqVHG+4qcXSj+lNMwIww6Tovj/odSpei93EA7L
	 0AeRYfXMnUEmBEkt+clEPrMYpWIuZczGyQtzkD2Jpg6U7cqk+lLnt0pItK+KUmrEBF
	 AqDPn/0S9RmDA==
Date: Thu, 8 Oct 2026 07:35:31 +1100
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Norbert Szetei <norbert@doyensec.com>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: fix exchange-range-to-eof file size exchange
Message-ID: <asatE7Sr3r5oIglx@dread>
References: <20261007170227.GH2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007170227.GH2705364@frogsfrogsfrogs>

On Wed, Oct 07, 2026 at 10:02:27AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Norbert Szetei posted a patch containing an incomplete description of a
> bug in XFS_IOC_EXCHANGE_RANGE's TO_EOF flag.  The bug tricks
> exchange-range into modifying a file so that it has shared blocks
> starting beyond EOF, which is never allowed because files never have
> written data beyond EOF, and you can only share written data blocks.
> This is key to all the incorrect behavior that follows.
.....
> @@ -1005,10 +1006,18 @@ xfs_exchmaps_init_intent(
>  		return xmi;
>  	}
>  
> +	/*
> +	 * If the caller wanted, set each file's size to that file's exchange
> +	 * offset + length exchanged from the other file because the ranges in
> +	 * each file might be different lengths.
> +	 */
>  	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
> +		loff_t	off1 = XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
> +		loff_t	off2 = XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
> +
>  		xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
> -		xmi->xmi_isize1 = req->ip2->i_disk_size;
> -		xmi->xmi_isize2 = req->ip1->i_disk_size;
> +		xmi->xmi_isize1 = off1 + (req->ip2->i_disk_size - off2);
> +		xmi->xmi_isize2 = off2 + (req->ip1->i_disk_size - off1);
>  	}

Yup, that comment helps :)

Rest of the fix looks good, too.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
dgc@kernel.org
