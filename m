Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6FBE57F54
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 17:12:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 354B38F8033
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 15:12:27 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	z136fcuSCrD9JZIa for <xfs@oss.sgi.com>;
	Mon, 16 Nov 2015 15:12:24 -0800 (PST)
Date: Tue, 17 Nov 2015 10:12:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 11/11] xfs: add support for DAX fsync/msync
Message-ID: <20151116231222.GY19199@dastard>
References: <1447459610-14259-1-git-send-email-ross.zwisler@linux.intel.com>
	<1447459610-14259-12-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447459610-14259-12-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: x86@kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Fri, Nov 13, 2015 at 05:06:50PM -0700, Ross Zwisler wrote:
> To properly support the new DAX fsync/msync infrastructure filesystems
> need to call dax_pfn_mkwrite() so that DAX can properly track when a user
> write faults on a previously cleaned address.  They also need to call
> dax_fsync() in the filesystem fsync() path.  This dax_fsync() call uses
> addresses retrieved from get_block() so it needs to be ordered with
> respect to truncate.  This is accomplished by using the same locking that
> was set up for DAX page faults.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/xfs/xfs_file.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 39743ef..2b490a1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -209,7 +209,8 @@ xfs_file_fsync(
>  	loff_t			end,
>  	int			datasync)
>  {
> -	struct inode		*inode = file->f_mapping->host;
> +	struct address_space	*mapping = file->f_mapping;
> +	struct inode		*inode = mapping->host;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error = 0;
> @@ -218,7 +219,13 @@ xfs_file_fsync(
>  
>  	trace_xfs_file_fsync(ip);
>  
> -	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
> +	if (dax_mapping(mapping)) {
> +		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +		dax_fsync(mapping, start, end);
> +		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +	}
> +
> +	error = filemap_write_and_wait_range(mapping, start, end);

Ok, I don't understand a couple of things here.

Firstly, if it's a DAX mapping, why are we still calling
filemap_write_and_wait_range() after the dax_fsync() call that has
already written back all the dirty cachelines?

Secondly, exactly what is the XFS_MMAPLOCK_SHARED lock supposed to
be doing here? I don't see where dax_fsync() has any callouts to
get_block(), so the comment "needs to be ordered with respect to
truncate" doesn't make any obvious sense. If we have a racing
truncate removing entries from the radix tree, then thanks to the
mapping tree lock we'll either find an entry we need to write back,
or we won't find any entry at all, right?

Lastly, this flushing really needs to be inside
filemap_write_and_wait_range(), because we call the writeback code
from many more places than just fsync to ensure ordering of various
operations such that files are in known state before proceeding
(e.g. hole punch).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
