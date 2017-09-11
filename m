Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54602 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbdIKW27 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Sep 2017 18:28:59 -0400
Subject: Re: XFS and sector size on thin volumes
References: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
 <20170909231215.GK17782@dastard>
 <0c59ba403f83e571d695a716ccad5d0a@assyoma.it>
 <20170909235323.GL17782@dastard>
 <838841738c3d8ca84328075615f95475@assyoma.it>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9d6b72e9-37ca-70f9-a40d-62ceaafc9db6@sandeen.net>
Date: Mon, 11 Sep 2017 17:28:58 -0500
MIME-Version: 1.0
In-Reply-To: <838841738c3d8ca84328075615f95475@assyoma.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 9/11/17 5:14 PM, Gionatan Danti wrote:
>> If a block device is presented with 512 sectors on 4k-only sector
>> drives, then that's a bug. If it's doing so with 512e drives,
>> then that's still a bug because it should be presenting as a
>> 512 byte logical, 4096 byte physical sector size device and in that
>> case mkfs.xfs will choose 4k sectors by default.
>>
>> IOWs, if the underlying device is correctly presented to mkfs.xfs
>> then it will choose the correct sector size by default.  dm-thinp
>> does the right thing with sector sizes, but I have no idea about
>> ZoL.
> 
> Hi Dave,
> it seems ZVOLs behave... interestingly...
> 
> # 4K volume
> [root@blackhole ~]# zfs create tank/vol1 -V 300M -b 4k
> [root@blackhole ~]# blockdev --getss --getpbsz --getiomin --getioopt /dev/zvol/tank/vol1
> 512
> 4096
> 4096
> 4096

<snip> last 3 vals follow volume's block size </snip>

That's all ok, it's just that xfs will have to use the logical sector
size (512) for its sector size, not the physical - which is large than
the maximum (4k) block it can handle on x86.
 
> So, it seems that volume's block size does not only change the iomin/ioopt values, but pbsz also. On the other hand, ss is stuck at 512B, even if I am using a 512e (4K physical sector size) underlying disk:
> 
> [root@blackhole ~]# blockdev --getss --getpbsz --getiomin --getioopt /dev/sdc
> 512
> 4096
> 4096
> 0
> 
> Creating an XFS filesystem on such a ZVOL will issue the following message:
> 
> "specified blocksize 4096 is less than device physical sector size 8192
> switching to logical sector size 512"

That's the warning we (I) talked about getting rid of.  In part because
you didn't "specify" anything.  :(  It's just telling you that you can't
go to what it thinks is the "optimal" sector size for the filesystem, i.e.
the one that matches the physical sector size of the storage; instead it is
going down to the logical sector size of 512 because it must be <=
the fs block size.

> In this case, should I specify block size (-b size=4k) at mkfs.xfs time, or not?
> Thanks.

I don't think -b size=4k will change anything.  If you specify -s size=512, that
might shut up the warning.  If the warning doesn't bother you, I don't think
anything is particularly wrong with the filesystem it created.

-Eric
