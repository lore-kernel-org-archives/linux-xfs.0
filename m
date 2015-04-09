Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E05717F80
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 18:10:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88F56AC001
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 16:10:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KVE4RSIlGY98QLfX for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 16:10:45 -0700 (PDT)
Date: Fri, 10 Apr 2015 09:10:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: interesting MD-xfs bug
Message-ID: <20150409231035.GI13731@dastard>
References: <5526E8E9.3030805@gmail.com> <20150409221846.GG13731@dastard>
	<5526FB2A.8060704@gmail.com> <20150409225322.GH13731@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150409225322.GH13731@dastard>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs <xfs@oss.sgi.com>

On Fri, Apr 10, 2015 at 08:53:22AM +1000, Dave Chinner wrote:
> On Thu, Apr 09, 2015 at 06:20:26PM -0400, Joe Landman wrote:
> > 
> > 
> > On 04/09/2015 06:18 PM, Dave Chinner wrote:
> > >On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
> > >>If I build an MD raid0 with a non power of 2 chunk size, it appears
> > >>that I can mkfs.xfs a file system, but it doesn't show up in blkid
> > >>and is not mountable.  Yet, using a power of 2 chunk size, this does
> > >>work correctly.   This is kernel 3.18.9.
> > >>
> > 
> > [...]
> > 
> > >That looks more like a blkid or udev problem. try using blkid -p so
> > >that it doesn't look up the cache but directly probes devices for
> > >the signatures. strace might tell you a bit more, too. And if the
> > >filesystem mounts, then it definitely isn't an XFS problem ;)
> > 
> > Thats the thing, it didn't mount, even when I used the device name
> > directly.
> 
> Ok, that's interesting. Let me see if I can reproduce it locally. If
> you don't hear otherwise, tracing would still be useful. Thanks for
> the bug report, Joe.

No luck - md doesn't allow the device to be activated on 4.0-rc7:

$ sudo mdadm --version
mdadm - v3.3.2 - 21st August 2014
$ uname -a
Linux test4 4.0.0-rc7-dgc+ #882 SMP Fri Apr 10 08:50:52 AEST 2015 x86_64 GNU/Linux
$ sudo wipefs -a /dev/vd[ab]
/dev/vda: 4 bytes were erased at offset 0x00001000 (linux_raid_member): fc 4e 2b a9
/dev/vdb: 4 bytes were erased at offset 0x00001000 (linux_raid_member): fc 4e 2b a9
$ sudo mdadm --create /dev/md20 --level=0 --metadata=1.2 --chunk=1152 --auto=yes --raid-disks=2 /dev/vd[ab]
mdadm: RUN_ARRAY failed: Invalid argument
       Problem may be that chunk size is not a power of 2
$ cat /proc/mdstat
Personalities : [raid1] [raid10] [raid6] [raid5] [raid4] 
unused devices: <none>
$

So I can't actually reproduce what you are seeing because MD doesn't
allow the device to be activated and so mdadm tears it back down.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
