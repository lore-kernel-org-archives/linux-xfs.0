Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246309;
	b=wRrjO+UYXRlp2Y23J4+JcWrYwGuJ2xvxbAKudqoSXMCL6F+eLAwRvtEXG2UA9yQmJJWu
	 5+t4O8cfjBhk+7jD8UvmckLlBpNUB4PXgWglqN4MznhLQh61BZbQPKV0oyEqOsmwMaiEp
	 CQLBavXTT2KxzdetIQUKOYyk/TRjUs/peBrPvdYw++cbZ25x14IzSKnCFadiIaWkQAGlt
	 kSlV+voYhMv9jt7Zl6qZQi4GDEAShQ4ruTNOuLLu0ld1dL+mOKqbzYa23hk42znBJK18d
	 zRZJANyss/i9DgTifm99Ia7BDCVywqRXjmH5shULRsgZ7Webg0nq9RdM6WqL7Sjo3gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246309;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=Uh8Pc9yIgbbYwtals5es2B8RfbvGhyPX7fv5nZQZRCk=;
	b=IKP+oj0DG+EIbGIOlVbwwRLZDyRdAR6jxcWKcV+IO9UKTMAPYxmLTHhWyo9QQO79G/uT
	 stPpJb8jY6gRAzzYNvfKkCfCfJa4gOcZAx+FXJJOpDZYSwGzWJ6EnHQpuqropLqDfXh3F
	 C/X47ZJdoBPSmRaC+oB2yLTU11tjUUl1iebQYd6vKmYaRzcySKMKANX9FuBnM4yTRLa51
	 XB78SwFUKFlc0hL+bYiiz0BbVkYg3XIW6isL7ISfcJD2qaCj6kHRuO0EoP+4PkMZGZ1EB
	 7/ki6/6A23cmrqjeOnbqxrgwFmoFK/0355lvDqDkr34/oiq87LqPNBucIJRMFpLItuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZOuJkCiK;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C88606A333
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 17:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14C88606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZOuJkCiK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794246307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uh8Pc9yIgbbYwtals5es2B8RfbvGhyPX7fv5nZQZRCk=;
	b=ZOuJkCiK2ehqFzYC9tSJYJ54neWpLMgIJWumTuvo7gCX/az9KLhKw9h14FucZIbrn3S71o
	uw/s1wbnRJ3+uYkhCZYn5KDvueRqnRQ8P0p2xGnQ00BD2uROImqn0cXKAJlfjRW/iQkUJP
	hgLkNvOUxQa2T28rKFngGXPbiSSW+O0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-ik8ZQ037ODeTcULghcVHqw-1; Mon,
 09 Nov 2026 12:45:03 -0500
X-MC-Unique: ik8ZQ037ODeTcULghcVHqw-1
X-Mimecast-MFC-AGG-ID: ik8ZQ037ODeTcULghcVHqw_1794246301
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BAA81955EAC;
	Mon,  9 Nov 2026 17:45:01 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1960195608B;
	Mon,  9 Nov 2026 17:44:59 +0000 (UTC)
Date: Mon, 9 Nov 2026 12:44:57 -0500
From: Brian Foster <bfoster@redhat.com>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: skip the fsync flush when a later flush has
 completed
Message-ID: <avIGmcLZPKIDlf06@bfoster>
References: <20261105-xfs-fsync-flush-seq-v1-0-299bdf5e28c3@samsung.com>
 <20261105-xfs-fsync-flush-seq-v1-2-299bdf5e28c3@samsung.com>
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
In-Reply-To: <20261105-xfs-fsync-flush-seq-v1-2-299bdf5e28c3@samsung.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Nov 05, 2026 at 11:49:13AM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> Since commit 47c7d0b19502 ("xfs: fix incorrect log_flushed on
> fsync"), fsync sends its own cache flush whenever another task wrote
> out the iclog it waited for. With concurrent fsyncs, these flushes can
> limit throughput.
> 
> Skip the flush when a flush submitted after the data writes completed
> has finished. Number the fsync's own flush too, so that concurrent
> fsyncs can share it. DAX does not use the new skip, because DAX writes
> do not go through block I/O.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> 16 fio jobs of 4k append + fsync, QEMU guest on a 990 PRO without
> power loss protection (virtio-blk, cache=none): 809 -> 4185 fsyncs/s,
> mean fsync latency 19.8 -> 3.8 ms.
> 

Can you include this in the commit log so we have a record of the perf
impact?

> dm-log-writes with 8 fsync writers: no fsync-ed block was lost in 528
> replays, while at least 33257 of 48048 fsyncs skipped their flush
> through the new check. Taking the snapshot before the writeback loses
> 15 of 528. The test needs "dm-log-writes: log earlier flushes' writes
> when a later flush completes", sent to dm-devel.
> ---
>  fs/xfs/xfs_buf.c  | 26 ++++++++++++++++++++++++++
>  fs/xfs/xfs_buf.h  | 19 +++++++++++++++++++
>  fs/xfs/xfs_file.c | 21 +++++++++++++++------
>  3 files changed, 60 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9025b177931..6b545d79a41 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1785,6 +1785,32 @@ xfs_buftarg_flush_done(
>  		;
>  }
>  
> +/*
> + * Return true if a flush numbered above @seq has completed. All writes that
> + * completed before @seq was read are then on stable storage.
> + */

I think it would be helpful if the comment here and perhaps above
xfs_buftarg_flush_seq() referred to the submit/completion ordering logic
being applied. Maybe even rename seq -> submit_seq as well to make it
more clear. For example, something like:

"Return true if a flush has been submitted and completed since
@submit_seq was sampled. If so, this guarantees writes completed before
@submit_seq are flushed to disk."

But feel free to change that.

> +bool
> +xfs_buftarg_flushed_since(
> +	struct xfs_buftarg	*btp,
> +	s64			seq)
> +{
> +	return atomic64_read(&btp->bt_flush_completed) > seq;
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
...
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 396aca8c66a..a98361e9ead 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -87,7 +87,9 @@ xfs_file_fsync(
>  	int			datasync)
>  {
>  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
> +	struct xfs_buftarg	*btp = xfs_inode_buftarg(ip);
>  	int			log_flushed = 0;
> +	s64			flush_seq;
>  	int			error;
>  
>  	trace_xfs_file_fsync(ip);
> @@ -95,6 +97,7 @@ xfs_file_fsync(
>  	error = file_write_and_wait_range(file, start, end);
>  	if (error)
>  		return error;
> +	flush_seq = xfs_buftarg_flush_seq(btp);
>  

Ok, so I think I follow the logic. We write the file, sample the submit
sequence (after write completes), then can optimize away our own flush
if we can confirm that a flush submitted after write completion has
already completed. Right?

That kind of makes me wonder whether we could do something like "flush
or wait on any flush submitted after this seq," but maybe that's
something for another day. ;)

>  	if (xfs_is_shutdown(ip->i_mount))
>  		return -EIO;
> @@ -115,16 +118,22 @@ xfs_file_fsync(
>  	}
>  
>  	/*
> -	 * If the log force was a no-op, we may still need to flush the
> -	 * file data target cache here. This can happen for fdatasync/O_DSYNC
> -	 * when no metadata needed to be committed.

Did we intend to remove the comment on why we flush in the first place?

Brian

> +	 * Flush the file data target unless a flush submitted to it after the
> +	 * data writes above completed has already finished. That is usually
> +	 * the flush before an iclog written out by this log force or by
> +	 * another task, or another fsync's flush.
> +	 *
> +	 * DAX writes are CPU stores, not block I/O, and the check above
> +	 * relies on REQ_PREFLUSH covering completed block I/O. So DAX only
> +	 * skips the flush when this log force flushed, as before.
>  	 *
>  	 * Use the inode's actual file data target rather than assuming the
>  	 * main data device.
>  	 */
> -	if (!log_flushed)
> -		return blkdev_issue_flush(xfs_inode_buftarg(ip)->bt_bdev);
> -	return 0;
> +	if (log_flushed ||
> +	    (!IS_DAX(VFS_I(ip)) && xfs_buftarg_flushed_since(btp, flush_seq)))
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

