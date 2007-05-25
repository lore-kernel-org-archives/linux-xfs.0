Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 25 May 2007 07:01:40 -0700 (PDT)
Received: from dh.localdomain (3e44a16d.adsl.index.hu [217.20.130.176])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4PE1XWt014547
	for <xfs@oss.sgi.com>; Fri, 25 May 2007 07:01:35 -0700
From: Pallai Roland <dap@mail.index.hu>
Subject: Re: raid5: I lost a XFS file system due to a minor IDE cable problem
Date: Fri, 25 May 2007 16:01:27 +0200
References: <200705241318.30711.dap@mail.index.hu> <20070525000547.GH85884050@sgi.com> <1180056948.6183.10.camel@daptopfc.localdomain>
In-Reply-To: <1180056948.6183.10.camel@daptopfc.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251601.27577.dap@mail.index.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com


On Friday 25 May 2007 03:35:48 Pallai Roland wrote:
> On Fri, 2007-05-25 at 10:05 +1000, David Chinner wrote:
> > On Thu, May 24, 2007 at 07:20:35AM -0400, Justin Piszcz wrote:
> > > On Thu, 24 May 2007, Pallai Roland wrote:
> > > >It's a good question too, but I think the md layer could
> > > >save dumb filesystems like XFS if denies writes after 2 disks are
> > > > failed, and
> > > >I cannot see a good reason why it's not behave this way.
> >
> > How is *any* filesystem supposed to know that the underlying block
> > device has gone bad if it is not returning errors?
>
>  It is returning errors, I think so. If I try to write raid5 with 2
> failed disks with dd, I've got errors on the missing chunks.
>  The difference between ext3 and XFS is that ext3 will remount to
> read-only on the first write error but the XFS won't, XFS only fails
> only the current operation, IMHO. The method of ext3 isn't perfect, but
> in practice, it's working well.
 Sorry, I was wrong: md really isn't returning error! It's madness, IMHO.

 The reason why ext3 safer on raid5 in practice is that ext3 remounts to 
read-only on read errors too and when a raid5 array got 2 failed drives and 
there's some read, the error= behavior of ext3 will be activated and stops 
further writes. You're right, it's not a good solution and there should be 
read operations to prevent data loss in this case on ext3 too. Raid5 *must 
deny all writes* when 2 disks failed: I still can't see a good reason why 
not, and the current method is braindead!

> > I did mention this exact scenario in the filesystems workshop back
> > in february - we'd *really* like to know if a RAID block device has gone
> > into degraded mode (i.e. lost a disk) so we can throttle new writes
> > until the rebuil dhas been completed. Stopping writes completely on a
> > fatal error (like 2 lost disks in RAID5, and 3 lost disks in RAID6)
> > would also be possible if only we could get the information out
> > of the block layer.
 Yes, it's sounds good, but I think we need a quick fix now, it's a real 
problem and easily can lead to mass data loss.



--
 d
