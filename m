Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25423 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751478AbdFEIdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2017 04:33:03 -0400
Subject: Re: [PATCH] fs: xfs: Fix a lock-twice and sleep-in-atomic bug in
 xfs_iget
References: <1496650649-2296-1-git-send-email-baijiaju1990@163.com>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <43a9b80f-fd7d-2df3-f726-207742c7924f@oracle.com>
Date: Mon, 5 Jun 2017 16:32:48 +0800
MIME-Version: 1.0
In-Reply-To: <1496650649-2296-1-git-send-email-baijiaju1990@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jia-Ju Bai <baijiaju1990@163.com>, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org



On 2017年06月05日 16:17, Jia-Ju Bai wrote:
> The driver may sleep under a read rcu lock, and function call path is:
> xfs_iget (acquire the lock by rcu_read_lock)
>    "goto out_error_or_again" after xfs_iget_cache_hit
>      delay
>        schedule_timeout_uninterruptible --> may sleep
> Meanwhile, the rcu_read_lock will be called twice in this situation.
>
> To fix it, the lock is released before "goto".
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
> ---
>   fs/xfs/xfs_icache.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f61c84f8..c2a4722 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -600,8 +600,10 @@ struct xfs_inode *
>   
>   	if (ip) {
>   		error = xfs_iget_cache_hit(pag, ip, ino, flags, lock_flags);
> -		if (error)
> +		if (error) {
> +			rcu_read_unlock();

Seems you are going to double unlock by doing this, since it is unlocked 
in the xfs_iget_cache_hit.

Thanks
Shan Hai

>   			goto out_error_or_again;
> +		}
>   	} else {
>   		rcu_read_unlock();
>   		XFS_STATS_INC(mp, xs_ig_missed);

