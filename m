Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q220Kl24209345 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 18:20:47 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yCmw4RuvJbPdFNvX for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 16:20:45 -0800 (PST)
Date: Fri, 2 Mar 2012 11:20:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: pick up 4k physical sector size
Message-ID: <20120302002043.GD5091@dastard>
References: <4F500690.2080804@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F500690.2080804@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Mar 01, 2012 at 05:30:24PM -0600, Eric Sandeen wrote:
> This splits the fs topology sectorsize into logical & physical,
> and gets both via blkid_get_topology.
> 
> After that there are various gyrations & warnings to handle
> various combinations of specified sector, blocksize, and
> what's actually found on disk.
> 
> mkfs.xfs's "sector size" gets reduced to logical if
> a block size < physical sector size is specified, for
> example.

Looks good, just a minor comment:

> +		sectorsize = ft.psectorsize ? ft.psectorsize :
> +					      XFS_MIN_SECTORSIZE;
> +
> +		if ((blocksize < sectorsize) && (blocksize >= ft.lsectorsize)) {
> +			fprintf(stderr, _("specified blocksize %d is less than "
> +					  "device physical sector size %d\n"),
> +					  blocksize, ft.psectorsize);

i wouldn't break the format string like that. Doing:

			fprintf(stderr,
	_("specified blocksize %d is less than device physical sector size %d\n"),
				blocksize, ft.psectorsize);

Is consistent with long format strings elsewhere in the xfsprogs
code, and it makes grepping easy. Same for each of the other long
format strings you broke in half...

Other than that, consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
