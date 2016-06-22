Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D62287CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 06:25:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9AEDF8F8033
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 04:25:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZxGQCeowBTHShbjG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 04:25:28 -0700 (PDT)
Date: Wed, 22 Jun 2016 13:25:23 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v3] xfs: indentation fix in xfs_btree_get_iroot()
Message-ID: <20160622112523.GA27894@redhat.com>
References: <20160622191137.26d0725d@zenbook.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160622191137.26d0725d@zenbook.lan>
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
To: Kaho Ng <ngkaho1234@gmail.com>
Cc: xfs@oss.sgi.com


On Wed, Jun 22, 2016 at 07:11:37PM +0800, Kaho Ng wrote:
> The indentation in this function is different from the other functions.
> Those spacebars are converted to tabs to improve readability.
> 
> Signed-off-by: Kaho Ng <ngkaho1234@gmail.com>

Ah, much better.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_btree.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 1f88e1c..4f84dde 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -543,12 +543,12 @@ xfs_btree_ptr_addr(
>   */
>  STATIC struct xfs_btree_block *
>  xfs_btree_get_iroot(
> -       struct xfs_btree_cur    *cur)
> +	struct xfs_btree_cur	*cur)
>  {
> -       struct xfs_ifork        *ifp;
> +	struct xfs_ifork	*ifp;
>  
> -       ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
> -       return (struct xfs_btree_block *)ifp->if_broot;
> +	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
> +	return (struct xfs_btree_block *)ifp->if_broot;
>  }
>  
>  /*
> -- 
> 2.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
