Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54760 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbeIRSUc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 14:20:32 -0400
Subject: Re: dm-writecache issue
References: <20180911221147.GA23308@redhat.com>
 <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
 <20180918123238.GI27618@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net>
Date: Tue, 18 Sep 2018 07:48:04 -0500
MIME-Version: 1.0
In-Reply-To: <20180918123238.GI27618@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>

On 9/18/18 7:32 AM, Dave Chinner wrote:
> On Tue, Sep 18, 2018 at 07:46:47AM -0400, Mikulas Patocka wrote:
>> I would ask the XFS developers about this - why does mkfs.xfs select 
>> sector size 512 by default?
> 
> Because the underlying device told it that it supported a
> sector size of 512 bytes?

Not only that, but it must have told us that it had a /physical/ 512 sector.
If it had even said physical/logical 4096/512, we would have chosen 4096.

What does please check blockdev --getpbsz --getss /dev/$FOO say at mkfs time?

>> If a filesystem created with the default 512-byte sector size is activated 
>> on a device with 4k sectors, it results in mount failure.
> 
> Yes, it does, but mkfs should also fail when it tries to write 512
> byte sectors to a 4k device, too.

...

> I'm betting that the underlying device advertised a logical/physical
> sector size of 512 bytes to mkfs, and then adding pmem as the cache
> device changed the logical volume from a 512 byte sector device to a
> hard 4k sector device.

Yup, please check blockdev --getpbsz --getss /dev/$FOO for the
devices in question during the course of this testcase.  As Dave says,
we can't mkfs a device that claims to support 512 bytes IOs and then
have that granularity increase.  (And going the other way, i.e. making
512 byte IOs non-atomic may break guarantees that journaling relies on).

-Eric
