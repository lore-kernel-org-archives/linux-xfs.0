Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B87884B8
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 21:09:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2BCA48F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 19:09:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 18abdPaxsujvRKSM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 19:09:48 -0700 (PDT)
Date: Thu, 16 Jun 2016 19:09:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 0/2] Initial support for badblock checking in xfs
Message-ID: <20160617020942.GB11810@birch.djwong.org>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@ml01.01.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 07:03:37PM -0600, Vishal Verma wrote:
> These are early/RFC patches to add badblock support in xfs.
> 
> Patch 1 should be relatively straightforward - it adds a notifier chain
> to badblocks that filesystems can register with.
> 
> Patch 2 is the beginnings of xfs support. So far, I have the notifier
> registration and building the initial badblock list happening in
> xfs_mountfs. The next steps (and I may need some help with this as I'm
> no (x)fs developer :)) are to add this badblocks info to the reverse
> mapping tree, and then to check for it before accessing the media.
> 
> Right now, this just prints the sector numbers/counts/{added, removed}
> to the kernel log, for both the initial list, and subsequent notifier
> hits.
> 
> While I've tested this with a fake pmem device using libnvdimm's
> nfit_test framework, it should also work using badblock injection with
> any block device:
> 
> # mkfs.xfs -f /dev/<device>
> # echo 122 1 > /sys/block/<device>/badblocks
> # echo 124 1 > /sys/block/<device>/badblocks
> # mount -t xfs /dev/<device> /mnt
> ... in log:
> [  +8.803776] XFS (pmem7): Mounting V4 Filesystem
> [  +0.009633] XFS (pmem7): Ending clean mount
> [  +0.001655] XFS (pmem7): got badblocks: sector 122, count 1
> [  +0.002018] XFS (pmem7): got badblocks: sector 124, count 1
> 
> # echo 132 5 | > /sys/block/<device>/badblocks
> [Jun16 18:56] XFS (pmem7): xfs badblock added sector 132 (count 5)
> 
> This is all based on Darrik's rmap work at:
> https://github.com/djwong/linux/tree/rmap-reflink-devel
> 
> Since this is based on a v4.5-rc kernel, it lacks pmem support for
> clearing badblocks on zeroing/writing, so those parts can't easily
> be tested yet. The clearing work is in 4.7-rs kernels, and once we
> rebase to that, that should also be available.

I'm assuming you got at least a few of the 300 patches I just sent.
IOW: The whole kit and kaboodle have been rebased to for-next, which
means the kernel patches are based on 4.7-rc3.

Will have a look at the other patches.

:)

--D

> 
> 
> Vishal Verma (2):
>   block, badblocks: add a notifier for badblocks
>   xfs: initial/partial support for badblocks
> 
>  block/badblocks.c         |  79 +++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_linux.h        |   1 +
>  fs/xfs/xfs_mount.c        | 104 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_mount.h        |   1 +
>  include/linux/badblocks.h |  19 +++++++++
>  5 files changed, 201 insertions(+), 3 deletions(-)
> 
> -- 
> 2.5.5
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
