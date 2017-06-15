Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52036 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751459AbdFOTL5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jun 2017 15:11:57 -0400
Subject: Re: [PATCH 2/3] xfs_repair: add prefetch trace calls to debug thread
 creation failures
References: <1484627973-11535-1-git-send-email-jeffm@suse.com>
 <1484627973-11535-3-git-send-email-jeffm@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4d7e3221-b8e0-0087-cf09-42e63b13ac30@sandeen.net>
Date: Thu, 15 Jun 2017 14:11:55 -0500
MIME-Version: 1.0
In-Reply-To: <1484627973-11535-3-git-send-email-jeffm@suse.com>
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
> When debugging prefetch failures, it's useful to have thread creation
> failure messages that are output as warnings on stderr in the trace
> log as well.  It's also helpful to see when an AG gets queued behind
> another one rather than having the thread started directly, which
> has a separate trace line.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/prefetch.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 044fab2..37d60d6 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -703,6 +703,8 @@ pf_queuing_worker(
>  		if (err != 0) {
>  			do_warn(_("failed to create prefetch thread: %s\n"),
>  				strerror(err));
> +			pftrace("failed to create prefetch thread for AG %d: %s",
> +				args->agno, strerror(err));
>  			args->io_threads[i] = 0;
>  			if (i == 0) {
>  				pf_start_processing(args);
> @@ -817,6 +819,8 @@ pf_create_prefetch_thread(
>  	if (err != 0) {
>  		do_warn(_("failed to create prefetch thread: %s\n"),
>  			strerror(err));
> +		pftrace("failed to create prefetch thread for AG %d: %s",
> +			args->agno, strerror(err));
>  		args->queuing_thread = 0;
>  		cleanup_inode_prefetch(args);
>  	}
> @@ -882,8 +886,11 @@ start_inode_prefetch(
>  		if (prev_args->prefetch_done) {
>  			if (!pf_create_prefetch_thread(args))
>  				args = NULL;
> -		} else
> +		} else {
>  			prev_args->next_args = args;
> +			pftrace("queued AG %d after AG %d",
> +				args->agno, prev_args->agno);
> +		}
>  		pthread_mutex_unlock(&prev_args->lock);
>  	}
>  
> 
