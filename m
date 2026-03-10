Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95F1397E6B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147176; cv=none; b=sBGg7yAMIyLjn/vQVPtNp3bIJ427vBN4RYK/G55BZAyxeyijw7Mif/7JwQxPm9LifB7BlPjVg/7hTVGeCP2bToachWkK39QbEXiN22L2lRC1+ZON/YJ8FGEBjtXRkoXLpaPJP+d4oe/Ig0vc/RnFptZteV0xRCb0cfC347cMt2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147176; c=relaxed/simple;
	bh=2d1rODiD7NWOlYIQdONqSDOa0u02nBbQg+3ldZjUdHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmdakPL4YPnVNtwVkGuT1h9C4Jv/TgShamTiLGoVqusgqwV2wPD8hvg/ydpS4MkTuBJ++M2Yx+VNckb28vt8q4rva5E2nQHrnGsbq1MwlRKw0LW6JcbnSNEVXHNbJOpPs6wmkFyIF1iSVWE0wiFET6Iu1tAvnIViV4As83BpYG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9F1D68C4E; Tue, 10 Mar 2026 13:52:51 +0100 (CET)
Date: Tue, 10 Mar 2026 13:52:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dlemoal@kernel.org
Subject: Re: [PATCH 1/4] xfs: factor out isize updates from
 xfs_dio_write_end_io
Message-ID: <20260310125251.GA3323@lst.de>
References: <20260310115555.114197-1-cem@kernel.org> <20260310115555.114197-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310115555.114197-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 10, 2026 at 12:55:04PM +0100, cem@kernel.org wrote:
> +static int
> +xfs_dio_endio_set_isize(
> +	struct inode		*inode,
> +	loff_t			offset,
> +	ssize_t			size)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +
> +	if (offset + size <= i_size_read(inode))
> +		return 0;
> +
> +	spin_lock(&ip->i_flags_lock);
> +	if (offset + size > i_size_read(inode)) {
> +		i_size_write(inode, offset + size);
> +		spin_unlock(&ip->i_flags_lock);
> +	} else {
> +		spin_unlock(&ip->i_flags_lock);
> +	}
> +
> +	return xfs_setfilesize(ip, offset, size);

This now calls xfs_setfilesize for the case where we don't update
the inode size.  This looks harmless to be, but isn't needed.

This should become something like:

	if (offset + size <= i_size_read(inode)) {
		spin_unlock(&ip->i_flags_lock);
		return 0;
	}
	i_size_write(inode, offset + size);
	spin_unlock(&ip->i_flags_lock);
	return xfs_setfilesize(ip, offset, size);

