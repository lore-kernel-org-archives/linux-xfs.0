Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXSAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 14:00:15 -0400
Date: Mon, 24 Jun 2019 10:59:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/10] xfs: mount-api - rename xfs_fill_super()
Message-ID: <20190624175947.GA5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134516161.2519.11373830976371295990.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134516161.2519.11373830976371295990.stgit@fedora-28>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ian Kent <raven@themaw.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Dave Chinner <dchinner@redhat.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>

On Mon, Jun 24, 2019 at 10:59:21AM +0800, Ian Kent wrote:
> Now the legacy mount functions have been removed xfs_fill_super()
> can be renamed to xfs_fs_fill_super() in keeping with the previous
> xfs naming convention.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok I guess.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 643b40e8a328..38f3af44fbbf 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1756,7 +1756,7 @@ __xfs_fs_fill_super(
>  }
>  
>  STATIC int
> -xfs_fill_super(
> +xfs_fs_fill_super(
>  	struct super_block	*sb,
>  	struct fs_context	*fc)
>  {
> @@ -1798,7 +1798,7 @@ STATIC int
>  xfs_get_tree(
>  	struct fs_context	*fc)
>  {
> -	return vfs_get_block_super(fc, xfs_fill_super);
> +	return vfs_get_block_super(fc, xfs_fs_fill_super);
>  }
>  
>  STATIC void
> 
