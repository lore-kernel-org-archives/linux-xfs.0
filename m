Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59410 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936831AbdKPVKk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 16:10:40 -0500
Subject: Re: [PATCH for 4.14] xfs_copy: don't hang if /all/ the targets hit
 write errors
References: <20171116011232.GG5119@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9bfccb40-f75c-b801-80aa-a80d05952795@sandeen.net>
Date: Thu, 16 Nov 2017 15:10:39 -0600
MIME-Version: 1.0
In-Reply-To: <20171116011232.GG5119@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, djwong@kernel.org



On 11/15/17 7:14 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If xfs_copy is told to copy a filesystem and /all/ the writer threads
> hit an write error, there won't be any threads to unlock mainwait, which
> means that write_wbuf will deadlock with itself trying to lock mainwait.
> Therefore, if we discover that all the writer threads are dead, just
> bail out.
> 
> Discovered by running xfs/073 with a tiny test device.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  copy/xfs_copy.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> index 33e05df..fb37375 100644
> --- a/copy/xfs_copy.c
> +++ b/copy/xfs_copy.c
> @@ -476,6 +476,7 @@ void
>  write_wbuf(void)
>  {
>  	int		i;
> +	int		badness = 0;
>  
>  	/* verify target threads */
>  	for (i = 0; i < num_targets; i++)
> @@ -486,6 +487,17 @@ write_wbuf(void)
>  	for (i = 0; i < num_targets; i++)
>  		if (target[i].state != INACTIVE)
>  			pthread_mutex_unlock(&targ[i].wait);	/* wake up */
> +		else
> +			badness++;
> +
> +	/*
> +	 * If all the targets are inactive then there won't be any io
> +	 * threads left to release mainwait.  We're screwed, so bail out.
> +	 */
> +	if (badness == num_targets) {
> +		check_errors();

libxfs_umount(mp); ?

-Eric

> +		exit(1);
> +	}
>  
>  	signal_maskfunc(SIGCHLD, SIG_UNBLOCK);
>  	pthread_mutex_lock(&mainwait);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
