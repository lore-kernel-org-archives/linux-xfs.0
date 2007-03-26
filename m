Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Mar 2007 15:09:19 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2QM9E6p003285
	for <xfs@oss.sgi.com>; Mon, 26 Mar 2007 15:09:15 -0700
Subject: Re: changing xfs file system tunnings(sunit,swidth) after mkfs.xfs
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <5d96567b0703261325m8f17b2eg55e04264fee4832a@mail.gmail.com>
References: <5d96567b0703261325m8f17b2eg55e04264fee4832a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Mar 2007 08:10:30 +1000
Message-Id: <1174947030.5051.586.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, 2007-03-26 at 22:25 +0200, Raz Ben-Jehuda(caro) wrote:
> I want to change the sunit,swidth of a file system which
> was already created with a different tunnings, or at least
> mount it with a different values.
> Is it possible ?

>From the XFS section in mount(8) ...

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
       swidth  option  is  required if the sunit option has been speci‐
       fied, and must be a multiple of the sunit value.


cheers.

-- 
Nathan
