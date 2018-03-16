Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45206 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbeCPFaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Mar 2018 01:30:22 -0400
Date: Thu, 15 Mar 2018 22:30:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] workqueue: add missing pthreads header
Message-ID: <20180316053016.GB1757@magnolia>
References: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c05fc32d43b3870b63539c57428e1c52e3e7c3cd.1521177696.git.baruch@tkos.co.il>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-xfs@vger.kernel.org

On Fri, Mar 16, 2018 at 07:21:35AM +0200, Baruch Siach wrote:
> Fix the following build failure with musl libc:
> 
> In file included from read_verify.c:25:0:
> ../include/workqueue.h:39:2: error: unknown type name 'pthread_t'
>   pthread_t  *threads;
>   ^~~~~~~~~
> ../include/workqueue.h:42:2: error: unknown type name 'pthread_mutex_t'
>   pthread_mutex_t  lock;
>   ^~~~~~~~~~~~~~~
> ../include/workqueue.h:43:2: error: unknown type name 'pthread_cond_t'
>   pthread_cond_t  wakeup;
>   ^~~~~~~~~~~~~~
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  include/workqueue.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/workqueue.h b/include/workqueue.h
> index b4b3541701df..edb2f8ac5991 100644
> --- a/include/workqueue.h
> +++ b/include/workqueue.h
> @@ -22,6 +22,8 @@
>  #ifndef	_WORKQUEUE_H_
>  #define	_WORKQUEUE_H_
>  
> +#include <pthread.h>

Ooops, sorry about that.

Our convention within xfsprogs sources (I think) is for most header
files to avoid having headers include other headers.  Would you mind
adding this include to read_verify.c instead?

(That said, you probably ought to wait for the maintainer (Eric) to
weigh in on this before you do any more work.)

--D

> +
>  struct workqueue;
>  
>  typedef void workqueue_func_t(struct workqueue *wq, uint32_t index, void *arg);
> -- 
> 2.16.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
