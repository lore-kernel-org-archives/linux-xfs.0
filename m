Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:33801 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727193AbfGYML7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 08:11:59 -0400
Received: by mail-wm1-f44.google.com with SMTP id w9so35631189wmd.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 05:11:57 -0700 (PDT)
Date: Thu, 25 Jul 2019 14:11:54 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: Sanity check - need a second pair of eyes ;-)
Message-ID: <20190725121154.pewwwdpgejcrgdi7@pegasus.maiolino.io>
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
 <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
 <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Carlos E. R." <robin.listas@telefonica.net>
Cc: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

> 
> Thanks. 
> 
> (Yes, I looked at the manual but did not /see/ aka understand what I really needed).
> 
> My page is a little bit different:
> 
>        -s sector_size_options
>               This option specifies the fundamental  sector  size  of
>               the filesystem.  The valid sector_size_option is:
> 
>                    size=value
>                           The  sector  size is specified with a value
>                           in bytes.  The default sector_size  is  512
>                           bytes. The minimum value for sector size is
>                           512; the maximum is  32768  (32  KiB).  The
>                           sector_size  must  be a power of 2 size and
>                           cannot be made larger than  the  filesystem
>                           block size.
> 
>                           To  specify any options on the command line
>                           in units of sectors, this  option  must  be
>                           specified  first so that the sector size is
>                           applied consistently to all options.

There was an update on the manpage past year which changed this section, the
usage is the same.

> 
> Thus the final command line was:
> 
> # mkfs.xfs -L ANameUnseen -s size=2048 /dev/mapper/cr_nombre

Looks correct.


But I apologize if it's a dumb question, but what do you expect to achieve by
setting the sector size here? You will be essentially writing the fs image file
over the BluRay Filesystem (which IIRC uses UDF), so, the sector size set on
your xfs filesystem image won't matter much, unless I'm missing something, which
is exactly why I'm asking it :)

Cheers

> meta-data=/dev/mapper/cr_nombre  isize=512    agcount=4, agsize=3054592 blks
>          =                       sectsz=2048  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=0, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=12218368, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=5966, version=2
>          =                       sectsz=2048  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> -- 
> Cheers / Saludos,
> 
> 		Carlos E. R.
> 		(from 15.0 x86_64 at Telcontar)
> 




-- 
Carlos
