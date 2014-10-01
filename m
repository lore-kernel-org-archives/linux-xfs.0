Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 763B37F6F
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 17:23:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65333304048
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 15:23:43 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UUz1242yir2zhvpp for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 15:23:41 -0700 (PDT)
Date: Thu, 2 Oct 2014 08:23:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: add RWF_NONBLOCK support
Message-ID: <20141001222327.GT4758@dastard>
References: <1412197494-7655-1-git-send-email-hch@lst.de>
	<1412197494-7655-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1412197494-7655-2-git-send-email-hch@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, Milosz Tanski <milosz@adfin.com>, xfs@oss.sgi.com

On Wed, Oct 01, 2014 at 11:04:52PM +0200, Christoph Hellwig wrote:
> Add support for non-blocking reads.  The guts are handled by the generic
> code, the only addition is a non-blocking variant of xfs_rw_ilock.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 30 +++++++++++++++++++++++++-----
>  1 file changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index cf61271..f9efffc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -61,6 +61,23 @@ xfs_rw_ilock(
>  	xfs_ilock(ip, type);
>  }
>  
> +static inline bool
> +xfs_rw_ilock_nowait(
> +	struct xfs_inode	*ip,
> +	int			type)
> +{
> +	if (type & XFS_IOLOCK_EXCL) {
> +		if (!mutex_trylock(&VFS_I(ip)->i_mutex))
> +			return false;
> +	}
> +	if (!xfs_ilock_nowait(ip, type)) {
> +		mutex_unlock(&VFS_I(ip)->i_mutex);

Shouldn't that be:

		if (type & XFS_IOLOCK_EXCL) {
			mutex_unlock(&VFS_I(ip)->i_mutex);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
