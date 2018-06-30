Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbeF3Sec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Jun 2018 14:34:32 -0400
Date: Sat, 30 Jun 2018 11:34:26 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Kernel oops at NULL pointer when performing readlink on a fuzzed
 v5 image
Message-ID: <20180630183426.GR5711@magnolia>
References: <15FCAC1E-1320-4122-8768-A45FFCFD1AC2@gatech.edu>
 <20180618052110.GE19934@dastard>
 <E1E76300-2928-4DAA-A15A-15CE062BDDAF@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1E76300-2928-4DAA-A15A-15CE062BDDAF@gatech.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Xu, Wen" <wen.xu@gatech.edu>
Cc: Dave Chinner <david@fromorbit.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

On Fri, Jun 29, 2018 at 05:04:08PM +0000, Xu, Wen wrote:
> Hi Dave,
> 
> Where is the corresponding patch for this issue..has it been committed to for-next branch so far?

IIRC the corresponding patch submission is "xfs: zero length symlinks
are not valid", which (the last time I saw thread activity) he said he'd
clean up and resubmit. (?)

(Under the weather a little still)

--D

> 
> Thanks,
> Wen
> 
> > On Jun 18, 2018, at 1:21 AM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Mon, Jun 18, 2018 at 03:49:52AM +0000, Xu, Wen wrote:
> >> Hi,
> >> 
> >> Here is an issue I found when fuzzing V5 filesystem related with softlink.
> >> 
> >> - Reproduce (4.17/for-next branch)
> >> # mkdir mnt
> >> # mount -t xfs final.img mnt
> >> # gcc -o poc poc.c
> >> # ./poc ./mnt
> > 
> > This does not reproduce on my local dev tree.
> > 
> > This is as much output as I get:
> > 
> >> [  315.207956] XFS (loop0): Mounting V5 Filesystem
> >> [  315.214851] XFS (loop0): Ending clean mount
> >> [  315.214976] Filesystem "loop0": reserve blocks depleted! Consider increasing reserve pool size.
> >> [  315.214979] XFS (loop0): Per-AG reservation for AG 0 failed.  Filesystem may run out of space.
> >> [  315.214981] XFS (loop0): Per-AG reservation for AG 0 failed.  Filesystem may run out of space.
> >> [  326.041728] XFS (loop0): Failed to remove inode(s) from unlinked list. Please free space, unmount and run xfs_repair.
> > 
> > i.e. Nothing unexpected fails, I get ENOENT as expected once the baz
> > -> ./baz symlink loop has been removed.
> > 
> > Ok, now I'm betting that this has something to do with zero length
> > symlinks not being caught correctly, given that a) we identified
> > this flaw a few days ago, b) strlen(symlink_data_ptr) gets a
> > null dereference indicating an empty symlink is being read, and c)
> > there's a warning about failing to remove an inode from the unlinked
> > list and that can leave symlinks with a zeroed in-memory data fork.
> > 
> > Ok, so lets try a plain 4.17 + xfs/for-next. Yup, that does indeed
> > fail.
> > 
> > IOWs, the patch I wrote a few hours ago to prevent zero length
> > symlinks from hitting the disk by not screwing with the inline inode
> > data fork until the inode has been pulled from the unlinked list
> > prevents the crash from occurring.
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
