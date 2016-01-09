Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 212A37F37
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 01:54:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F84F30405F
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 23:54:27 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id naxWQEknYLBk3T5s (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jan 2016 23:54:25 -0800 (PST)
Date: Sat, 9 Jan 2016 07:54:14 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [resend PATCH 1/3] block, fs: reliably communicate bdev
	end-of-life
Message-ID: <20160109075414.GA5008@ZenIV.linux.org.uk>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, linux-nvdimm@ml01.01.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Mon, Jan 04, 2016 at 10:20:05AM -0800, Dan Williams wrote:
> Historically we have waited for filesystem specific heuristics to
> attempt to guess when a block device is gone.  Sometimes this works, but
> in other cases the system can hang waiting for the fs to trigger its
> shutdown protocol.
> 
> The initial motivation for this investigation was to prevent DAX
> mappings (direct mmap access to persistent memory) from leaking past the
> lifetime of the hosting block device.  However, Dave points out that
> these shutdown operations are needed in other scenarios.  Quoting Dave:
> 
>     For example, if we detect a free space corruption during allocation,
>     it is not safe to trust *any active mapping* because we can't trust
>     that we having handed out the same block to multiple owners. Hence
>     on such a filesystem shutdown, we have to prevent any new DAX
>     mapping from occurring and invalidate all existing mappings as we
>     cannot allow userspace to modify any data or metadata until we've
>     resolved the corruption situation.
> 
> The current block device shutdown sequence of del_gendisk +
> blk_cleanup_queue is problematic.  We want to tell the fs after
> blk_cleanup_queue that there is no possibility of recovery, but by that
> time we have deleted partitions and lost the ability to find all the
> super-blocks on a block device.
> 
> Introduce del_gendisk_queue to trigger ->quiesce() and ->bdi_gone()
> notifications to all the filesystems hosted on the disk.  Where
> ->quiesce() are 'shutdown' operations while the bdev may still be alive,
> and ->bdi_gone() is a set of actions to take after the backing device
> is known to be permanently dead.

	Would you mind explaining what the hell is _the_ backing device
of a filesystem?  What does that translate into in case of e.g. btrfs
spanning several disks?  Or ext4 with journal on a different device, for
that matter?

	If anything, I would argue that filesystem is out of place here -
general situation is "IO on X may require IO on device Y and X needs to do
something when Y goes away".  Consider e.g. /dev/loop backed by a device
that went away.  Or by a file on fs that has run down the curtain and joined
the bleedin choir invisible.  With another fs partially hosted by that
loopback device.  Or by RAID0 containing said device.

	You are given Y and attempt to locate the affected X.  _Then_
you assume that X is a filesystem and has "something to be done" independent
from the role Y played for it, so you can pick that action from superblock
method.

	IMO you are placing the burden in the wrong place.  _Recepient_
knows what it depends upon and what should be done for each source of
trouble.  So make it recepient's responsibility to request notifications.
At which point the superblock method goes away, along with the requirement
to handle all sources of trouble the same way, etc.

	What's more, things like RAID5 (also interested in knowing when
a component has been ripped out) might or might not decide to propagate
the event further - after all, that's exactly the point of redundancy.

	I'd look into something along the lines of notifier chain per
gendisk, with potential victims registering a callback when they decide
that from now on such and such device might screw them over...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
