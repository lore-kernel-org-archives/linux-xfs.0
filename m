Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Aug 2006 00:59:29 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7M7wrDW019663
	for <xfs@oss.sgi.com>; Tue, 22 Aug 2006 00:58:58 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.7/8.13.4) with ESMTP id k7M7w0JH014398
	for <xfs@oss.sgi.com>; Tue, 22 Aug 2006 16:58:08 +0900 (JST)
Subject: Re: [PATCH] xfs: i_state of inode is changed after the inode is freed
In-reply-to: <20060814025901.GE51703024@melbourne.sgi.com>
Message-Id: <20060822164847m-saito@mail.aom.tnes.nec.co.jp>
References: <20060814025901.GE51703024@melbourne.sgi.com>
Mime-Version: 1.0
From: Masayuki Saito <m-saito@tnes.nec.co.jp>
Date: Tue, 22 Aug 2006 16:48:47 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nathan Scott <nathans@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Hi Nathan, David,

I had the vacation too.

David Chinner <dgc@sgi.com> wrote:
>Hmmm - Idon't think we should iput() before we wake up any pinned waiters.
>When we have a waiter on i_ipin_wait (called from xfs_iflush()), we have
>a thread sleeping with the inode locked.
>
>If we then call iput() and it drops the last reference, we can call back
>into the filesystem and start transactions. Those transactions will need
>to lock the inode. Hence I think the above can deadlock when racing against
>an inode flush. 
>
>The code should probably read:
>
>	if (dropped last pincount) {
>		int need_iput = 0;
>		struct inode *inode;
>
>		spin_lock(i_flags_lock)
>		if (!reclaimable) {
>			if (!vp) {
>				if (!(i_state & (NEW|CLEAR))) {
>					inode = igrab(inode)
>					if (inode) {
>						need_iput = 1	
>						mark_inode_dirty_sync(inode)
>					}
>				}
>			}
>		}
>		spin_unlock(i_flags_lock)
>		wake_up(&ip->i_ipin_wait)
>		if (need_iput)
>			iput(inode);
>	}
>
>to avoid this possible deadlock.

OK, I see your point.  There is wait_event(in xfs_iunpin_wait) that should
be wake_up'ed(in xfs_iunpin), so deadlock can occur.

I'll update my patch and test it.  Please wait for a few moments.
