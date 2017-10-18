Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:57328 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757804AbdJRJ7V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 05:59:21 -0400
Date: Wed, 18 Oct 2017 11:59:16 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RESEND PATCH 3/3] lockdep: Assign a lock_class per gendisk used
 for wait_for_completion()
Message-ID: <20171018095916.gr3n4mal6dz5xs7v@gmail.com>
References: <1508319532-24655-1-git-send-email-byungchul.park@lge.com>
 <1508319532-24655-4-git-send-email-byungchul.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508319532-24655-4-git-send-email-byungchul.park@lge.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Byungchul Park <byungchul.park@lge.com>
Cc: peterz@infradead.org, tglx@linutronix.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org, johannes.berg@intel.com, oleg@redhat.com, amir73il@gmail.com, david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@infradead.org, idryomov@gmail.com, kernel-team@lge.com


* Byungchul Park <byungchul.park@lge.com> wrote:

> diff --git a/block/bio.c b/block/bio.c
> index 9a63597..0d4d6c0 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -941,7 +941,7 @@ int submit_bio_wait(struct bio *bio)
>  {
>  	struct submit_bio_ret ret;
>  
> -	init_completion(&ret.event);
> +	init_completion_with_map(&ret.event, &bio->bi_disk->lockdep_map);
>  	bio->bi_private = &ret;
>  	bio->bi_end_io = submit_bio_wait_endio;
>  	bio->bi_opf |= REQ_SYNC;
> @@ -1382,7 +1382,7 @@ struct bio *bio_map_user_iov(struct request_queue *q,
>  
>  			if (len <= 0)
>  				break;
> -			
> +
>  			if (bytes > len)
>  				bytes = len;
>  

That's a spurious cleanup unrelated to this patch.

> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -3,7 +3,7 @@
>  
>  /*
>   * 	genhd.h Copyright (C) 1992 Drew Eckhardt
> - *	Generic hard disk header file by  
> + *	Generic hard disk header file by
>   * 		Drew Eckhardt
>   *
>   *		<drew@colorado.edu>

Ditto.

> @@ -483,7 +486,7 @@ struct bsd_disklabel {
>  	__s16	d_type;			/* drive type */
>  	__s16	d_subtype;		/* controller/d_type specific */
>  	char	d_typename[16];		/* type name, e.g. "eagle" */
> -	char	d_packname[16];			/* pack identifier */ 
> +	char	d_packname[16];			/* pack identifier */
>  	__u32	d_secsize;		/* # of bytes per sector */
>  	__u32	d_nsectors;		/* # of data sectors per track */
>  	__u32	d_ntracks;		/* # of tracks per cylinder */

Ditto.

Thanks,

	Ingo
