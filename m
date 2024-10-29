Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A7A802
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730217088; cv=none; b=HlGKzRMomnHQHoo8jCFmMESKwcRuSmacJ0ivsA3VDvKCqBRDgGD5fUtn7NlbsTA9TrjZIjwwM5EMFCzT3H9EPDhUAz7Z/muFEUz95hqUQNLEW9wQeTKMwWgQ+C4Kf2esTI3WVJT0NmtcTuFMDnwxvdzR/9g1aqcynY0hpmKnq9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730217088; c=relaxed/simple;
	bh=n+i1qcDD29X6ATXI/hlrpUWfu9iZqnmy3q337wlZVvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0w3MzJZYHhiGOyDsYFVXTSENVXiskjb6lzullxproGsgvCNzqyGJIuFccwYgV9/EVET4hSHm+ZO3GZ2eFBMUKSL7+6lduwr3MDQXJDs/S9M9Td1YFcDvDgMR/kL2JAWxi/b7YCI7EGjz1y2UfFbeiXY9Xudi3d4wh0ZWWmQjj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ef5qVQ0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ef5qVQ0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7F7C4CECD;
	Tue, 29 Oct 2024 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730217087;
	bh=n+i1qcDD29X6ATXI/hlrpUWfu9iZqnmy3q337wlZVvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ef5qVQ0Yyntnqh1CvSWPjJUSEtLkBtm6Y3Moagma67gjJ0SiYM9U23I08+qZUHch7
	 JPQi2pk5zsAPNhVg3GDUY/UqegnUK1J1dheD55TDT2n1/q9yaw/OqCd3zTlPUwvZYX
	 6tQzfUk17p1YNPUqb3Gk+D6BD/lYY38U7UxwvIU9HQqW+ALstzOyEo+6N+HoW337c3
	 YP9iYc0BZCA6O6optGvYvsTzuykUwCDxujbSnmP23iVw6DV5HgsnJlGR9Ucn8eqRHo
	 auyaTKMaNXp6IzOd48Vn5sZib1wiSvmq2FUWEF8ssdZzxTDWIiRXzIGrPGAxQ9hMog
	 SuW6Xh1Qf7lXg==
Date: Tue, 29 Oct 2024 08:51:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: split the page fault trace event
Message-ID: <20241029155127.GU2386201@frogsfrogsfrogs>
References: <20241029151214.255015-1-hch@lst.de>
 <20241029151214.255015-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151214.255015-2-hch@lst.de>

On Tue, Oct 29, 2024 at 04:11:57PM +0100, Christoph Hellwig wrote:
> Split the xfs_filemap_fault trace event into separate ones for read and
> write faults and move them into the applicable locations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay nice split!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c  |  8 ++++++--
>  fs/xfs/xfs_trace.h | 20 ++++++++++++--------
>  2 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b19916b11fd5..20f7f92b8867 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1425,6 +1425,8 @@ xfs_dax_read_fault(
>  	struct xfs_inode	*ip = XFS_I(file_inode(vmf->vma->vm_file));
>  	vm_fault_t		ret;
>  
> +	trace_xfs_read_fault(ip, order);
> +
>  	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
>  	ret = xfs_dax_fault_locked(vmf, order, false);
>  	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> @@ -1442,6 +1444,8 @@ xfs_write_fault(
>  	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
>  	vm_fault_t		ret;
>  
> +	trace_xfs_write_fault(ip, order);
> +
>  	sb_start_pagefault(inode->i_sb);
>  	file_update_time(vmf->vma->vm_file);
>  
> @@ -1485,12 +1489,12 @@ __xfs_filemap_fault(
>  {
>  	struct inode		*inode = file_inode(vmf->vma->vm_file);
>  
> -	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
> -
>  	if (write_fault)
>  		return xfs_write_fault(vmf, order);
>  	if (IS_DAX(inode))
>  		return xfs_dax_read_fault(vmf, order);
> +
> +	trace_xfs_read_fault(XFS_I(inode), order);
>  	return filemap_fault(vmf);
>  }
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index ee9f0b1f548d..efc4aae295aa 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -827,28 +827,32 @@ DEFINE_INODE_EVENT(xfs_inode_inactivating);
>  TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
>  TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
>  
> -TRACE_EVENT(xfs_filemap_fault,
> -	TP_PROTO(struct xfs_inode *ip, unsigned int order, bool write_fault),
> -	TP_ARGS(ip, order, write_fault),
> +DECLARE_EVENT_CLASS(xfs_fault_class,
> +	TP_PROTO(struct xfs_inode *ip, unsigned int order),
> +	TP_ARGS(ip, order),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
>  		__field(unsigned int, order)
> -		__field(bool, write_fault)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = VFS_I(ip)->i_sb->s_dev;
>  		__entry->ino = ip->i_ino;
>  		__entry->order = order;
> -		__entry->write_fault = write_fault;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx order %u write_fault %d",
> +	TP_printk("dev %d:%d ino 0x%llx order %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
> -		  __entry->order,
> -		  __entry->write_fault)
> +		  __entry->order)
>  )
>  
> +#define DEFINE_FAULT_EVENT(name) \
> +DEFINE_EVENT(xfs_fault_class, name, \
> +	TP_PROTO(struct xfs_inode *ip, unsigned int order), \
> +	TP_ARGS(ip, order))
> +DEFINE_FAULT_EVENT(xfs_read_fault);
> +DEFINE_FAULT_EVENT(xfs_write_fault);
> +
>  DECLARE_EVENT_CLASS(xfs_iref_class,
>  	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
>  	TP_ARGS(ip, caller_ip),
> -- 
> 2.45.2
> 
> 
