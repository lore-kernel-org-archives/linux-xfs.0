Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38180 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbeKLEI1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 11 Nov 2018 23:08:27 -0500
Date: Mon, 12 Nov 2018 02:21:10 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 837514f7a4ca
Message-ID: <20181111182110.GK2279@dhcp-12-117.nay.redhat.com>
References: <20181106162413.GV4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106162413.GV4135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 06, 2018 at 08:24:13AM -0800, Darrick J. Wong wrote:
> Hi folks,
> 
> The for-next branch of the xfs-linux repository at:
> 
> 	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> 
> has just been updated.
> 
> Patches often get missed, so please check if your outstanding patches
> were in this update. If they have not been in this update, please
> resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
> the next update.  As of this message, I am taking the reins back from
> Dave.
> 
> The new head of the for-next branch is commit:
> 
> 837514f7a4ca xfs: fix overflow in xfs_attr3_leaf_verify

JFYI:

I just done some basic XFS regression testing once on this kernel
(git HEAD is at 837514f7a xfs: fix overflow in xfs_attr3_leaf_verify), nothing
weird can be found. Test cases include (on x86_64 and ppc64le):
---
xfstests auto group test on XFS with 4k+reflink, 2k+reflink+rmapbt, 1k+finobt, 512b.
LTP (fs related test) on XFS with 4k+reflink and 2k+reflink+rmapbt, 64k+reflink.
pjd-fstest on XFS with 4k+reflink.
fsx 3 days stress tests.
fsstress stress test.
Lustre race test.
All mkfs.xfs options test.
Kernel build stress test.
And some other regression tests.
---

Maybe import more tests in next xfs-4.20-fixes-2 Feel free to tell me, if you
have any suggestions.

Thanks,
Zorro

> 
> New Commits:
> 
> Christophe JAILLET (1):
>       [132bf6723749] xfs: Fix error code in 'xfs_ioc_getbmap()'
> 
> Darrick J. Wong (1):
>       [bdec055bb9f2] xfs: print buffer offsets when dumping corrupt buffers
> 
> Dave Chinner (1):
>       [837514f7a4ca] xfs: fix overflow in xfs_attr3_leaf_verify
> 
> 
> Code Diffstat:
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++++--
>  fs/xfs/xfs_ioctl.c            |  2 +-
>  fs/xfs/xfs_message.c          |  2 +-
>  3 files changed, 11 insertions(+), 4 deletions(-)
