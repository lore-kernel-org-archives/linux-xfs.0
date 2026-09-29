Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810681A0B15;
	Tue, 29 Sep 2026 00:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641793; cv=none; b=OheYNWyuqDl6X4+5mMAh2VUeozgfDLEkESmS6cqG2MYZNP9hkwTPsOGcmERS5CPgnQdPPcAJYCF2KabcxZNN/EP4k9R0mQ/a0BWWoyGXZEWi2Uo7tK7jzRVtDLUzQx2lHtEYlMsqk97aUGppScpea47CX7Y/0SKPGG0hzrp+ojw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641793; c=relaxed/simple;
	bh=lFkx6wn3IBB4n5zjJKbDKTcWOWGLYpUI6AiSqYrSQ4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqffFAz6fiUAO8aw3cbDSimPbVAYwTRVWbL4Mz5xXTSrKOiO1HsM1a/1o8I/H42Np91qPsg4KJycSzqCr9e33bwoBpjY3QhQ49gQ7/7EHsXmOqPXUHQmltaLNyxkfvF9W3Tq4PJuMs9PwmgF2gIAbtaFEAsqa/7yVpKbyrKlFBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBCJe/7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBCJe/7v"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 158F11F000FF;
	Tue, 29 Sep 2026 00:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790641792;
	bh=K60lpMN70m5PhD5Y3j0BeVbbyj/bTr4IDzRhXPL48vY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EBCJe/7vmX+O8a4UZeQBKdr7QzvBm6L2d5gZgGQszVnQH39HK4eFS4sR5XTr9OkxJ
	 abS+Bf+9ryzJXYnlEDRQZ8RAXu2hbXt7B162345y9jefPKt7mhHy5ADgVkjO8N5D9z
	 4ZwyaEOr9cfnmHKcFgEKoXblRvQID94FFiGSK8Ob8JdBnZQ8TFdfLSDrxcNC0RT23C
	 FDugZp9R6//BS1KhZsLvzB4gk3VIeFN0FltbalnCMzK5pStySoZd+Ge/K+LrubG8oY
	 +nFeLqOSveesX0sHQhO/V1oAWfmEtt0e8TPLGBnA9Bo6xlV8npXyw8HRxFPh1yojQl
	 skVNCwKo5VX7g==
Date: Mon, 28 Sep 2026 17:29:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] iomap: use bio_complete_in_task for buffered write
 failures
Message-ID: <20260929002951.GP6283@frogsfrogsfrogs>
References: <20260928091111.3986811-1-hch@lst.de>
 <20260928091111.3986811-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928091111.3986811-3-hch@lst.de>

On Mon, Sep 28, 2026 at 11:11:08AM +0200, Christoph Hellwig wrote:
> Use bio_complete_in_task to defer the bio completion handler to task
> context instead of the homegrown deferral.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks about the same as the previous conversion, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/ioend.c | 48 ++----------------------------------------------
>  1 file changed, 2 insertions(+), 46 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 7bbbb417f915..1c8840bde1ff 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -74,57 +74,13 @@ static u32 iomap_finish_ioend_buffered_write(struct iomap_ioend *ioend)
>  	return folio_count;
>  }
>  
> -static DEFINE_SPINLOCK(failed_ioend_lock);
> -static LIST_HEAD(failed_ioend_list);
> -
> -static void
> -iomap_fail_ioends(
> -	struct work_struct	*work)
> -{
> -	struct iomap_ioend	*ioend;
> -	struct list_head	tmp;
> -	unsigned long		flags;
> -
> -	spin_lock_irqsave(&failed_ioend_lock, flags);
> -	list_replace_init(&failed_ioend_list, &tmp);
> -	spin_unlock_irqrestore(&failed_ioend_lock, flags);
> -
> -	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
> -			io_list))) {
> -		list_del_init(&ioend->io_list);
> -		iomap_finish_ioend_buffered_write(ioend);
> -		cond_resched();
> -	}
> -}
> -
> -static DECLARE_WORK(failed_ioend_work, iomap_fail_ioends);
> -
> -static void iomap_fail_ioend_buffered(struct iomap_ioend *ioend)
> -{
> -	unsigned long flags;
> -
> -	/*
> -	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
> -	 * in the fserror code.  The caller no longer owns the ioend reference
> -	 * after the spinlock drops.
> -	 */
> -	spin_lock_irqsave(&failed_ioend_lock, flags);
> -	if (list_empty(&failed_ioend_list))
> -		WARN_ON_ONCE(!schedule_work(&failed_ioend_work));
> -	list_add_tail(&ioend->io_list, &failed_ioend_list);
> -	spin_unlock_irqrestore(&failed_ioend_lock, flags);
> -}
> -
>  static void ioend_writeback_end_bio(struct bio *bio)
>  {
>  	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
>  
> -	ioend->io_error = blk_status_to_errno(bio->bi_status);
> -	if (ioend->io_error) {
> -		iomap_fail_ioend_buffered(ioend);
> +	if (bio->bi_status && bio_complete_in_task(bio))
>  		return;
> -	}
> -
> +	ioend->io_error = blk_status_to_errno(bio->bi_status);
>  	iomap_finish_ioend_buffered_write(ioend);
>  }
>  
> -- 
> 2.53.0
> 
