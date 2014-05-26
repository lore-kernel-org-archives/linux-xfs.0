Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A226029DF8
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 17:49:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 763CF8F8059
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 15:49:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4YJAah0BcZna1foE for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 15:49:35 -0700 (PDT)
Date: Tue, 27 May 2014 08:49:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/3] xfs: add scan owner field to xfs_eofblocks
Message-ID: <20140526224921.GQ18954@dastard>
References: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
	<1400845950-41435-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1400845950-41435-2-git-send-email-bfoster@redhat.com>
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

On Fri, May 23, 2014 at 07:52:28AM -0400, Brian Foster wrote:
> The scan owner field represents an optional inode number that is
> responsible for the current scan. The purpose is to identify that an
> inode is under iolock and as such, the iolock shouldn't be attempted
> when trimming eofblocks. This is an internal only field.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 12 +++++++++++-
>  fs/xfs/xfs_icache.h |  2 ++
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c48df5f..f4191f6 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1211,6 +1211,7 @@ xfs_inode_free_eofblocks(
>  {
>  	int ret;
>  	struct xfs_eofblocks *eofb = args;
> +	bool need_iolock = true;
>  
>  	if (!xfs_can_free_eofblocks(ip, false)) {
>  		/* inode could be preallocated or append-only */
> @@ -1235,9 +1236,18 @@ xfs_inode_free_eofblocks(
>  		if (eofb->eof_flags & XFS_EOF_FLAGS_MINFILESIZE &&
>  		    XFS_ISIZE(ip) < eofb->eof_min_file_size)
>  			return 0;
> +
> +		/*
> +		 * A scan owner implies we already hold the iolock. Skip it in
> +		 * xfs_free_eofblocks() to avoid deadlock. This also eliminates
> +		 * the possibility of EAGAIN being returned.
> +		 */
> +		if (eofb->eof_scan_owner != NULLFSINO &&
> +		    eofb->eof_scan_owner == ip->i_ino)
> +			need_iolock = false;

No need to check against NULLFSINO there. ip->i_ino can never be
NULLFSINO, so just checking eofb->eof_scan_owner == ip->i_ino is
sufficient.

What might be an idea is adding a

	ASSERT(eofb->eof_scan_owner != 0);

to the start of the function to catch anyone who does not initialise
it appropriately. The inode number can never be zero (that would
translate to block 0 - the primary superblock) and so this woul dbe
sufficient to ensure callers are doing the right thing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
