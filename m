Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF8AB7F50
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 16:19:18 -0500 (CDT)
Date: Mon, 30 Sep 2013 16:19:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/4] xfs: lockdep needs to know about 3 dquot-deep nesting
Message-ID: <20130930211917.GN1935@sgi.com>
References: <1380497826-13474-1-git-send-email-david@fromorbit.com>
	<1380497826-13474-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380497826-13474-2-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Mon, Sep 30, 2013 at 09:37:03AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Michael Semon reported that xfs/299 generated this lockdep warning:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.12.0-rc2+ #2 Not tainted
> ---------------------------------------------
> touch/21072 is trying to acquire lock:
>  (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
> 
> but task is already holding lock:
>  (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&xfs_dquot_other_class);
>   lock(&xfs_dquot_other_class);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 7 locks held by touch/21072:
>  #0:  (sb_writers#10){++++.+}, at: [<c11185b6>] mnt_want_write+0x1e/0x3e
>  #1:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<c11078ee>] do_last+0x245/0xe40
>  #2:  (sb_internal#2){++++.+}, at: [<c122c9e0>] xfs_trans_alloc+0x1f/0x35
>  #3:  (&(&ip->i_lock)->mr_lock/1){+.+...}, at: [<c126cd1b>] xfs_ilock+0x100/0x1f1
>  #4:  (&(&ip->i_lock)->mr_lock){++++-.}, at: [<c126cf52>] xfs_ilock_nowait+0x105/0x22f
>  #5:  (&dqp->q_qlock){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
>  #6:  (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
> 
> The lockdep annotation for dquot lock nesting only understands
> locking for user and "other" dquots, not user, group and quota
> dquots. Fix the annotations to match the locking heirarchy we now
> have.
> 
> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good. 

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
