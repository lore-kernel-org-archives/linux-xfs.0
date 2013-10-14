Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8434B7F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:28:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 72C988F8040
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 13:28:44 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5mZvARzxlQ6niZkD for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 13:28:42 -0700 (PDT)
Date: Tue, 15 Oct 2013 07:28:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5 v3] xfs: always take the iolock around xfs_setattr_size
Message-ID: <20131014202840.GP4446@dastard>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075639.940898263@bombadil.infradead.org>
	<20131014140935.GA32035@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131014140935.GA32035@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Oct 14, 2013 at 07:09:35AM -0700, Christoph Hellwig wrote:
> There is no reason to conditionally take the iolock inside xfs_setattr_size
> when we can let the caller handle it unconditionally, which just incrases
> the lock hold time for the case where it was previously taken internally
> by a few instructions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
...
> @@ -750,12 +745,11 @@ xfs_setattr_size(
>  	 */
>  	if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
>  		if (!(mask & (ATTR_CTIME|ATTR_MTIME)))
> -			goto out_unlock;
> +			return 0;

That looks better :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
