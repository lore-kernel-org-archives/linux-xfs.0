Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3BD35A398;
	Tue, 21 Jul 2026 03:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784603020; cv=none; b=nrFhvqoyZr8b3pHJZXQIMydmeruIwNPlweGqISkXI6rXuh68PZRcW8KFrnC7hQMjjzOLGMwoCKPLxUpFQcruJNWl6wGiXcdFPhop0VNKu4jYODx7KEq5IwCw6T1aeIHRDrIYrlYCZO6jZ3cgojLk8OXyLeqq16uZMlE/oWpeypA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784603020; c=relaxed/simple;
	bh=WBCQHwPhPPr6z90ZVGRMTO5GnQ3f4Fd1gqLNlVhZHQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAvzSl79anJZjw1hORiyhKV33EHZt1gW3Kyl/xHqXGxWyYm5zli4Uc7gH6g8FyRQgQwpN5DcNOsAB/ty7JZGJZl1QwtglqynBjivfki6rxK3Q7EJ+44TgYsbGiUvWJtOQ5JcjG2A151vJJQaGa2Drzar7ohuPwEatZ7chTJcG8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mT232Ioc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mT232Ioc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0626B1F00A3A;
	Tue, 21 Jul 2026 03:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784603019;
	bh=dIUjqOdXz8s3GU3FSf0DNsxZW0ec4Q3ON+kEXcE98vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mT232IocgPs9Mb1fu7096j6jmqvMxbBUove0Ev1eLwr5EnWlYz7ZintjYTRrYJ4WH
	 ABT22ytRyOZp4yO/ZU3UAo428RY/VAaFcNwsKDTF1yJsTxMazumu3vNFMJ4qSgz5Mz
	 X7bJwtUHf9uaGbVxOQ/xNFeKWzVguaDq1xQQfKZst0WwK0ScHsjvHztTxGpqTtCqrk
	 XpCX+3SvfGm0/O6VxYh2Fhzy0lix8aMdc3KB7YrcEJt1Be2ul3uWhG3IGj6zgn2FfL
	 aoUVpeh1j1ywaE3COIh/ZYU5FzvSzticO8wz98qLfUd/nayCoMuzMRNsuNHfiEn5Eu
	 H1YjkXDI7OgHw==
Date: Mon, 20 Jul 2026 20:03:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 1/6] fs: add write-stream management ioctls
Message-ID: <20260721030338.GU7380@frogsfrogsfrogs>
References: <20260717125538.508925-1-joshi.k@samsung.com>
 <CGME20260717125627epcas5p3f5ad1cf917d563cc061e571b2f932319@epcas5p3.samsung.com>
 <20260717125538.508925-2-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-2-joshi.k@samsung.com>

On Fri, Jul 17, 2026 at 06:25:33PM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Wire up the userspace interface for write stream management via four
> ioctls:
> 
>   FS_IOC_WRITE_STREAM_GET_MAX  query the max streams supported
>   FS_IOC_WRITE_STREAM_OPEN     open a stream id, returns a stream fd
>   FS_IOC_WRITE_STREAM_SET      attach the stream fd to an open file
>   FS_IOC_WRITE_STREAM_GET      query the stream id value set on a file
> 
> Application should query the available streams by using
> FS_IOC_WRITE_STREAM_GET_MAX. If returned value is N, valid stream id for
> the file are 1 to N.
> 
> Application calls FS_IOC_WRITE_STREAM_OPEN to get fd for a stream-id.
> By default, kernel picks an available stream-id and returns the fd for
> it. The flag FS_WRITE_STREAM_OPEN_EXACT can be used to request a
> specific stream_id. This is useful if application cares about keeping a
> stable stream-id-to-spatial-isolation-bucket mapping across restarts.

Hmm.  If FS_IOC_WRITE_STREAM_OPEN returns an fd that represents an open
stream id, then why does STREAM_SET below take a pointer to a signed
s32?  And why does STREAM_GET take a pointer to a u32?

IOWs it'd be much easier to distinguish these things if the ioctls took
pointers to structs instead of u32/s32 pointers directly.

Also it's a little weird that STREAM_SET associates an open file with a
stream fd, but STREAM_GET returns the stream *id* (not the fd)
associated with an open file.

Can you extract the stream id from the fd that FS_IOC_WRITE_STREAM_OPEN
returns?

--D

> Suggested-by: Christoph Hellwig <hch@lst.de>
> Co-developed-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  include/uapi/linux/fs.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index bd87262f2e34..a756d27bdf84 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -345,6 +345,22 @@ struct file_attr {
>  /* Get logical block metadata capability details */
>  #define FS_IOC_GETLBMD_CAP		_IOWR(0x15, 2, struct logical_block_metadata_cap)
>  
> +struct fs_write_stream_open {
> +	__u32		stream_id;	/* IN: requested id if OPEN_EXACT set; OUT: assigned id */
> +	__u32		flags;		/* IN: FS_WRITE_STREAM_OPEN_* */
> +};
> +
> +/*
> + * Flag to ask for specific stream_id, otherwise kernel can return any.
> + * Fails with -EBUSY if that stream_id is already held
> + */
> +#define FS_WRITE_STREAM_OPEN_EXACT	(1 << 0)
> +
> +#define FS_IOC_WRITE_STREAM_GET_MAX	_IOR('f', 135, __u32)
> +#define FS_IOC_WRITE_STREAM_OPEN	_IOWR('f', 136, struct fs_write_stream_open)
> +#define FS_IOC_WRITE_STREAM_SET		_IOW('f', 137, __s32)
> +#define FS_IOC_WRITE_STREAM_GET		_IOR('f', 138, __u32)
> +
>  /*
>   * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
>   *
> -- 
> 2.25.1
> 
> 
