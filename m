Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0181DF258
	for <linux-xfs@vger.kernel.org>; Thu, 26 Feb 2026 05:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772083854; cv=none; b=gQOadmckLTeaX2R7H4ibIsf6lspznV+aEhVhVVopX6S8plMU1mnFePCmPE06Ea8BWcUgbnttvklx6L3ZUAkz2iEPtL5oe4SU9U6ab9XNUGljZPsosUAuVnoNpLTg58xFXz2KtpRaOIE2Z+TdG0hYr8etyOoYXImfXUlhwf2nUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772083854; c=relaxed/simple;
	bh=vsN+7SeUwFGymXqlFNLnBjZ09TkMshPs1r/hhlM5h7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2wqOqAoVsgOs14JJC8VcQfLRT83L6RbSgem+GjS4kuiG+7FgAmj7sslLhFNBLb2zntge5vOnShKWWV4NIEYStyuoMfSw7BVFLaaTo9uDZ0vOYDVBrm43MzBWWPi7iQy9Ja+L5up21/rPpDgJw/pmrUN9f9T+YqXlWBQ2+No7UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aFx5eREc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aFx5eREc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6CBC19422;
	Thu, 26 Feb 2026 05:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772083853;
	bh=vsN+7SeUwFGymXqlFNLnBjZ09TkMshPs1r/hhlM5h7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aFx5eREc+dvnocO54opWebBjqqqt3NyZdgm4xTXJpd3KuhdcpQS6D3C5EC+QZ4dXT
	 Pq3n19JbsVRPK4RlhI+lbAwE07NKAZk5bNStt9SsWF1Z1zJD4JBcsfyqWSDQp+Ua0c
	 UpLzdukw2iYPEOzdlkWrTP5QsvNHY9I1TyotJJq3eUHMTwIK6rCb0DWgzVD3AuEls2
	 /5nDa6akWXfxwBcsWTFOBlAPK2M8P7C0D4Ues0fy1TvlZSIRWO3K65uAl94mXOXglU
	 bqDjyqIsEHOpBpM31FwXWkXWQdtolHFqm8mfTuRWmzGXidGobr2nadcI461hJIVa85
	 0bh+E5u4t7ioQ==
Date: Wed, 25 Feb 2026 21:30:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: generic/753 crash with LARP
Message-ID: <20260226053052.GE13853@frogsfrogsfrogs>
References: <aYC0pe-S-RWSMXHn@infradead.org>
 <20260202185959.GJ7712@frogsfrogsfrogs>
 <CAF-d4OshnJ997DDsgWzr0f+4-JpRaQ+B5-y6M0PUm=es9LpQXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF-d4OshnJ997DDsgWzr0f+4-JpRaQ+B5-y6M0PUm=es9LpQXA@mail.gmail.com>

On Wed, Feb 25, 2026 at 02:14:53PM +0530, Ravi Singh wrote:
> Hi Darrick,
> 
> When running xfstests generic/753, I’ve been running into the same
> crash(with debug) during attribute log recovery as well as xfs_repair
> error messages(with non-debug). I found that the xfstests commit
> e72c9219 (“fsstress: fix attr_set naming”) exposed a pre-existing gap
> in XFS attribute crash recovery. Prior to this change, fsstress did
> not correctly exercise multi-transaction attribute replace operations
> and was silently failing to do so, which masked the underlying
> recovery issue.
> 
> There are two related issues here, one for debug (with LARP) and one
> affecting non-debug(without LARP) build.
> 
> Issue 1: With Debug  ASSERT failure during LARP recovery
> 
> Root cause: During log recovery, xfs_attr_recover_work() reconstructs
> the initial state for a logged REPLACE by calling
> xfs_attr_init_replace_state(). When XFS_DA_OP_LOGGED is set, this
> returns xfs_attr_init_remove_state() - starting the state machine at
> XFS_DAS_NODE_REMOVE. The intent log item doesn't record which state
> the operation had reached before the crash, so recovery always
> restarts from the beginning.
> 
> The state machine enters XFS_DAS_NODE_REMOVE in xfs_attr_set_iter()
> which calls xfs_attr_node_removename_setup() ->
> xfs_attr_leaf_mark_incomplete() -> xfs_attr3_leaf_setflag(). This
> function asserts that XFS_ATTR_INCOMPLETE is not already set.
> But if the crash occurred after the transaction that set the
> INCOMPLETE flag had committed (i.e., the original operation had
> already passed through xfs_attr3_leaf_setflag and committed) but
> before the full replace finished, then the entry already has
> INCOMPLETE on disk. Recovery replays setflag on an already-INCOMPLETE
> entry and trips the assertion.
> 
> Issue 2: Non-debug (LARP disabled) - xfs_repair detects INCOMPLETE entries.
> 
> The multi-transaction sequence is:
>   1. Add new entry with XFS_ATTR_INCOMPLETE set (committed)
>   2. Allocate remote value blocks if needed (committed in one or more
> transactions)
>   3. xfs_attr3_leaf_flipflags() atomically clears INCOMPLETE on new
> entry and sets it on old entry (committed)
>   4. Remove old entry and its remote blocks
> 
> If a crash occurs between steps 1 and 3 (e.g., generic/753 induces a
> dm-error crash), the new attribute entry exists on disk with
> XFS_ATTR_INCOMPLETE set and potentially partially or fully allocated
> remote blks. Since no ATTRI intent was logged, log recovery has
> nothing to replay. The INCOMPLETE entry and its associated blocks are
> orphaned permanently.
> 
> When xfs_repair detects INCOMPLETE entries, it clears the attribute
> fork. However, the inode’s di_nblocks and di_anextents counters are
> not updated and still include the blocks that were allocated to the
> removed attribute data. This discrepancy leads to counter mismatch
> errors
> 
> Errors from generic/753.full :
> 
> attribute entry #6 in attr block 82, inode 132 is INCOMPLETE
> problem with attribute contents in inode 132
> would clear attr fork
> bad nblocks 2119 for inode 132, would reset to 0
> bad anextents 921 for inode 132, would reset to 0
> attribute entry #5 in attr block 140, inode 133 is INCOMPLETE
> problem with attribute contents in inode 133
> would clear attr fork
> bad nblocks 1243 for inode 133, would reset to 0
> bad anextents 684 for inode 133, would reset to 0
> 
> A potential fix for the debug build might look like this:
> 
> xfs_attr3_leaf_setflag()
> 
>   /* Before: */
>   ASSERT((entry->flags & XFS_ATTR_INCOMPLETE) == 0);
> 
>   /* After: */
>   if (entry->flags & XFS_ATTR_INCOMPLETE) {
>       ASSERT(args->op_flags & XFS_DA_OP_RECOVERY);
>       return 0;
>   }
> 
> But I’m not sure what the appropriate fix would be for the non-debug build.

Hrm.  Where should we insert a xfs_force_shutdown call to reproduce the
problem?  I can get this to trip, but only after 18-25 minutes of
letting g/753 run.

Also, if you apply that patch so that it creates the incomplete attr
name, do you end up with a consistent filesystem afterwards?

I think xfs_repair could report incomplete attr names instead of
clobbering the whole attr fork.  xfs_scrub can fix it, so it's not a big
deal to leave incomplete names around ... unless it'll confuse
xfs_attr_set?

(Also, do you ever see the xfs_repair in g/753 fail with complaints
about a corrupt attr leaf block at block offset 0?  I've seen that once
or twice but haven't reproduced it consistently yet...)

--D

> Thanks,
> Ravi
> 
> On Tue, Feb 3, 2026 at 12:30 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Mon, Feb 02, 2026 at 06:28:53AM -0800, Christoph Hellwig wrote:
> > > I've seen a few crashed during xfstests where generic/753 crashed during
> > > attr log recovery.  They never reproduced when running the test
> > > standalone in the loop, which made me realize that normally the
> > > test does not even hit attr log recovery.  Forcing using the attr log
> > > items using:
> > >
> > > echo 1 > /sys/fs/xfs/debug/larp
> > >
> > > Now makes it crash immediately for me.  I plan to separately look why
> > > LARP is enabled during my -g auto run, probably some issue with the
> > > actual LARP tests, but for now here is the trace.  Sending this to
> > > Darrick as I think he touched that area last and might have ideas.
> >
> > Huh, that's interesting.  I still get other weird failures in g/753 like
> > attr fork block 0 containing random garbage, but I've not seen this one
> > yet.
> >
> > I suspect what's happening is that the attr intent code might have
> > finished writing the new attr and cleared incomplete but didn't manage
> > to write the attrd log item to disk before the fs went down.
> >
> > The strange thing that I think I'm seeing is a dirty log with an ondisk
> > transaction that ends with the updates needed to allocate and map a new
> > block into the attr fork at fileoff 0, but oddly is missing the buffer
> > log item to set the contents of the new block 0 to an attr leaf block.
> >
> > But it takes a good hour of pounding before that happens, so it's hard
> > even to add debugging to chase this down.
> >
> > --D
> >
> > > [   40.121475] XFS (dm-0): Mounting V5 Filesystem 82ccfb3f-c733-4297-a560-0b583af89968
> > > [   40.325118] XFS (dm-0): Starting recovery (logdev: internal)
> > > [   40.947262] XFS: Assertion failed: (entry->flags & XFS_ATTR_INCOMPLETE) == 0, file: fs/xfs/libxfs/xfs_attr_leaf.c, line: 2996
> > > [   40.947950] ------------[ cut here ]------------
> > > [   40.948205] kernel BUG at fs/xfs/xfs_message.c:102!
> > > [   40.948500] Oops: invalid opcode: 0000 [#1] SMP NOPTI
> > > [   40.948932] CPU: 0 UID: 0 PID: 4585 Comm: mount Not tainted 6.19.0-rc6+ #3467 PREEMPT(full)
> > > [   40.949483] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> > > [   40.950048] RIP: 0010:assfail+0x2c/0x35
> > > [   40.950252] Code: 40 d6 49 89 d0 41 89 c9 48 c7 c2 58 ed f8 82 48 89 f1 48 89 fe 48 c7 c7 d6 33 02 83 e8 fd fd ff ff 80 3d 7e ce 84 02 00 74 02 <0f> 0b 0f 0b c3 cc cc cc cc 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c
> > > [   40.950871] RSP: 0018:ffffc90006dc3a68 EFLAGS: 00010202
> > > [   40.950871] RAX: 0000000000000000 RBX: ffff8881130bd158 RCX: 000000007fffffff
> > > [   40.950871] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff830233d6
> > > [   40.950871] RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000000a
> > > [   40.950871] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88811ac9c000
> > > [   40.950871] R13: ffff88811ac9c0d0 R14: ffff888117b8e300 R15: ffff8881130bd100
> > > [   40.950871] FS:  00007f35a3087840(0000) GS:ffff8884eb58a000(0000) knlGS:0000000000000000
> > > [   40.950871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   40.950871] CR2: 00007fff920deed8 CR3: 000000012821e004 CR4: 0000000000770ef0
> > > [   40.950871] PKRU: 55555554
> > > [   40.950871] Call Trace:
> > > [   40.950871]  <TASK>
> > > [   40.950871]  xfs_attr3_leaf_setflag+0x188/0x1e0
> > > [   40.950871]  xfs_attr_set_iter+0x46d/0xbb0
> > > [   40.950871]  xfs_attr_finish_item+0x48/0x110
> > > [   40.950871]  xfs_defer_finish_one+0xfd/0x2a0
> > > [   40.950871]  xlog_recover_finish_intent+0x68/0x80
> > > [   40.950871]  xfs_attr_recover_work+0x360/0x5a0
> > > [   40.950871]  xfs_defer_finish_recovery+0x1f/0x90
> > > [   40.950871]  xlog_recover_process_intents+0x9f/0x2b0
> > > [   40.950871]  ? _raw_spin_unlock_irqrestore+0x1d/0x40
> > > [   40.950871]  ? debug_object_activate+0x1ec/0x250
> > > [   40.950871]  xlog_recover_finish+0x46/0x320
> > > [   40.950871]  xfs_log_mount_finish+0x16a/0x1c0
> > > [   40.950871]  xfs_mountfs+0x52e/0xa60
> > > [   40.950871]  ? xfs_mru_cache_create+0x179/0x1c0
> > > [   40.950871]  xfs_fs_fill_super+0x669/0xa30
> > > [   40.950871]  ? __pfx_xfs_fs_fill_super+0x10/0x10
> > > [   40.950871]  get_tree_bdev_flags+0x12f/0x1d0
> > > [   40.950871]  vfs_get_tree+0x24/0xd0
> > > [   40.950871]  vfs_cmd_create+0x54/0xd0
> > > [   40.950871]  __do_sys_fsconfig+0x4f6/0x6b0
> > > [   40.950871]  do_syscall_64+0x50/0x2a0
> > > [   40.950871]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > [   40.950871] RIP: 0033:0x7f35a32ac4aa
> > > [   40.950871] Code: 73 01 c3 48 8b 0d 4e 59 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 af 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1e 59 0d 00 f7 d8 64 89 01 48
> > > [   40.950871] RSP: 002b:00007ffce01ac698 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
> > > [   40.950871] RAX: ffffffffffffffda RBX: 00005625531e3ad0 RCX: 00007f35a32ac4aa
> > > [   40.950871] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
> > > [   40.950871] RBP: 00005625531e4bf0 R08: 0000000000000000 R09: 0000000000000000
> > > [   40.950871] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > [   40.950871] R13: 00007f35a343e580 R14: 00007f35a344026c R15: 00007f35a3425a23
> > > [   40.950871]  </TASK>
> > > [   40.950871] Modules linked in:
> > > [   40.964577] ---[ end trace 0000000000000000 ]---
> > > [   40.965044] RIP: 0010:assfail+0x2c/0x35
> > > [   40.965274] Code: 40 d6 49 89 d0 41 89 c9 48 c7 c2 58 ed f8 82 48 89 f1 48 89 fe 48 c7 c7 d6 33 02 83 e8 fd fd ff ff 80 3d 7e ce 84 02 00 74 02 <0f> 0b 0f 0b c3 cc cc cc cc 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c
> > > [   40.966296] RSP: 0018:ffffc90006dc3a68 EFLAGS: 00010202
> > > [   40.966588] RAX: 0000000000000000 RBX: ffff8881130bd158 RCX: 000000007fffffff
> > > [   40.967151] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff830233d6
> > > [   40.967546] RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000000a
> > > [   40.967947] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff88811ac9c000
> > > [   40.968322] R13: ffff88811ac9c0d0 R14: ffff888117b8e300 R15: ffff8881130bd100
> > > [   40.968687] FS:  00007f35a3087840(0000) GS:ffff8884eb58a000(0000) knlGS:0000000000000000
> > > [   40.969101] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   40.969437] CR2: 00007f9fd47ad3f0 CR3: 000000012821e004 CR4: 0000000000770ef0
> > > [   40.969806] PKRU: 55555554
> > >
> >
> 
> 
