Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49044 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031530AbeEXRLl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 13:11:41 -0400
Subject: Re: [PATCH] xfs: fix inobt magic number check
References: <20180524155553.GO14384@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3fb6744f-15af-48b6-1e99-7629373cfbce@sandeen.net>
Date: Thu, 24 May 2018 12:11:39 -0500
MIME-Version: 1.0
In-Reply-To: <20180524155553.GO14384@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 5/24/18 10:55 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit a6a781a58befcbd467c ("xfs: have buffer verifier functions
> report failing address") the bad magic number return was ported
> incorrectly.
> 
> Fixes: a6a781a58befcbd467ce843af4eaca3906aa1f08
> Reported-by: syzbot+08ab33be0178b76851c8@syzkaller.appspotmail.com
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>   fs/xfs/libxfs/xfs_ialloc_btree.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index ba053a4c124f..b04c55512159 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -296,7 +296,7 @@ xfs_inobt_verify(
>   	case cpu_to_be32(XFS_FIBT_MAGIC):
>   		break;
>   	default:
> -		return NULL;
> +		return __this_address;
>   	}
>   
>   	/* level verification */
