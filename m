Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406948;
	b=ehGkcghwbo0izIWdT0RuJKC53o00z+mxVPpaofZ3M62sWZIh3yZogQeR9ALyhBKccysq
	 gYG4/W9lnX1aATrvdrywaCdxudIBNaLVsyvojKBbCxbiJ0R0B4m8KRlqZKRO3aFBrXK2t
	 zuDUj/AEWJ+cjqXRHLj9wXCDO8z6re0VmqSyvpzIXBHIThuJBnENSZfzWLeHyIWBrWDHV
	 juiqaJvAoX0jp2Rphtrvq/Nr+eMTfRKKrZp4chmPCOfl3Tz5dAAHe7CLgaYCJHlVXqUYF
	 NtKIp5FE0Erh6aP4ChX7daU+F1x0b/i61ZmSFjLfAqA8zcj+KZfuMvqP3MF8aSsh4IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406948;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=l6OtkjW5M33WPamjpZRAaHXjwidRu8lbMNR80GBRSBU=;
	b=iWxe97xFyd3WGlyoESrP+flamtZy0ooNoe5DIlWnkg6iAr3VObdGKOy9NSublfODDZsV
	 nIQYt+wnDZeQpJDExT4zoX5OPp67nUrYB9WF5hVG6iM5u+9wbxW2PGtwR0UoEFIuAPfc8
	 MLkUhefcVlwAaeKI1KnqTi3EE3NXO85xSSpIapGerEiJLx+iMK2+ELVtfV/ZppYl6TjTp
	 T7NgCJbFbCKOdL31SNMBLbrsR21HH71SAY5ArkmxE5D3DQsUBHvQP/olhjxR6RrPFHgMb
	 iK/2wdBriIMLSA7e8LjIL2VIzXVvw7WP74AKbE2g4nCqqQsgTLtQayA2jJzN7DQgWPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="asWq5g/h";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A688606A324
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 14:22:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A688606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=asWq5g/h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794406946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l6OtkjW5M33WPamjpZRAaHXjwidRu8lbMNR80GBRSBU=;
	b=asWq5g/hqrkQtx/o8LSVi1LXQxW2qy05aVE4FGBfD9Yh+7FSi5v0rJSE9VYTUA1nWbD2Uw
	euAePR2UQ0mR76mE+1ry4CDjp+OIpe2DDcsRRQh2LHqHSqfHs3TQVc2sDYWLhzndLCzfos
	lIZdcxkrLtLBboT3f/ni72GBO2OHgiE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-426-_ysHYmeDNw2vAcR3hEEE4Q-1; Wed,
 11 Nov 2026 09:22:24 -0500
X-MC-Unique: _ysHYmeDNw2vAcR3hEEE4Q-1
X-Mimecast-MFC-AGG-ID: _ysHYmeDNw2vAcR3hEEE4Q_1794406943
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E61FE180060B;
	Wed, 11 Nov 2026 14:22:22 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 961871956086;
	Wed, 11 Nov 2026 14:22:21 +0000 (UTC)
Date: Wed, 11 Nov 2026 09:22:19 -0500
From: Brian Foster <bfoster@redhat.com>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: skip the fsync flush when a later flush has
 completed
Message-ID: <avR6G6TQehW08BD0@bfoster>
References: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
 <20261111-xfs-fsync-flush-seq-v2-2-b5c00c25d276@samsung.com>
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
In-Reply-To: <20261111-xfs-fsync-flush-seq-v2-2-b5c00c25d276@samsung.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Nov 11, 2026 at 12:17:12PM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> Since commit 47c7d0b19502 ("xfs: fix incorrect log_flushed on
> fsync"), fsync sends its own cache flush whenever another task wrote
> out the iclog it waited for. With concurrent fsyncs, these flushes can
> limit throughput.
> 
> Skip the flush when a flush submitted after the data writes completed
> has finished. DAX files keep the old behavior.
> 
> fio 4k append + fsync in a QEMU guest, virtio-blk (cache=none) on a
> Samsung 990 PRO NVMe SSD without power loss protection, before ->
> after:
> 
>   16 jobs: 1111 -> 4498 fsyncs/s, mean fsync latency 14.4 -> 3.6 ms
>    1 job:  399 -> 396 fsyncs/s
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> Christoph's 2017 mail with the sequence counter idea:
> https://lore.kernel.org/20170830142134.GA650@lst.de
> 
> A dm-log-writes test written for this series (8 fsync writers,
> internal log) lost no fsync-ed block in 528 replays. At least 33319
> of 48048 fsyncs skipped their flush through the new check. A variant
> that samples before the writeback loses 16 of 528. The test needs
> "dm-log-writes: log earlier flushes' writes when a later flush
> completes", sent to dm-devel.
> 
> With an internal log, an fsync that takes the new skip can miss a
> failed flush on bio-based dm. dm drops the error of a preflush sent
> with data, unless the table is linear or stripe on a single device.
> The skip trusts the status of the iclog bio, as the log and the fsync
> that wrote the iclog already do. Before this patch the other fsyncs
> sent their own flush and returned its result. With 8 writers on a
> two-device linear table whose second device fails every flush, 2590
> of 4000 fsyncs returned EIO before and 37 do now. From the code,
> bcache in writeback mode drops that error too. md reports no flush
> error at all. Neither was tested.
> ---

Hmm.. that's kind of interesting. So IIUC unless dm can pass through a
preflush+data bio, it will split out the flushes and ignore any error
status in favor of the packaged data I/O..?

I agree with the reasoning in that we're already subject to that caveat
and the patch looks fine to me. Modulo Dave's comments on perf results:

Reviewed-by: Brian Foster <bfoster@redhat.com>

But if you have to post this again I think it would be useful to
describe this caveat in the commit log description as well. If there
happens to be some currently unknown flush failiure scenario that
materializes in the future and we don't currently hit due to spamming
enough flushes, that would be a useful clue about a subtle behavior
change.

Brian

>  fs/xfs/xfs_buf.c  | 27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_buf.h  | 22 ++++++++++++++++++++++
>  fs/xfs/xfs_file.c | 18 +++++++++++++++---
>  3 files changed, 64 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9025b177931..2862cbdeda4 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1785,6 +1785,33 @@ xfs_buftarg_flush_done(
>  		;
>  }
>  
> +/*
> + * Return true if a flush has been submitted and completed since @submit_seq
> + * was sampled. If so, all writes that completed before @submit_seq was sampled
> + * are on stable storage.
> + */
> +bool
> +xfs_buftarg_flushed_since(
> +	struct xfs_buftarg	*btp,
> +	s64			submit_seq)
> +{
> +	return atomic64_read(&btp->bt_flush_completed) > submit_seq;
> +}
> +
> +/* Flush the device cache and record it. */
> +int
> +xfs_buftarg_flush(
> +	struct xfs_buftarg	*btp)
> +{
> +	s64			seq = xfs_buftarg_flush_start(btp);
> +	int			error;
> +
> +	error = blkdev_issue_flush(btp->bt_bdev);
> +	if (!error)
> +		xfs_buftarg_flush_done(btp, seq);
> +	return error;
> +}
> +
>  struct xfs_buftarg *
>  xfs_alloc_buftarg(
>  	struct xfs_mount	*mp,
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 6e6f0dbfef6..08282e1b3c8 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -368,6 +368,26 @@ struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
>  		struct file *bdev_file);
>  extern void xfs_free_buftarg(struct xfs_buftarg *);
>  
> +/*
> + * Sample the flush submit counter of @btp. Call this after the writes that a
> + * flush must cover have completed. Flushes take their number before they are
> + * submitted, so a flush numbered above the sample was submitted after it and
> + * covers those writes once it succeeds. xfs_buftarg_flushed_since() checks
> + * for such a flush.
> + */
> +static inline s64
> +xfs_buftarg_flush_seq(
> +	struct xfs_buftarg	*btp)
> +{
> +	/*
> +	 * Order the read after the write completions the caller waited for.
> +	 * Pairs with the fully ordered atomic64_inc_return() that
> +	 * xfs_buftarg_flush_start() does before the flush is submitted.
> +	 */
> +	smp_mb();
> +	return atomic64_read(&btp->bt_flush_submitted);
> +}
> +
>  /* Call right before submitting a cache flush to @btp. */
>  static inline s64
>  xfs_buftarg_flush_start(
> @@ -377,6 +397,8 @@ xfs_buftarg_flush_start(
>  }
>  
>  void xfs_buftarg_flush_done(struct xfs_buftarg *btp, s64 seq);
> +bool xfs_buftarg_flushed_since(struct xfs_buftarg *btp, s64 submit_seq);
> +int xfs_buftarg_flush(struct xfs_buftarg *btp);
>  extern void xfs_buftarg_wait(struct xfs_buftarg *);
>  extern void xfs_buftarg_drain(struct xfs_buftarg *);
>  int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 396aca8c66a..5af00520cbe 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -87,7 +87,9 @@ xfs_file_fsync(
>  	int			datasync)
>  {
>  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
> +	struct xfs_buftarg	*btp = xfs_inode_buftarg(ip);
>  	int			log_flushed = 0;
> +	s64			submit_seq;
>  	int			error;
>  
>  	trace_xfs_file_fsync(ip);
> @@ -95,6 +97,7 @@ xfs_file_fsync(
>  	error = file_write_and_wait_range(file, start, end);
>  	if (error)
>  		return error;
> +	submit_seq = xfs_buftarg_flush_seq(btp);
>  
>  	if (xfs_is_shutdown(ip->i_mount))
>  		return -EIO;
> @@ -119,12 +122,21 @@ xfs_file_fsync(
>  	 * file data target cache here. This can happen for fdatasync/O_DSYNC
>  	 * when no metadata needed to be committed.
>  	 *
> +	 * Flush the file data target unless a flush submitted to it after the
> +	 * data writes above completed has already finished. That is usually
> +	 * the flush before an iclog written out by this log force or by
> +	 * another task, or another fsync's flush.
> +	 *
> +	 * DAX writes are not block I/O, so DAX only skips the flush when
> +	 * this log force flushed, as before.
> +	 *
>  	 * Use the inode's actual file data target rather than assuming the
>  	 * main data device.
>  	 */
> -	if (!log_flushed)
> -		return blkdev_issue_flush(xfs_inode_buftarg(ip)->bt_bdev);
> -	return 0;
> +	if (log_flushed ||
> +	    (!IS_DAX(VFS_I(ip)) && xfs_buftarg_flushed_since(btp, submit_seq)))
> +		return 0;
> +	return xfs_buftarg_flush(btp);
>  }
>  
>  static int
> 
> -- 
> 2.43.0
> 
> 
> 

