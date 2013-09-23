Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35E5B29DFB
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 19:57:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 018478F8035
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 17:57:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	CDj1eomNlXgzwTQX for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 17:57:00 -0700 (PDT)
Date: Mon, 23 Sep 2013 10:56:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix the wrong new_size/rnew_size at
	xfs_iext_realloc_direct()
Message-ID: <20130923005657.GN12541@dastard>
References: <523EA96B.3040904@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <523EA96B.3040904@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Sep 22, 2013 at 04:25:15PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> At xfs_iext_realloc_direct(), the new_size is changed by adding
> if_bytes if originally the extent records are stored at the inline
> extent buffer, and we have to switch from it to a direct extent
> list for those new allocated extents, this is wrong. e.g,
> 
> Create a file with three extents which was showing as following,
> 
> xfs_io -f -c "truncate 100m" /xfs/testme
> 
> for i in $(seq 0 5 10); do
> 	offset=$(($i * $((1 << 20))))
> 	xfs_io -c "pwrite $offset 1m" /xfs/testme
> done
> 
> Inline
> ------
> irec:	if_bytes	bytes_diff	new_size
> 1st	0		16		16
> 2nd	16		16		32
> 
> Switching
> ---------						rnew_size
> 3rd	32		16		48 + 32 = 80	roundup=128
> 
> In this case, the desired value of new_size should be 48, and then
> it will be roundup to 64 and be assigned to rnew_size.

Ok, so it allocates 128 bytes instead of 64 bytes. It tracks that
allocation size correctly ifp->if_real_bytes, and all it means is
that there are 4 empty extra slots in the extent array. The code
already handles having empty slots in the direct extent array, so
what impact is there as a result of the oversized initial allocation
that is currently happening?

i.e. if fixing the oversized results in more memory allocations due
to resizing more regularly, then is there a benefit to changing this
code given that the rewrite of the ifp->if_bytes value in the case
where we do inline->direct conversion prevents this over-allocation
from being a problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
