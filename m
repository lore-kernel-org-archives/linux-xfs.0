Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA65A9443;
	Fri, 13 Feb 2026 20:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771013019; cv=none; b=WppcMSRgEovGjxK+ulVKT+NkB1kCSAW7/wcr/AMxTxwtqQVuru/esBoNUcN63Fxt6jDcTPiUcFF36kOUQjBtMjdgGWNTQer0F8Wp4vY/38yglWO1lgdh349Mz4Ky0XNSTe9s+Cqid/NiBhnHdRzy9k3BVHWWEdUBa1S4zDxM59Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771013019; c=relaxed/simple;
	bh=mk2mSJUEf73au1t002CTwLHtwF4mjJ+y37p5bizgvv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h05DSN0ZUYMhpLCj5NlPu4SSy7SAYni36lCpi012gzG9fjNDpVI6KioMdOfsipNLHPcqIrssEl6CiCst4P48yaCAbQtENw0jBqHunO+8oe4k3ppEabv3b6rZFwQGGSz8BBaeKxRCU3T3T/uzuCbexbuBauKXC73MyY174qYN/zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A54k221T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A54k221T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D15C116C6;
	Fri, 13 Feb 2026 20:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771013019;
	bh=mk2mSJUEf73au1t002CTwLHtwF4mjJ+y37p5bizgvv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A54k221TkT/eABwxbAI6ZudzZgTY347tudNrGdUidRrAD7iO1OSdda1OcdsKoXdGf
	 2lRyqXjVNMxg5tWbPjEXb4sTL5C4eyoEh8XY8/mG+xlkbTQMJaXoDvnUwvUZTQADj5
	 s5LRN6aaPABdLWXDAxPLGKJfa1DTRe1IznkiK/5aJDhpAR00Yh+qj4sIxThY3s3Gow
	 wOLjrL8BegFiMGwJf94liZoaWwfXKi27l2isvrHAyk0Jdv/8KS2E9Kf2GKeOaVPe7O
	 Uu2u/hsLaX8VyoXMgK8b0QHM4la2kKBWqeEShC+71NxQpnCRdOwBqlTlYVeouIglNb
	 rXEBbiVPj79xA==
Date: Fri, 13 Feb 2026 12:03:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sam Sun <samsun1006219@gmail.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
Subject: Re: [Linux xfs bug] KASAN: slab-use-after-free Read in fserror_worker
Message-ID: <20260213200338.GU1535390@frogsfrogsfrogs>
References: <CAEkJfYNmhZ3E6p-MukHWNo8B-djgobP3EZ2yucJCGVwNBtuooQ@mail.gmail.com>
 <20260212160204.GF7712@frogsfrogsfrogs>
 <CAEkJfYM=vn5rPT-mUtRsO4wjGvwO9S-u9HUtYbO7oK38aomUjw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEkJfYM=vn5rPT-mUtRsO4wjGvwO9S-u9HUtYbO7oK38aomUjw@mail.gmail.com>

On Fri, Feb 13, 2026 at 10:46:03AM +0800, Sam Sun wrote:
> On Fri, Feb 13, 2026 at 12:02 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Feb 12, 2026 at 08:46:42PM +0800, Sam Sun wrote:
> > > Dear developers and maintainers,
> > >
> > > We encountered a slab-use-after-free bug while using our modified
> > > syzkaller. This bug is successfully reproduced on kernel commit
> > > 37a93dd5c49b5fda807fd204edf2547c3493319c. Kernel crash log is listed
> > > below.
> >
> > Oh good, yet ANOTHER person running their own private syzbot instance,
> > not using the existing syzbot dashboard, and dumping a zeroday exploit
> > on a public mailing list.
> >
> > Why do I keep saying this same damn thing over and over?
> >
> > Yes, I do have a question: What code change do you propose to *fix*
> > this problem?
> >
> > --D
> >
> 
> Hi Darrick,
> 
> I’m sorry for the noise and for handling this poorly.
> 
> The bug appears to be a lifetime mismatch between asynchronous fserror
> reporting and temporary XFS inode teardown paths.
> xfs_inode_mark_sick/corrupt always trigger inode-scoped async fserror
> reporting. That reporting queues work and later does
> iput(event->inode) in worker context. But in some paths (e.g.
> temporary inode construction/failure paths such as xfs_iget_cache_miss
> error handling), the inode can be destroyed directly before the queued
> work runs, which can lead to UAF when the worker later touches or puts
> that inode.
> 
> I added a check in xfs_inode_mark_sick and xfs_inode_mark_corrupt, and
> only do inode-scoped fserror reporting if the inode looks
> stable/published (not unhashed, not in
> I_NEW/I_WILL_FREE/I_FREEING/I_CLEAR). Otherwise, fall back to
> superblock-scoped metadata error reporting. This keeps error reporting
> but avoids queuing async inode events for short-lived/teardown inodes.
> 
> Could you please check if this fix would apply?
> 
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 169123772cb3..d7c5e97801bf 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -38,6 +38,37 @@ xfs_health_unmount_group(
> }
> }
> +static bool
> +xfs_inode_can_report_file_error(
> + struct inode *inode)
> +{

This is neither xfs nor kernel coding style.

> + enum inode_state_flags_enum state;
> + bool ok;
> +
> + spin_lock(&inode->i_lock);
> + state = inode_state_read(inode);
> + ok = !inode_unhashed(inode) &&
> + !(state & (I_NEW | I_WILL_FREE | I_FREEING | I_CLEAR));

I don't like the idea of looking at VFS state in XFS code, surely this
belongs in fserror_report itself?

The problem you have here (guessing from the stack trace because again a
log of strace calls is NOT a reproducer!) is that xfs_iget_cache_miss
allocates a new xfs_inode (which doesn't set XFS_INEW), trips over a
corruption error, and passes the xfs_inode to xfs_inode_mark_sick.

_mark_sick then passes it to fserror_report, which it shouldn't do
because the xfs_inode hasn't been set up with vfs state yet.  IOWs,
the XFS side of the fix should probably be setting XFS_INEW earlier
and not passing inodes to fserror_report if they've XFS_INEW (or
RECLAIM) set.

On the VFS side of things, fserror_report should clarify that it must
only be passed active inodes (aka ones that don't have
I_NEW/I_FREEING/I_WILL_FREE set), at which point it could probably
increment inode::i_count on its own instead of calling igrab, which
would fix the lockdep spew that hch reported earlier this morning.

Also xfs shouldn't be passing metadata inodes into the VFS because
there's nothing good that can come from telling userspace about file
errors for a file that it cannot ever open.

IOWs, I think this is a better alternative:


static inline void xfs_inode_report_fserror(struct xfs_inode *ip)
{
	/*
	 * Do not report inodes being constructed or freed, or metadata
	 * inodes, to fsnotify.
	 */
	if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIM) ||
	    xfs_is_internal_inode(ip)) {
		fserror_report_metadata(ip->i_mount->m_super, -EFSCORRUPTED,
				GFP_NOFS);
		return;
	}

	fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
}

> + if (ok)
> + inode_state_clear(inode, I_DONTCACHE);

Why is clearing I_DONTCACHE now conditional?

> + spin_unlock(&inode->i_lock);
> +
> + return ok;
> +}
> +
> +static void
> +xfs_report_inode_corruption(
> + struct xfs_inode *ip)
> +{
> + struct inode *inode = VFS_I(ip);
> +
> + if (xfs_inode_can_report_file_error(inode))
> + fserror_report_file_metadata(inode, -EFSCORRUPTED, GFP_NOFS);
> + else
> + fserror_report_metadata(ip->i_mount->m_super, -EFSCORRUPTED,
> + GFP_NOFS);
> +}
> +
> /*
> * Warn about metadata corruption that we detected but haven't fixed, and
> * make sure we're not sitting on anything that would get in the way of
> @@ -330,16 +361,7 @@ xfs_inode_mark_sick(
> ip->i_sick |= mask;
> spin_unlock(&ip->i_flags_lock);
> - /*
> - * Keep this inode around so we don't lose the sickness report. Scrub
> - * grabs inodes with DONTCACHE assuming that most inode are ok, which
> - * is not the case here.

Do not delete explanatory comments.

> - */
> - spin_lock(&VFS_I(ip)->i_lock);
> - inode_state_clear(VFS_I(ip), I_DONTCACHE);
> - spin_unlock(&VFS_I(ip)->i_lock);
> -
> - fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
> + xfs_report_inode_corruption(ip);

It's not good practice for a function to contain hidden side effects
that aren't even hinted at in the name/comment.

> if (mask)
> xfs_healthmon_report_inode(ip, XFS_HEALTHMON_SICK, old_mask,
> mask);
> @@ -362,16 +384,7 @@ xfs_inode_mark_corrupt(
> ip->i_checked |= mask;
> spin_unlock(&ip->i_flags_lock);
> - /*
> - * Keep this inode around so we don't lose the sickness report. Scrub
> - * grabs inodes with DONTCACHE assuming that most inode are ok, which
> - * is not the case here.
> - */
> - spin_lock(&VFS_I(ip)->i_lock);
> - inode_state_clear(VFS_I(ip), I_DONTCACHE);
> - spin_unlock(&VFS_I(ip)->i_lock);
> -
> - fserror_report_file_metadata(VFS_I(ip), -EFSCORRUPTED, GFP_NOFS);
> + xfs_report_inode_corruption(ip);
> if (mask)
> xfs_healthmon_report_inode(ip, XFS_HEALTHMON_CORRUPT, old_mask,
> mask);
> 
> 
> Also, for future reports like this, what is the preferred process?
> Should I report privately first (e.g. to kernel security) before
> posting publicly when a bug might have exploitation potential?

As I said in the last email, don't run your own private syzbot instance
that makes triaging difficult because it doesn't integrate with the
syzkaller dashboards.

I'm really sick of saying this over and over again.

--D

> Sorry again, and thanks for the direct feedback.
> 
> Best Regards,
> Yue
> 
> > > [  217.613191][    T9]
> > > ==================================================================
> > > [  217.613974][    T9] BUG: KASAN: slab-use-after-free in
> > > iput.part.0+0xe43/0xf50
> > > [  217.614674][    T9] Read of size 4 at addr ff1100002b0e11b8 by task
> > > kworker/0:0/9
> > > [  217.615384][    T9]
> > > [  217.615614][    T9] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not
> > > tainted 6.19.0-08320-g37a93dd5c49b #11 PREEMPT(full)
> > > [  217.615630][    T9] Hardware name: QEMU Standard PC (i440FX + PIIX,
> > > 1996), BIOS 1.15.0-1 04/01/2014
> > > [  217.615639][    T9] Workqueue: events fserror_worker
> > > [  217.615654][    T9] Call Trace:
> > > [  217.615659][    T9]  <TASK>
> > > [  217.615663][    T9]  dump_stack_lvl+0x116/0x1b0
> > > [  217.615687][    T9]  print_report+0xca/0x5f0
> > > [  217.615706][    T9]  ? __phys_addr+0xeb/0x180
> > > [  217.615727][    T9]  ? iput.part.0+0xe43/0xf50
> > > [  217.615742][    T9]  ? iput.part.0+0xe43/0xf50
> > > [  217.615758][    T9]  kasan_report+0xca/0x100
> > > [  217.615776][    T9]  ? iput.part.0+0xe43/0xf50
> > > [  217.615793][    T9]  iput.part.0+0xe43/0xf50
> > > [  217.615809][    T9]  ? _raw_spin_unlock_irqrestore+0x41/0x70
> > > [  217.615831][    T9]  ? __pfx_xfs_fs_report_error+0x10/0x10
> > > [  217.615851][    T9]  iput+0x35/0x40
> > > [  217.615866][    T9]  fserror_worker+0x1da/0x320
> > > [  217.615879][    T9]  ? __pfx_fserror_worker+0x10/0x10
> > > [  217.615894][    T9]  ? _raw_spin_unlock_irq+0x23/0x50
> > > [  217.615916][    T9]  process_one_work+0x992/0x1b00
> > > [  217.615934][    T9]  ? __pfx_process_srcu+0x10/0x10
> > > [  217.615952][    T9]  ? __pfx_process_one_work+0x10/0x10
> > > [  217.615969][    T9]  ? __pfx_fserror_worker+0x10/0x10
> > > [  217.615983][    T9]  worker_thread+0x67e/0xe90
> > > [  217.616000][    T9]  ? __pfx_worker_thread+0x10/0x10
> > > [  217.616016][    T9]  kthread+0x38d/0x4a0
> > > [  217.616030][    T9]  ? __pfx_kthread+0x10/0x10
> > > [  217.616044][    T9]  ret_from_fork+0xb32/0xde0
> > > [  217.616058][    T9]  ? __pfx_ret_from_fork+0x10/0x10
> > > [  217.616070][    T9]  ? __pfx_kthread+0x10/0x10
> > > [  217.616084][    T9]  ? __switch_to+0x767/0x10d0
> > > [  217.616100][    T9]  ? __pfx_kthread+0x10/0x10
> > > [  217.616114][    T9]  ret_from_fork_asm+0x1a/0x30
> > > [  217.616134][    T9]  </TASK>
> > > [  217.616138][    T9]
> > > [  217.631722][    T9] Allocated by task 12552:
> > > [  217.632138][    T9]  kasan_save_stack+0x24/0x50
> > > [  217.632588][    T9]  kasan_save_track+0x14/0x30
> > > [  217.633034][    T9]  __kasan_slab_alloc+0x87/0x90
> > > [  217.633498][    T9]  kmem_cache_alloc_lru_noprof+0x23f/0x6c0
> > > [  217.634050][    T9]  xfs_inode_alloc+0x80/0x910
> > > [  217.634496][    T9]  xfs_iget+0x893/0x3020
> > > [  217.634903][    T9]  xfs_lookup+0x323/0x6c0
> > > [  217.635320][    T9]  xfs_vn_lookup+0x154/0x1d0
> > > [  217.635752][    T9]  lookup_open.isra.0+0x64a/0x1030
> > > [  217.636244][    T9]  path_openat+0xe97/0x2cf0
> > > [  217.636663][    T9]  do_file_open+0x216/0x470
> > > [  217.637086][    T9]  do_sys_openat2+0xe6/0x250
> > > [  217.637523][    T9]  __x64_sys_openat+0x13f/0x1f0
> > > [  217.637980][    T9]  do_syscall_64+0x11b/0xf80
> > > [  217.638411][    T9]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > [  217.638959][    T9]
> > > [  217.639183][    T9] Freed by task 15:
> > > [  217.639541][    T9]  kasan_save_stack+0x24/0x50
> > > [  217.639987][    T9]  kasan_save_track+0x14/0x30
> > > [  217.640431][    T9]  kasan_save_free_info+0x3b/0x60
> > > [  217.640899][    T9]  __kasan_slab_free+0x61/0x80
> > > [  217.641351][    T9]  kmem_cache_free+0x139/0x6a0
> > > [  217.641804][    T9]  rcu_core+0x59e/0x1130
> > > [  217.642210][    T9]  handle_softirqs+0x1d4/0x8e0
> > > [  217.642667][    T9]  run_ksoftirqd+0x3a/0x60
> > > [  217.643089][    T9]  smpboot_thread_fn+0x3d4/0xaa0
> > > [  217.643555][    T9]  kthread+0x38d/0x4a0
> > > [  217.643939][    T9]  ret_from_fork+0xb32/0xde0
> > > [  217.644373][    T9]  ret_from_fork_asm+0x1a/0x30
> > > [  217.644821][    T9]
> > > [  217.645043][    T9] Last potentially related work creation:
> > > [  217.645565][    T9]  kasan_save_stack+0x24/0x50
> > > [  217.646019][    T9]  kasan_record_aux_stack+0xa7/0xc0
> > > [  217.646499][    T9]  __call_rcu_common.constprop.0+0xa4/0xa00
> > > [  217.647058][    T9]  xfs_iget+0x100e/0x3020
> > > [  217.647466][    T9]  xfs_lookup+0x323/0x6c0
> > > [  217.647874][    T9]  xfs_vn_lookup+0x154/0x1d0
> > > [  217.648310][    T9]  lookup_open.isra.0+0x64a/0x1030
> > > [  217.648794][    T9]  path_openat+0xe97/0x2cf0
> > > [  217.649217][    T9]  do_file_open+0x216/0x470
> > > [  217.649647][    T9]  do_sys_openat2+0xe6/0x250
> > > [  217.650089][    T9]  __x64_sys_openat+0x13f/0x1f0
> > > [  217.650546][    T9]  do_syscall_64+0x11b/0xf80
> > > [  217.650983][    T9]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > > [  217.651537][    T9]
> > > [  217.651761][    T9] The buggy address belongs to the object at
> > > ff1100002b0e0f00
> > > [  217.651761][    T9]  which belongs to the cache xfs_inode of size 1784
> > > [  217.653033][    T9] The buggy address is located 696 bytes inside of
> > > [  217.653033][    T9]  freed 1784-byte region [ff1100002b0e0f00,
> > > ff1100002b0e15f8)
> > > [  217.654300][    T9]
> > > [  217.654521][    T9] The buggy address belongs to the physical page:
> > > [  217.654681][T12608] XFS (loop1): Ending clean mount
> > > [  217.655107][    T9] page: refcount:0 mapcount:0
> > > mapping:0000000000000000 index:0xff1100002b0e3c00 pfn:0x2b0e0
> > > [  217.656518][    T9] head: order:3 mapcount:0 entire_mapcount:0
> > > nr_pages_mapped:0 pincount:0
> > > [  217.657289][    T9] memcg:ff1100002b0e0721
> > > [  217.657686][    T9] flags:
> > > 0xfff00000000240(workingset|head|node=0|zone=1|lastcpupid=0x7ff)
> > > [  217.658474][    T9] page_type: f5(slab)
> > > [  217.658853][    T9] raw: 00fff00000000240 ff1100001cf1a280
> > > ffd400000090d010 ff1100001cf1b648
> > > [  217.659642][    T9] raw: ff1100002b0e3c00 0000078000110008
> > > 00000000f5000000 ff1100002b0e0721
> > > [  217.660438][    T9] head: 00fff00000000240 ff1100001cf1a280
> > > ffd400000090d010 ff1100001cf1b648
> > > [  217.661243][    T9] head: ff1100002b0e3c00 0000078000110008
> > > 00000000f5000000 ff1100002b0e0721
> > > [  217.662038][    T9] head: 00fff00000000003 ffd4000000ac3801
> > > 00000000ffffffff 00000000ffffffff
> > > [  217.662829][    T9] head: ffffffffffffffff 0000000000000000
> > > 00000000ffffffff 0000000000000008
> > > [  217.663624][    T9] page dumped because: kasan: bad access detected
> > > [  217.664211][    T9] page_owner tracks the page as allocated
> > > [  217.664732][    T9] page last allocated via order 3, migratetype
> > > Reclaimable, gfp_mask 0xd2050(__GFP_RECLAIMABLE|__GFP_IO|__2
> > > [  217.665172][T12608] XFS (loop1): Quotacheck needed: Please wait.
> > > [  217.666765][    T9]  post_alloc_hook+0x1ca/0x240
> > > [  217.667789][    T9]  get_page_from_freelist+0xde8/0x2ae0
> > > [  217.668307][    T9]  __alloc_frozen_pages_noprof+0x256/0x20f0
> > > [  217.668868][    T9]  new_slab+0xa6/0x6b0
> > > [  217.669335][    T9]  refill_objects+0x256/0x3f0
> > > [  217.669774][    T9]  __pcs_replace_empty_main+0x1b1/0x620
> > > [  217.670284][    T9]  kmem_cache_alloc_lru_noprof+0x586/0x6c0
> > > [  217.670818][    T9]  xfs_inode_alloc+0x80/0x910
> > > [  217.671257][    T9]  xfs_iget+0x893/0x3020
> > > [  217.671656][    T9]  xfs_trans_metafile_iget+0xa8/0x3c0
> > > [  217.672149][    T9]  xfs_rtginode_load+0x655/0xb00
> > > [  217.672617][    T9]  xfs_rtmount_inodes+0x17f/0x4c0
> > > [  217.673094][    T9]  xfs_mountfs+0x1182/0x1fa0
> > > [  217.673525][    T9]  xfs_fs_fill_super+0x1598/0x1f70
> > > [  217.674007][    T9]  get_tree_bdev_flags+0x389/0x620
> > > [  217.674484][    T9]  vfs_get_tree+0x93/0x340
> > > [  217.674909][    T9] page last free pid 10493 tgid 10493 stack trace:
> > > [  217.675511][    T9]  free_unref_folios+0xa06/0x14e0
> > > [  217.675981][    T9]  folios_put_refs+0x4b3/0x750
> > > [  217.676430][    T9]  shmem_undo_range+0x553/0x12b0
> > > [  217.676893][    T9]  shmem_evict_inode+0x39a/0xb90
> > > [  217.677369][    T9]  evict+0x3a1/0xa90
> > > [  217.677745][    T9]  iput.part.0+0x5bb/0xf50
> > > [  217.678166][    T9]  iput+0x35/0x40
> > > [  217.678512][    T9]  dentry_unlink_inode+0x296/0x470
> > > [  217.678991][    T9]  __dentry_kill+0x1d2/0x600
> > > [  217.679428][    T9]  finish_dput+0x75/0x460
> > > [  217.679838][    T9]  dput.part.0+0x451/0x570
> > > [  217.680259][    T9]  dput+0x1f/0x30
> > > [  217.680604][    T9]  __fput+0x516/0xb50
> > > [  217.680979][    T9]  task_work_run+0x16b/0x260
> > > [  217.681219][   T27] XFS (loop1): Metadata corruption detected at
> > > xfs_dinode_verify.part.0+0x8e0/0x1870, inode 0x2443 dinode
> > > [  217.681410][    T9]  exit_to_user_mode_loop+0x115/0x510
> > > [  217.682491][   T27] XFS (loop1): Unmount and run xfs_repair
> > > [  217.682981][    T9]  do_syscall_64+0x714/0xf80
> > > [  217.683512][   T27] XFS (loop1): First 128 bytes of corrupted
> > > metadata buffer:
> > > [  217.683940][    T9]
> > > [  217.683943][    T9] Memory state around the buggy address:
> > > [  217.685359][    T9]  ff1100002b0e1080: fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb fb fb fb
> > > [  217.686100][    T9]  ff1100002b0e1100: fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb fb fb fb
> > > [  217.686825][    T9] >ff1100002b0e1180: fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb fb fb fb
> > > [  217.687552][    T9]                                         ^
> > > [  217.688091][    T9]  ff1100002b0e1200: fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb fb fb fb
> > > [  217.688822][    T9]  ff1100002b0e1280: fb fb fb fb fb fb fb fb fb
> > > fb fb fb fb fb fb fb
> > > [  217.689558][    T9]
> > > ==================================================================
> > > [  217.708247][   T27] 00000000: 49 4e 41 ed 03 01 00 00 00 00 00 00
> > > 00 00 00 00  INA.............
> > > [  217.709103][   T27] 00000010: 00 00 00 02 00 00 00 00 00 00 00 00
> > > 00 00 00 00  ................
> > > [  217.711226][    T9] Kernel panic - not syncing: KASAN: panic_on_warn set ...
> > > [  217.711923][    T9] CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not
> > > tainted 6.19.0-08320-g37a93dd5c49b #11 PREEMPT(full)
> > > [  217.712915][    T9] Hardware name: QEMU Standard PC (i440FX + PIIX,
> > > 1996), BIOS 1.15.0-1 04/01/2014
> > > [  217.713788][    T9] Workqueue: events fserror_worker
> > > [  217.714278][    T9] Call Trace:
> > > [  217.714594][    T9]  <TASK>
> > > [  217.714876][    T9]  dump_stack_lvl+0x3d/0x1b0
> > > [  217.715324][    T9]  vpanic+0x679/0x710
> > > [  217.715709][    T9]  panic+0xc2/0xd0
> > > [  217.716073][    T9]  ? __pfx_panic+0x10/0x10
> > > [  217.716502][    T9]  ? preempt_schedule_common+0x44/0xb0
> > > [  217.717019][    T9]  ? iput.part.0+0xe43/0xf50
> > > [  217.717466][    T9]  ? preempt_schedule_thunk+0x16/0x30
> > > [  217.717982][    T9]  ? check_panic_on_warn+0x1f/0xc0
> > > [  217.718468][    T9]  ? iput.part.0+0xe43/0xf50
> > > [  217.718915][    T9]  check_panic_on_warn+0xb1/0xc0
> > > [  217.719392][    T9]  ? iput.part.0+0xe43/0xf50
> > > [  217.719837][    T9]  end_report+0x107/0x160
> > > [  217.720260][    T9]  kasan_report+0xd8/0x100
> > > [  217.720696][    T9]  ? iput.part.0+0xe43/0xf50
> > > [  217.721141][    T9]  iput.part.0+0xe43/0xf50
> > > [  217.721570][    T9]  ? _raw_spin_unlock_irqrestore+0x41/0x70
> > > [  217.722135][    T9]  ? __pfx_xfs_fs_report_error+0x10/0x10
> > > [  217.722675][    T9]  iput+0x35/0x40
> > > [  217.723033][    T9]  fserror_worker+0x1da/0x320
> > > [  217.723480][    T9]  ? __pfx_fserror_worker+0x10/0x10
> > > [  217.723974][    T9]  ? _raw_spin_unlock_irq+0x23/0x50
> > > [  217.724479][    T9]  process_one_work+0x992/0x1b00
> > > [  217.724961][    T9]  ? __pfx_process_srcu+0x10/0x10
> > > [  217.725448][    T9]  ? __pfx_process_one_work+0x10/0x10
> > > [  217.725969][    T9]  ? __pfx_fserror_worker+0x10/0x10
> > > [  217.726457][    T9]  worker_thread+0x67e/0xe90
> > > [  217.726900][    T9]  ? __pfx_worker_thread+0x10/0x10
> > > [  217.727395][    T9]  kthread+0x38d/0x4a0
> > > [  217.727790][    T9]  ? __pfx_kthread+0x10/0x10
> > > [  217.728235][    T9]  ret_from_fork+0xb32/0xde0
> > > [  217.728680][    T9]  ? __pfx_ret_from_fork+0x10/0x10
> > > [  217.729165][    T9]  ? __pfx_kthread+0x10/0x10
> > > [  217.729606][    T9]  ? __switch_to+0x767/0x10d0
> > > [  217.730066][    T9]  ? __pfx_kthread+0x10/0x10
> > > [  217.730513][    T9]  ret_from_fork_asm+0x1a/0x30
> > > [  217.730981][    T9]  </TASK>
> > > [  217.731450][    T9] Kernel Offset: disabled
> > > [  217.731860][    T9] Rebooting in 86400 seconds..
> > >
> > > We used the syzbot kernel config to compile kernel and reproduce the
> > > bug (https://syzkaller.appspot.com/text?tag=KernelConfig&x=6ee9072e2455c395).
> > >
> > > If you have any other question, please let me know!
> > >
> > > Best Regards,
> > > Yue Sun
> > >


