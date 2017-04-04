Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46152 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755367AbdDDT0W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 15:26:22 -0400
Subject: Re: [PATCH][PROGS] xfs_io: Allow setting multiple mode flags for
 fallocate()
References: <c2fdfcbb1f4ac9a71633dfbe192ed1145b12b8ac.1489799604.git.calvinowens@fb.com>
 <20170318065554.GX17542@dastard>
 <8dc5334b-a7b9-d455-25b5-5d651a3b918d@fb.com>
 <20170321215458.GC17542@dastard> <20170331041452.e7lvxwq3hla3kims@Haydn>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5615a823-a5c4-b7f0-a815-48a3c89faf15@sandeen.net>
Date: Tue, 4 Apr 2017 14:26:20 -0500
MIME-Version: 1.0
In-Reply-To: <20170331041452.e7lvxwq3hla3kims@Haydn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Calvin Owens <calvinowens@fb.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com

On 3/30/17 11:14 PM, Calvin Owens wrote:
> ---8<---
> From: Calvin Owens <calvinowens@fb.com>
> Date: Thu, 30 Mar 2017 20:50:55 -0700
> Subject: [PATCH] io/prealloc: Fix "falloc -p" to pass KEEP_SIZE
> 
> Otherwise, the syscall just returns -EOPPNOTSUPP.
> 
> Signed-off-by: Calvin Owens <calvinowens@fb.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  io/prealloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/prealloc.c b/io/prealloc.c
> index a9d66cc..1a1c9ca 100644
> --- a/io/prealloc.c
> +++ b/io/prealloc.c
> @@ -210,7 +210,7 @@ fallocate_f(
>  			mode = FALLOC_FL_KEEP_SIZE;
>  			break;
>  		case 'p':
> -			mode = FALLOC_FL_PUNCH_HOLE;
> +			mode = FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE;
>  			break;
>  		case 'u':
>  			mode = FALLOC_FL_UNSHARE_RANGE;
> -- 2.9.3
