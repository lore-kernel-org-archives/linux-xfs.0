Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57411 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbfGVAN0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Jul 2019 20:13:26 -0400
Date: Mon, 22 Jul 2019 10:12:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] fs: New zonefs file system
Message-ID: <20190722001200.GQ7689@dread.disaster.area>
References: <20190712030017.14321-1-damien.lemoal@wdc.com>
 <x49zhlbe8li.fsf@segfault.boston.devel.redhat.com>
 <BYAPR04MB5816B59932372E2D97330308E7C80@BYAPR04MB5816.namprd04.prod.outlook.com>
 <x49h87iqexz.fsf@segfault.boston.devel.redhat.com>
 <BYAPR04MB5816A2630B1EBC0696CBEC71E7CA0@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB5816A2630B1EBC0696CBEC71E7CA0@BYAPR04MB5816.namprd04.prod.outlook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Ting Yao <d201577678@hust.edu.cn>

On Sat, Jul 20, 2019 at 01:07:25AM +0000, Damien Le Moal wrote:
> On 2019/07/19 23:25, Jeff Moyer wrote:
> > I'll throw out another suggestion that may or may not work (I haven't
> > given it much thought).  Would it be possible to create a device mapper
> > target that would export each zone as a separate block device?  I
> > understand that wouldn't help with the write pointer management, but it
> > would allow you to create a single "file" for each zone.
> 
> Well, I do not think you need a new device mapper for this. dm-linear supports
> zoned block devices and will happily allow mapping a single zone and expose a
> block device file for it. My problem with this approach is that SMR drives are
> huge, and getting bigger. A 15 TB drive has 55380 zones of 256 MB. Upcoming 20
> TB drives have more than 75000 zones. Using dm-linear or any per-zone device
> mapper target would create a huge resources pressure as the amount of memory
> alone that would be used per zone would be much higher than with a file system
> and the setup would also take far longer to complete compared to zonefs mount.

Right, it's kinda insane to expect userspace to manage tens of
thousands of "block devices" like this. You go run blkid on one of
these devices, and what happens? Then there's stuff like udev
overhead, grub os-probing that walks all block devices it can find,
etc. Then consider putting hundreds of SMR drives into a machine
that has multiple paths to each drive....

As such, I just don't think this block device approach is feasible,
especially as Managing tens of thousands of individual small data
regions in a storage device is exactly what filesystems are for.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
