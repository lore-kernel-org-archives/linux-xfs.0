Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6S8q01c247699 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:52:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9730183BA65
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 01:51:59 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uHoTgGckl4P9Gudi for <xfs@oss.sgi.com>;
	Thu, 28 Jul 2011 01:51:59 -0700 (PDT)
Date: Thu, 28 Jul 2011 04:51:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfstests: Add support for btrfs in 079
Message-ID: <20110728085158.GD3407@infradead.org>
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
	<0cbb002def872039fd8c0bb90ceb5f6bf0e15b02.1311776403.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0cbb002def872039fd8c0bb90ceb5f6bf0e15b02.1311776403.git.sbehrens@giantdisaster.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 28, 2011 at 10:28:01AM +0200, Stefan Behrens wrote:
> Added btrfs to the list of supported filesystems for test 079.
> In src/t_immutable.c which is compiled for Linux only, add support for
> btrfs by replacing the ioctl(EXT2_IOC_SETFLAGS) with
> ioctl(FS_IOC_SETFLAGS) which is defined to be the same.

That has nothing to do with btrfs support.  Your patch means we recent
kernel headers to get the FS_IOC_SETFLAGS instead of having a local one.
I don't care what name to use for the local one, and I also don't
mind an ifdef to pick up a header one in preference, but as-is the patch
isn't too useful as FS_IOC_SETFLAGS is a fairly recent addition to the
kernel headers, and we will break existing working setups.

> Afterwards in src/t_immutable.c in function fsetflag(), share the code
> branch for the ext2 case also for the btrfs case.
> Furthermore, added missing call to ioctl(FS_IOC_GETFLAGS) to the ext3
> and btrfs code branch, this was a difference to the way the XFS code
> branch was implemented.

I'd suggest to completely drop the stat check, and use the ext2 branch
unconditionally.  The ioctl is suppored by all major filesystems.

This also means we can make the test generic, maybe with a _notrun
instead of an error if FS_IOC_GETFLAGS/FS_IOC_SETFLAGS isn't supported.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
