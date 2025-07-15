Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29801531E8
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592705; cv=none; b=FQF1obzfsgxzlMsufnObrG7b98jFl1ARjEwuJIPUNvxF+ut6qI5v8jowJhTgdiUlXk/bXbu9emInQU6ydsOM/7WuSTHMzm/L1cw1/qUK8878C42mj4lGky31EnuqMhlQOEKZwsx5zpMwwG/edmDCkDo6TQ7IuNJJ5Byir2zdIU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592705; c=relaxed/simple;
	bh=DQsMLMP+xV2krhJVZSn2XbCC8Cls0mePCC6k3T9CWqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ln5kxaxvrcopjdlWAcD3R1y8bBC8iyVyvXyYPqxOXY3TO0ic1FcVriIxL06L92fOVBs2xTC5YeFeUq/GA9HHxFRJ9IAXuQO+FHoAkD7+7BvSo1UTRXyu//4jn5ws2MDza/NMNMBM4VrKA3z26pVpkcD6ypjTl42CyQYV9X/uiIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDdRgFy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDdRgFy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F809C4CEE3;
	Tue, 15 Jul 2025 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752592705;
	bh=DQsMLMP+xV2krhJVZSn2XbCC8Cls0mePCC6k3T9CWqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZDdRgFy8EWfkIQ+906pblDxgtcfLYJK86Vp/NATbmxqOTVGJ+tai2FdjfqJW675m1
	 +T7PSXkYlqMfAxMIgEWgXmCZy+LM6TBFWql4QaDAVq9m+mugK4oboZGfSR8dZQTEZx
	 qmK/Ld9W+jZ1M8Dob7sjSyxyGtj6dNyitUfdgJd9MIvwg27jx5xQ8lpdVcXJ8yLLnE
	 ujRd24nkUU4ICD4WIKaJ1GQDz0LqP1aG/fK8NUj0ra11vDc7TKO1Y5RXGcDacvHOh5
	 iP8dFcul2N0KR7tT47urrlvDwP3da/Ajc5oJyqAqe7V/Lga0tQiT01XKem88CyFFvb
	 uAke+khRFOeHQ==
Date: Tue, 15 Jul 2025 08:18:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: remove the xlog_ticket_t typedef
Message-ID: <20250715151824.GA2672049@frogsfrogsfrogs>
References: <20250715122544.1943403-1-hch@lst.de>
 <20250715122544.1943403-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715122544.1943403-9-hch@lst.de>

On Tue, Jul 15, 2025 at 02:25:41PM +0200, Christoph Hellwig wrote:
> Almost no users of the typedef left, kill it and switch the remaining
> users to use the underlying struct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      | 6 +++---
>  fs/xfs/xfs_log_priv.h | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 793468b4d30d..bc3297da2143 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3092,16 +3092,16 @@ xfs_log_force_seq(
>   */
>  void
>  xfs_log_ticket_put(
> -	xlog_ticket_t	*ticket)
> +	struct xlog_ticket	*ticket)
>  {
>  	ASSERT(atomic_read(&ticket->t_ref) > 0);
>  	if (atomic_dec_and_test(&ticket->t_ref))
>  		kmem_cache_free(xfs_log_ticket_cache, ticket);
>  }
>  
> -xlog_ticket_t *
> +struct xlog_ticket *
>  xfs_log_ticket_get(
> -	xlog_ticket_t	*ticket)
> +	struct xlog_ticket	*ticket)
>  {
>  	ASSERT(atomic_read(&ticket->t_ref) > 0);
>  	atomic_inc(&ticket->t_ref);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 39a102cc1b43..a9a7a271c15b 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -144,7 +144,7 @@ enum xlog_iclog_state {
>  
>  #define XLOG_COVER_OPS		5
>  
> -typedef struct xlog_ticket {
> +struct xlog_ticket {
>  	struct list_head	t_queue;	/* reserve/write queue */
>  	struct task_struct	*t_task;	/* task that owns this ticket */
>  	xlog_tid_t		t_tid;		/* transaction identifier */
> @@ -155,7 +155,7 @@ typedef struct xlog_ticket {
>  	char			t_cnt;		/* current unit count */
>  	uint8_t			t_flags;	/* properties of reservation */
>  	int			t_iclog_hdrs;	/* iclog hdrs in t_curr_res */
> -} xlog_ticket_t;
> +};
>  
>  /*
>   * - A log record header is 512 bytes.  There is plenty of room to grow the
> -- 
> 2.47.2
> 
> 
