Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB648ErI186491 for <xfs@oss.sgi.com>; Sun, 5 Dec 2010 22:08:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6908D1C98E06
	for <xfs@oss.sgi.com>; Sun,  5 Dec 2010 20:09:58 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	CdxUFzBvYCWGMECE for <xfs@oss.sgi.com>;
	Sun, 05 Dec 2010 20:09:58 -0800 (PST)
Date: Mon, 6 Dec 2010 15:09:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101206040940.GA16103@dastard>
References: <4CF7A539.1050206@shiftmail.org> <4CF7A9CF.2020904@shiftmail.org>
	<20101202230743.GZ16922@dastard> <4CF8F9BE.6000604@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CF8F9BE.6000604@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: linux-lvm@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Dec 03, 2010 at 03:07:58PM +0100, Spelic wrote:
> On 12/03/2010 12:07 AM, Dave Chinner wrote:
> >This is a classic ENOSPC vs NFS client writeback overcommit caching
> >issue.  Have a look at the block map output - I bet theres holes in
> >the file and it's only consuming 1.5GB of disk space. use xfs_bmap
> >to check this. du should tell you the same thing.
> >
> 
> Yes you are right!
....
> root@server:/mnt/ram# xfs_bmap zerofile
> zerofile:
....
>         30: [3473240..3485567]: 2265328..2277655
>         31: [3485568..3632983]: hole
>         32: [3632984..3645311]: 2277656..2289983
>         33: [3645312..3866455]: hole
>         34: [3866456..3878783]: 2289984..2302311
> 
> (many delayed allocation extents cannot be filled because space on
> device is finished)
> 
> However ...
> 
> 
> >Basically, the NFS client overcommits the server filesystem space by
> >doing local writeback caching. Hence it caches 1.9GB of data before
> >it gets the first ENOSPC error back from the server at around 1.5GB
> >of written data. At that point, the data that gets ENOSPC errors is
> >tossed by the NFS client, and a ENOSPC error is placed on the
> >address space to be reported to the next write/sync call. That gets
> >to the dd process when it's 1.9GB into the write.
> 
> I'm no great expert but isn't this a design flaw in NFS?

Yes, sure is.

[ Well, to be precise the original NFSv2 specification
didn't have this flaw because all writes were synchronous. NFSv3
introduced asynchronous writes (writeback caching) and with it this
problem. NFSv4 does not fix this flaw. ]

> Ok in this case we were lucky it was all zeroes so XFS made a sparse
> file and could fit a 1.9GB into 1.5GB device size.
> 
> In general with nonzero data it seems to me you will get data
> corruption because the NFS client thinks it has written the data
> while the NFS server really can't write more data than the device
> size.

Yup, well known issue. Simple rule: don't run your NFS server out of
space.

> It's nice that the NFS server does local writeback caching but it
> should also cache the filesystem's free space (and check it
> periodically, since nfs-server is presumably not the only process
> writing in that filesystem) so that it doesn't accept more data than
> it can really write. Alternatively, when free space drops below 1GB
> (or a reasonable size based on network speed), nfs-server should
> turn off filesystem writeback caching.

This isn't a NFS server problem, or one that canbe worked around at
the server. it's a NFS _client_ problem in that it does not get
synchronous ENOSPC errors when using writeback caching. There is no
way for the NFS client to know the server is near ENOSPC conditions
prior to writing the data to the server as clients operate
independently.

If you really want your NFS clients to behave correctly when the
server goes ENOSPC, turn off writeback caching at the client side,
not the server (i.e. use sync mounts on the client side).
Write performance will suck, but if you want sane ENOSPC behaviour...

.....

> Holes in a random file!
> This is data corruption, and nobody is notified of this data
> corruption: no error at client side or server side!
> Is it good semantics? How could client get notified of this? Some
> kind of fsync maybe?

Use wireshark to determine if the server sends an ENOSPC to the
client when the first background write fails. I bet it does and that
your dd write failed with ENOSPC, too. Something stopped it writing
at 1.9GB....

What happens to the remaining cached writeback data in the NFS
client once the server runs out of space is NFS client specific
behaviour. If you end up with only bits of the file on the server,
ending up on the server, then that's a result of NFS client
behaviour, not a NFS server problem.

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
