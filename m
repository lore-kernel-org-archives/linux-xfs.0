Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 22DC37FA1
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 02:02:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AAD2CAC001
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 00:02:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	R0G19H7O15ETy7rE for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 00:02:03 -0700 (PDT)
Date: Thu, 11 Apr 2013 17:02:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair breaks with assertion
Message-ID: <20130411070201.GI10481@dastard>
References: <CAPaMSRCGSyhmnjrXpFFkEpmKrjsHqLn0kJ1xLGyf-WZosV7mmQ@mail.gmail.com>
	<20130411062515.GH10481@dastard>
	<CAPaMSRCq0f+GqTbRRCXBFUDdtmpBx=VjBaOLpdDytXunL9dfmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPaMSRCq0f+GqTbRRCXBFUDdtmpBx=VjBaOLpdDytXunL9dfmQ@mail.gmail.com>
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
To: Victor K <kvic45@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 11, 2013 at 02:34:32PM +0800, Victor K wrote:
> > Running xfs_repair /dev/md1 the first time resulted in suggestion to
> 
> > > mount/unmount to replay log, but mounting would not work. After running
> > > xfs_repair -v -L -P /dev/md1 this happens:
> > > (lots of output on stderr, moving to Phase 3, then more output - not sure
> > > if it is relevant, the log file is ~170Mb in size), then stops and prints
> > > the only line on stdout:
> >
> > Oh dear. A log file that big indicates that something *bad* has
> > happened to the array. i.e that it has most likely been put back
> > together wrong.
> >
> > Before going any further with xfs_repair, please verify that the
> > array has been put back together correctly....
> >
> >
> The raid array did not suffer, at least, not according to mdadm; it is now
> happily recovering the one disk that officially failed, but the whole thing
> assembled without a problem

Yeah, we see this often enough that all I can say is this: don't
trust what mdadm is telling you. Validate it by hand.  Massive
corruption does not occur when everything is put back together
correctly.

> There was a similar crash several weeks ago on this same array, but had
> ext4 system back then.
> I was able to save some of the latest stuff, and decided to move to xfs as
> something more reliable.

If the storage below the filesystem is unreliable, then changing
filesystems won't magically fix the problem.

> I suspect now I should also had replaced the disk controller then.

Well, that depends on whether it is the problem or not. if you are
not using hardware raid, then disk controller problems rarely result
in massive corruption of filesystems. A busted block here or there,
but they generally do not cause entire disks to suddenly becoe
corrupted.

I'd still be looking to a RAID reassembly problem than a filesystem
or a storage hardware issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
