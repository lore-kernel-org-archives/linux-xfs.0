Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdBUJbB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 04:31:01 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4DF794E02E
        for <linux-xfs@vger.kernel.org>; Tue, 21 Feb 2017 09:31:02 +0000 (UTC)
Date: Tue, 21 Feb 2017 10:30:57 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] [WIP] Propagate error state from buffers to the objects
 attached
Message-ID: <20170221093057.6bxc6itmimyqckav@eorzea.usersys.redhat.com>
References: <20170112142209.23458-1-cmaiolino@redhat.com>
 <20170112153852.GF14085@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170112153852.GF14085@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi Brian.

First, I apologize for my late reply, I was on vacations, comments inline.


> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 2975cb2..16896d5 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -1123,6 +1123,12 @@ xfs_buf_iodone_callback_error(
> >  	/* still a transient error, higher layers will retry */
> >  	xfs_buf_ioerror(bp, 0);
> >  	xfs_buf_relse(bp);
> > +
> > +	/*
> > +	 * Notify log item that the buffer has been failed so it can be retried
> > +	 * later if needed
> > +	 */
> > +	lip->li_flags |= XFS_LI_FAILED;
> 
> Looks like the right idea to me. We might want to set this before we
> release the buffer though. Perhaps move it a few lines up and combine
> this comment with the "transient error" comment above..?
> 

I agree, will do it.

> >  	return true;
> >  
> >  	/*
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index d90e781..308aa27 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -517,8 +517,37 @@ xfs_inode_item_push(
> >  	 * the AIL.
> >  	 */
> >  	if (!xfs_iflock_nowait(ip)) {
> > -		rval = XFS_ITEM_FLUSHING;
> > -		goto out_unlock;
> > +		int error;
> > +		struct xfs_dinode *dip;
> > +
> > +		/* Buffer carrying this item has been failed, we must resubmit
> > +		 * the buffer or the item will be locked forever
> > +		 */
> 
> I'd suggest to reference the flush lock specifically, in particular how
> it's locked once and remains so until the flushed content makes it to
> disk (across I/O failures and retries if necessary).
> 
> Note that the comment above the 'if (!xfs_iflock_nowait())' above will
> probably need an update as well.
> 

Agreed

> > +		if (lip->li_flags & XFS_LI_FAILED) {
> > +			printk("#### ITEM BUFFER FAILED PREVIOUSLY, inode: %llu\n",
> > +			       ip->i_ino);
> > +			error = xfs_imap_to_bp(ip->i_mount, NULL, &ip->i_imap,
> > +					       &dip, &bp, XBF_TRYLOCK, 0);
> > +
> > +			if (error) {
> > +				rval = XFS_ITEM_FLUSHING;
> > +				goto out_unlock;
> > +			}
> > +
> > +			if (!(bp->b_flags & XBF_WRITE_FAIL)) {
> > +				rval = XFS_ITEM_FLUSHING;
> > +				xfs_buf_relse(bp);
> > +				goto out_unlock;
> > +			}
> > +
> > +			if (!xfs_buf_delwri_queue(bp, buffer_list)) {
> > +				printk("#### QUEUEING AGAIN\n");
> > +				rval = XFS_ITEM_FLUSHING;
> > +			}
> > +
> 
> We need to clear the LI_FAILED state once we've queued it for retry. 

I tried to do this to clear the flag:

		if (!xfs_buf_delwri_queue(bp, buffer_list)) {
				lip->li_flags &= ~XFS_LI_FAILED;
				printk("#### QUEUEING AGAIN\n");
				rval = XFS_ITEM_FLUSHING;
			}

There is something wrong here that I'm trying to figure out. When I clear the
flag, my reproducer ends up in a stack overflow, see below (I removed the linked
in modules from the stack to save some space). I just started to investigate
why such overflow happened, but I thought it might be worth to post giving that
I'm still learning how buffers and the log items work together, maybe you or
somebody else might have an idea.

[   70.655063] #### ITEM BUFFER FAILED PREVIOUSLY, inode: 131 
[   70.660031] BUG: stack guard page was hit at ffffc90000fe0000 (stack is
ffffc90000fdc000..ffffc90000fdffff)
[   70.661553] kernel stack overflow (page fault): 0000 [#1] SMP 
[   70.662375] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfs
fscache.....
..
..
..

[   70.673330] CPU: 0 PID: 55 Comm: kworker/0:1 Not tainted 4.9.0-rc1xfs-next+
#59
[   70.674324] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
[   70.675572] Workqueue:            (null) ()
[   70.676226] task: ffff880235ea9d40 task.stack: ffffc90000fdc000
[   70.677073] RIP: 0010:[<ffffffff813b7e8d>]  [<ffffffff813b7e8d>] xfs_iflush_done+0x19d/0x210
[   70.678293] RSP: 0000:ffffc90000fdfd30  EFLAGS: 00010202
[   70.679051] RAX: ffff880230738640 RBX: ffff880230738a00 RCX: 000000000000005a
[   70.680068] RDX: 000000000000005b RSI: 0000000000000003 RDI: ffff88022fee2dc0
[   70.681077] RBP: ffffc90000fdfd78 R08: ffff880230738640 R09: 0000000100000080
[   70.682036] R10: ffffc90000fdfd70 R11: 0000000000000000 R12: ffffc90000fdfd50
[   70.682998] R13: ffff88022fee2d80 R14: ffffc90000fdfd30 R15: ffff88022e4f1a18
[   70.684015] FS:  0000000000000000(0000) GS:ffff88023fc00000(0000) knlGS:0000000000000000
[   70.685163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   70.685988] CR2: 00000000000000b8 CR3: 0000000231de9000 CR4: 00000000003406f0
[   70.687010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   70.688024] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   70.689034] Stack:
[   70.689332]  ffff880230738a00 ffff880230738640 ffff880230738640 ffff880230738640
[   70.690463]  ffff880230738640 ffff880230738640 ffff880230738640 ffff880230738640
[   70.691542]  ffff880230738640 ffff880230738640 ffff880230738640 ffff880230738640
[   70.692570] Call Trace:
[   70.692931] Code: d8 31 d2 eb 09 48 8b 40 38 48 85 c0 74 2a 66 83 b8 92 00 00
00 00 74 ed 48 8b 88 80 00 00 00 48 39 48 $
0 75 e0 48 63 ca 83 c2 01 <49> 89 04 ce 48 8b 40 38 48 85 c0 75 d6 b9 08 00 00
00 4c 89 f6  
[   70.696678] RIP  [<ffffffff813b7e8d>] xfs_iflush_done+0x19d/0x210
[   70.697518]  RSP <ffffc90000fdfd30>
[   70.698026] ---[ end trace 87916c0b8e13041c ]---

And xfsaild hang up

  95.784135] CPU: 1 PID: 7430 Comm: xfsaild/dm-5 Tainted: G      D      L
4.9.0-rc1xfs-next+ #59
[   95.785241] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.9.3-1.fc25 04/01/2014
[   95.786297] task: ffff880234e557c0 task.stack: ffffc90001e74000
[   95.787014] RIP: 0010:[<ffffffff810d8595>]  [<ffffffff810d8595>]
queued_spin_lock_slowpath+0x25/0x1a0
[   95.788145] RSP: 0018:ffffc90001e77e00  EFLAGS: 00000202
[   95.788792] RAX: 0000000000000001 RBX: ffff880234e557c0 RCX: 0000000000000000
[   95.789668] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88022fee2dc0
[   95.790538] RBP: ffffc90001e77e00 R08: 0000001055207808 R09: 0000000000000000
[   95.791409] R10: 0000000000000232 R11: 0000000000000400 R12: ffffffff8218eba8
[   95.792281] R13: ffff8802316f5000 R14: ffff88022fee2dc0 R15: ffff88022fee2d80
[   95.793157] FS:  0000000000000000(0000) GS:ffff88023fc80000(0000)
knlGS:0000000000000000
[   95.794116] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   95.794743] CR2: 00007ffe3543fd18 CR3: 0000000001e06000 CR4: 00000000003406e0
[   95.795511] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   95.796287] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   95.797086] Stack:
[   95.797346]  ffffc90001e77e10 ffffffff8186e740 ffffc90001e77ec0
ffffffff813c0a3c
[   95.798437]  ffff880234e557c0 ffff880234e557c0 ffff880234e557c0
0000000000000001
[   95.799466]  0000000100000000 0000000100000080 0000000100000080
ffff88022fee2d90
[   95.800453] Call Trace:
[   95.800780]  [<ffffffff8186e740>] _raw_spin_lock+0x20/0x30
[   95.801519]  [<ffffffff813c0a3c>] xfsaild+0x15c/0x740
[   95.802337]  [<ffffffff813c08e0>] ? xfs_trans_ail_cursor_first+0x90/0x90
[   95.803217]  [<ffffffff813c08e0>] ? xfs_trans_ail_cursor_first+0x90/0x90
[   95.804058]  [<ffffffff810ac999>] kthread+0xd9/0xf0
[   95.804674]  [<ffffffff810ac8c0>] ? kthread_park+0x60/0x60
[   95.805356]  [<ffffffff8186ebd5>] ret_from_fork+0x25/0x30
[   95.806042] Code: 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 0f 1f 44 00 00
ba 01 00 00 00 8b 07 85 c0 75 0a f0 0f b1 1
7 85 c0 75 f2 5d c3 f3 90 <eb> ec 81 fe 00 01 00 00 0f 84 92 00 00 00 41 b8 01
01 00 00 b9

>We
> may also want to do the same for all other LI_FAILED log items attached
> to the buffer so we don't lock the buffer a bunch of times. For
> example, add a helper to walk the log items and clear the failure flag.
> (That could be a separate patch in the series though).
> 
> Those things aside this looks like it's on the right track to me. Thanks
> Carlos.
> 
> Brian

-- 
Carlos
