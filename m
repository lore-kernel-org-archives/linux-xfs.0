Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Sep 2006 17:48:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8B0ldDW028276
	for <linux-xfs@oss.sgi.com>; Sun, 10 Sep 2006 17:47:50 -0700
Date: Mon, 11 Sep 2006 10:46:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: oops mounting unassembled md device
Message-ID: <20060911004643.GJ10950339@melbourne.sgi.com>
References: <450342F9.8090301@stwo-corp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <450342F9.8090301@stwo-corp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Morrison <mikem@stwo-corp.com>
Cc: linux-xfs@oss.sgi.com

On Sat, Sep 09, 2006 at 03:40:57PM -0700, Michael Morrison wrote:
> Got on oops when trying to mount xfs filesystem onto unassembled md
> raid0 device.
> What else can I provide to help with this?
> 
> Linux version: 2.6.18-rc4
> Drives are hanging off an LSI fibre channel controller which is driven by
> the mpt driver in drivers/message/fusion.
> 
> Steps leading up to this:
> 
> 1. assemble 8 drive raid0 on /dev/md0
> 2. mount filesystem: /bin/mount -t xfs /dev/md0 /mnt/testfs -o
> noatime,nodiratime
> 3. umount /mnt/testfs
> 4. mdadm --stop /dev/md0
> 5. /bin/mount -t xfs /dev/md0 /mnt/testfs -o noatime,nodiratime

So why did MD allow /dev/md0 to be used if the device had been
stopped? According to the mdadm man page a --stop will release all
resources associated with the md device so after stopping /dev/md0
it should not be possible to use it.

This is not an XFS problem - this is either an MD bug (leaving /dev/md0
around after being stopped) and/or user error.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
