Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51766 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbeLRTbs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 14:31:48 -0500
Date: Tue, 18 Dec 2018 11:31:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/2] xfs: swapext replay fixes
Message-ID: <20181218193134.GI27208@magnolia>
References: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81b35377-47d9-2421-ba5c-537ac6c8c021@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 18, 2018 at 12:59:15PM -0600, Eric Sandeen wrote:
> We've seen 2 reports of an oops on log replay after a swapext, which
> look something like:
> 
> [   63.188907] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004 
> [   63.196774] IP: [<ffffffffc093e5e6>] xfs_bmbt_init_cursor+0x46/0x180 [xfs] 
> ...
> [   63.309769] RIP: 0010:[<ffffffffc093e5e6>]  [<ffffffffc093e5e6>] xfs_bmbt_init_cursor+0x46/0x180 [xfs] 
> [   63.319132] RSP: 0018:ffff951b4d2977d0  EFLAGS: 00010282 
> [   63.324443] RAX: ffff951b4df63440 RBX: ffff951ba8a48000 RCX: 0000000000000000 
> [   63.331570] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff951b4df63518 
> [   63.338689] RBP: ffff951b4d2977f8 R08: 000000000001e2f0 R09: ffff951b4df63440 
> [   63.345818] R10: ffff951afa403800 R11: ffffffffffffffe0 R12: ffff951b4d0a3000 
> [   63.352949] R13: 0000000000000000 R14: 0000000000000000 R15: ffff951ba8a48040 
> [   63.360079] FS:  00007f72bcd1f880(0000) GS:ffff951bafc80000(0000) knlGS:0000000000000000 
> [   63.368160] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
> [   63.373893] CR2: 0000000000000004 CR3: 0000000128d8a000 CR4: 00000000000007e0 
> [   63.381029] Call Trace: 
> [   63.383541]  [<ffffffffc093e7f7>] xfs_bmbt_change_owner+0x27/0x70 [xfs] 
> [   63.390225]  [<ffffffffc09941a3>] xfs_recover_inode_owner_change.isra.26+0xa3/0xc0 [xfs] 
> [   63.398351]  [<ffffffffc0995b9c>] xlog_recover_inode_pass2+0x4cc/0x9d0 [xfs] 
> [   63.405460]  [<ffffffffc0990018>] ? xfs_efi_release+0x58/0x80 [xfs] 
> [   63.411763]  [<ffffffffc0996192>] xlog_recover_commit_pass2+0xf2/0x1a0 [xfs] 
> [   63.418848]  [<ffffffffc0996289>] xlog_recover_items_pass2+0x49/0x70 [xfs] 
> [   63.425769]  [<ffffffffc09964c5>] xlog_recover_commit_trans+0x215/0x250 [xfs] 
> ...
> 
> I can reproduce this with a hacky script that can be cleaned up and turned into
> an xfstest:
> 
> #!/bin/bash
> 
> DEV=/dev/sdZ1
> 
> umount $DEV
> mkfs.xfs -f $DEV
> 
> mkdir -p /mnt/test
> mount $DEV /mnt/test
> 
> for I in `seq 4194304 -4096 0`; do
> 	((I % 12288)) || continue
> 	xfs_io -f -d -c "pwrite $I 4096" /mnt/test/fragfile
> done
> 
> xfs_fsr -v /mnt/test/fragfile
> 
> 
> xfs_io -c "truncate 0" /mnt/test/fragfile
> 
> for I in `seq 32768 -4096 0`; do
> 	xfs_io -f -c "pwrite $I 4096" /mnt/test/fragfile
> done
> 
> sync
> 
> xfs_io -x -c shutdown /mnt/test
> umount /mnt/test
> mount $DEV /mnt/test

...which I assume is going to show up on fstests shortly, right? :)

--D

> ====
> 
> The upshot is that if we successfully fsr a file and it remains in btree format,
> then it changes to non-btree format and we crash, log replay will still try to
> do xfs_bmbt_change_owner which will oops if we're not in btree format.
> 
> Patches to fix this follow.  Lightly tested.  Thanks to dave for talking
> through this one with me.
