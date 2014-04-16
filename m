Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C50937F5A
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 17:10:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AD23830408C
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 15:10:04 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	viRamAyG04Czo0OQ for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 15:10:02 -0700 (PDT)
Date: Thu, 17 Apr 2014 08:10:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix 32bit __divdi3 undefined
Message-ID: <20140416221000.GO15995@dastard>
References: <534EAB41.60901@windriver.com> <20140416215223.512644029@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416215223.512644029@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, XFS Filesystem <xfs@oss.sgi.com>

On Wed, Apr 16, 2014 at 04:51:56PM -0500, Mark Tinguely wrote:
> The roundup in commit 68c1fb5d should be a roundup_64()
> because it is desired to round a 64 bit type by an integer
> and that will result in a 64 bit value. On 32 bit machines
> using roundup() in this case will result in the error:
> 
>  ERROR: "__divdi3" [fs/xfs/xfs.ko] undefined!
> 
> Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_aops.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/fs/xfs/xfs_aops.c
> ===================================================================
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1365,7 +1365,7 @@ __xfs_get_blocks(
>  		if (offset < i_size_read(inode) &&
>  		    offset + mapping_size >= i_size_read(inode)) {
>  			/* limit mapping to block that spans EOF */
> -			mapping_size = roundup(i_size_read(inode) - offset,
> +			mapping_size = roundup_64(i_size_read(inode) - offset,
>  					       1 << inode->i_blkbits);
>  		}
>  		if (mapping_size > LONG_MAX)

I'm not going to apply this as a patch - I'm going to rebase the
branch with the fix in the original patch so we don't have a bisect
breakage in the branch. Don't worry, I'll add the fact you fixed the
bug into the commit message...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
