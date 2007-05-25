Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 May 2007 18:53:25 -0700 (PDT)
Received: from daptopfc.localdomain (inn.nightwish.hu [217.20.130.190])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4P1rHWt028033
	for <xfs@oss.sgi.com>; Thu, 24 May 2007 18:53:20 -0700
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable
	problem
From: Pallai Roland <dap@mail.index.hu>
In-Reply-To: <20070525000547.GH85884050@sgi.com>
References: <200705241318.30711.dap@mail.index.hu>
	 <Pine.LNX.4.64.0705240720040.16751@p34.internal.lan>
	 <20070525000547.GH85884050@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 May 2007 03:35:48 +0200
Message-Id: <1180056948.6183.10.camel@daptopfc.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com


On Fri, 2007-05-25 at 10:05 +1000, David Chinner wrote:
> On Thu, May 24, 2007 at 07:20:35AM -0400, Justin Piszcz wrote:
> > On Thu, 24 May 2007, Pallai Roland wrote:
> > >I wondering why the md raid5 does accept writes after 2 disks failed. I've 
> > >an
> > >array built from 7 drives, filesystem is XFS. Yesterday, an IDE cable 
> > >failed
> > >(my friend kicked it off from the box on the floor:) and 2 disks have been
> > >kicked but my download (yafc) not stopped, it tried and could write the 
> > >file
> > >system for whole night!
> > >Now I changed the cable, tried to reassembly the array (mdadm -f --run),
> > >event counter increased from 4908158 up to 4929612 on the failed disks, 
> > >but I
> > >cannot mount the file system and the 'xfs_repair -n' shows lot of errors
> > >there. This is expainable by the partially successed writes. Ext3 and JFS
> > >has "error=" mount option to switch filesystem read-only on any error, but
> > >XFS hasn't: why?
> 
> "-o ro,norecovery" will allow you to mount the filesystem and get any
> uncorrupted data off it.
> 
> You still may get shutdowns if you trip across corrupted metadata in
> the filesystem, though.
 Thanks, I'll try it

> > >It's a good question too, but I think the md layer could
> > >save dumb filesystems like XFS if denies writes after 2 disks are failed, 
> > >and
> > >I cannot see a good reason why it's not behave this way.
> 
> How is *any* filesystem supposed to know that the underlying block
> device has gone bad if it is not returning errors?
 It is returning errors, I think so. If I try to write raid5 with 2
failed disks with dd, I've got errors on the missing chunks.
 The difference between ext3 and XFS is that ext3 will remount to
read-only on the first write error but the XFS won't, XFS only fails
only the current operation, IMHO. The method of ext3 isn't perfect, but
in practice, it's working well.

> I did mention this exact scenario in the filesystems workshop back
> in february - we'd *really* like to know if a RAID block device has gone
> into degraded mode (i.e. lost a disk) so we can throttle new writes
> until the rebuil dhas been completed. Stopping writes completely on a
> fatal error (like 2 lost disks in RAID5, and 3 lost disks in RAID6)
> would also be possible if only we could get the information out
> of the block layer.
 It would be nice, but as I mentioned above, ext3 do it well in practice
now.

> > >Do you have better idea how can I avoid such filesystem corruptions in the
> > >future? No, I don't want to use ext3 on this box. :)
> 
> Well, the problem is a bug in MD - it should have detected
> drives going away and stopped access to the device until it was
> repaired. You would have had the same problem with ext3, or JFS,
> or reiser or any other filesystem, too.
> 
> > >my mount error:
> > >XFS: Log inconsistent (didn't find previous header)
> > >XFS: failed to find log head
> > >XFS: log mount/recovery failed: error 5
> > >XFS: log mount failed
> 
> You MD device is still hosed - error 5 = EIO; the md device is
> reporting errors back the filesystem now. You need to fix that
> before trying to recover any data...
 I play with it tomorrow, thanks for your help


--
 d
