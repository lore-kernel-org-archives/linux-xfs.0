Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4CAF67F86
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 16:54:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 362188F807A
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 14:54:45 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id oO5ENQjwJBSpEFYY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 14:54:44 -0700 (PDT)
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <paulmck@linux.vnet.ibm.com>;
	Tue, 8 Oct 2013 15:54:44 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CE2CF19D8036
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 15:54:38 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r98Lse2R298370 for <xfs@oss.sgi.com>; Tue, 8 Oct 2013 15:54:40 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r98Lvmlj022040
	for <xfs@oss.sgi.com>; Tue, 8 Oct 2013 15:57:48 -0600
Date: Tue, 8 Oct 2013 14:54:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: xfs lockdep trace after unlink
Message-ID: <20131008215439.GA5790@linux.vnet.ibm.com>
References: <20131008212056.GA7467@redhat.com> <20131008213742.GB4446@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131008213742.GB4446@dastard>
Reply-To: paulmck@linux.vnet.ibm.com
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
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Oct 09, 2013 at 08:37:42AM +1100, Dave Chinner wrote:
> On Tue, Oct 08, 2013 at 05:20:56PM -0400, Dave Jones wrote:
> > I was deleting a kernel tree, when this happened..
> > RCU, or xfs ?
> > 
> > BUG: MAX_LOCKDEP_CHAINS too low!
> 
> Or lockdep?
> 
> > turning off the locking correctness validator.
> > Please attach the output of /proc/lock_stat to the bug report
> > CPU: 2 PID: 8109 Comm: rm Not tainted 3.12.0-rc4+ #96 
> >  ffffffff824bc2e0 ffff880026f416a8 ffffffff8172d798 41e619a2e5098827
> >  ffff880026f41768 ffffffff810cc91f 0000000000000002 000010a02977b643
> >  ffff880026f416d8 0000000000000212 ffff880026f416f8 ffffffff810c7329
> > Call Trace:
> >  [<ffffffff8172d798>] dump_stack+0x4e/0x82
> >  [<ffffffff810cc91f>] __lock_acquire+0x1b7f/0x1be0
> >  [<ffffffff810c7329>] ? get_lock_stats+0x19/0x60
> >  [<ffffffff810c7f5d>] ? lock_release_holdtime.part.29+0x9d/0x160
> >  [<ffffffff810cd133>] lock_acquire+0x93/0x200
> >  [<ffffffff81097d0a>] ? try_to_wake_up+0x22a/0x350
> >  [<ffffffff817373c0>] _raw_spin_lock+0x40/0x80
> >  [<ffffffff81097d0a>] ? try_to_wake_up+0x22a/0x350
> >  [<ffffffff81097d0a>] try_to_wake_up+0x22a/0x350
> >  [<ffffffff81097ea2>] default_wake_function+0x12/0x20
> >  [<ffffffff81084c38>] autoremove_wake_function+0x18/0x40
> >  [<ffffffff81090083>] ? __wake_up+0x23/0x50
> >  [<ffffffff8108eb78>] __wake_up_common+0x58/0x90
> >  [<ffffffff81090099>] __wake_up+0x39/0x50
> >  [<ffffffff8110dc38>] rcu_report_qs_rsp+0x48/0x70
> >  [<ffffffff8110f7d4>] rcu_report_unblock_qs_rnp+0x84/0x90
> >  [<ffffffff81117fcf>] ? rcu_read_unlock_special+0x9f/0x4e0
> >  [<ffffffff81118264>] rcu_read_unlock_special+0x334/0x4e0
> >  [<ffffffff810c720f>] ? trace_hardirqs_off_caller+0x1f/0xc0
> >  [<ffffffff8107f16c>] __rcu_read_unlock+0x8c/0x90
> >  [<ffffffffa027084e>] xfs_perag_get+0xde/0x2a0 [xfs]
> >  [<ffffffffa0270775>] ? xfs_perag_get+0x5/0x2a0 [xfs]
> >  [<ffffffffa01f72f6>] _xfs_buf_find+0xd6/0x480 [xfs]
> >  [<ffffffffa01f780a>] xfs_buf_get_map+0x2a/0x260 [xfs]
> >  [<ffffffffa01f8fcc>] xfs_buf_read_map+0x2c/0x200 [xfs]
> >  [<ffffffffa0281019>] xfs_trans_read_buf_map+0x4b9/0xa70 [xfs]
> >  [<ffffffffa0245578>] xfs_da_read_buf+0xb8/0x340 [xfs]
> >  [<ffffffff810ca84b>] ? mark_held_locks+0xbb/0x140
> >  [<ffffffffa024a3b9>] xfs_dir3_block_read+0x39/0x80 [xfs]
> >  [<ffffffffa024a440>] xfs_dir2_block_lookup_int+0x40/0x260 [xfs]
> >  [<ffffffffa024b49d>] xfs_dir2_block_removename+0x3d/0x390 [xfs]
> >  [<ffffffffa022d0da>] ? xfs_bmap_last_offset+0x4a/0xa0 [xfs]
> >  [<ffffffffa024991c>] xfs_dir_removename+0x11c/0x180 [xfs]
> >  [<ffffffffa0262085>] xfs_remove+0x2e5/0x510 [xfs]
> >  [<ffffffffa020ab8b>] xfs_vn_unlink+0x4b/0x90 [xfs]
> >  [<ffffffff811d4fd0>] vfs_unlink+0x90/0x100
> >  [<ffffffff811d51bf>] do_unlinkat+0x17f/0x240
> >  [<ffffffff81010b45>] ? syscall_trace_enter+0x145/0x2a0
> >  [<ffffffff811d830b>] SyS_unlinkat+0x1b/0x40
> >  [<ffffffff817408e4>] tracesys+0xdd/0xe2
> 
> It's hard to see what in XFS is causing this. You're reading a
> single block directory, which means we're holding two inode locks
> here, and then we've done a lookup on a radix tree under
> rcu_read_lock(). Hence I can't see how we've overrun the lockdep
> chain depth in the XFS code path. FWIW, it's thrown this warning
> when calling rcu_read_unlock() here:
> 
> struct xfs_perag *
> xfs_perag_get(
>         struct xfs_mount        *mp,
>         xfs_agnumber_t          agno)
> {
>         struct xfs_perag        *pag;
>         int                     ref = 0;
> 
>         rcu_read_lock();
>         pag = radix_tree_lookup(&mp->m_perag_tree, agno);
>         if (pag) {
>                 ASSERT(atomic_read(&pag->pag_ref) >= 0);
>                 ref = atomic_inc_return(&pag->pag_ref);
>         }
> >>>>>>  rcu_read_unlock();

Would xfs be holding one of the scheduler's rq or pi locks at this
point?  That could result in deadlock.

But I doubt that this is the problem, unless radix_tree_lookup() grabs
one and returns with it held.  Otherwise, you have interrupts disabled
throughout the RCU read-side critical section, and thus are guaranteed
to take the lockless fastpath through rcu_read_unlock().  (As opposed
to merely having extremely high probability of taking that fastpath.)

							Thanx, Paul

>         trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
>         return pag;
> }
> 
> So I'd be looking at RCU or lockdep at this point....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
