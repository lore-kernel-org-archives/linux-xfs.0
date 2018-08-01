Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40236 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732959AbeHAGw7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 02:52:59 -0400
Subject: Re: xfsprogs 4.17.0 error building xfs_repair
References: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
 <20180801042146.GI2234@dastard>
 <CAJCQCtTv4ppBr1jxJBg4hBWfxDO=J2jZVYj-ZvZTADcb7KHT3g@mail.gmail.com>
 <f052c332-e154-9aa7-7cdf-c1b92a7d994d@sandeen.net>
 <CAJCQCtT9UoXdpF0OhWtEN7x_tKCZksJYY_BLqe-x68c8ubq81A@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <87156058-fd41-8130-7206-7cdc9e1a85d9@sandeen.net>
Date: Wed, 1 Aug 2018 00:09:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT9UoXdpF0OhWtEN7x_tKCZksJYY_BLqe-x68c8ubq81A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs list <linux-xfs@vger.kernel.org>

On 8/1/18 12:06 AM, Chris Murphy wrote:

> And then I found the xfsprogs.spec file for Fedora 29's xfsprogs which contains:
> 
> %configure \
>      --enable-readline=yes \
>      --enable-blkid=yes \
>      --enable-lto=no
> 
> 
> That too blows up, likely because I don't have readline-devel.x86_64 installed.

If you're gonna read the spec, read the whole spec:

BuildRequires:  gcc
BuildRequires:  libtool, gettext, libattr-devel, libuuid-devel
BuildRequires:  readline-devel, libblkid-devel >= 2.17-0.1.git5e51568
Buildrequires:  libunistring-devel, lvm2-devel
Provides:       xfs-cmds

or, you know, just rebuild 
https://kojipkgs.fedoraproject.org/packages/xfsprogs/4.17.0/3.fc29/src/xfsprogs-4.17.0-3.fc29.src.rpm
if you want 4.17.0 on fedora.

-Eric
