Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1EBhtac128611 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 05:43:56 -0600
Date: Mon, 14 Feb 2011 22:46:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent leaking uninitialized stack memory in
	FSGEOMETRY_V1
Message-ID: <20110214114629.GA13052@dastard>
References: <1297347904.13370.9.camel@dan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1297347904.13370.9.camel@dan>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: security@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, aelder@sgi.com, stable@kernel.org

On Thu, Feb 10, 2011 at 09:25:04AM -0500, Dan Rosenberg wrote:
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3.  This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.  Since all other members are filled in all code
> paths and there are no padding bytes in this structure, it's safe to
> avoid an expensive memset() in favor of just clearing this one field.

If this really is a security problem, then it should use a memset.
This is not a performance critical path and there are differences in
the padding of the structure between 32 bit and 64 bit ioctl
variants (it has a compat ioctl handler) and that can only be
correctly handled by memset().

Also, using a memset means we won't have the problem of introducing
new uninitialised fields or padding if we ever rev the structure
again...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
