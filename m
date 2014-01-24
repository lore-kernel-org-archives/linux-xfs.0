Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E35827FB2
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 20:51:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8FBE5304051
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 18:51:07 -0800 (PST)
Received: from mail-ob0-f180.google.com (mail-ob0-f180.google.com
	[209.85.214.180]) by cuda.sgi.com with ESMTP id
	9BMQdBx6gpUt0Qo6 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 18:51:06 -0800 (PST)
Received: by mail-ob0-f180.google.com with SMTP id wp4so3036470obc.11
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 18:51:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140124022903.GK27606@dastard>
References: <20140124015855.GM16455@hansolo.jdub.homelinux.org>
	<20140124022903.GK27606@dastard>
Date: Thu, 23 Jan 2014 21:51:05 -0500
Message-ID: <CA+5PVA4i0xp7jqcR=yMG3BjucXfkbM+yXP7YoDHWZgbLtdej-Q@mail.gmail.com>
Subject: Re: XFS lockdep spew with v3.13-4156-g90804ed
From: Josh Boyer <jwboyer@fedoraproject.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Ben Myers <bpm@sgi.com>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Jan 23, 2014 at 9:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jan 23, 2014 at 08:58:56PM -0500, Josh Boyer wrote:
>> Hi All,
>>
>> I'm hitting an XFS lockdep error with Linus' tree today after the XFS
>> merge.  I wasn't hitting this with v3.13-3995-g0dc3fd0, which seems
>> to backup the "before XFS merge" claim.  Full text below:
>
> Ugh. mmap_sem/inode lock order stupidity.
>
> Looks like a false positive. Basically, it's complaining that a page
> fault can occur in getdents() syscall on a user buffer while the
> directory IO lock is held, and then complaining that a this is the
> opposite lock order for a
>>
>>
>> [  132.638044] ======================================================
>> [  132.638045] [ INFO: possible circular locking dependency detected ]
>> [  132.638047] 3.14.0-0.rc0.git7.1.fc21.x86_64 #1 Not tainted
>> [  132.638048] -------------------------------------------------------
>> [  132.638049] gnome-session/1432 is trying to acquire lock:
>> [  132.638050]  (&mm->mmap_sem){++++++}, at: [<ffffffff811b846f>] might_fault+0x
>> 5f/0xb0
>> [  132.638055]
>> but task is already holding lock:
>> [  132.638056]  (&(&ip->i_lock)->mr_lock){++++..}, at: [<ffffffffa05b3c12>] xfs_
>> ilock+0xf2/0x1c0 [xfs]
>> [  132.638076]
>> which lock already depends on the new lock.
>>
>> [  132.638077]
>> the existing dependency chain (in reverse order) is:
>> [  132.638078]
>> -> #1 (&(&ip->i_lock)->mr_lock){++++..}:
>> [  132.638080]        [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
>> [  132.638083]        [<ffffffff8178312e>] _raw_spin_lock+0x3e/0x80
>> [  132.638085]        [<ffffffff8123c579>] __mark_inode_dirty+0x119/0x440
>> [  132.638088]        [<ffffffff812447fc>] __set_page_dirty+0x6c/0xc0
>> [  132.638090]        [<ffffffff812477e1>] mark_buffer_dirty+0x61/0x180
>> [  132.638092]        [<ffffffff81247a31>] __block_commit_write.isra.21+0x81/0xb0
>> [  132.638094]        [<ffffffff81247be6>] block_write_end+0x36/0x70
>> [  132.638096]        [<ffffffff81247c48>] generic_write_end+0x28/0x90
>> [  132.638097]        [<ffffffffa0554cab>] xfs_vm_write_end+0x2b/0x70 [xfs]
>> [  132.638104]        [<ffffffff8118c4f6>] generic_file_buffered_write+0x156/0x260
>> [  132.638107]        [<ffffffffa05651d7>] xfs_file_buffered_aio_write+0x107/0x250 [xfs]
>> [  132.638115]        [<ffffffffa05653eb>] xfs_file_aio_write+0xcb/0x130 [xfs]
>> [  132.638122]        [<ffffffff8120af8a>] do_sync_write+0x5a/0x90
>> [  132.638125]        [<ffffffff8120b74d>] vfs_write+0xbd/0x1f0
>> [  132.638126]        [<ffffffff8120c15c>] SyS_write+0x4c/0xa0
>> [  132.638128]        [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b
>
> Sorry, what? That trace is taking the ip->i_vnode->i_lock
> *spinlock*, not the ip->i_lock *rwsem*. And it's most definitely not
> currently holding the ip->i_lock rwsem here. I think lockdep has
> dumped the wrong stack trace here, because it most certainly doesn't
> match the unsafe locking scenario that has been detected.

I rebooted again with the same kernel and lockdep spit out a different
stacktrace for this part.  See below.  The rest looks mostly the same,
and it spews when I log into gnome, so at least it's recreatable.

> You can't mmap directories, and so the page fault lock order being
> shown for CPU1 can't happen on a directory. False positive.
>
> *sigh*
>
> More complexity in setting up inode lock order instances is required
> so that lockdep doesn't confuse the lock ordering semantics of
> directories with regular files. As if that code to make lockdep
> happy wasn't complex enough already....

So the summary is basically: false positive with additional annotations needed?

josh

Full output of the lockdep report after I rebooted (sorry if the
formatting is off, I'm on a different machine and doing this remotely
until tomorrow.)

[  104.565930] ======================================================
[  104.565931] [ INFO: possible circular locking dependency detected ]
[  104.565933] 3.14.0-0.rc0.git7.1.fc21.x86_64 #1 Not tainted
[  104.565934] -------------------------------------------------------
[  104.565935] gnome-session/1450 is trying to acquire lock:
[  104.565936]  (&mm->mmap_sem){++++++}, at: [<ffffffff811b846f>]
might_fault+0x5f/0xb0
[  104.565942]
but task is already holding lock:
[  104.565943]  (&(&ip->i_lock)->mr_lock){++++..}, at:
[<ffffffffa05f4c12>] xfs_ilock+0xf2/0x1c0 [xfs]
[  104.565963]
which lock already depends on the new lock.

[  104.565964]
the existing dependency chain (in reverse order) is:
[  104.565965]
-> #1 (&(&ip->i_lock)->mr_lock){++++..}:
[  104.565967]        [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
[  104.565970]        [<ffffffff810d7d27>] down_read_nested+0x57/0xa0
[  104.565972]        [<ffffffffa05f4c12>] xfs_ilock+0xf2/0x1c0 [xfs]
[  104.565983]        [<ffffffffa05f4cff>]
xfs_ilock_data_map_shared+0x1f/0x40 [xfs]
[  104.565995]        [<ffffffffa0597367>] __xfs_get_blocks+0x87/0x730 [xfs]
[  104.566002]        [<ffffffffa0597a21>] xfs_get_blocks+0x11/0x20 [xfs]
[  104.566008]        [<ffffffff812531e7>] do_mpage_readpage+0x447/0x670
[  104.566011]        [<ffffffff812534eb>] mpage_readpages+0xdb/0x130
[  104.566012]        [<ffffffffa0595ddd>] xfs_vm_readpages+0x1d/0x20 [xfs]
[  104.566019]        [<ffffffff8119b222>] __do_page_cache_readahead+0x2c2/0x360
[  104.566022]        [<ffffffff8119b9b1>] ra_submit+0x21/0x30
[  104.566023]        [<ffffffff8118ed7d>] filemap_fault+0x37d/0x420
[  104.566026]        [<ffffffff811b8a9f>] __do_fault+0x6f/0x520
[  104.566027]        [<ffffffff811bcd91>] handle_mm_fault+0x3b1/0xe60
[  104.566029]        [<ffffffff81787e94>] __do_page_fault+0x174/0x5e0
[  104.566031]        [<ffffffff8178830e>] do_page_fault+0xe/0x10
[  104.566032]        [<ffffffff81784538>] page_fault+0x28/0x30
[  104.566034]
-> #0 (&mm->mmap_sem){++++++}:
[  104.566036]        [<ffffffff810de0fc>] __lock_acquire+0x18ec/0x1aa0
[  104.566038]        [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
[  104.566040]        [<ffffffff811b849c>] might_fault+0x8c/0xb0
[  104.566041]        [<ffffffff81220a91>] filldir+0x91/0x120
[  104.566043]        [<ffffffffa05a1f7f>]
xfs_dir2_sf_getdents+0x23f/0x2a0 [xfs]
[  104.566051]        [<ffffffffa05a23fb>] xfs_readdir+0x16b/0x1d0 [xfs]
[  104.566059]        [<ffffffffa05a483b>] xfs_file_readdir+0x2b/0x40 [xfs]
[  104.566066]        [<ffffffff812208d8>] iterate_dir+0xa8/0xe0
[  104.566068]        [<ffffffff81220d83>] SyS_getdents+0x93/0x120
[  104.566070]        [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b
[  104.566072]
other info that might help us debug this:

[  104.566073]  Possible unsafe locking scenario:

[  104.566074]        CPU0                    CPU1
[  104.566075]        ----                    ----
[  104.566075]   lock(&(&ip->i_lock)->mr_lock);
[  104.566077]                                lock(&mm->mmap_sem);
[  104.566078]                                lock(&(&ip->i_lock)->mr_lock);
[  104.566079]   lock(&mm->mmap_sem);
[  104.566081]
 *** DEADLOCK ***

[  104.566082] 2 locks held by gnome-session/1450:
[  104.566083]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
[<ffffffff81220892>] iterate_dir+0x62/0xe0
[  104.566087]  #1:  (&(&ip->i_lock)->mr_lock){++++..}, at:
[<ffffffffa05f4c12>] xfs_ilock+0xf2/0x1c0 [xfs]
[  104.566099]
stack backtrace:
[  104.566101] CPU: 4 PID: 1450 Comm: gnome-session Not tainted
3.14.0-0.rc0.git7.1.fc21.x86_64 #1
[  104.566102] Hardware name: Dell Inc. XPS 8300  /0Y2MRG, BIOS A06 10/17/2011
[  104.566103]  ffffffff825ba040 ffff8800b8dedc60 ffffffff8177a8c9
ffffffff825ba040
[  104.566106]  ffff8800b8dedca0 ffffffff8177616c ffff8800b8dedcf0
ffff8802fb842648
[  104.566108]  ffff8802fb841ab0 0000000000000002 0000000000000002
ffff8802fb842648
[  104.566110] Call Trace:
[  104.566113]  [<ffffffff8177a8c9>] dump_stack+0x4d/0x66
[  104.566115]  [<ffffffff8177616c>] print_circular_bug+0x201/0x20f
[  104.566117]  [<ffffffff810de0fc>] __lock_acquire+0x18ec/0x1aa0
[  104.566119]  [<ffffffff810deaa2>] lock_acquire+0xa2/0x1d0
[  104.566121]  [<ffffffff811b846f>] ? might_fault+0x5f/0xb0
[  104.566123]  [<ffffffff811b849c>] might_fault+0x8c/0xb0
[  104.566124]  [<ffffffff811b846f>] ? might_fault+0x5f/0xb0
[  104.566126]  [<ffffffff81220a91>] filldir+0x91/0x120
[  104.566134]  [<ffffffffa05a1f7f>] xfs_dir2_sf_getdents+0x23f/0x2a0 [xfs]
[  104.566145]  [<ffffffffa05f4c12>] ? xfs_ilock+0xf2/0x1c0 [xfs]
[  104.566153]  [<ffffffffa05a23fb>] xfs_readdir+0x16b/0x1d0 [xfs]
[  104.566161]  [<ffffffffa05a483b>] xfs_file_readdir+0x2b/0x40 [xfs]
[  104.566163]  [<ffffffff812208d8>] iterate_dir+0xa8/0xe0
[  104.566166]  [<ffffffff8122ca7c>] ? fget_light+0x3c/0x4f0
[  104.566168]  [<ffffffff81220d83>] SyS_getdents+0x93/0x120
[  104.566170]  [<ffffffff81220a00>] ? fillonedir+0xf0/0xf0
[  104.566172]  [<ffffffff81134ecc>] ? __audit_syscall_entry+0x9c/0xf0
[  104.566174]  [<ffffffff8178db69>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
