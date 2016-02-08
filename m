Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C281A29DF5
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 09:34:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E44CAC001
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 07:34:54 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id LkV3j53B2N0TXoAN for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 07:34:53 -0800 (PST)
Date: Mon, 8 Feb 2016 08:34:43 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] dax: pass bdev argument to dax_clear_blocks()
Message-ID: <20160208153443.GC2343@linux.intel.com>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
	<1454829553-29499-2-git-send-email-ross.zwisler@linux.intel.com>
	<20160207220329.GK31407@dastard>
	<20160208014409.GA2343@linux.intel.com>
	<20160208051725.GM31407@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208051725.GM31407@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Mon, Feb 08, 2016 at 04:17:25PM +1100, Dave Chinner wrote:
> On Sun, Feb 07, 2016 at 06:44:09PM -0700, Ross Zwisler wrote:
> > On Mon, Feb 08, 2016 at 09:03:29AM +1100, Dave Chinner wrote:
> > > On Sun, Feb 07, 2016 at 12:19:12AM -0700, Ross Zwisler wrote:
> > > > dax_clear_blocks() needs a valid struct block_device and previously it was
> > > > using inode->i_sb->s_bdev in all cases.  This is correct for normal inodes
> > > > on mounted ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
> > > > block devices and for XFS real-time devices.
> > > > 
> > > > Instead, have the caller pass in a struct block_device pointer which it
> > > > knows to be correct.
> > > ....
> > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > index 07ef29b..f722ba2 100644
> > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > @@ -73,9 +73,11 @@ xfs_zero_extent(
> > > >  	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
> > > >  	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
> > > >  	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
> > > > +	struct inode	*inode = VFS_I(ip);
> > > >  
> > > >  	if (IS_DAX(VFS_I(ip)))
> > > > -		return dax_clear_blocks(VFS_I(ip), block, size);
> > > > +		return dax_clear_blocks(inode, xfs_find_bdev_for_inode(inode),
> > > > +				block, size);
> > > 
> > > Get rid of the local inode variable and use VFS_I(ip) like the code
> > > originally did. Do not change code that is unrelated to the
> > > modifcation being made, especially when it results in making
> > > the code an inconsistent mess of mixed pointer constructs....
> > 
> > The local 'inode' variable was added to avoid multiple calls for VFS_I() for
> > the same 'ip'.
> 
> My point is you didn't achieve that. The end result of your patch
> is:
> 
> 	struct inode	*inode = VFS_I(ip);
> 
> 	if (IS_DAX(VFS_I(ip)))
> 		return dax_clear_blocks(inode, xfs_find_bdev_for_inode(inode),
> 					block, size);
> 
> So now we have a local variable, but we still have 2 calls to
> VFS_I(ip). i.e. this makes the code harder to read and understand
> than before for no benefit.

*facepalm*  Yep, thanks for the correction.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
