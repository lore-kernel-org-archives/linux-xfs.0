Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFDF97F51
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 08:05:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8FD50304039
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 06:05:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fVWRQPkfBqmnRqQO for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 06:05:21 -0700 (PDT)
Date: Mon, 8 Sep 2014 23:05:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't ASSERT on corrupt ftype
Message-ID: <20140908130507.GN30012@dastard>
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

No, they weren't cut-n-paste from the put functions. They were
actually designed for a metadata block where bad values would not be
written to disk, and corrupted disk blocks would be detected by CRC
validation failures. So on debug kernels it's quite appropriate to
assert fail on a "should never, ever happen" condition.

Then the v4 ftype feature bit was rammed in but none of the code got
changed to reflect that the values in the ftype fields are not CRC
protected on v4 filesystems....

> diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> index 5079e05..ea89250 100644
> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> @@ -635,7 +635,6 @@ xfs_dir2_sf_check(
>  		offset =
>  			xfs_dir2_sf_get_offset(sfep) +
>  			dp->d_ops->data_entsize(sfep->namelen);
> -		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);
>  	}
>  	ASSERT(i8count == sfp->i8count);
>  	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);

That's a debug only function validating that the shortform directory
is internally consistent. And as the comment says:

/*
 * Check consistency of shortform directory, assert if bad.
 */

So that assert should remain because it's checking the in-memory
state immediately before, during and after modifications are made to
the directory, not when it has just been read of disk....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
