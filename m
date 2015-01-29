Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89F487FE0
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 17:37:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 777F1304039
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 15:37:17 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZnU52xKorS6iHYwH for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 15:37:15 -0800 (PST)
Date: Fri, 30 Jan 2015 10:12:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Unable to mount and repair filesystems
Message-ID: <20150129231231.GD6282@dastard>
References: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
	<54CA9586.1010607@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
	<54CAAAEC.1080803@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F0279AB@exchange.tsag.local>
	<54CAB11A.7040509@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54CAB11A.7040509@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Gerard Beekmans <GBeekmans@tsag.net>

On Thu, Jan 29, 2015 at 04:15:54PM -0600, Eric Sandeen wrote:
> On 1/29/15 3:59 PM, Gerard Beekmans wrote:
> I'm sure it's not related to this issue (unless it was very recently grown?
> Was it grown shortly before the failures?)
> 
> Hm, it would have started at 4 AGs by default, and it's the 5th one that
> looks bad; maybe that's a clue.  Are agf 6, 7, 8 etc also full of 0s?

Gerard is using the default mount options, so XFS is issuing cache
flushes and FUA with log writes. Hence if the new AG headers are
zero yet the superblock says they are valid, then that's a storage
bug.

In more detail: we force the new AGs to be written to disk
synchronously during the growfs operation before we commit the
transaction. The superblock with the larger AG count can only get on
disk after the transaction has been written to the log. Log writes
trigger a storge device cache flush, which results in the IO
ordering of:

new AG header IO
IO complete
transaction commit
....
Device cache flush
	(new AG headers guaranteed to be on disk)
journal write (FUA)
	(journal write guaranteed to be on disk)
.....
superblock write IO.

Hence if the superblock is showing 25 AGs and the new ags from 4-25
are not found on disk then either:

	a) if the grow was very recent the storage is not obeying
	cache flushes and hence breaking fundamental IO ordering
	behaviour; or,

	b) if the growfs happened long ago, the storage has lost the
	data that was written to stable media...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
