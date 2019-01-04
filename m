Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbfADMcT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Jan 2019 07:32:19 -0500
Date: Fri, 4 Jan 2019 07:32:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [Bug 202053] [xfstests generic/464]: XFS corruption and
 Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
Message-ID: <20190104123217.GA16751@bfoster>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
 <bug-202053-201763-R7nWMjQIjy@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202053-201763-R7nWMjQIjy@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 25, 2018 at 06:10:59AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202053
> 
> --- Comment #5 from Zorro Lang (zlang@redhat.com) ---
> (In reply to Zorro Lang from comment #4)
> > I never hit this bug before, just a similar bug which has been fixed one
> > year ago, by:
> > commit 40214d128e07dd21bb07a8ed6a7fe2f911281ab2
> > Author: Brian Foster <bfoster@redhat.com>
> > Date:   Fri Oct 13 09:47:46 2017 -0700
> > 
> >     xfs: trim writepage mapping to within eof
> > 
> > So I doubt if this's a regression issue?
> 
> I just reproduced this issue on kernel 4.19, so it's not a regression from
> v4.19:
> 
> [ 1297.449750] XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) ||
> ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 954
> [ 1297.463147] WARNING: CPU: 20 PID: 26952 at fs/xfs/xfs_message.c:104
> assfail+0x54/0x57 [xfs]
> [ 1297.472473] Modules linked in: sunrpc intel_rapl sb_edac
> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ipmi_ssif 
> intel_cstate intel_uncore iTCO_wdt iTCO_vendor_support ipmi_si sg
> intel_rapl_perf ipmi_devintf wmi ioatdma i2c_i801 pcspkr ipmi_msghandler
> lpc_ich xfs libcrc32c sd_mod mgag200 drm_kms_helper 
> syscopyarea sysfillrect sysimgblt igb fb_sys_fops ttm dca drm crc32c_intel
> megaraid_sas i2c_algo_bit cdc_ether usbnet mii dm_mirror dm_region_hash dm_log
> dm_mod
> [ 1297.525374] CPU: 20 PID: 26952 Comm: umount Not tainted 4.19.0-mainline #1
> 

I can reproduce this problem and it appears to be somewhat related to
the commit referenced above, mainly because the placement of the imap
trim leaves a larger than necessary window to race with external changes
to the extent map.

For example, a trace dump shows the following sequence of events:

- writepages is in progress on a particular file that has decently sized
  post-eof speculative preallocation
- writepages gets to the point where it looks up or allocates a new imap
  that includes the preallocation, the allocation/lookup result is
  stored in wpc
- the file is closed by one process, killing off preallocation, then
  immediately appended to by another, updating the file size by a few
  bytes
- writepages comes back around to xfs_map_blocks() and trims imap to the
  current size, but imap still includes one block of the original speculative
  prealloc (that was truncated and recreated) because the size increased
  between the time imap was stored and trimmed

The EOF trim approach is known to be a bandaid and potentially racy, but
ISTM that this problem can be trivially avoided by moving or adding
trims of wpc->imap immediately after a new one is cached. I don't
reproduce the problem so far with a couple such extra calls in place.

Bigger picture, we need some kind of invalidation mechanism similar to
what we're already doing for dealing with the COW fork in this writeback
context. I'm not sure the broad semantics used by the COW fork sequence
counter mechanism is really suitable for the data fork because any
extent-related change in the fork would cause an invalidation, but I am
wondering if we could define some subset of less frequent operations for
the same mechanism to reliably invalidate (e.g., on eofblocks trims, for
starters).

Brian

> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
