Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E033D29DF8
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:43:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAF16304043
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:43:50 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ZMkCaLFMZeqdvQBE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:43:47 -0800 (PST)
Date: Thu, 12 Dec 2013 10:43:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] repair: phase 6 is trivially parallelisable
Message-ID: <20131212184346.GA23479@infradead.org>
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386832945-19763-4-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  static void
>  add_dotdot_update(
> @@ -64,12 +65,14 @@ add_dotdot_update(
>  		do_error(_("malloc failed add_dotdot_update (%zu bytes)\n"),
>  			sizeof(dotdot_update_t));
>  
> +	pthread_mutex_lock(&dotdot_lock);
>  	dir->next = dotdot_update_list;
>  	dir->irec = irec;
>  	dir->agno = agno;
>  	dir->ino_offset = ino_offset;
>  
>  	dotdot_update_list = dir;
> +	pthread_mutex_unlock(&dotdot_lock);

Would be nice to make this use a list_head if you touch it anyway.
(As a separate patch)

>  static void
>  traverse_ags(
> -	xfs_mount_t 		*mp)
> +	xfs_mount_t		*mp)

Not quite sure what actually changed here, but if you touch it anyway
you might as well use the struct version..

> +	if (!ag_stride) {
> +		work_queue_t	queue;
> +
> +		queue.mp = mp;
> +		pf_args[0] = start_inode_prefetch(0, 1, NULL);
> +		for (i = 0; i < glob_agcount; i++) {
> +			pf_args[(~i) & 1] = start_inode_prefetch(i + 1, 1,
> +					pf_args[i & 1]);
> +			traverse_function(&queue, i, pf_args[i & 1]);
> +		}
> +		return;
>  	}
> +
> +	/*
> +	 * create one worker thread for each segment of the volume
> +	 */
> +	queues = malloc(thread_count * sizeof(work_queue_t));
> +	for (i = 0, agno = 0; i < thread_count; i++) {
> +		create_work_queue(&queues[i], mp, 1);
> +		pf_args[0] = NULL;
> +		for (j = 0; j < ag_stride && agno < glob_agcount; j++, agno++) {
> +			pf_args[0] = start_inode_prefetch(agno, 1, pf_args[0]);
> +			queue_work(&queues[i], traverse_function, agno,
> +				   pf_args[0]);
> +		}
> +	}
> +
> +	/*
> +	 * wait for workers to complete
> +	 */
> +	for (i = 0; i < thread_count; i++)
> +		destroy_work_queue(&queues[i]);
> +	free(queues);


This is the third copy of this code block, might make sense to
consolidate it.

Btw, does anyone remember why we have the libxfs_bcache_overflowed()
special case in phase4, but not anywhere else?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
