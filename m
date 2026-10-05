Received: from mta1.migadu.com (out-217.mta1.migadu.com [95.215.58.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC6E1FA859
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217507; cv=none; b=ifxnIALkcs8nnWfEwCdW5zoeqd+iIbFndk5Hjn5I3BmSgjKhr8p010d2qpcwO6iMclRUgBl/9aOxfH8U3jHUQZSpNFGCjRzqeIjYHIOl+i02YRkDEYC5E3d2o+7tbxJn6aLSp344VV8M2cysZ8C6KJ4Yg1tiq37Oaukf9BJ6emI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217507; c=relaxed/simple;
	bh=P/LiebPBVX8FtgC9PL7tvIpCkwMo4eJVCgJnQtrZNxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsAP0ZY1IwHfjtI9Usb/q09oIWUxkceLKbVaFR+j44CzhLMBR7OoWlCTT0bZHJJ4sqTZiaQZfh2Kr/ZryH+nN1n8pi8ANW4vWcio3JG7EONMemVAG2y3Uzg1EuZXFXo3ibuoIkRgFfkYy+M7H/y5AAtUBQrYYnn/wiKGAwu7rTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CmKSU9l+; arc=none smtp.client-ip=95.215.58.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CmKSU9l+"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=P/LiebPBVX8FtgC9PL7tvIpCkwMo4eJVCgJnQtrZNxo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791217502; v=1; x=1791822302;
 b=CmKSU9l+C1yC0sOwh58PYg6PrRMvR5e6H33Af3cfHDwI6xhRdWHNIO05vPDuoLOuTz0XLn4j
 5Ir+XqTE2zISEKNjg8fz4NooWCxj3CIUNzIzVLdIwGtvhNGag+u5PsFtGYfwmS0EjR71Iy9+JYw
 VcdCmFHB6YxNNHKvMn+2qaQc=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1fb2db2aae2dc482;
	Mon, 05 Oct 2026 16:25:02 +0000
X-Mizu-Trace-ID: 1fb2db2aae2dc482
X-Migadu-Flow: FLOW_OUT
Date: Mon, 5 Oct 2026 18:24:48 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: John Garry <john.garry@linux.dev>
Cc: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org, 
	linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, gost.dev@samsung.com
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
Message-ID: <asOpaPuHF072GJwt@quentin>
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <8d9babb0-5d36-427d-b4a2-5a3e9664a796@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d9babb0-5d36-427d-b4a2-5a3e9664a796@linux.dev>

> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index d1306e723899..8c8b14f94ede 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -620,6 +620,12 @@ xfs_get_atomic_write_min(
> >   	return 0;
> >   }
> > +static inline enum xfs_group_type
> > +xfs_inode_group_type(struct xfs_inode *ip)
> > +{
> > +	return XFS_IS_REALTIME_INODE(ip) ? XG_TYPE_RTG : XG_TYPE_AG;
> > +}
> 
> would this be better is a common location (so that it could be reused)?
> 

Probably to xfs_mount.h?

> > +
> >   unsigned int
> >   xfs_get_atomic_write_max(
> >   	struct xfs_inode	*ip)
> > @@ -642,19 +648,20 @@ xfs_get_atomic_write_max(
> >   	 * then advertise a maximum size of whatever we can complete through
> >   	 * that means.  Hardware support is reported via max_opt, not here.
> >   	 */
> > -	if (XFS_IS_REALTIME_INODE(ip))
> > -		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].awu_max);
> > -	return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
> > +	return XFS_FSB_TO_B(mp, mp->m_groups[xfs_inode_group_type(ip)].awu_max);
> >   }
> >   unsigned int
> >   xfs_get_atomic_write_max_opt(
> >   	struct xfs_inode	*ip)
> >   {
> > +	struct xfs_mount	*mp = ip->i_mount;
> >   	unsigned int		awu_max = xfs_get_atomic_write_max(ip);
> 
> xfs_get_atomic_write_max() value is calculated based on HW atomic support. I
> am wondering if we should add a function to just give the max CoW-based
> atomic, and have it called here and from xfs_get_atomic_write_max(). Not a
> big deal, though.

Could you elaborate this comment?

I do remove any HW dependency in xfs_get_atomic_write_max() calculation
as a part of this patch.

> 
> > +	xfs_extlen_t		align_max_fsb;
> > +	unsigned int		opt;
> >   	/* if the max is 1x block, then just keep behaviour that opt is 0 */
> > -	if (awu_max <= ip->i_mount->m_sb.sb_blocksize)
> > +	if (awu_max <= mp->m_sb.sb_blocksize)
> >   		return 0;
> >   	/*
> > @@ -663,7 +670,17 @@ xfs_get_atomic_write_max_opt(
> >   	 * less than our out of place write limit, but we don't want to exceed
> >   	 * the awu_max.
> >   	 */
> > -	return min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
> > +	opt = min(awu_max, xfs_inode_buftarg(ip)->bt_awu_max);
> > +
> > +	/*
> > +	 * REQ_ATOMIC writes also have to be naturally aligned on disk, so we
> > +	 * cannot promise more than the largest extent that the allocator is
> > +	 * able to align within a group.
> > +	 */
> > +	align_max_fsb = xfs_calc_group_awu_align_max(mp,
> > +						xfs_inode_group_type(ip));
> > +
> > +	return min_t(xfs_fsize_t, opt, XFS_FSB_TO_B(mp, align_max_fsb));
> 
> unsigned int? But is there a possibility that the value in XFS_FSB_TO_B(mp,
> align_max_fsb) can exceed an unsigned int?

We are limited by `opt` length which is an unsigned int. I do use
min_t(xfs_fsize_t, ..) for calculation to avoid any truncation error.

-- 
Pankaj
