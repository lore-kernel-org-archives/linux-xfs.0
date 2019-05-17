Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:37328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEQW5u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 18:57:50 -0400
Subject: Re: [PATCH 7/3] libxfs: fix argument to xfs_trans_add_item
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <1bd8bba2-b884-02f6-8e49-eb2374481888@redhat.com>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <e473e37d-433f-9437-2dcd-b7760c70f00c@oracle.com>
Date: Fri, 17 May 2019 15:57:35 -0700
MIME-Version: 1.0
In-Reply-To: <1bd8bba2-b884-02f6-8e49-eb2374481888@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/16/19 1:40 PM, Eric Sandeen wrote:
> The hack of casting an inode_log_item or buf_log_item to a
> xfs_log_item_t is pretty gross; yes it's the first member in the
> structure, but yuk.  Pass in the correct structure member.
> 
> This was fixed in the kernel with commit e98c414f9
> ("xfs: simplify log item descriptor tracking")
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/trans.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index f78222fd..6ef4841f 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -346,7 +346,7 @@ xfs_trans_ijoin(
>   	ASSERT(iip->ili_lock_flags == 0);
>   	iip->ili_lock_flags = lock_flags;
>   
> -	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
> +	xfs_trans_add_item(tp, &iip->ili_item);
>   }
>   
>   void
> @@ -570,7 +570,7 @@ _xfs_trans_bjoin(
>   	 * Attach the item to the transaction so we can find it in
>   	 * xfs_trans_get_buf() and friends.
>   	 */
> -	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
> +	xfs_trans_add_item(tp, &bip->bli_item);
>   	bp->b_transp = tp;
>   
>   }
> 
