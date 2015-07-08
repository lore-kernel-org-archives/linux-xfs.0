Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 63CB57F4E
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 19:09:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F34BAAC004
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2015 17:09:13 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tKIlJU8C50nN2hYV for <xfs@oss.sgi.com>;
	Tue, 07 Jul 2015 17:09:11 -0700 (PDT)
Date: Wed, 8 Jul 2015 10:09:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: close xc_cil list_empty() races with cil commit
	sequence
Message-ID: <20150708000909.GA7943@dastard>
References: <1435154641-7790-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1435154641-7790-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 24, 2015 at 10:04:01AM -0400, Brian Foster wrote:
> We have seen somewhat rare reports of the following assert from
> xlog_cil_push_background() failing during ltp tests or somewhat
> innocuous desktop root fs workloads (e.g., virt operations, initramfs
> construction):
> 
> 	ASSERT(!list_empty(&cil->xc_cil));
> 
> The reasoning behind the assert is that the transaction has inserted
> items to the CIL and hit background push codepath all with
> cil->xc_ctx_lock held for reading. This locks out background commit from
> emptying the CIL, which acquires the lock for writing. Therefore, the
> reasoning is that the items previously inserted in the CIL should still
> be present.
> 
> The cil->xc_ctx_lock read lock is not sufficient to protect the xc_cil
> list, however, due to how CIL insertion is handled.
> xlog_cil_insert_items() inserts and reorders the dirty transaction items
> to the tail of the CIL under xc_cil_lock. It uses list_move_tail() to
> achieve insertion and reordering in the same block of code. This
> function removes and reinserts an item to the tail of the list. If a
> transaction commits an item that was already logged and thus already
> resides in the CIL, and said item is the sole item on the list, the
> removal and reinsertion creates a temporary state where the list is
> actually empty.

The only way I can see this occurring is that we have to be committing a transaction that
modifies the same object as the previous transaction commit that
is still running through xfs_log_commit_cil(). e.g. racing
timestamp modifications on an inode, and the CIL is empty:

thread A			thread B

lock(inode)			lock(inode)
xfs_trans_join(inode)		<schedule>
xfs_trans_log(inode)
xfs_trans_commit(tp)
  xfs_log_commit_cil()
    lock(xc_ctx_lock)
    <add inode to cil>
    xfs_trans_free_items()
      unlock(inode)
      <schedule>
				<runs with inode lock>
				xfs_trans_join(inode)
				xfs_trans_log(inode)
				xfs_trans_commit(tp)
				  xfs_log_commit_cil()
				    lock(xc_ctx_lock)
				    xlog_cil_insert_items()
				      xlog_cil_insert_format_items()
      <runs again>
      xlog_cil_push_background
	ASSERT(!list_empty(cil))      list_move_tail(item, cil)


If that is the race, then the fix appears simple to me: call
xlog_cil_push_background() before xfs_trans_free_items() so that we
push the CIL before we unlock the items we just added to the CIL.
i.e.:

thread A			thread B

lock(inode)			lock(inode)
xfs_trans_join(inode)		<schedule>
xfs_trans_log(inode)
xfs_trans_commit(tp)
  xfs_log_commit_cil()
    lock(xc_ctx_lock)
    <add inode to cil>
    log_cil_push_background
	ASSERT(!list_empty(cil))
    xfs_trans_free_items()
      unlock(inode)
      <schedule>
				<runs with inode lock>
				xfs_trans_join(inode)
				xfs_trans_log(inode)
				xfs_trans_commit(tp)
				  xfs_log_commit_cil()
				    lock(xc_ctx_lock)
				    xlog_cil_insert_items()
				      xlog_cil_insert_format_items()
				      list_move_tail(item, cil)
> This state is not valid and thus should never be observed by concurrent
> transaction commit-side checks in the circumstances outlined above.
> Update all of the xc_cil checks to acquire xc_cil_lock before assessing
> the state of xc_cil.

That will reintroduce the problem of lock contention between the
commit and the push sides of the CIL, which the cil/push lock
separation was added to solve:

commit 4bb928cdb900d0614f4766d5f1ca5bc3844f7656
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:08 2013 +1000

    xfs: split the CIL lock
    
    The xc_cil_lock is used for two purposes - to protect the CIL
    itself, and to protect the push/commit state and lists. These are
    two logically separate structures and operations, so can have their
    own locks. This means that pushing on the CIL and the commit wait
    ordering won't contend for a lock with other transactions that are
    completing concurrently. As the CIL insertion is the hottest path
    throught eh CIL, this is a big win.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
