Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50316 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbeKUJeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 04:34:11 -0500
Date: Tue, 20 Nov 2018 15:02:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] splice: increase pipe size in
 splice_direct_to_actor()
Message-ID: <20181120230231.GN6792@magnolia>
References: <20181119211742.8824-1-david@fromorbit.com>
 <20181119211742.8824-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119211742.8824-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Nov 20, 2018 at 08:17:41AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When copy_file_range() is called on files that have been opened with
> O_DIRECT, do_splice_direct() does a manual copy of the range one
> pipe buffer at a time. The default is 16 pages, which means on
> x86_64 it is limited to 64kB IO. This is extremely slow - 64k
> synchrnous read/write will run at maybe 5-10MB/s on a spinning disk
> and be seek bound. It will be faster on SSDs, but still very
> inefficient.
> 
> Increase the pipe size to the maximum allowed user size so that we
> can get decent throughput for this highly sub-optimal copy loop.  We
> also don't care if changing the pipe size fails - that will just
> result in a slower copy.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks fine to me but what do I know about pipe administration policy? :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/pipe.c                 | 2 +-
>  fs/splice.c               | 8 ++++++++
>  include/linux/pipe_fs_i.h | 1 +
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index bdc5d3c0977d..5885d29cdaa6 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -1025,7 +1025,7 @@ unsigned int round_pipe_size(unsigned long size)
>   * Allocate a new array of pipe buffers and copy the info over. Returns the
>   * pipe size if successful, or return -ERROR on error.
>   */
> -static long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
> +long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg)
>  {
>  	struct pipe_buffer *bufs;
>  	unsigned int size, nr_pages;
> diff --git a/fs/splice.c b/fs/splice.c
> index 3553f1956508..64dcc622db8d 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -34,6 +34,7 @@
>  #include <linux/socket.h>
>  #include <linux/compat.h>
>  #include <linux/sched/signal.h>
> +#include <linux/pipe_fs_i.h>
>  
>  #include "internal.h"
>  
> @@ -931,6 +932,13 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>  		current->splice_pipe = pipe;
>  	}
>  
> +	/*
> +	 * Try to increase the data holding capacity of the pipe so we can do
> +	 * larger IOs. This may not increase the size at all because maximum
> +	 * user pipe size is administrator controlled, but we still should try.
> +	 */
> +	pipe_set_size(pipe, pipe_max_size);
> +
>  	/*
>  	 * Do the splice.
>  	 */
> diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
> index 5a3bb3b7c9ad..e7d728e5b5f8 100644
> --- a/include/linux/pipe_fs_i.h
> +++ b/include/linux/pipe_fs_i.h
> @@ -191,5 +191,6 @@ struct pipe_inode_info *get_pipe_info(struct file *file);
>  
>  int create_pipe_files(struct file **, int);
>  unsigned int round_pipe_size(unsigned long size);
> +long pipe_set_size(struct pipe_inode_info *pipe, unsigned long arg);
>  
>  #endif
> -- 
> 2.19.1
> 
