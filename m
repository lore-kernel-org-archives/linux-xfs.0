Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Mar 2007 01:09:48 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2R89h6p023517
	for <xfs@oss.sgi.com>; Tue, 27 Mar 2007 01:09:45 -0700
Received: by ug-out-1314.google.com with SMTP id a2so1733593ugf
        for <xfs@oss.sgi.com>; Tue, 27 Mar 2007 01:09:41 -0700 (PDT)
Message-ID: <5d96567b0703270004j72d89618xe27bbf3d5e44eea1@mail.gmail.com>
Date: Tue, 27 Mar 2007 09:04:33 +0200
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: changing xfs file system tunnings(sunit,swidth) after mkfs.xfs
In-Reply-To: <1174947030.5051.586.camel@edge>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0703261325m8f17b2eg55e04264fee4832a@mail.gmail.com>
	 <1174947030.5051.586.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs@oss.sgi.com

ahha...
but did you ever tried to set an sunit value bigger than the one
set during the mkfs.xfs ?

On 3/27/07, Nathan Scott <nscott@aconex.com> wrote:
> On Mon, 2007-03-26 at 22:25 +0200, Raz Ben-Jehuda(caro) wrote:
> > I want to change the sunit,swidth of a file system which
> > was already created with a different tunnings, or at least
> > mount it with a different values.
> > Is it possible ?
>
> >From the XFS section in mount(8) ...
>
>    sunit=value and swidth=value
>        Used to specify the stripe unit and width for a RAID device or a
>        stripe volume.  value must be specified in 512-byte block units.
>        If this option is not specified and the filesystem was made on a
>        stripe volume or the stripe width or unit were specified for the
>        RAID device at mkfs  time,  then  the  mount  system  call  will
>        restore the value from the superblock.  For filesystems that are
>        made directly on RAID devices, these  options  can  be  used  to
>        override  the  information  in  the superblock if the underlying
>        disk layout changes after the filesystem has been created.   The
>        swidth  option  is  required if the sunit option has been speci‐
>        fied, and must be a multiple of the sunit value.
>
>
> cheers.
>
> --
> Nathan
>
>


-- 
Raz
