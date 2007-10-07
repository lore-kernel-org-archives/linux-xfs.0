Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 08:48:23 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l97FmD7D028733
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 08:48:15 -0700
Date: Sun, 7 Oct 2007 11:48:14 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mounting raid5 with different unit values
In-Reply-To: <20071007145213.GA4504@puku.stupidest.org>
Message-ID: <Pine.LNX.4.64.0710071147390.22702@p34.internal.lan>
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
 <20071007145213.GA4504@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Raz <raziebe@gmail.com>, linux-xfs@oss.sgi.com



On Sun, 7 Oct 2007, Chris Wedgwood wrote:

> On Sun, Oct 07, 2007 at 09:15:23AM +0200, Raz wrote:
>
>> mount -osunit=6144,swidth=18432 /dev/md1 /d1/
>
> those values are set when you make the filesystem, not mount it
>
> see the mkfs.xfs man page
>
>

?

man mount :)

        sunit=value and swidth=value
               Used to specify the stripe unit and width for a RAID device or a
               stripe volume.  value must be specified in 512-byte block units.
               If this option is not specified and the filesystem was made on a
               stripe volume or the stripe width or unit were specified for the
               RAID device at mkfs  time,  then  the  mount  system  call  will
               restore the value from the superblock.  For filesystems that are
               made directly on RAID devices, these  options  can  be  used  to
               override  the  information  in  the superblock if the underlying
               disk layout changes after the filesystem has been created.   The
               swidth  option  is  required if the sunit option has been speci-
               fied, and must be a multiple of the sunit value.

He should be able to specify those option from the command line using 
mount.

Justin.
