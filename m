Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:34862 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbfADXDt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Jan 2019 18:03:49 -0500
Date: Sat, 5 Jan 2019 10:03:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202127] cannot mount or create xfs on a  597T device
Message-ID: <20190104230343.GR4205@dastard>
References: <bug-202127-201763@https.bugzilla.kernel.org/>
 <bug-202127-201763-t3oBXdH3w7@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202127-201763-t3oBXdH3w7@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 04, 2019 at 10:02:58PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202127
> 
> --- Comment #16 from Eric Sandeen (sandeen@sandeen.net) ---
> Broadcom is simply wrong - ext4 doesn't care about or use the stripe geometry
> like xfs does.  But that is beside the point, because:
> 
> It is not valid to have a preferred I/O size smaller than the minimum I/O size
> - this should be obvious to the vendor.  We can detect this at mkfs time and
> error out or ignore the bad values, but there can be no debate about whether
> the hardware is returning nonsense.  It /is/ returning nonsense.  That's a
> firmware bug.
> 
> Pose the question to broadcom:
> 
> "How can the preferred IO size be less than the minimum allowable IO size?

Just to clarify, the "minio" being reported here is not the
"minimum allowable IO size". The minimum allowed IO size is the
logical sector/block size of the device.

"minimum_io_size" is badly named - it's actually the smallest IO
size alignment that allows for /efficient/ IO operations to be
performed by the device, and that's typically very different to
logical_block_size of the device. e.g:

$ cat /sys/block/sdf/queue/hw_sector_size
512
$ cat /sys/block/sdf/queue/logical_block_size
512
$ cat /sys/block/sdf/queue/physical_block_size
4096
$ cat /sys/block/sdf/queue/minimum_io_size
4096
$

So, we can do 512 byte sector IOs to this device, but it's not
efficient due to it having a physical 4k block size. i.e. ti
requires a RMW cycle to do a 512 byte write.

IOWs, a 4k IO (minimum_io_size) will avoid physical block RMW cycles
as the physical block size of the storage is 4k. That's what
"minimum efficient IO size" means.

For a RAID5/6 lun, this is typically the chunk size, as
many RAID implementations can do single chunk aligned writes
efficiently via partial stripe recalculation without needing RMW
cycles. If the write partially overlaps chunks, then RMW cycles are
required for RAID recalc, hence setting the RAID chunk size as the
"minimum_io_size" makes sense.

However, a device may not be efficient and reach saturation when
fed lots of minimum_io_size requests. That's where optimal_io_size
comes in - a lot of SSDs out there have an optimal IO size in the
range of 128-256KB because they can't reach max throughput when
smaller IO sizes are used (iops bound). i.e. the optimal IO size is
the size of the Io that will allow the entire bandwidth of the
device to be effectively utilised.

For a RAID5/6 lun, the optimal IO size is the one that keeps all
disk heads moving sequentially and in synchronisation and doesn't
require partial stripe writes (and hence RMW cycles) to occur. IOWs,
its the IO alignment and size that will allow full stripe writes to
be sent to the underlying device.

By definition, the optimal_io_size is /always/ >= minimum_io_size.
If the optimal_io_size is < minimum_io_size, then one of them is
incorrectly specified. The only time this does not hold true is when
the device does not set a optimal_io_size, in which case it should
be zero and then gets ignored by userspace.

Regardless, what still stands here is that the firmware needs fixing
and that is only something broadcom can fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
