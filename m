Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2C51E0DE8;
	Wed, 24 Jun 2026 18:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324209; cv=none; b=pxGOQ9M9vF0UNcHS78dZFlQz+pYmTLZOAIYbHkb6KkMYDKVmDZJdTkg5hXtOkO1ey+Oibx09/6+PZMLxjLS1iFIHJcK8YAA18O8LBtL0YbyshGOAB+gX3xNKsUUvukZBTyOg3kAy8FvPAVHbcONnuKLenDZgPsYQza6uHBKqt4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324209; c=relaxed/simple;
	bh=QO23kDMImtM+5HOMNrMXLHItHj21ff677Zh529A456k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iV7Me7AoaNffL9/HCR2LpdzKaESAcp4IqUFE+p6lUezYHscW+YXbRSRu2QBPOjfM/TEWNgng6EQteVfi//JhEaw0Ixx+4yz6JZF2XIuFasc1Vf1o5FlWYu1CDUvnTkX2cE7xWlnfTYyBrtw5xxyDCCJwnHE2JgLEDaSElIG43jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=etnhE0UE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="etnhE0UE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E4371F000E9;
	Wed, 24 Jun 2026 18:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324208;
	bh=rpMUP6qY4/gUuajVubQNXi13lPGi6siMMKZVoDS+Kb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=etnhE0UERKjfGnj++pfg5gIAVWxOwmMipcOGdwJ7tnK3bQsVlatIG7Lw0yZUUtDE5
	 vyg4QZ6JZIhWzKrMgD6hmi2FegELsqfKTWcWhFXQKXEMIIcVWWEEVxR0Sdtb8/QU1a
	 NjIXOKpD8UX+FgJRpVLy8kY+6urD8AsWR+obgnDHQGxxT4S63GD0urlxNCEoqKwQB7
	 tihb0t6ynzxi9JAjD2u4ny2ZeZLzX84PVJdDq74G8YYvTIoRJw86v0/HqOB3UdHUog
	 i3bevv7WrBgSDdfbMxEUYpTvklt8G7OKeBQBummCOfarnFmFRsNJqoyyj+VRPx0Dcr
	 7qnrXEDMYcWSw==
Date: Wed, 24 Jun 2026 11:03:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com
Subject: Re: [PATCH v3 1/6] fs: add generic write-stream management ioctl
Message-ID: <20260624180327.GV6078@frogsfrogsfrogs>
References: <20260616180555.33338-1-joshi.k@samsung.com>
 <CGME20260616181242epcas5p28887b4de29580d5fc74448f2b0d45a1d@epcas5p2.samsung.com>
 <20260616180555.33338-2-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616180555.33338-2-joshi.k@samsung.com>

On Tue, Jun 16, 2026 at 11:35:50PM +0530, Kanchan Joshi wrote:
> Wire up the userspace interface for write stream management via a new
> vfs ioctl 'FS_IOC_WRITE_STEAM'.
> Application communictes the intended operation using the 'op_flags'
> field of the passed 'struct fs_write_stream'.
> Valid flags are:
> FS_WRITE_STREAM_OP_GET_MAX: Returns the number of available streams.
> FS_WRITE_STREAM_OP_SET: Assign a specific stream value to the file.
> FS_WRITE_STREAM_OP_GET: Query what stream value is set on the file.
> 
> Application should query the available streams by using
> FS_WRITE_STREAM_OP_GET_MAX first.
> If returned value is N, valid stream values for the file are 0 to N.
> Stream value 0 implies that no stream is set on the file.

You might want to make that an explicit #define then.

> Setting a larger value than available streams is rejected.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/uapi/linux/fs.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 13f71202845e..9e87271e610b 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -338,6 +338,20 @@ struct file_attr {
>  /* Get logical block metadata capability details */
>  #define FS_IOC_GETLBMD_CAP		_IOWR(0x15, 2, struct logical_block_metadata_cap)
>  
> +struct fs_write_stream {
> +	__u32		op_flags;	/* IN: operation flags */
> +	union {
> +		__u32		stream_id;	/* IN/OUT:  stream value to assign/guery */

"query"?

--D

> +		__u32		max_streams;	/* OUT: max streams values supported */
> +	};
> +	__u64		rsvd;
> +};
> +
> +#define FS_WRITE_STREAM_OP_GET_MAX		(1 << 0)
> +#define FS_WRITE_STREAM_OP_GET			(1 << 1)
> +#define FS_WRITE_STREAM_OP_SET			(1 << 2)
> +
> +#define FS_IOC_WRITE_STREAM		_IOWR('f', 135, struct fs_write_stream)
>  /*
>   * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
>   *
> -- 
> 2.25.1
> 
> 
