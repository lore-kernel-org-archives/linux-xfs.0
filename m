Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 812E37F3F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 16:58:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E571304066
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 14:58:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4UIiy165l5AHEDDp for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 14:58:11 -0700 (PDT)
Date: Fri, 27 Sep 2013 07:58:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs hardware RAID alignment over linear lvm
Message-ID: <20130926215806.GQ26872@dastard>
References: <CAE3v2EaODFud_S_BzuSjtwGwuNBXhvL0RiPB1P5QroF45Obwbw@mail.gmail.com>
	<52435327.9080607@hardwarefreak.com>
	<2F959FD9-EF28-4495-9D0B-59B93D89C820@colorremedies.com>
	<20130925215713.GH26872@dastard>
	<CAE3v2EYVnXiWq1n8AJ0+Y2eifZyhV08S4uLwf6B6mXXWAzBzRA@mail.gmail.com>
	<5243FCD6.4000701@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5243FCD6.4000701@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Stewart Webb <stew@messeduphare.co.uk>, Chris Murphy <lists@colorremedies.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Sep 26, 2013 at 04:22:30AM -0500, Stan Hoeppner wrote:
> On 9/26/2013 3:55 AM, Stewart Webb wrote:
> > Thanks for all this info Stan and Dave,
> > 
> >> "Stripe size" is a synonym of XFS sw, which is su * #disks.  This is the
> >> amount of data written across the full RAID stripe (excluding parity).
> > 
> > The reason I stated Stripe size is because in this instance, I have 3ware
> > RAID controllers, which refer to
> > this value as "Stripe" in their tw_cli software (god bless manufacturers
> > renaming everything)
> > 
> > I do, however, have a follow-on question:
> > On other systems, I have similar hardware:
> > 3x Raid Controllers
> > 1 of them has 10 disks as RAID 6 that I would like to add to a logical
> > volume
> > 2 of them have 12 disks as a RAID 6 that I would like to add to the same
> > logical volume
> > 
> > All have the same "Stripe" or "Strip Size" of 512 KB
> > 
> > So if I where going to make 3 seperate xfs volumes, I would do the
> > following:
> > mkfs.xfs -d su=512k sw=8 /dev/sda
> > mkfs.xfs -d su=512k sw=10 /dev/sdb
> > mkfs.xfs -d su=512k sw=10 /dev/sdc
> > 
> > I assume, If I where going to bring them all into 1 logical volume, it
> > would be best placed to have the sw value set
> > to a value that is divisible by both 8 and 10 - in this case 2?
> 
> No.  In this case you do NOT stripe align XFS to the storage, because
> it's impossible--the RAID stripes are dissimilar.  In this case you use
> the default 4KB write out, as if this is a single disk drive.
> 
> As Dave stated, if you format a concatenated device with XFS and you
> desire to align XFS, then all constituent arrays must have the same
> geometry.
> 
> Two things to be aware of here:
> 
> 1.  With a decent hardware write caching RAID controller, having XFS
> alined to the RAID geometry is a small optimization WRT overall write
> performance, because the controller is going to be doing the optimizing
> of final writeback to the drives.
> 
> 2. Alignment does not affect read performance.

Ah, but it does...

> 3.  XFS only performs aligned writes during allocation.

Right, and it does so not only to improve write performance, but to
also maximise sequential read performance of the data that is
written, especially when multiple files are being read
simultaneously and IO latency is important to keep low (e.g.
realtime video ingest and playout).

> What really makes a difference as to whether alignment will be of
> benefit to you, and how often, is your workload.  So at this point, you
> need to describe the primary workload(s) of your systems we're discussing.

Yup, my thoughts exactly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
