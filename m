Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52032 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751459AbdFOTLx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jun 2017 15:11:53 -0400
Subject: Re: [PATCH 1/3] xfs_repair: clear pthread_t when pthread_create fails
References: <1484627973-11535-1-git-send-email-jeffm@suse.com>
 <1484627973-11535-2-git-send-email-jeffm@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7cbb636c-bcb1-6e2b-727d-1d64bd78e232@sandeen.net>
Date: Thu, 15 Jun 2017 14:11:46 -0500
MIME-Version: 1.0
In-Reply-To: <1484627973-11535-2-git-send-email-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jeffm@suse.com, linux-xfs@vger.kernel.org

On 1/16/17 10:39 PM, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> pf_queuing_worker and pf_create_prefetch_thread both try to handle
> thread creation failure gracefully, but assume that pthread_create
> doesn't modify the pthread_t when it fails.
> 
> From the pthread_create man page:
> On  success,  pthread_create() returns 0; on error, it returns an error
> number, and the contents of *thread are undefined.
> 
> In fact, glibc's pthread_create writes the pthread_t value before
> calling clone().  When we join the created threads in
> cleanup_inode_prefetch and the cleanup stage of pf_queuing_worker, we
> assume that if the pthread_t is nonzero that it's a valid thread handle
> and end up crashing in pthread_join.
> 
> This patch zeros out the handle after pthread_create failure.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Sweeping up old patches, sorry for missing these.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/prefetch.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index ff50606..044fab2 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -703,6 +703,7 @@ pf_queuing_worker(
>  		if (err != 0) {
>  			do_warn(_("failed to create prefetch thread: %s\n"),
>  				strerror(err));
> +			args->io_threads[i] = 0;
>  			if (i == 0) {
>  				pf_start_processing(args);
>  				return NULL;
> @@ -816,6 +817,7 @@ pf_create_prefetch_thread(
>  	if (err != 0) {
>  		do_warn(_("failed to create prefetch thread: %s\n"),
>  			strerror(err));
> +		args->queuing_thread = 0;
>  		cleanup_inode_prefetch(args);
>  	}
>  
> 
