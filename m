Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:50237 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752109AbeDCBql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Apr 2018 21:46:41 -0400
Date: Tue, 3 Apr 2018 11:46:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: always free inline data before resetting inode fork
 during ifree
Message-ID: <20180403014638.GH1150@dastard>
References: <20180323172620.GK4818@magnolia>
 <20180323182302.GB9190@wotan.suse.de>
 <20180325223357.GJ18129@dastard>
 <CA+1xoqdWBumgCn9iw7FH_6VtDnEmd5_Hyw=cY4b9zB=Avhx-4g@mail.gmail.com>
 <20180328033228.GA18129@dastard>
 <20180328193004.GB7561@sasha-vm>
 <20180328230535.GE18129@dastard>
 <20180330024704.GE7561@sasha-vm>
 <20180331220245.GG1150@dastard>
 <20180402003242.GF7561@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180402003242.GF7561@sasha-vm>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <Alexander.Levin@microsoft.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>, "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>, Takashi Iwai <tiwai@suse.de>, Michal Hocko <mhocko@kernel.org>, Joerg Roedel <joro@8bytes.org>

On Mon, Apr 02, 2018 at 12:32:44AM +0000, Sasha Levin wrote:
> On Sun, Apr 01, 2018 at 08:02:45AM +1000, Dave Chinner wrote:
> >On Fri, Mar 30, 2018 at 02:47:05AM +0000, Sasha Levin wrote:
> >> On Thu, Mar 29, 2018 at 10:05:35AM +1100, Dave Chinner wrote:
> >> >On Wed, Mar 28, 2018 at 07:30:06PM +0000, Sasha Levin wrote:
> >> > This commit has been processed by the -stable helper bot and determined
> >> > to be a high probability candidate for -stable trees. (score: 6.4845)
> >> >
> >> > The bot has tested the following trees: v4.15.12, v4.14.29, v4.9.89, v4.4.123, v4.1.50, v3.18.101.
> >> >
> >> > v4.15.12: Build OK!
> >> > v4.14.29: Build OK!
> >> > v4.9.89: Build OK!
> >> > v4.4.123: Build OK!
> >> > v4.1.50: Build OK!
> >> > v3.18.101: Build OK!
> >> >
> >> > XFS Specific tests:
> >> >
> >> > v4.15.12 (http://stable-bot.westus2.cloudapp.azure.com/test/v4.15.12/tests/):
> >> >     No tests completed!
> >
> >Can you capture the actual check command output into it's own file?
> >That tells us at a glance which tests succeed or failed.
> >
> >So I'm looking at the v5.log file:
> >
> >....
> >echo 'export MKFS_OPTIONS='\''-m crc=0,reflink=0,rmapbt=0, -i sparse=0,'\'''
> >....
> >
> >
> >FSTYP         -- xfs (debug)
> >PLATFORM      -- Linux/x86_64 autosel 4.15.12+
> >MKFS_OPTIONS  -- -f -m crc=0,reflink=0,rmapbt=0, -i sparse=0,
> >/dev/vdb
> >MOUNT_OPTIONS -- /dev/vdb /mnt2
> >
> >That's not testing v5 filesystems. That's turned off crcs, and
> >so is testing a v4 filesystem. You'll see this on filesysetms that
> >don't support reflink:
> >
> > [not run] Reflink not supported by test filesystem type: xfs
> 
> I mixed up the configs here. Basically I have 4 different ones (provided
> by Darrick):
> 
> MKFS_OPTIONS='-m reflink=1,rmapbt=1, -i sparse=1, -b size=1024,'
> MKFS_OPTIONS='-m reflink=1,rmapbt=1, -i sparse=1,'
> MKFS_OPTIONS='-m crc=0,reflink=0,rmapbt=0, -i sparse=0,'
> MKFS_OPTIONS='-m crc=0,reflink=0,rmapbt=0, -i sparse=0, -b size=512,'

That doesn't actually test the default options that most users will
currently be using. It tests a new format relatively few people are
using in production, and the old format that people are slowly
moving away from. If you run mkfs.xfs without any options right now
you get

MKFS_OPTIONS='-m crc=1,reflink=0,rmapbt=0, -i sparse=0'

> >So this is just basic XFS validation, and it's throwing problems up
> >all over the place. Now do you see why we've been saying maintaining
> >stable backports for XFS is pretty much a full time job for someone?
> 
> Maintaining stable backports is indeed lots of work, but I feel that
> a lot of progress can be made by automating parts of it.

Yup, but the sorting out the results of the automated tests is the
part that takes all the developer time and resources, not the
running of the tests...

> >And keep in mind this is just one filesystem. You're going to end up
> >with the same issues on ext4 and btrfs - the regression tests are
> >going to show up all sorts of problems that have been fixed in the
> >upstream kernels but never backported....
> 
> Right, but this effort will both make it harder for new regressions to
> creep in, and will make it easier to backport fixes for these issues
> much easier.

Assuming someone has the time to actually look at all these
problems....

> I've tried running it on current mainline (that was about 12 hours
> before v4.16 was released), and saw some failures there, in particular
> the use-after-free which seems to be caused by generic/388:
> 
> [25302.342348] ==================================================================
> [25302.348851] BUG: KASAN: use-after-free in xfs_rui_release+0x1ce/0x220
> [25302.355334] Read of size 4 at addr ffff8801600f3630 by task fsstress/6274
> [25302.360678]
> [25302.360678] CPU: 7 PID: 6274 Comm: fsstress Not tainted 4.16.0-rc7+ #22
> [25302.360678] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [25302.360678] Call Trace:
> [25302.360678]  dump_stack+0xd6/0x184
> [25302.360678]  ? _atomic_dec_and_lock+0x2cc/0x2cc
> [25302.360678]  ? show_regs_print_info+0x5/0x5
> [25302.360678]  print_address_description+0x75/0x430
> [25302.360678]  ? xfs_rui_release+0x1ce/0x220
> [25302.360678]  kasan_report+0x1d8/0x460
> [25302.360678]  ? xfs_rui_release+0x1ce/0x220
> [25302.360678]  xfs_rui_release+0x1ce/0x220
> [25302.407137]  ? xfs_rui_copy_format+0x100/0x100
> [25302.407137]  xfs_defer_trans_abort+0x1e6/0xac0

I'm sure this was fixed. It's simply a case of having the code call
the release function rather than freeing the item it directly on
abort.

But I can't find the patch, commit, etc.

Ah, a drive-by bug fix back to the EFI code in January, didn't pass
review, was not followed up on with fixes required. Just posted a
patch to fix it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
