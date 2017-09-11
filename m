Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:53942 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdIKWOW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 18:14:22 -0400
Subject: Re: XFS and sector size on thin volumes
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Sep 2017 00:14:19 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170909235323.GL17782@dastard>
References: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
 <20170909231215.GK17782@dastard>
 <0c59ba403f83e571d695a716ccad5d0a@assyoma.it>
 <20170909235323.GL17782@dastard>
Message-ID: <838841738c3d8ca84328075615f95475@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

> If a block device is presented with 512 sectors on 4k-only sector
> drives, then that's a bug. If it's doing so with 512e drives,
> then that's still a bug because it should be presenting as a
> 512 byte logical, 4096 byte physical sector size device and in that
> case mkfs.xfs will choose 4k sectors by default.
> 
> IOWs, if the underlying device is correctly presented to mkfs.xfs
> then it will choose the correct sector size by default.  dm-thinp
> does the right thing with sector sizes, but I have no idea about
> ZoL.

Hi Dave,
it seems ZVOLs behave... interestingly...

# 4K volume
[root@blackhole ~]# zfs create tank/vol1 -V 300M -b 4k
[root@blackhole ~]# blockdev --getss --getpbsz --getiomin --getioopt 
/dev/zvol/tank/vol1
512
4096
4096
4096

# 8K volume
[root@blackhole ~]# zfs create tank/vol1 -V 300M -b 8k
[root@blackhole ~]# blockdev --getss --getpbsz --getiomin --getioopt 
/dev/zvol/tank/vol1
512
8192
8192
8192

# 128K volume
[root@blackhole ~]# zfs create tank/vol1 -V 300M -b 128k
[root@blackhole ~]# blockdev --getss --getpbsz --getiomin --getioopt 
/dev/zvol/tank/vol1
512
131072
131072
131072

So, it seems that volume's block size does not only change the 
iomin/ioopt values, but pbsz also. On the other hand, ss is stuck at 
512B, even if I am using a 512e (4K physical sector size) underlying 
disk:

[root@blackhole ~]# blockdev --getss --getpbsz --getiomin --getioopt 
/dev/sdc
512
4096
4096
0

Creating an XFS filesystem on such a ZVOL will issue the following 
message:

"specified blocksize 4096 is less than device physical sector size 8192
switching to logical sector size 512"

In this case, should I specify block size (-b size=4k) at mkfs.xfs time, 
or not?
Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
