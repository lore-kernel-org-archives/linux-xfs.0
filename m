Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L5p7Ag106327 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 00:51:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCA6414AAD0C
	for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 22:57:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	AtyJ20idbt4xxlU5 for <xfs@oss.sgi.com>;
	Sun, 20 Jun 2010 22:57:49 -0700 (PDT)
Date: Mon, 21 Jun 2010 15:53:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs partition layout  and using xfs_growfs
Message-ID: <20100621055342.GL6590@dastard>
References: <4C1EEC01.9090509@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C1EEC01.9090509@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Jun 20, 2010 at 09:35:13PM -0700, Linda A. Walsh wrote:
> 
> Is there any difference in a file systems layout and efficiency between
> to xfs fs's of the same size, but where one was created at size
> '100%', where the other was created at size 50%, but then grown
> iteratively to 60, 70, 80, 90 and then 100% over time as it filled?

Yes.

> Would the final file systems look pretty much the same

>From a structural perspective, it depends on the size of the AGs in
the initial filesystem.  If the filesystem was big enough to begin
with (i.e.  using maximally sized AGs at mkfs time) then growing it
will result in a layout exactly the same as if it was mkfs'd at full
size.

However, the allocation patterns will be significantly different
between the two filesystems, so there will be no similarity in data
layout between the two different filesystems.

> and have roughly the
> same performance characteristics?

See previous answer.

> Assume, for sake of argument, that the
> file system was grown before space got tight enough to cause any
> severe large file fragmentation.

See previous answer. ;)

> I've been under the impression that one gained some performance benefits if one
> laid out the whole file system at once  is that a mis-impression?

I wouldn't say you "gain performance benefits" by starting with a
larger filesystem, more that a grown filesystem has different aging
characteristics to one that has not been grown. See previous answer.
;)

> That asked/said...is there any work underway to create an xfs_shrinkfs, so
> that one could go the other way?

http://xfs.org/index.php/Shrinking_Support

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
