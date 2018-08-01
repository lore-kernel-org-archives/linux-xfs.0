Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:54958 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731199AbeHAGFX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 02:05:23 -0400
Date: Wed, 1 Aug 2018 14:21:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs 4.17.0 error building xfs_repair
Message-ID: <20180801042146.GI2234@dastard>
References: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 08:02:17PM -0600, Chris Murphy wrote:
> Hi,
> I'm doing this on Fedora 28, I'm including the entire output from
> exporting environment variables from doc/INSTALL so it's kinda long...
> 
> [chris@f28s xfsprogs-dev]$ git reset --hard origin/master
> HEAD is now at 0821de47 xfsprogs: Release v4.17.0
> 
> [chris@f28s xfsprogs-dev]$ export TAR=/usr/bin/tar
> [chris@f28s xfsprogs-dev]$ export LIBTOOL=/usr/bin/libtool
> [chris@f28s xfsprogs-dev]$ export INSTALL_GROUP=wheel
> [chris@f28s xfsprogs-dev]$ export
> LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --enable-blkid=no
> --enable-librt=no"

You shot yourself in the foot.

....
>     [CC]     versions.o
>     [CC]     xfs_repair.o
>     [LD]     xfs_repair
> /tmp/cc95QLol.ltrans8.ltrans.o: In function `progress_rpt_thread.lto_priv.352':
> <artificial>:(.text+0xa2c9): undefined reference to `timer_create'
> <artificial>:(.text+0xa2e4): undefined reference to `timer_settime'
> <artificial>:(.text+0xa570): undefined reference to `timer_delete'

These functions are in librt, and you told the build not to use it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
