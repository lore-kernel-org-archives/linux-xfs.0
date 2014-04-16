Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E26E57F60
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 16:57:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C980A8F8066
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 14:57:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CydyzjKF63tco3oX for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 14:57:17 -0700 (PDT)
Message-ID: <534EFCC1.1080008@sandeen.net>
Date: Wed, 16 Apr 2014 16:57:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix 32bit __divdi3 undefined
References: <534EAB41.60901@windriver.com> <20140416215223.512644029@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>, XFS Filesystem <xfs@oss.sgi.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>

On 4/16/14, 4:51 PM, Mark Tinguely wrote:
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

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

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
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
