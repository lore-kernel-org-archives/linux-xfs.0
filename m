Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D646519F13F;
	Mon,  9 Mar 2026 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773074006; cv=none; b=LtOXYXaYRQov8VXK6eK1QWvX0Tc9CDAVEsxFFX5yz5LBsn38s8CSLqdRL222xsp+Cl5aDNFyYZS/r5GACr7QOwJznT5pambCn3IUkoxBwsHRxlxpECRMQQVWUENnBtJ/7bM1PmPYMzJeAlBytTG/OR/5c1SI36QLJM8ga4Aw/i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773074006; c=relaxed/simple;
	bh=ygz6b1Si4VW69qQpKSJN76zIHZPw5r/aGibbXVcJ0ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Owp8mBHGLlYzvYrqVhltxRDxSG+s9hn8mHBdWaxAVzpNtE0UyETAD/ACN+R+dCRcKSqEsGHrhmxOGkLHiAX0w59l6L5fYxn2RA8CAUGP455YP5L6STUb2N+WzGGlbsrYh/lNGeiCcq4SmIxub1l7KQhnU3MK+qqBoXm/SmY8Lg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEI9R5ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEI9R5ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FFAC4CEF7;
	Mon,  9 Mar 2026 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773074006;
	bh=ygz6b1Si4VW69qQpKSJN76zIHZPw5r/aGibbXVcJ0ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZEI9R5baFTuQ8CvPelSiLav4gZr37b4r8k2cdfp2pSEnJMZ0Mya+T3mIXFvAjbvGX
	 uWDaCDScpWVuTHT656QVMxqkYk5Ac2dMX7MDAwsl1mQQna+9PSwmuOdYDsMjo9F3TV
	 xS2mOtDOwxI9PAE+TRBVnKGxek/OFN+kzhN1UTRfoCI2Fk90nYnNls4p5yp/QcQTvg
	 KGC0ufOQF/yTeTGoYqcLtD67dIFNtfwQrY+2bq17q+3sFhLYMhyTFCft3d8z5ek8qc
	 gAFSwJB0YUUbbvWjml95YRwvYkhrGMcvFP5z8dzdeMyU0/KnUjYxFX2uQF4xQ7mamh
	 aPgpFyP/Du6ug==
Date: Mon, 9 Mar 2026 09:33:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, jack@suse.cz, cem@kernel.org,
	kbusch@kernel.org, axboe@kernel.dk, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, gost.dev@samsung.com,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: add generic write-stream management ioctl
Message-ID: <20260309163325.GE6033@frogsfrogsfrogs>
References: <20260309052944.156054-1-joshi.k@samsung.com>
 <CGME20260309053427epcas5p23419afbe49e4e35526388601e162ee94@epcas5p2.samsung.com>
 <20260309052944.156054-2-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309052944.156054-2-joshi.k@samsung.com>

[cc linux-api because this is certainly an API definition]

On Mon, Mar 09, 2026 at 10:59:40AM +0530, Kanchan Joshi wrote:
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
> Setting a larger value than available streams is rejected.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/uapi/linux/fs.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 70b2b661f42c..4d0805b52949 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -338,6 +338,18 @@ struct file_attr {
>  /* Get logical block metadata capability details */
>  #define FS_IOC_GETLBMD_CAP		_IOWR(0x15, 2, struct logical_block_metadata_cap)
>  
> +struct fs_write_stream {
> +	__u32		op_flags;	/* IN: operation flags */
> +	__u32		stream_id;	/* IN/OUT:  stream value to assign/guery */
> +	__u32		max_streams;	/* OUT: max streams values supported */
> +	__u32		rsvd;
> +};

This isn't an very cohesive interface -- GET_MAX probably only needs
op_flags and max_streams, right?  And GET/SET only use op_flags and
stream_id, right?

> +#define FS_WRITE_STREAM_OP_GET_MAX		(1 << 0)
> +#define FS_WRITE_STREAM_OP_GET			(1 << 1)
> +#define FS_WRITE_STREAM_OP_SET			(1 << 2)
> +
> +#define FS_IOC_WRITE_STREAM		_IOWR('f', 43, struct fs_write_stream)

EXT4_IOC_CHECKPOINT already took 'f' / 43.  I /think/ there's no problem
because its argument is a u32 and ioctl definitions incorporate the
lower bits of of the argument size but you might want to be careful
anyway.

--D

>  /*
>   * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
>   *
> -- 
> 2.25.1
> 
> 
