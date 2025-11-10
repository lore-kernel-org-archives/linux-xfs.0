Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568F031280E
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781895; cv=none; b=rDji+RsgZHqG8VHTsw0uQ4gmPKqafa4GAej6n8iZsNwF0Fb6jJkYoO1cJvSWg0s6Z1t+L5MyYalt2f44t7A/ZBM35CTYj+ofRMlNo5855uF5DC0J7CTZoZYByxW0FFIWNAOKO2aVI0z7SAr5l8+CR3XvBpZXN8IECKUp4Wdd5Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781895; c=relaxed/simple;
	bh=HOUCuTxWwKHYskDLNwEKHT2ZtC97epKNJQ0iYXnYKSw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=U1p4i3c6Xpq9F8y4+65CYUmVA1aiLMcXkjJw6rx2zgjyur/8yqEMDyxN+oo10K2P45ZmqHoF+gRUmbxGSaFhBuL39j4oTxVOyA2BnQ40tAcRkVfoIYvDgk/XWkwxFcLaMSUmv+PBgIs0qn/U7hkROvmhML8yVtL9ajcjGy/FY04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnzfU5Dx; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnzfU5Dx"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso2209167b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 05:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762781892; x=1763386692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jnGlBRb9DwPiK9LmBGDtYmrRRuxIEh43z/epZv69VLQ=;
        b=cnzfU5Dx7ei5165Oe21fXuxJobF5pYYWzJ6nz44a4qpnbTDHfaxt2uNEIxhyaar0gM
         NOiGAVlSOw9p1tOzQFuPRIqGvuf7I5xwuy589Sfw72gkHII2klEm/0qHqw9/xcP4QnE7
         CwA3VrKfrqD4OxTCCcSZdGsjfPcDafyt4ICvATeS2b9s0zidabiqqVankwQQ8doo+pE9
         JCEyAQVtuSQ7MsXe7Z/V54rHKuuNGWADEvDJrG02KvQ3jGrz2og562GH4STpSy6GuVHq
         qiQfG5gqFJ9amS4S1jQCXko05sruq0T0IEbHGMzBXbpV1F0k8G3JEXxaNJD2cK7jWkTK
         oF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762781892; x=1763386692;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jnGlBRb9DwPiK9LmBGDtYmrRRuxIEh43z/epZv69VLQ=;
        b=JWURNthpbZMjv55Kdlca5DRjSJFY47RR8nB5vj0790gjFEz+YT7Kl88l1IObZp++oY
         rRoXdkvet1LnaIEwFuj8F4K1rtfR/yqmkWaxlZtsDEn4mULRnsiRb2Rfbhoy6laBtj2A
         1RodrvDirECGlDRq54jz43vHWMrsHrxET12ryrlMgJzHKl7+QTMymC9aw5rgptM+7vBe
         yX+HqFtQmMoOq1Jbm4eFco8q8BGMxe/xv84ondOezrGBDaRsaN+XBJYAsTYwH+YGlrOT
         s39U5P3A/7aGyU9NaZkQoPaxfQtdhFeUCxFY8rxZRQ401V6njmHXxUHpXr+wHJ7WEO6T
         hiXA==
X-Forwarded-Encrypted: i=1; AJvYcCURFcu/odD3AHpJ7IwN+8otJ9WhP8PHr97bZBDzWCRtwu1YMvYzIREJ/zu6WtCf1uSvaaOnEbbSB3I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo6IHqbPcD/sPSXvx7OOnYDx7PYn0DcY+csyZhrcneIuSBKXBk
	wrrliBZxKI5e7gC9ZD2Au5f6cLWFrmrdlbBozvD8zXNgrqR3aAgmz6qJgJrWQQ==
X-Gm-Gg: ASbGnctFsrXACqssT/272Gfo/Zg2F1WkwORb7KwMdIbh78Jh7J6r82nnjhHk19Q8mL4
	XWBOfwyDg6d8nBcLm34m7tmj39Y84PIR8UNR+5+qeAAZj+AioBDZdWxw+V4jGyigedzwU74xvQI
	IGy+9tbk+lG69iX140dtrH4C2H7kaJl4R6LzQGicAxMMjDlojmKyCCSCL/bJvYrMODjobXTUGpH
	3IdsqLjSC9ym5ElvfAYi8zF+7yfuZpc5qacTw9xPuhzNOQ9/MW3VHlqYPY+qgUqjYvzRjVIGcuC
	/X2OUswf9CLZiKnZZUTvzVaH4OlYXMIMKeuWkyqsXcG4WLbxjBZw5q02cUo6vea05VNWVV4brz3
	Ubj6V31VbglENSWgyIRPWWuoRx+sNzD6bZqfe4W5pDf47tyIPT6tH6A+PQ8bayJmQp4eZbC92IJ
	BDzdE1f7Dq8gJTWypzO79cdoXsITBQAmmQRccqDqqR6jNmdDgnOVaJ/4fsKMemBo9m
X-Google-Smtp-Source: AGHT+IHNvk2m9lZznt0nbMSiGOUuWH6p+xE2cZfK8zcBuHfxFqo1BWD3CQfalfJc7QB2TuotmiLZDQ==
X-Received: by 2002:a05:6a21:32a0:b0:334:a784:304a with SMTP id adf61e73a8af0-353a2d3cec1mr9389506637.33.1762781891518;
        Mon, 10 Nov 2025 05:38:11 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.198.166])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8f9ed21desm13311276a12.11.2025.11.10.05.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 05:38:11 -0800 (PST)
Message-ID: <7f7163d79dc89ae8c8d1157ce969b369acbcfb5d.camel@gmail.com>
Subject: Re: [PATCH 4/4] xfs: fallback to buffered I/O for direct I/O when
 stable writes are required
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
	Christian Brauner
	 <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, "Martin K. Petersen"
 <martin.petersen@oracle.com>,  linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
 linux-raid@vger.kernel.org,  linux-block@vger.kernel.org
Date: Mon, 10 Nov 2025 19:08:05 +0530
In-Reply-To: <20251029071537.1127397-5-hch@lst.de>
References: <20251029071537.1127397-1-hch@lst.de>
	 <20251029071537.1127397-5-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-10-29 at 08:15 +0100, Christoph Hellwig wrote:
> Inodes can be marked as requiring stable writes, which is a setting
> usually inherited from block devices that require stable writes.  Block
> devices require stable writes when the drivers have to sample the data
> more than once, e.g. to calculate a checksum or parity in one pass, and
> then send the data on to a hardware device, and modifying the data
> in-flight can lead to inconsistent checksums or parity.
> 
> For buffered I/O, the writeback code implements this by not allowing
> modifications while folios are marked as under writeback, but for
> direct I/O, the kernel currently does not have any way to prevent the
> user application from modifying the in-flight memory, so modifications
> can easily corrupt data despite the block driver setting the stable
> write flag.  Even worse, corruption can happen on reads as well,
> where concurrent modifications can cause checksum mismatches, or
> failures to rebuild parity.  One application known to trigger this
> behavior is Qemu when running Windows VMs, but there might be many
> others as well.  xfstests can also hit this behavior, not only in the
> specifically crafted patch for this (generic/761), but also in
> various other tests that mostly stress races between different I/O
> modes, which generic/095 being the most trivial and easy to hit
> one.
> 
> Fix XFS to fall back to uncached buffered I/O when the block device
> requires stable writes to fix these races.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 54 +++++++++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_iops.c |  6 ++++++
>  2 files changed, 51 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e09ae86e118e..0668af07966a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -230,6 +230,12 @@ xfs_file_dio_read(
>  	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
>  	ssize_t			ret;
>  
> +	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
> +		xfs_info_once(ip->i_mount,
> +			"falling back from direct to buffered I/O for read");
> +		return -ENOTBLK;
> +	}
> +
>  	trace_xfs_file_direct_read(iocb, to);
>  
>  	if (!iov_iter_count(to))
> @@ -302,13 +308,22 @@ xfs_file_read_iter(
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
> -	if (IS_DAX(inode))
> +	if (IS_DAX(inode)) {
>  		ret = xfs_file_dax_read(iocb, to);
> -	else if (iocb->ki_flags & IOCB_DIRECT)
> +		goto done;
> +	}
> +
> +	if (iocb->ki_flags & IOCB_DIRECT) {
>  		ret = xfs_file_dio_read(iocb, to);
> -	else
> -		ret = xfs_file_buffered_read(iocb, to);
> +		if (ret != -ENOTBLK)
> +			goto done;
> +
> +		iocb->ki_flags &= ~IOCB_DIRECT;
> +		iocb->ki_flags |= IOCB_DONTCACHE;
> +	}
>  
> +	ret = xfs_file_buffered_read(iocb, to);
> +done:
>  	if (ret > 0)
>  		XFS_STATS_ADD(mp, xs_read_bytes, ret);
>  	return ret;
> @@ -883,6 +898,7 @@ xfs_file_dio_write(
>  	struct iov_iter		*from)
>  {
>  	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_buftarg      *target = xfs_inode_buftarg(ip);
>  	size_t			count = iov_iter_count(from);
>  
> @@ -890,15 +906,21 @@ xfs_file_dio_write(
>  	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
>  		return -EINVAL;
>  
> +	if (mapping_stable_writes(iocb->ki_filp->f_mapping)) {
> +		xfs_info_once(mp,
> +			"falling back from direct to buffered I/O for write");
Minor: Let us say that an user opens a file in O_DIRECT in an atomic write enabled device(requiring
stable writes), we get this warning once. Now the same/different user/application opens another file
with O_DIRECT in the same atomic write enabled device and expects atomic write to be enabled - but
it will not be enabled (since the kernel has falled back to the uncached buffered write path)
without any warning message. Won't that be a bit confusing for the user (of course unless the user
is totally aware of the kernel's exact behavior)?
--NR

> +		return -ENOTBLK;
> +	}
> +
>  	/*
>  	 * For always COW inodes we also must check the alignment of each
>  	 * individual iovec segment, as they could end up with different
>  	 * I/Os due to the way bio_iov_iter_get_pages works, and we'd
>  	 * then overwrite an already written block.
>  	 */
> -	if (((iocb->ki_pos | count) & ip->i_mount->m_blockmask) ||
> +	if (((iocb->ki_pos | count) & mp->m_blockmask) ||
>  	    (xfs_is_always_cow_inode(ip) &&
> -	     (iov_iter_alignment(from) & ip->i_mount->m_blockmask)))
> +	     (iov_iter_alignment(from) & mp->m_blockmask)))
>  		return xfs_file_dio_write_unaligned(ip, iocb, from);
>  	if (xfs_is_zoned_inode(ip))
>  		return xfs_file_dio_write_zoned(ip, iocb, from);
> @@ -1555,10 +1577,24 @@ xfs_file_open(
>  {
>  	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
>  		return -EIO;
> +
> +	/*
> +	 * If the underlying devices requires stable writes, we have to fall
> +	 * back to (uncached) buffered I/O for direct I/O reads and writes, as
> +	 * the kernel can't prevent applications from modifying the memory under
> +	 * I/O.  We still claim to support O_DIRECT as we want opens for that to
> +	 * succeed and fall back.
> +	 *
> +	 * As atomic writes are only supported for direct I/O, they can't be
> +	 * supported either in this case.
> +	 */
>  	file->f_mode |= FMODE_NOWAIT | FMODE_CAN_ODIRECT;
> -	file->f_mode |= FMODE_DIO_PARALLEL_WRITE;
> -	if (xfs_get_atomic_write_min(XFS_I(inode)) > 0)
> -		file->f_mode |= FMODE_CAN_ATOMIC_WRITE;
> +	if (!mapping_stable_writes(file->f_mapping)) {
> +		file->f_mode |= FMODE_DIO_PARALLEL_WRITE;
> +		if (xfs_get_atomic_write_min(XFS_I(inode)) > 0)
> +			file->f_mode |= FMODE_CAN_ATOMIC_WRITE;
> +	}
> +
>  	return generic_file_open(inode, file);
>  }
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index caff0125faea..bd49ac6b31de 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -672,6 +672,12 @@ xfs_report_atomic_write(
>  	struct xfs_inode	*ip,
>  	struct kstat		*stat)
>  {
> +	/*
> +	 * If the stable writes flag is set, we have to fall back to buffered
> +	 * I/O, which doesn't support atomic writes.
> +	 */
> +	if (mapping_stable_writes(VFS_I(ip)->i_mapping))
> +		return;
>  	generic_fill_statx_atomic_writes(stat,
>  			xfs_get_atomic_write_min(ip),
>  			xfs_get_atomic_write_max(ip),

