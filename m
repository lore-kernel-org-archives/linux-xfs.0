Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0P0nwqt123735 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 18:49:59 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	UEIFiaCOpA3NimLJ for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 16:49:56 -0800 (PST)
Date: Wed, 25 Jan 2012 11:49:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Partially corrupted raid array beneath xfs
Message-ID: <20120125004954.GQ15102@dastard>
References: <CAO4DVWoqgswvcSWii9uy6zuFyczVGQXFJjbgPi4XiMx+5cw2cA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAO4DVWoqgswvcSWii9uy6zuFyczVGQXFJjbgPi4XiMx+5cw2cA@mail.gmail.com>
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
To: Christopher Evans <christophere@luma-pictures.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 24, 2012 at 09:59:09AM -0800, Christopher Evans wrote:
> I made a mistake by recreating a raid 6 array, instead of taking the proper
> steps to rebuild it. Is there a way I can get find out which directories,
> files are/might be corrupted if 64k blocks of data offset every 21 times
> for an unknown count. Unfortunetly I've already mounted the raid array and
> have gotten xfs errors because of the corrupted data beneath it.

Write a script that walks the filesystem run xfs_bmap on every file
and directory and work out which one have extents that fall into the
bad range. If you walk into a corrupted directory, then you're
likely to see errors in dmesg, too.

In future we'll have a reverse mapping tree that will enable use to
avoid the tree walk to find the owners of corrupted regions like
this. I wrote half the code for it while I was at LCA last week ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
