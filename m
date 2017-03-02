Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55306 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753161AbdCBQAY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Mar 2017 11:00:24 -0500
Date: Thu, 2 Mar 2017 10:59:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: back off from kmem_zalloc_greedy if the task is
 killed
Message-ID: <20170302155941.GK3213@bfoster.bfoster>
References: <20170302153002.GG3213@bfoster.bfoster>
 <20170302154541.16155-1-mhocko@kernel.org>
 <20170302154541.16155-2-mhocko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302154541.16155-2-mhocko@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Thu, Mar 02, 2017 at 04:45:41PM +0100, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> It doesn't really make much sense to retry vmalloc request if the
> current task is killed. We should rather bail out as soon as possible
> and let it RIP as soon as possible. The current implementation of
> vmalloc will fail anyway.
> 
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/kmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index ee95f5c6db45..01c52567a4ff 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -34,7 +34,7 @@ kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
>  	size_t		kmsize = maxsize;
>  
>  	while (!(ptr = vzalloc(kmsize))) {
> -		if (kmsize == minsize)
> +		if (kmsize == minsize || fatal_signal_pending(current))
>  			break;
>  		if ((kmsize >>= 1) <= minsize)
>  			kmsize = minsize;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
