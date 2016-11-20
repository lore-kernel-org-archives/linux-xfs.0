Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56406 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753071AbcKTDji (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 19 Nov 2016 22:39:38 -0500
Subject: Re: [PATCH] fs: xfs: xfs_icreate_item: constify xfs_item_ops
 structure
References: <1479561411-27987-1-git-send-email-bhumirks@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <96126b0e-f786-5adf-ff57-f2b3ae98fa2d@sandeen.net>
Date: Sat, 19 Nov 2016 21:39:36 -0600
MIME-Version: 1.0
In-Reply-To: <1479561411-27987-1-git-send-email-bhumirks@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bhumika Goyal <bhumirks@gmail.com>, julia.lawall@lip6.fr, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org


On 11/19/16 7:16 AM, Bhumika Goyal wrote:
> Declare the structure xfs_item_ops as const as it is only passed as an
> argument to the function xfs_log_item_init. As this argument is of type
> const struct xfs_item_ops *, so xfs_item_ops structures having this
> property can be declared as const.
> Done using Coccinelle:
> 
> @r1 disable optional_qualifier @
> identifier i;
> position p;
> @@
> static struct xfs_item_ops i@p = {...};
> 
> @ok1@
> identifier r1.i;
> position p;
> expression e1,e2,e3;
> @@
> xfs_log_item_init(e1,e2,e3,&i@p)
> 
> @bad@
> position p!={r1.p,ok1.p};
> identifier r1.i;
> @@
> i@p
> 
> @depends on !bad disable optional_qualifier@
> identifier r1.i;
> @@
> static
> +const
> struct xfs_item_ops i={...};
> 
> @depends on !bad disable optional_qualifier@
> identifier r1.i;
> @@
> +const
> struct xfs_item_ops i;
> 
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>     737	     64	      8	    809	    329	fs/xfs/xfs_icreate_item.o
> 
> File size after:
>    text	   data	    bss	    dec	    hex	filename
>     801	      0	      8	    809	    329	fs/xfs/xfs_icreate_item.o
> 
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Sure, every other xfs_item_ops structure is a const.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  fs/xfs/xfs_icreate_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index d45ca72..865ad13 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -133,7 +133,7 @@ static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
>  /*
>   * This is the ops vector shared by all buf log items.
>   */
> -static struct xfs_item_ops xfs_icreate_item_ops = {
> +static const struct xfs_item_ops xfs_icreate_item_ops = {
>  	.iop_size	= xfs_icreate_item_size,
>  	.iop_format	= xfs_icreate_item_format,
>  	.iop_pin	= xfs_icreate_item_pin,
> 
