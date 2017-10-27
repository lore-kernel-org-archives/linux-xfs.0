Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932364AbdJ0AtT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 20:49:19 -0400
Subject: Re: [PATCH 04/10] xfs_repair: fix bag memory overwrite problems
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905611939.28563.11849739851792896762.stgit@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <ebe28b54-c095-a2d2-ffb7-95f2e7017455@redhat.com>
Date: Thu, 26 Oct 2017 19:49:17 -0500
MIME-Version: 1.0
In-Reply-To: <150905611939.28563.11849739851792896762.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 10/26/17 5:15 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's an off by one error in the bag_remove code such that we end up
> copying memory from beyond the end of the array into the array.  Not a
> serious problem since we have counters to prevent us from reading that
> garbage, but AddressSanitizer complained so let's fix it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/slab.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/repair/slab.c b/repair/slab.c
> index 8609270..d47448a 100644
> --- a/repair/slab.c
> +++ b/repair/slab.c
> @@ -469,7 +469,7 @@ bag_remove(
>  {
>  	ASSERT(nr < bag->bg_inuse);
>  	memmove(&bag->bg_ptrs[nr], &bag->bg_ptrs[nr + 1],
> -		(bag->bg_inuse - nr) * sizeof(void *));
> +		(bag->bg_inuse - nr - 1) * sizeof(void *));
>  	bag->bg_inuse--;
>  	return 0;
>  }
> 

