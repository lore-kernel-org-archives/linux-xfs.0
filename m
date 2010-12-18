Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBI23Djp013939 for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 20:03:13 -0600
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FE6A14653BB
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 18:05:06 -0800 (PST)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id 4wx52XqxBGMf47Sf
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 18:05:06 -0800 (PST)
Received: by wyf22 with SMTP id 22so1291421wyf.26
	for <xfs@oss.sgi.com>; Fri, 17 Dec 2010 18:05:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101217235408.GF5193@dastard>
References: <AANLkTi=0E2eh=wnX+Kr=egLoigkMDq5UuaGyOxnk+T1Q@mail.gmail.com>
	<20101217235408.GF5193@dastard>
Date: Sat, 18 Dec 2010 13:05:05 +1100
Message-ID: <AANLkTi=xVrev9WCw+=47AvAc4so6S8HAa3qPdqBtuvdH@mail.gmail.com>
Subject: Re: Another questionable lock order bug
From: Nick Piggin <npiggin@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sat, Dec 18, 2010 at 10:54 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Dec 18, 2010 at 04:40:23AM +1100, Nick Piggin wrote:
>> With the iprune_sem and iolock lock order warnings taken care of,
>> lockdep soon after chokes on i_lock
>
> What kernel are you running? It does not appear to be vanilla XFS,
> as:

It's just vanilla plus your patch to fix iolock and Christoph's iprune patc=
h to
fix that one -- lockdep doesn't get very far without them.


>> [ =A0716.364005] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usa=
ge.
>> [ =A0716.364005] cp/8370 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> [ =A0716.364005] =A0(&(&ip->i_lock)->mr_lock){++++-?}, at:
>> [<ffffffffa005537c>] xfs_ilock+0x8c/0x150 [xfs]
>> [ =A0716.364005] {RECLAIM_FS-ON-R} state was registered at:
>> [ =A0716.364005] =A0 [<ffffffff8108392b>] mark_held_locks+0x6b/0xa0
>> [ =A0716.364005] =A0 [<ffffffff810839f1>] lockdep_trace_alloc+0x91/0xd0
>> [ =A0716.364005] =A0 [<ffffffff811104fa>] __kmalloc+0x5a/0x220
>> [ =A0716.364005] =A0 [<ffffffffa0078717>] kmem_alloc+0x87/0xd0 [xfs]
>> [ =A0716.364005] =A0 [<ffffffffa002b8fb>] xfs_attr_shortform_list+0xfb/0=
x480 [xfs]
>> [ =A0716.364005] =A0 [<ffffffffa0027ab8>] xfs_attr_list_int+0xd8/0xe0 [x=
fs]
>> [ =A0716.364005] =A0 [<ffffffffa0088b5f>] xfs_vn_listxattr+0x7f/0x160 [x=
fs]
>> [ =A0716.364005] =A0 [<ffffffff811396ef>] vfs_listxattr+0x1f/0x30
>> [ =A0716.364005] =A0 [<ffffffff81139b1f>] listxattr+0x3f/0xf0
>> [ =A0716.364005] =A0 [<ffffffff81139c14>] sys_flistxattr+0x44/0x70
>> [ =A0716.364005] =A0 [<ffffffff810030bb>] system_call_fastpath+0x16/0x1b[
>> 716.364005] irq event stamp: 322521151
>> [ =A0716.364005] hardirqs last =A0enabled at (322521151):
>> [<ffffffff81601cbd>] mutex_trylock+0x11d/0x190
>> [ =A0716.364005] hardirqs last disabled at (322521150):
>> [<ffffffff81601bde>] mutex_trylock+0x3e/0x190
>> [ =A0716.364005] softirqs last =A0enabled at (322518910):
>> [<ffffffff81050d0e>] __do_softirq+0x16e/0x360
>> [ =A0716.364005] softirqs last disabled at (322518881):
>> [<ffffffff81003f8c>] call_softirq+0x1c/0x50
>> [ =A0716.364005]
>> [ =A0716.364005] other info that might help us debug this:
>> [ =A0716.364005] 3 locks held by cp/8370:
>> [ =A0716.364005] =A0#0: =A0(xfs_iolock_active){++++++}, at:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^^^
>
> This patch is not yet mainline. If you really want to do significant
> XFS scalability testing for .38, you should probably pull these branches
> in for testing:
>
> git://git.kernel.org/pub/scm/linux/dgc/xfsdev.git inode-scale
> git://git.kernel.org/pub/scm/linux/dgc/xfsdev.git xfs-for-2.6.38

OK I'll keep it in mind, however in this case I was stress testing
some other patches
which required that lockdep stay up.

>
>> [<ffffffffa0055395>] xfs_ilock+0xa5/0x150 [xfs]
>> [ =A0716.364005] =A0#1: =A0(shrinker_rwsem){++++..}, at:
>> [<ffffffff810d91c8>] shrink_slab+0x38/0x190
>> [ =A0716.364005] =A0#2: =A0(&pag->pag_ici_reclaim_lock){+.+...}, at:
>> [<ffffffffa00875c4>] xfs_reclaim_inodes_ag+
>> 0xa4/0x360 [xfs]
>> [ =A0716.364005]
>> [ =A0716.364005] stack backtrace:
>> [ =A0716.364005] Pid: 8370, comm: cp Not tainted 2.6.37-rc6+ #116
>> [ =A0716.364005] Call Trace:
>> [ =A0716.364005] =A0[<ffffffff81082a10>] print_usage_bug+0x170/0x180
>> [ =A0716.364005] =A0[<ffffffff810836d1>] mark_lock+0x211/0x400
>> [ =A0716.364005] =A0[<ffffffff810842ce>] __lock_acquire+0x40e/0x1490
>> [ =A0716.364005] =A0[<ffffffff810853e5>] lock_acquire+0x95/0x1b0
>> [ =A0716.364005] =A0[<ffffffffa005537c>] ? xfs_ilock+0x8c/0x150 [xfs]
>> [ =A0716.364005] =A0[<ffffffff8127c35c>] ? rcu_read_lock_held+0x2c/0x30
>> [ =A0716.364005] =A0[<ffffffff81073d5a>] down_write_nested+0x4a/0x70
>> [ =A0716.364005] =A0[<ffffffffa005537c>] ? xfs_ilock+0x8c/0x150 [xfs]
>> [ =A0716.364005] =A0[<ffffffffa005537c>] xfs_ilock+0x8c/0x150 [xfs]
>> [ =A0716.364005] =A0[<ffffffffa00872e6>] xfs_reclaim_inode+0x36/0x270 [x=
fs]
>> [ =A0716.364005] =A0[<ffffffffa008772f>] xfs_reclaim_inodes_ag+0x20f/0x3=
60 [xfs]
>> [ =A0716.364005] =A0[<ffffffffa00878f8>] xfs_reclaim_inode_shrink+0x78/0=
x80 [xfs]
>> [ =A0716.364005] =A0[<ffffffff810d92b7>] shrink_slab+0x127/0x190
>> [ =A0716.364005] =A0[<ffffffff810dc189>] zone_reclaim+0x349/0x420
>>
>> I assume this should be a false positive too, for the same reason,
>> and could be handled the same way as iolock.
>
> The ilock is very different to the iolock in terms of usage - the
> ilock is required in the writeback path (for block mapping,
> allocation and file size updates) while the iolock is not.
>
> Hence this is indicative of a potential deadlock and we shouldn't
> be doing memory allocation with the ilock outside a transaction.
> Allocations inside transactions are transformed to GFP_NOFS so are
> safe against such lock recursion, but outside transactions we need
> to use KM_NOFS directly. I'll send out a patch on Monday after I've
> looked at the code in more detail..

OK, good to know it uncovered a real problem.

Thanks,
Nick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
