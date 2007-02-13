Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 13 Feb 2007 02:31:22 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1DAVDm7005891
	for <linux-xfs@oss.sgi.com>; Tue, 13 Feb 2007 02:31:14 -0800
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: mkfs and mount tips?
Date: Tue, 13 Feb 2007 12:33:12 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.64.0702130430030.8199@p34.internal.lan>
Message-Id: <20070213103533.C89F519311@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Justin Piszcz' <jpiszcz@lucidpixels.com>
Cc: linux-xfs@oss.sgi.com



> -----Original Message-----
> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
> Sent: Tuesday, February 13, 2007 11:30 AM
> To: Leon Kolchinsky
> Cc: linux-xfs@oss.sgi.com
> Subject: Re: mkfs and mount tips?
> 
> 
> 
> On Tue, 13 Feb 2007, Leon Kolchinsky wrote:
> 
> > Hello All,
> >
> > I have Pentium II (Deschutes) with first 10GB (/dev/hda) and second
> > 60GB(/dev/hdc) disk.
> > After reading gentoo xfs threads on their forum and some SGI docs and
> FAQs I
> > came with this options for creating FS and mounting the disks:
> >
> > 1) To create XFS on hda:
> >
> > Code:
> > # mkfs.xfs -l internal,size=128m -d agcount=2 /dev/hda
> >
> >
> > I've also seen "?d unwritten=0" option:
> >
> > So my question:
> > Is it safe to add ?d unwritten=0 option to increase performance like
> this
> > (or will I lose some essential functionality)?:
> >
> > Is this how the code should look?:
> > # mkfs.xfs -l internal,size=128m -d agcount=2 ?d unwritten=0 /dev/hda
> >
> >
> > 2) To prevent data lost in case of power outage(Disabling the write back
> > cache):
> > Add the following to local.start:
> >
> > Code:
> > # hdparm -W0 /dev/hda
> > # hdparm -W0 /dev/hdc
> > # blktool /dev/hda wcache off
> > # blktool /dev/hdc wcache off
> >
> >
> > Right?
> >
> > 3) Mount options:
> >
> > On gentoo xfs thread it's suggested that the mount options should be
> > "noatime,logbufs=8"
> >
> > But what about "osyncisdsync" mount option.
> >
> > "? osyncisdsync
> > ? Writes to files opened with the O_SYNC flag set will behave as if the
> > O_DSYNC flag
> > had been used instead.
> > ? This can result in better performance without compromising data
> safety.
> > ? However timestamp updates from O_SYNC writes can be lost if the system
> > crashes.
> > Use osyncisosync to disable this setting."
> >
> > So do you think it is safe to add "osyncisdsync" mount option to fstab?
> >
> >
> > I'd appreciate any comments/tips/answers.
> >
> >
> > Best Regards,
> > Leon Kolchinsky
> >
> >
> >
> >
> >
> 
> When I was trying out different optimizations (and what I currently use on
> a couple volumes is):
> 
> logbufs=8,logbsize=262144,biosize=16,noatime,nodiratime,nobarrier
> 

I think that "nobarrier" option is bad, cause power failure would corrupt
your FS in this case.
"nodiratime" is useless here, cause you're already using noatime which
includes nodiratime AFAIK.

What about "osyncisdsync" mount option, can someone recommend this based on
its own experience?

What are other optimization options during mkfs?

Regards,
Leon
