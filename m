Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:55629 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387575AbeHANfV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 09:35:21 -0400
Received: by mail-wm0-f48.google.com with SMTP id f21-v6so6637045wmc.5
        for <linux-xfs@vger.kernel.org>; Wed, 01 Aug 2018 04:49:55 -0700 (PDT)
Date: Wed, 1 Aug 2018 13:49:51 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfsprogs 4.17.0 error building xfs_repair
Message-ID: <20180801114951.a54jwkinr5rb5ori@odin.usersys.redhat.com>
References: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
 <20180801042146.GI2234@dastard>
 <CAJCQCtTv4ppBr1jxJBg4hBWfxDO=J2jZVYj-ZvZTADcb7KHT3g@mail.gmail.com>
 <f052c332-e154-9aa7-7cdf-c1b92a7d994d@sandeen.net>
 <CAJCQCtT9UoXdpF0OhWtEN7x_tKCZksJYY_BLqe-x68c8ubq81A@mail.gmail.com>
 <87156058-fd41-8130-7206-7cdc9e1a85d9@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87156058-fd41-8130-7206-7cdc9e1a85d9@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, Dave Chinner <david@fromorbit.com>, xfs list <linux-xfs@vger.kernel.org>

On Wed, Aug 01, 2018 at 12:09:15AM -0500, Eric Sandeen wrote:
> On 8/1/18 12:06 AM, Chris Murphy wrote:
> 
> > And then I found the xfsprogs.spec file for Fedora 29's xfsprogs which contains:
> > 
> > %configure \
> >      --enable-readline=yes \
> >      --enable-blkid=yes \
> >      --enable-lto=no
> > 

Thing is, unless I'm looking at the wrong file, doc/INSTALL under xfsprogs, only
require such options when building xfsprogs in MacOS, the Linux instructions are
pretty straight forward"

"
   To build the package and install it manually, use the following steps:

       # make
       # su root
       # make install
       [and optionally, for the development libraries and headers]
       # make install-dev
"

Why are you using such options if you are building it on Fedora?



> > 
> > That too blows up, likely because I don't have readline-devel.x86_64 installed.
> 
> If you're gonna read the spec, read the whole spec:
> 
> BuildRequires:  gcc
> BuildRequires:  libtool, gettext, libattr-devel, libuuid-devel
> BuildRequires:  readline-devel, libblkid-devel >= 2.17-0.1.git5e51568
> Buildrequires:  libunistring-devel, lvm2-devel
> Provides:       xfs-cmds
> 
> or, you know, just rebuild 
> https://kojipkgs.fedoraproject.org/packages/xfsprogs/4.17.0/3.fc29/src/xfsprogs-4.17.0-3.fc29.src.rpm
> if you want 4.17.0 on fedora.
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
