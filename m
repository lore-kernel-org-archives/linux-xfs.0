Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4C8F07F56
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 15:52:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D12D304032
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 13:52:44 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JqB5KBufrxpzgT36 for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 13:52:41 -0700 (PDT)
Date: Tue, 2 Jun 2015 06:52:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: fix sparse inodes 32-bit compile failure
Message-ID: <20150601205239.GK24666@dastard>
References: <1433169194-41808-1-git-send-email-bfoster@redhat.com>
	<1433169194-41808-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433169194-41808-2-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 01, 2015 at 10:33:13AM -0400, Brian Foster wrote:
> The kbuild test robot reports the following compilation failure with a
> 32-bit kernel configuration:
> 
> 	fs/built-in.o: In function `xfs_ifree_cluster':
> 	>> xfs_inode.c:(.text+0x17ac84): undefined reference to `__umoddi3'
> 
> This is due to the use of the modulus operator on a 64-bit variable in
> the ASSERT() added as part of the following commit:
> 
> 	xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
> 
> This ASSERT() simply checks that the offset of the inode in a sparse
> cluster is appropriately aligned. Since the maximum inode record offset
> is 63 (for a 64 inode record) and the calculated offset here should be
> something less than that, cast the offset value to a 32-bit type before
> the mod to prevent the error.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 4c054f6..16bd01b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2265,7 +2265,7 @@ xfs_ifree_cluster(
>  		 * a sparse region.
>  		 */
>  		if ((xic->alloc & XFS_INOBT_MASK(inum - xic->first_ino)) == 0) {
> -			ASSERT(((inum - xic->first_ino) %
> +			ASSERT(((int)(inum - xic->first_ino) %
>  				inodes_per_cluster) == 0);

do_mod()

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
