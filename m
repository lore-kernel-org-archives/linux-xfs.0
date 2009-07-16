Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6GAth2c009372 for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 05:55:44 -0500
Subject: Re: [PATCH] reduce bmv_count in xfs_vn_fiemap
References: <4A5E2F01.7030107@sandeen.net>
From: Olaf Weber <olaf@sgi.com>
Date: Thu, 16 Jul 2009 12:56:21 +0200
In-Reply-To: <4A5E2F01.7030107@sandeen.net> (Eric Sandeen's message of "Wed,
	15 Jul 2009 14:33:21 -0500")
Message-ID: <bzybpnkhp62.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen writes:

> commit 6321e3ed2acf3ee9643cdd403e1c88605d7944ba caused
> the full bmv_count's worth of getbmapx structures to get
> allocated; telling it to do MAXEXTNUM was a bit insane,
> resulting in ENOMEM.

> Chop it down to something reasonable, the caller can
> loop over this if the file has > 64 extents.

It does seem to me that this will result in an unusal case for the
caller, in that it will get fewer extents than fit in the provided
buffer, yet should loop.  Do current callers know that they can hit
this case, detect it, and loop accordingly?  Or is this just pushing
the problem/regression to userspace?

> (this is a regression, FWIW)

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

> iff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index 58973bb..370e9a7 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -680,8 +680,12 @@ xfs_vn_fiemap(
>  	else
>  		bm.bmv_length = BTOBB(length);
 
> -	/* our formatter will tell xfs_getbmap when to stop. */
> -	bm.bmv_count = MAXEXTNUM;
> +	/*
> +	 * xfs_getbmap allocates based on that; pick a count that's
> +	 * not too outragous.
> +	 * Our formatter will tell xfs_getbmap when to stop.
> +	 */
> +	bm.bmv_count = 64;
>  	bm.bmv_iflags = BMV_IF_PREALLOC;
>  	if (fieinfo->fi_flags & FIEMAP_FLAG_XATTR)
>  		bm.bmv_iflags |= BMV_IF_ATTRFORK;


-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696752
                           Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-7151
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
