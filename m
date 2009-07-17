Return-Path: <xfs-bounces@oss.sgi.com>
Received: from fransum.emea.sgi.com (fransum.emea.sgi.com [144.253.208.10])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6HBjN4b085689 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 06:45:23 -0500
Subject: Re: [PATCH V3] reduce bmv_count in xfs_vn_fiemap
References: <4A5E2F01.7030107@sandeen.net>
	<bzybpnkhp62.fsf@fransum.emea.sgi.com> <4A5F3DBA.9040005@sandeen.net>
	<4A5F7B7B.6020903@sandeen.net>
From: Olaf Weber <olaf@sgi.com>
Date: Fri, 17 Jul 2009 13:46:02 +0200
In-Reply-To: <4A5F7B7B.6020903@sandeen.net> (Eric Sandeen's message of "Thu,
	16 Jul 2009 14:11:55 -0500")
Message-ID: <bzyy6qnsfb9.fsf@fransum.emea.sgi.com>
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
> resulting in ENOMEM every time.

> Chop it down to something reasonable, the number of slots
> in the caller's input buffer.  If this is too large the 
> caller may get ENOMEM but the reason should not be a
> mystery, and they can try again with something smaller.

> We add 1 to the value because in the normal getbmap
> world, bmv_count includes the header and xfs_getbmap does:

>         nex = bmv->bmv_count - 1;
>         if (nex <= 0)
>                 return XFS_ERROR(EINVAL);

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-by: Olaf Weber <olaf@sgi.com>

> ---

> V2: set it to the fiemap info's fi_extents_max
> V3: bump up by one to accomodate expected bmv header in core

> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index 58973bb..954d701 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -680,8 +680,7 @@ xfs_vn_fiemap(
>  	else
>  		bm.bmv_length = BTOBB(length);
 
> -	/* our formatter will tell xfs_getbmap when to stop. */
> -	bm.bmv_count = MAXEXTNUM;
> +	bm.bmv_count = fieinfo->fi_extents_max + 1;
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
