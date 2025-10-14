Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C841E47CA
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479950; cv=none; b=Ur9CE2y5B3/D+k8htO7DsGTq6Jwto7j48p2Sdfr5gyaGEotq58a9RUo5tfYhvVyOBmlzR1jNyAwGhX57YgaogLvEr13OooG/conO+MGb+2UqPffXvut3wFMF/2hvYY5C6wvFd6PqW5QscuA76txCeCyJx1FS63/t/QyYXklE/6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479950; c=relaxed/simple;
	bh=mLL9Nb5VRg4r40i/PETsxczabNRZLSTIlyJAlslShYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0muJFV7DrboWgCeoQlW7xVFNccOl2kSVLrMzYLLoPIN5vqJiMduXw3uerAeN/9HZfB7lJL0xAT1ClFnyWoezY3EuK8RIRnEBYgglQGt4QYdZba3z4L6N/2oSrFEicnO5xsRR/xCTQCrs6cxjwV9/oVG1wxRFJZfXLunpSdlvSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pw/7So3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pw/7So3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13D9C4CEE7;
	Tue, 14 Oct 2025 22:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760479949;
	bh=mLL9Nb5VRg4r40i/PETsxczabNRZLSTIlyJAlslShYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pw/7So3VWDxUKo9WmZW/kefTFqj6DFlVCsMFfzCTXBcVKG4VHRGymgDaS77fU7m4t
	 8KrKHKBUP3AhPd6mX8enX0wf4jtP3aS6SF3YKg1upfqF+dw57cZ2maMrrIVpDRamyX
	 pMNW6v20/s268ExJHBhXLyxWxzgqb7GF1OKm+wsGO1gPVBaPbPj0eBWZbU690O3JLX
	 Vcx4SS8xLMjlkjct0lWNbsMzq9VNIwtHxgZfDAZd1eA7g+maoiquV6PiLx7Vg2/0uS
	 YZw1Sleo5ZIfpKRhtJnbq47berh1g8yOcNrGXdy8140KP95FB2xrSzRLmsn11qupcR
	 ewkU2Y/qFRXEg==
Date: Tue, 14 Oct 2025 15:12:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: remove the xlog_in_core_t typedef
Message-ID: <20251014221229.GO6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-10-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:13AM +0900, Christoph Hellwig wrote:
> Switch the few remaining users to use the underlying struct directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Gooooody!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      | 18 +++++++++---------
>  fs/xfs/xfs_log_priv.h |  6 +++---
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 47a8e74c8c5c..a311385b23d8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1368,8 +1368,8 @@ xlog_alloc_log(
>  	int			num_bblks)
>  {
>  	struct xlog		*log;
> -	xlog_in_core_t		**iclogp;
> -	xlog_in_core_t		*iclog, *prev_iclog=NULL;
> +	struct xlog_in_core	**iclogp;
> +	struct xlog_in_core	*iclog, *prev_iclog = NULL;
>  	int			i;
>  	int			error = -ENOMEM;
>  	uint			log2_size = 0;
> @@ -1813,10 +1813,10 @@ xlog_sync(
>   */
>  STATIC void
>  xlog_dealloc_log(
> -	struct xlog	*log)
> +	struct xlog		*log)
>  {
> -	xlog_in_core_t	*iclog, *next_iclog;
> -	int		i;
> +	struct xlog_in_core	*iclog, *next_iclog;
> +	int			i;
>  
>  	/*
>  	 * Destroy the CIL after waiting for iclog IO completion because an
> @@ -3293,7 +3293,7 @@ xlog_verify_iclog(
>  	int			count)
>  {
>  	struct xlog_rec_header	*rhead = iclog->ic_header;
> -	xlog_in_core_t		*icptr;
> +	struct xlog_in_core	*icptr;
>  	void			*base_ptr, *ptr;
>  	ptrdiff_t		field_offset;
>  	uint8_t			clientid;
> @@ -3481,11 +3481,10 @@ xlog_force_shutdown(
>  
>  STATIC int
>  xlog_iclogs_empty(
> -	struct xlog	*log)
> +	struct xlog		*log)
>  {
> -	xlog_in_core_t	*iclog;
> +	struct xlog_in_core	*iclog = log->l_iclog;
>  
> -	iclog = log->l_iclog;
>  	do {
>  		/* endianness does not matter here, zero is zero in
>  		 * any language.
> @@ -3494,6 +3493,7 @@ xlog_iclogs_empty(
>  			return 0;
>  		iclog = iclog->ic_next;
>  	} while (iclog != log->l_iclog);
> +
>  	return 1;
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 17733ba7f251..0fe59f0525aa 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -181,7 +181,7 @@ struct xlog_ticket {
>   * We'll put all the read-only and l_icloglock fields in the first cacheline,
>   * and move everything else out to subsequent cachelines.
>   */
> -typedef struct xlog_in_core {
> +struct xlog_in_core {
>  	wait_queue_head_t	ic_force_wait;
>  	wait_queue_head_t	ic_write_wait;
>  	struct xlog_in_core	*ic_next;
> @@ -204,7 +204,7 @@ typedef struct xlog_in_core {
>  	struct work_struct	ic_end_io_work;
>  	struct bio		ic_bio;
>  	struct bio_vec		ic_bvec[];
> -} xlog_in_core_t;
> +};
>  
>  /*
>   * The CIL context is used to aggregate per-transaction details as well be
> @@ -418,7 +418,7 @@ struct xlog {
>  						/* waiting for iclog flush */
>  	int			l_covered_state;/* state of "covering disk
>  						 * log entries" */
> -	xlog_in_core_t		*l_iclog;       /* head log queue	*/
> +	struct xlog_in_core	*l_iclog;       /* head log queue	*/
>  	spinlock_t		l_icloglock;    /* grab to change iclog state */
>  	int			l_curr_cycle;   /* Cycle number of log writes */
>  	int			l_prev_cycle;   /* Cycle number before last
> -- 
> 2.47.3
> 
> 
