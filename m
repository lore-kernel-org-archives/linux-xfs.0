Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:5341 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751132AbeFCXbR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:31:17 -0400
Date: Mon, 4 Jun 2018 09:31:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: NULL pointer dereference in xfs_bmap_extents_to_btree() when
 mounting and operating a crafted image
Message-ID: <20180603233114.GW10363@dastard>
References: <CANrHXgzLvaud2HEv3jAFGTfn5S80d7Rwj-ztJNWPT8eyFTohMg@mail.gmail.com>
 <20180603223435.GU10363@dastard>
 <20180603230341.GV10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180603230341.GV10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wen Xu <xuwen.sjtu@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 04, 2018 at 09:03:41AM +1000, Dave Chinner wrote:
> On Mon, Jun 04, 2018 at 08:34:35AM +1000, Dave Chinner wrote:
> > On Sun, Jun 03, 2018 at 06:19:54PM -0400, Wen Xu wrote:
> > > Hi XFS developers and maintainers,
> > > Please check: https://bugzilla.kernel.org/show_bug.cgi?id=199915
> > 
> > Please report bugs straight to this list - it's much easier to
> > track and faster to discuss bugs through email than it is through
> > bugzilla.
> 
> Image log size is too small for the filesystem config. If this was
> a v5 filesystem, then the image would refuse to mount right there.
> 
> As it is, a CONFIG_XFS_DEBUG=y kernel assert fails at mount in
> xfs_check_agi_unlinked().

FWIW, with this check commented out, I can't reproduce the problem
reported in the bugzilla on a current 4.17-rc7 + xfs-for-next tree.
The POC dumps this in the log:

[  262.021574] XFS (loop0): Mounting V4 Filesystem
[  262.022689] XFS (loop0): Log size 864 blocks too small, minimum size is 942 blocks
[  262.024173] XFS (loop0): Log size out of supported range.
[  262.025107] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
[  262.028529] XFS (loop0): Ending clean mount
[  263.448565] XFS (loop0): bad inode magic/vsn daddr 7008 #1 (magic=ffe2)
[  263.450389] XFS (loop0): Metadata corruption detected at xfs_buf_ioend+0x64/0x170, xfs_inode block 0x1b60 xfs_inode_buf_verify
[  263.453309] XFS (loop0): Unmount and run xfs_repair
[  263.454605] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[  263.456301] 00000000d3db45c2: ff e2 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  263.458496] 0000000025677d6d: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  263.460528] 0000000082376c33: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  263.462534] 000000002e73e1fc: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  263.464469] 00000000dfbbb4d7: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 64  ...............d
[  263.466457] 00000000a9156d94: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  263.468383] 00000000f55f3544: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  263.470227] 00000000c0d68803: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  263.472029] XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x1b60 len 16 error 117
[  263.474049] XFS (loop0): xfs_imap_to_bp: xfs_trans_read_buf() returned error -117.
 
And does nothing else.

Can you confirm this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
