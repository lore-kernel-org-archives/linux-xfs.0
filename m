Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C43C29DF5
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 16:04:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E12DFAC003
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 14:04:34 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1pHiaihkcLN0al1P for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 14:04:32 -0800 (PST)
Date: Mon, 8 Feb 2016 09:03:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] dax: pass bdev argument to dax_clear_blocks()
Message-ID: <20160207220329.GK31407@dastard>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
	<1454829553-29499-2-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454829553-29499-2-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Sun, Feb 07, 2016 at 12:19:12AM -0700, Ross Zwisler wrote:
> dax_clear_blocks() needs a valid struct block_device and previously it was
> using inode->i_sb->s_bdev in all cases.  This is correct for normal inodes
> on mounted ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
> block devices and for XFS real-time devices.
> 
> Instead, have the caller pass in a struct block_device pointer which it
> knows to be correct.
....
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 07ef29b..f722ba2 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -73,9 +73,11 @@ xfs_zero_extent(
>  	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
>  	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
>  	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
> +	struct inode	*inode = VFS_I(ip);
>  
>  	if (IS_DAX(VFS_I(ip)))
> -		return dax_clear_blocks(VFS_I(ip), block, size);
> +		return dax_clear_blocks(inode, xfs_find_bdev_for_inode(inode),
> +				block, size);

Get rid of the local inode variable and use VFS_I(ip) like the code
originally did. Do not change code that is unrelated to the
modifcation being made, especially when it results in making
the code an inconsistent mess of mixed pointer constructs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
