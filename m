Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55252 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfD1PcB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Apr 2019 11:32:01 -0400
Date: Sun, 28 Apr 2019 08:31:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't parse the mtpt mount option
Message-ID: <20190428153155.GC5207@magnolia>
References: <20190428120057.14503-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428120057.14503-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Apr 28, 2019 at 02:00:57PM +0200, Christoph Hellwig wrote:
> The text isn't really any more useful than the default unknown option
> handling.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Heh.  I guess we can skip the regular deprecation process since this
mount option hasn't worked (afaict) since ~2010.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f093ea244849..d1bd55d87f49 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -66,7 +66,7 @@ static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  enum {
>  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev, Opt_biosize,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
> -	Opt_mtpt, Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
> +	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
>  	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
>  	Opt_noikeep, Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2,
>  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
> @@ -87,7 +87,6 @@ static const match_table_t tokens = {
>  	{Opt_sunit,	"sunit=%u"},	/* data volume stripe unit */
>  	{Opt_swidth,	"swidth=%u"},	/* data volume stripe width */
>  	{Opt_nouuid,	"nouuid"},	/* ignore filesystem UUID */
> -	{Opt_mtpt,	"mtpt"},	/* filesystem mount point */
>  	{Opt_grpid,	"grpid"},	/* group-ID from parent directory */
>  	{Opt_nogrpid,	"nogrpid"},	/* group-ID from current process */
>  	{Opt_bsdgroups,	"bsdgroups"},	/* group-ID from parent directory */
> @@ -236,9 +235,6 @@ xfs_parseargs(
>  			if (!mp->m_logname)
>  				return -ENOMEM;
>  			break;
> -		case Opt_mtpt:
> -			xfs_warn(mp, "%s option not allowed on this system", p);
> -			return -EINVAL;
>  		case Opt_rtdev:
>  			kfree(mp->m_rtname);
>  			mp->m_rtname = match_strdup(args);
> -- 
> 2.20.1
> 
