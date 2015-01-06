Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 61F4B7FA6
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 17:36:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4175A8F8033
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 15:36:49 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Uee7ggOG11SD7xs7 for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 15:36:47 -0800 (PST)
Date: Wed, 7 Jan 2015 10:21:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/18] xfs: do not allocate blocks when converting
	unwritten extents
Message-ID: <20150106232103.GF31508@dastard>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-17-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-17-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 05:28:39PM +0100, Christoph Hellwig wrote:
> Current xfs_bmapi_write always allocates blocks when it encounters a
> hole.  But for unwritten extent conversions we do not have the proper
> transaction reservations to do that, and should error out instead.
> 
> Currently this doesn't matter too much because the writeback path
> ensures that all blocks are properly allocated, but the pNFS block
> server code will accept unwritten extent conversions from clients,
> and in case of recovery from a crashed server we might get conversion
> requests for blocks whose allocation transaction hasn't made it to
> disk before the crash.  Also in general it is a good idea to be
> defensive here, especially for client initiated requests.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 15 +++++++++++++++
>  fs/xfs/xfs_iomap.c       | 17 ++++++-----------
>  2 files changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index b5eb474..be08671 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4580,6 +4580,20 @@ xfs_bmapi_write(
>  		 * that we found, if any.
>  		 */
>  		if (inhole || wasdelay) {
> +			if ((flags & (XFS_BMAPI_CONVERT|XFS_BMAPI_PREALLOC)) ==
> +					XFS_BMAPI_CONVERT) {
> +				xfs_filblks_t count;
> +
> +				if (eof)
> +					bma.got.br_startoff = end;
> +
> +				count = XFS_FILBLKS_MIN(len,
> +						bma.got.br_startoff - bno);
> +				bno += count;
> +				len -= count;
> +				goto next;
> +			}

Please add a comment to the code explaining why this check is needed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
