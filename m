Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60028248B;
	Tue, 29 Sep 2026 00:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641411; cv=none; b=tCECvYaMHyB8QI+OawlA3usq4vhN5ec7jfczQIuI1BTIUn0VOlWb4+SaWUUSlPmQCjr+5AgELKTZS37CKcAyRyJ8Si+QRZmxGshcE0/gyxxfHGqm6CwFE1oVbo4XXzXpzFky+Co5b4qftcA4nAaRyX/OUr8hAPX0q94MBEQk5TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641411; c=relaxed/simple;
	bh=8+GB7lpDysl5bYw93tlE0sg4FN1oapyZezZhSpvJ1GU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHyO7Yj2O4PsVK/puiwsAhheg4CTOdrkPAGDlZypwjnnozX8P7i6uZ74VtWoSqRxT3lf1PCj/Krf3aE3abERb/cT08sAqcoIDITp05oF2Y8GRsnCgkDWmTEsRj4F+NB8lc76Hzjo8vEEel/3qRT1LG51GwAc10vWLHAwwJYfVeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5v7sdYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5v7sdYk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 518821F000FF;
	Tue, 29 Sep 2026 00:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790641410;
	bh=SZ4P2K3UC24pW8JIPzlelKyWXY1SUTs6XuhCrDqmR2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h5v7sdYkQfyl6Sp/5RH9/zDNmQwsDObDGETOPZ3rPSOoB2TliFE6Z6WJZqrxWSTIV
	 GqUXUAQy0JM4hISBJfvnUwI2GVJBSBm19sT+/eR3yk47KHsJxkY3JNbz4B0gA8OeUs
	 9FrWuCC/dmr8P/eSVLUbegVQECWJspcrL95TpbVdc+iAPK/swM4Ah3ZM0GelbA+M+j
	 35DG52OL5v0gjklXgbCxGjrtGRDrWgRfXkZsnKyW2cskyYlmd2wjnswLJdW3cI4s3q
	 4z0EheKvOFpUxPVg5445eJrmCBAhzbGK3L9CE0+7Nv8dv4N2D7Gp99zQ0Dn9wC+ZbX
	 TaROTTAvZT+Zg==
Date: Mon, 28 Sep 2026 17:23:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: use bio_complete_in_task for buffered read
 failures
Message-ID: <20260929002329.GO6283@frogsfrogsfrogs>
References: <20260928091111.3986811-1-hch@lst.de>
 <20260928091111.3986811-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928091111.3986811-2-hch@lst.de>

On Mon, Sep 28, 2026 at 11:11:07AM +0200, Christoph Hellwig wrote:
> Use bio_complete_in_task to defer the bio completion handler to task
> context instead of the homegrown deferral.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/bio.c | 46 ++--------------------------------------------
>  1 file changed, 2 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
> index 48100c614431..e83524c46838 100644
> --- a/fs/iomap/bio.c
> +++ b/fs/iomap/bio.c
> @@ -9,9 +9,6 @@
>  #include "internal.h"
>  #include "trace.h"
>  
> -static DEFINE_SPINLOCK(failed_read_lock);
> -static struct bio_list failed_read_list = BIO_EMPTY_LIST;
> -
>  static u32 __iomap_read_end_io(struct bio *bio, int error)
>  {
>  	struct folio_iter fi;
> @@ -27,50 +24,11 @@ static u32 __iomap_read_end_io(struct bio *bio, int error)
>  	return folio_count;
>  }
>  
> -static void
> -iomap_fail_reads(
> -	struct work_struct	*work)
> -{
> -	struct bio		*bio;
> -	struct bio_list		tmp = BIO_EMPTY_LIST;
> -	unsigned long		flags;
> -
> -	spin_lock_irqsave(&failed_read_lock, flags);
> -	bio_list_merge_init(&tmp, &failed_read_list);
> -	spin_unlock_irqrestore(&failed_read_lock, flags);
> -
> -	while ((bio = bio_list_pop(&tmp)) != NULL) {
> -		__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));
> -		cond_resched();
> -	}
> -}
> -
> -static DECLARE_WORK(failed_read_work, iomap_fail_reads);
> -
> -static void iomap_fail_buffered_read(struct bio *bio)
> -{
> -	unsigned long flags;
> -
> -	/*
> -	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
> -	 * in the fserror code.  The caller no longer owns the bio reference
> -	 * after the spinlock drops.
> -	 */
> -	spin_lock_irqsave(&failed_read_lock, flags);
> -	if (bio_list_empty(&failed_read_list))
> -		WARN_ON_ONCE(!schedule_work(&failed_read_work));
> -	bio_list_add(&failed_read_list, bio);
> -	spin_unlock_irqrestore(&failed_read_lock, flags);
> -}
> -
>  static void iomap_read_end_io(struct bio *bio)
>  {
> -	if (bio->bi_status) {
> -		iomap_fail_buffered_read(bio);
> +	if (bio->bi_status && bio_complete_in_task(bio))

Hmm.

If bio failed, we call bio_complete_in_task to do something with the
bio.  If the bio wasn't flagged COMPLETE_IN_TASK and we're in atomic
context, then __bio_complete_in_task will queue the bio to a per-cpu
completion batch, (maybe) schedule a worker to deal with the batch,
and we're done.

If the bio was already a COMPLETE_IN_TASK bio or we're not in atomic
context, the function returns false and we fall through to the
__iomap_read_end_io call below.

That looks like a correct conversion of the iomap_fail_buffered_read
code, with only the slight change that we're using a per-cpu batch
instead of a single static list.  Right?

If yes, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


>  		return;
> -	}
> -
> -	__iomap_read_end_io(bio, 0);
> +	__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));
>  }
>  
>  u32 iomap_finish_ioend_buffered_read(struct iomap_ioend *ioend)
> -- 
> 2.53.0
> 
