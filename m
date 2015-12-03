Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B6BA7F37
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 10:44:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F380AAC002
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 08:44:22 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id hyqOxImjO4CDvcQI for
	<xfs@oss.sgi.com>; Thu, 03 Dec 2015 08:44:21 -0800 (PST)
Date: Thu, 3 Dec 2015 09:43:42 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: xfstest failure with xfs, dax and v4.4-rc3
Message-ID: <20151203164342.GA14849@linux.intel.com>
References: <20151201224346.GA15684@linux.intel.com>
	<20151201235158.GF19199@dastard>
	<x49k2owq3z6.fsf@segfault.boston.devel.redhat.com>
	<20151203065127.GB26718@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151203065127.GB26718@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

On Thu, Dec 03, 2015 at 05:51:27PM +1100, Dave Chinner wrote:
> As it is, that test does not fail on my DAX testing on RAM disks.
> ISTR it failing up until recently, though. Yeah:
> 
> Last login: Tue Nov 17 08:45:55 2015 from 192.168.1.103
> $ cd ~/src/xfstests-dev; sudo mkfs.xfs -f /dev/ram0 ; sudo xfs_admin -U generate /dev/ram0 ; sudo MOUNT_OPTIONS="-o dax" ./check -g auto
> SECTION       -- xfs
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test4 4.3.0-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/ram1
> MOUNT_OPTIONS -- -o dax /dev/ram1 /mnt/scratch
> ....
> generic/083 2s ... 1s
> _check_xfs_filesystem: filesystem on /dev/ram1 is inconsistent (c) (see /home/dave/src/xfstests-dev/results//xfs/generic/083.full)
> _check_xfs_filesystem: filesystem on /dev/ram1 is inconsistent (r) (see /home/dave/src/xfstests-dev/results//xfs/generic/083.full)
> ....
> 
> But as I ran earlier today when testing the ENOSPC fix:
> 
> PLATFORM      -- Linux/x86_64 test4 4.4.0-rc2-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/ram1
> MOUNT_OPTIONS -- -o dax /dev/ram1 /mnt/scratch
> ....
> generic/083 1s ... 2s
> ....
> 
> So I'm seeing that the current 4.4-rc2 + my local dev tree patches
> appear to have fixed whatever was causing generic/083 to fail
> here...

Yea, interesting, the patch you sent out yesterday:

xfs: Don't use reserved blocks for data blocks with DAX

Makes this issue disappear in my system as well.  Testing with v4.4-rc3
generic/083 fails 50% of the time or so in my setup, but with just that patch
added to v4.4-rc3 I can't make it fail.

> What version of xfsprogs are you using, Ross?

I'm currently using xfsprogs v4.3.0, but the failure occurred when I was using
v4.2.0 as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
