Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37556 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732980AbeHAGXD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 02:23:03 -0400
Subject: Re: xfsprogs 4.17.0 error building xfs_repair
References: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
 <20180801042146.GI2234@dastard>
 <CAJCQCtTv4ppBr1jxJBg4hBWfxDO=J2jZVYj-ZvZTADcb7KHT3g@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f052c332-e154-9aa7-7cdf-c1b92a7d994d@sandeen.net>
Date: Tue, 31 Jul 2018 23:39:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTv4ppBr1jxJBg4hBWfxDO=J2jZVYj-ZvZTADcb7KHT3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs list <linux-xfs@vger.kernel.org>



On 7/31/18 11:37 PM, Chris Murphy wrote:
> On Tue, Jul 31, 2018 at 10:21 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Tue, Jul 31, 2018 at 08:02:17PM -0600, Chris Murphy wrote:
>>> Hi,
>>> I'm doing this on Fedora 28, I'm including the entire output from
>>> exporting environment variables from doc/INSTALL so it's kinda long...
>>>
>>> [chris@f28s xfsprogs-dev]$ git reset --hard origin/master
>>> HEAD is now at 0821de47 xfsprogs: Release v4.17.0
>>>
>>> [chris@f28s xfsprogs-dev]$ export TAR=/usr/bin/tar
>>> [chris@f28s xfsprogs-dev]$ export LIBTOOL=/usr/bin/libtool
>>> [chris@f28s xfsprogs-dev]$ export INSTALL_GROUP=wheel
>>> [chris@f28s xfsprogs-dev]$ export
>>> LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --enable-blkid=no
>>> --enable-librt=no"
>>
>> You shot yourself in the foot.
>>
>> ....
>>>     [CC]     versions.o
>>>     [CC]     xfs_repair.o
>>>     [LD]     xfs_repair
>>> /tmp/cc95QLol.ltrans8.ltrans.o: In function `progress_rpt_thread.lto_priv.352':
>>> <artificial>:(.text+0xa2c9): undefined reference to `timer_create'
>>> <artificial>:(.text+0xa2e4): undefined reference to `timer_settime'
>>> <artificial>:(.text+0xa570): undefined reference to `timer_delete'
>>
>> These functions are in librt, and you told the build not to use it...
> 
> 
> I did what doc/INSTALL told me to do:
> 
>    Building xfsprogs:
> 
>     [firstly set these environment variables to these values]
>     TAR=/usr/bin/gnutar
>     LIBTOOL=/usr/bin/glibtool
>     INSTALL_GROUP=wheel
>     LOCAL_CONFIGURE_OPTIONS="\
>                  --enable-gettext=no\
>                  --enable-blkid=no\
>                  --enable-librt=no\
>                  "

Wow, no idea why that crap is in there, it should probably be removed.

Just "make" will suffice.

Patches accepted :)

-Eric
