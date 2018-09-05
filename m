Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbeIENfA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Sep 2018 09:35:00 -0400
Date: Wed, 5 Sep 2018 10:05:45 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180905090545.GC27120@redhat.com>
References: <20180903224919.GA16358@redhat.com>
 <20180904004940.GR5631@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180904004940.GR5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 04, 2018 at 10:49:40AM +1000, Dave Chinner wrote:
> What's the sector size of you device? This seems to imply that it is
> 1024 bytes, not the normal 512 or 4096 bytes we see in most devices.

It turns out that the sector size is selectable using the nbd-client
-b parameter, which I didn't notice before:

  # nbd-client -b 512 localhost /dev/nbd0

This actually turns out to be essential when mounting MBR partitioned
disks because the MBR partition table uses sector numbers, and if you
use the default (1k) sector size then everything is messed up.

Compare with 1k sectors:

  # fdisk -l /dev/nbd0
  Disk /dev/nbd0: 10 GiB, 10737418240 bytes, 10485760 sectors
  Units: sectors of 1 * 1024 = 1024 bytes
  Sector size (logical/physical): 1024 bytes / 1024 bytes
  I/O size (minimum/optimal): 1024 bytes / 1024 bytes
  Disklabel type: dos
  Disk identifier: 0x000127ae
  
  Device      Boot Start      End  Sectors Size Id Type
  /dev/nbd0p1       2048 20971519 20969472  20G 83 Linux
                                            ~~~

to the correct output with 512b sectors:

  # fdisk -l /dev/nbd0
  Disk /dev/nbd0: 10 GiB, 10737418240 bytes, 20971520 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 1024 bytes / 1024 bytes
  Disklabel type: dos
  Disk identifier: 0x000127ae
  
  Device      Boot Start      End  Sectors Size Id Type
  /dev/nbd0p1       2048 20971519 20969472  10G 83 Linux

So that's a nasty little "gotcha" in the nbd-client tool.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
