Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794303702;
	b=L6RzbJtcjRp5lDe6/ue+ymVDXVYVbLl+7+L04EDdgpHa4c5bljdunpaPinFHsGSmMlJM
	 EFzs2yYLNYsixlwHvRwTaljXBpwR8Htxuo7m+oma7VuCEV5UxWOZR8DurmCpjk7xUWA2k
	 5E1N3MsQmywZbo5AAlhw+KpeW8h0tqrSSos73UZagzc9XWrZe/WLjgMNNlFEi0PCOlkV0
	 m2mYY5TBvvBwrNUFovPEJycAcBNWgBhow1mHu0LcLh5TQu5nglgPaY3cqN8NuI2JZD4CO
	 C3OXT0PNQrYo4d8i3u5gR5JOTueZy/hwR1F12T/JyJU7rhjPOob2r78VIkL3YyQ9bLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794303702;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6n/yC+liQ+buoND9hqvVFuCxVFLLPdfTSqhfFh/Q6Qw=;
	b=0Z/Qnb537W/0SsP2HCTRjp4iWL1Fk6G7k/ZzmeKZSA5U160NMJjzDRaAJMhnxVyRmx93
	 hAij6RAevjuwUb2ydszqxuI78ZduoemqU5IERarwQquPTL2DPlHJsURmLXdYMN7pR5h67
	 d7ajPAI5kNAqNTnR8NNxAJGpFzFlcrHsYz7dHxppE/KWSeIOS0YgubHEIE0wIwHq5RhCB
	 7S/qMdBRDBnoKhzdttMw17kX71m1eI5Y2svktaK4677lmWwiNxR0161BrZAjCrcPZnMW/
	 SC2i7C/fpdQ1l9q7hlp/dBvXOteB0Tg8X3etiLboaR4CaIaM7brCqoBmdo2x6jLQM8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BHoOnoIo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028F2606A933;
	Tue, 10 Nov 2026 09:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BHoOnoIo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BE31F0089F;
	Tue, 10 Nov 2026 09:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794303701;
	bh=6n/yC+liQ+buoND9hqvVFuCxVFLLPdfTSqhfFh/Q6Qw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BHoOnoIo3zYriw9BZlqZnLxYeZXwtj9ZcdmVYeD22i+0Kr59SIQT/O+TAgwkivvRV
	 sD6nkAxEzGaRpktlIq61x5darwC1kJnak7rj90zgqkG84b/p8y/CE7COro4PZm9OnV
	 sOY6yFPKymVCkEjXReS7kxgTzRecvBoh5A0JUGWEUTvA/WQMp9+zqnINqxnmwlsb/r
	 JCZwLvBaWzrLdxQAQRyhuzUNeyU/SkrPUBA5AtbQbOHWym7tAJSTOp9dKZoSj7MBMl
	 WIWdY44FpVyMr7ZNPQrdy2ESBQGlmtTXajx5S+krCJz9SvujPiSqBrDCYgxhEUkaQM
	 c4qKNokIHu5/A==
Date: Tue, 10 Nov 2026 10:41:36 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, david@fromorbit.com, jack@suse.cz, djwong@kernel.org, 
	josef@toxicpanda.com, hch@lst.de, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 05/10] fs: validate atomic writes after O_APPEND and
 limits
Message-ID: <avLhEEZjDdQha7ul@nidhogg.toxiclabs.cc>
References: <20261109235111.14129-1-mason@kernel.org>
 <20261109235111.14129-6-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109235111.14129-6-mason@kernel.org>

On Mon, Nov 09, 2026 at 06:51:16PM -0500, Chris Mason wrote:
> An RWF_ATOMIC write on XFS with reflink can expose stale disk contents
> if O_APPEND or RLIMIT_FSIZE leaves it sector aligned but not block
> aligned.
> 
> XFS and ext4 call generic_atomic_write_valid() on the range that the
> caller passed. But generic_write_checks() changes the range later:
> O_APPEND moves the position, and RLIMIT_FSIZE cuts the length. XFS can
> then fill only a part of a new block, and still map the whole block into
> the file:
> 
>     block size 4096, i_size 512, O_APPEND
>     validated:        0 to 4095
>     written:          512 to 4607
>     new blocks:       0 to 8191
>     stale below EOF:  0 to 511
> 
> The fix used here is to validate an atomic write in
> generic_write_checks(), after its range is final, and to refuse one that
> was cut. XFS no longer picks the path of an atomic write by the
> alignment of the range that the caller passed.
> 
> Fixes: f096207d3276 ("xfs: Validate atomic writes")
> Fixes: 43c696f9d094 ("ext4: Check for atomic writes support in write iter")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko caught an issue on this patch (and some of the next ones) worth
investigating in depth.

In this one it says it may cause ext4 to silently convert an atomic
write into a buffered non-atomic. I know that ext4 tends to move from
DIO to buffered IO by default, but silently dropping atomic doesn't seem
right in this case.

Looking through the report and the code it indeed seems a valid
possibility in some FS configurations as ext4_dio_alignment checks may
cause ext4_should_use_dio to return false (dio_align == 0 cases).

Giving ext4's special fallback, perhaps just leave the
generic_atomic_write_valid check in place for ext4?


> ---
>  fs/ext4/file.c    |  4 ----
>  fs/read_write.c   | 13 +++++++++++++
>  fs/xfs/xfs_file.c | 17 +++++++++++------
>  3 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 50d3c92709c8..e301d4faf1c3 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -802,10 +802,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		if (len < EXT4_SB(inode->i_sb)->s_awu_min ||
>  		    len > EXT4_SB(inode->i_sb)->s_awu_max)
>  			return -EINVAL;
> -
> -		ret = generic_atomic_write_valid(iocb, from);
> -		if (ret)
> -			return ret;
>  	}
>  
>  	if (iocb->ki_flags & IOCB_DIRECT)
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 676728310899..1b34b7382619 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1775,6 +1775,19 @@ ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  	if (ret)
>  		return ret;
>  
> +	/*
> +	 * O_APPEND has moved the position and the file size limits have
> +	 * shortened the write by now, so this is the range to validate.  An
> +	 * atomic write is all or nothing, so refuse it if it got shorter.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (count != iov_iter_count(from))
> +			return -EINVAL;
> +		ret = generic_atomic_write_valid(iocb, from);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	iov_iter_truncate(from, count);
>  	return iov_iter_count(from);
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index be1f775128d1..153f53f964b9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -926,12 +926,21 @@ xfs_file_dio_write(
>  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
>  		return -EINVAL;
>  
> +	/*
> +	 * An atomic write is at least one block long, and generic_write_checks()
> +	 * refuses it unless its final position is a multiple of its length.  So
> +	 * there is no unaligned case to handle for it.
> +	 */
> +	if (iocb->ki_flags & IOCB_ATOMIC) {
> +		if (xfs_is_zoned_inode(ip))
> +			return xfs_file_dio_write_zoned(ip, iocb, from);
> +		return xfs_file_dio_write_atomic(ip, iocb, from);
> +	}
> +
>  	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
>  		return xfs_file_dio_write_unaligned(ip, iocb, from);
>  	if (xfs_is_zoned_inode(ip))
>  		return xfs_file_dio_write_zoned(ip, iocb, from);
> -	if (iocb->ki_flags & IOCB_ATOMIC)
> -		return xfs_file_dio_write_atomic(ip, iocb, from);
>  	return xfs_file_dio_write_aligned(ip, iocb, from,
>  			&xfs_direct_write_iomap_ops, &xfs_dio_write_ops, NULL);
>  }
> @@ -1128,10 +1137,6 @@ xfs_file_write_iter(
>  
>  		if (ocount > xfs_get_atomic_write_max(ip))
>  			return -EINVAL;
> -
> -		ret = generic_atomic_write_valid(iocb, from);
> -		if (ret)
> -			return ret;
>  	}
>  
>  	if (IS_DAX(inode))
> -- 
> 2.55.0
> 
> 
