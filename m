Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f51.google.com ([209.85.167.51]:41204 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731592AbeHAGt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 02:49:58 -0400
Received: by mail-lf1-f51.google.com with SMTP id v22-v6so12370656lfe.8
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 22:06:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f052c332-e154-9aa7-7cdf-c1b92a7d994d@sandeen.net>
References: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
 <20180801042146.GI2234@dastard> <CAJCQCtTv4ppBr1jxJBg4hBWfxDO=J2jZVYj-ZvZTADcb7KHT3g@mail.gmail.com>
 <f052c332-e154-9aa7-7cdf-c1b92a7d994d@sandeen.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 31 Jul 2018 23:06:13 -0600
Message-ID: <CAJCQCtT9UoXdpF0OhWtEN7x_tKCZksJYY_BLqe-x68c8ubq81A@mail.gmail.com>
Subject: Re: xfsprogs 4.17.0 error building xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Murphy <lists@colorremedies.com>, Dave Chinner <david@fromorbit.com>, xfs list <linux-xfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 10:39 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
> On 7/31/18 11:37 PM, Chris Murphy wrote:
>> On Tue, Jul 31, 2018 at 10:21 PM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Tue, Jul 31, 2018 at 08:02:17PM -0600, Chris Murphy wrote:
>>>> Hi,
>>>> I'm doing this on Fedora 28, I'm including the entire output from
>>>> exporting environment variables from doc/INSTALL so it's kinda long...
>>>>
>>>> [chris@f28s xfsprogs-dev]$ git reset --hard origin/master
>>>> HEAD is now at 0821de47 xfsprogs: Release v4.17.0
>>>>
>>>> [chris@f28s xfsprogs-dev]$ export TAR=/usr/bin/tar
>>>> [chris@f28s xfsprogs-dev]$ export LIBTOOL=/usr/bin/libtool
>>>> [chris@f28s xfsprogs-dev]$ export INSTALL_GROUP=wheel
>>>> [chris@f28s xfsprogs-dev]$ export
>>>> LOCAL_CONFIGURE_OPTIONS="--enable-gettext=no --enable-blkid=no
>>>> --enable-librt=no"
>>>
>>> You shot yourself in the foot.
>>>
>>> ....
>>>>     [CC]     versions.o
>>>>     [CC]     xfs_repair.o
>>>>     [LD]     xfs_repair
>>>> /tmp/cc95QLol.ltrans8.ltrans.o: In function `progress_rpt_thread.lto_priv.352':
>>>> <artificial>:(.text+0xa2c9): undefined reference to `timer_create'
>>>> <artificial>:(.text+0xa2e4): undefined reference to `timer_settime'
>>>> <artificial>:(.text+0xa570): undefined reference to `timer_delete'
>>>
>>> These functions are in librt, and you told the build not to use it...
>>
>>
>> I did what doc/INSTALL told me to do:
>>
>>    Building xfsprogs:
>>
>>     [firstly set these environment variables to these values]
>>     TAR=/usr/bin/gnutar
>>     LIBTOOL=/usr/bin/glibtool
>>     INSTALL_GROUP=wheel
>>     LOCAL_CONFIGURE_OPTIONS="\
>>                  --enable-gettext=no\
>>                  --enable-blkid=no\
>>                  --enable-librt=no\
>>                  "
>
> Wow, no idea why that crap is in there, it should probably be removed.
>
> Just "make" will suffice.
>
> Patches accepted :)


And then I found the xfsprogs.spec file for Fedora 29's xfsprogs which contains:

%configure \
     --enable-readline=yes \
     --enable-blkid=yes \
     --enable-lto=no


That too blows up, likely because I don't have readline-devel.x86_64 installed.

...

Building libxcmd
    [CC]     command.lo
    [CC]     input.lo
input.c:25:11: fatal error: readline/history.h: No such file or directory
 # include <readline/history.h>
           ^~~~~~~~~~~~~~~~~~~~
compilation terminated.
gmake[3]: *** [../include/buildrules:56: input.lo] Error 1
gmake[2]: *** [include/buildrules:36: libxcmd] Error 2
make[1]: *** [Makefile:77: default] Error 2
make: *** [Makefile:74: default] Error 2
[chris@f28s xfsprogs-dev]$


And starting over without any environment variables set from
doc/INSTALL and that now works. :-P



-- 
Chris Murphy
