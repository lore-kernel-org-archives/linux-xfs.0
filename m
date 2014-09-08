Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45F9F7F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 07:03:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 261368F8033
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 05:03:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8ie6vAjgCl7F3FHD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 05:03:41 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s88C3dEw023957
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 8 Sep 2014 08:03:40 -0400
Date: Mon, 8 Sep 2014 08:03:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't ASSERT on corrupt ftype
Message-ID: <20140908120336.GA50018@bfoster.bfoster>
References: <540D011B.2000807@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540D011B.2000807@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Sep 07, 2014 at 08:06:35PM -0500, Eric Sandeen wrote:
> xfs_dir3_data_get_ftype() and xfs_dir2_sf_check() get
> the file type off disk, but ASSERT if it's invalid:
> 
> 	ASSERT(type < XFS_DIR3_FT_MAX);
> 
> This might be cut & paste from the "put" functions,
> which should be checking that they've not been passed
> bad values, but we shouldn't ASSERT on bad values
> read from disk.
> 

Does this lead to a problem of some kind in a valid configuration?

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index c9aee52..7e42fdf 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -270,7 +270,6 @@ xfs_dir3_data_get_ftype(
>  {
>  	__uint8_t	ftype = dep->name[dep->namelen];
> -	ASSERT(ftype < XFS_DIR3_FT_MAX);
>  	if (ftype >= XFS_DIR3_FT_MAX)
>  		return XFS_DIR3_FT_UNKNOWN;
>  	return ftype;
> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 5079e05..ea89250 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -635,7 +635,6 @@ xfs_dir2_sf_check(
>  		offset =
>  			xfs_dir2_sf_get_offset(sfep) +
>  			dp->d_ops->data_entsize(sfep->namelen);
> -		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);

This one is a DEBUG mode only function and the comment suggests the
intent is to assert on directory inconsistency..?

Brian

>  	}
>  	ASSERT(i8count == sfp->i8count);
>  	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
