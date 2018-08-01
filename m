Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33524 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389256AbeHAPEi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 11:04:38 -0400
Subject: Re: xfsprogs 4.17.0 error building xfs_repair
References: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
 <20180801042146.GI2234@dastard>
 <CAJCQCtTv4ppBr1jxJBg4hBWfxDO=J2jZVYj-ZvZTADcb7KHT3g@mail.gmail.com>
 <f052c332-e154-9aa7-7cdf-c1b92a7d994d@sandeen.net>
 <CAJCQCtT9UoXdpF0OhWtEN7x_tKCZksJYY_BLqe-x68c8ubq81A@mail.gmail.com>
 <87156058-fd41-8130-7206-7cdc9e1a85d9@sandeen.net>
 <20180801114951.a54jwkinr5rb5ori@odin.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <85b478dd-4897-387b-f4b8-2b216bc39b0b@sandeen.net>
Date: Wed, 1 Aug 2018 08:18:51 -0500
MIME-Version: 1.0
In-Reply-To: <20180801114951.a54jwkinr5rb5ori@odin.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, Dave Chinner <david@fromorbit.com>, xfs list <linux-xfs@vger.kernel.org>



On 8/1/18 6:49 AM, Carlos Maiolino wrote:
> On Wed, Aug 01, 2018 at 12:09:15AM -0500, Eric Sandeen wrote:
>> On 8/1/18 12:06 AM, Chris Murphy wrote:
>>
>>> And then I found the xfsprogs.spec file for Fedora 29's xfsprogs which contains:
>>>
>>> %configure \
>>>      --enable-readline=yes \
>>>      --enable-blkid=yes \
>>>      --enable-lto=no
>>>
> 
> Thing is, unless I'm looking at the wrong file, doc/INSTALL under xfsprogs, only
> require such options when building xfsprogs in MacOS, the Linux instructions are
> pretty straight forward"
>

Oh, hah.  You right.  Thanks Carlos!

-Eric
