Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48900 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbfAGCfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Jan 2019 21:35:25 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2B8A9289E0
        for <linux-xfs@vger.kernel.org>; Mon,  7 Jan 2019 02:35:24 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202053] [xfstests generic/464]: XFS corruption and Assertion
 failed: 0, file: fs/xfs/xfs_super.c, line: 985
Date: Mon, 07 Jan 2019 02:35:23 +0000
Message-ID: <bug-202053-201763-TB4e5MNyFf@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202053-201763@https.bugzilla.kernel.org/>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202053

--- Comment #10 from Zorro Lang (zlang@redhat.com) ---
(In reply to bfoster from comment #7)
> On Fri, Jan 04, 2019 at 07:32:17AM -0500, Brian Foster wrote:
> > On Tue, Dec 25, 2018 at 06:10:59AM +0000,
> bugzilla-daemon@bugzilla.kernel.org
> > wrote:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=202053
> > > 
> > > --- Comment #5 from Zorro Lang (zlang@redhat.com) ---
> > > (In reply to Zorro Lang from comment #4)
> > > > I never hit this bug before, just a similar bug which has been fixed
> one
> > > > year ago, by:
> > > > commit 40214d128e07dd21bb07a8ed6a7fe2f911281ab2
> > > > Author: Brian Foster <bfoster@redhat.com>
> > > > Date:   Fri Oct 13 09:47:46 2017 -0700
> > > > 
> > > >     xfs: trim writepage mapping to within eof
> > > > 
> > > > So I doubt if this's a regression issue?
> > > 
> > > I just reproduced this issue on kernel 4.19, so it's not a regression
> from
> > > v4.19:
> > > 
> > > [ 1297.449750] XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) ||
> > > ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 954
> > > [ 1297.463147] WARNING: CPU: 20 PID: 26952 at fs/xfs/xfs_message.c:104
> > > assfail+0x54/0x57 [xfs]
> > > [ 1297.472473] Modules linked in: sunrpc intel_rapl sb_edac
> > > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
> > > crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ipmi_ssif 
> > > intel_cstate intel_uncore iTCO_wdt iTCO_vendor_support ipmi_si sg
> > > intel_rapl_perf ipmi_devintf wmi ioatdma i2c_i801 pcspkr ipmi_msghandler
> > > lpc_ich xfs libcrc32c sd_mod mgag200 drm_kms_helper 
> > > syscopyarea sysfillrect sysimgblt igb fb_sys_fops ttm dca drm
> crc32c_intel
> > > megaraid_sas i2c_algo_bit cdc_ether usbnet mii dm_mirror dm_region_hash
> > dm_log
> > > dm_mod
> > > [ 1297.525374] CPU: 20 PID: 26952 Comm: umount Not tainted
> 4.19.0-mainline
> > #1
> > > 
> > 
> > I can reproduce this problem and it appears to be somewhat related to
> > the commit referenced above, mainly because the placement of the imap
> > trim leaves a larger than necessary window to race with external changes
> > to the extent map.
> > 
> > For example, a trace dump shows the following sequence of events:
> > 
> > - writepages is in progress on a particular file that has decently sized
> >   post-eof speculative preallocation
> > - writepages gets to the point where it looks up or allocates a new imap
> >   that includes the preallocation, the allocation/lookup result is
> >   stored in wpc
> > - the file is closed by one process, killing off preallocation, then
> >   immediately appended to by another, updating the file size by a few
> >   bytes
> > - writepages comes back around to xfs_map_blocks() and trims imap to the
> >   current size, but imap still includes one block of the original
> speculative
> >   prealloc (that was truncated and recreated) because the size increased
> >   between the time imap was stored and trimmed
> > 
> > The EOF trim approach is known to be a bandaid and potentially racy, but
> > ISTM that this problem can be trivially avoided by moving or adding
> > trims of wpc->imap immediately after a new one is cached. I don't
> > reproduce the problem so far with a couple such extra calls in place.
> > 
> > Bigger picture, we need some kind of invalidation mechanism similar to
> > what we're already doing for dealing with the COW fork in this writeback
> > context. I'm not sure the broad semantics used by the COW fork sequence
> > counter mechanism is really suitable for the data fork because any
> > extent-related change in the fork would cause an invalidation, but I am
> > wondering if we could define some subset of less frequent operations for
> > the same mechanism to reliably invalidate (e.g., on eofblocks trims, for
> > starters).
> > 
> 
> Zorro,
> 
> Can you still reproduce with the following patch?

Hi Brian, below patch looks good. I've kept running g/464 one day, can't
reproduce this bug now.

Thanks,
Zorro

> 
> Brian
> 
> --- 8< ---
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 338b9d9984e0..d9048bcea49c 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -449,6 +449,7 @@ xfs_map_blocks(
>       }
>  
>       wpc->imap = imap;
> +     xfs_trim_extent_eof(&wpc->imap, ip);
>       trace_xfs_map_blocks_found(ip, offset, count, wpc->io_type, &imap);
>       return 0;
>  allocate_blocks:
> @@ -459,6 +460,7 @@ xfs_map_blocks(
>       ASSERT(whichfork == XFS_COW_FORK || cow_fsb == NULLFILEOFF ||
>              imap.br_startoff + imap.br_blockcount <= cow_fsb);
>       wpc->imap = imap;
> +     xfs_trim_extent_eof(&wpc->imap, ip);
>       trace_xfs_map_blocks_alloc(ip, offset, count, wpc->io_type, &imap);
>       return 0;
>  }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
