Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0F9A57FAD
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 07:18:05 -0600 (CST)
Message-ID: <527B92FF.8060604@sgi.com>
Date: Thu, 07 Nov 2013 07:17:51 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: fix unlock in xfs_bmap_add_attrfork
References: <20131106211618.754470168@sgi.com> <20131106224145.GH6188@dastard>
In-Reply-To: <20131106224145.GH6188@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/06/13 16:41, Dave Chinner wrote:
> On Wed, Nov 06, 2013 at 03:14:58PM -0600, Mark Tinguely wrote:
>> xfs_trans_ijoin() activates the inode in a transaction and
>> also can specify which lock to free when the transaction is
>> committed or canceled.
>>
>> xfs_bmap_add_attrfork call locks and add the lock to the
>> transaction but also manually removes the lock. Change the
>> routine to not add the lock to the transaction and manually
>> remove lock on completion.
>>
>> While here, clean up the xfs_trans_cancel flags and goto names.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>
> All good, except for:
>

...

>
> This hunk. It ends up looking like this:
>
> 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> 	goto unlock_return;
> bmap_cancel:
> 	xfs_bmap_cancel(&flist);
> trans_cancel:
> 	xfs_trans_cancel(tp, cancel_flags);
> unlock_return:
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	return error;
> }
>
> Which jumps over error handling cases on a successful completion.
> The conventional way of doing this is having the successful return
> case run straight through to the return, and having the error stack
> either jump back into it like so:
>
> 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> unlock_return:
> 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 	return error;
>
> bmap_cancel:
> 	xfs_bmap_cancel(&flist);
> trans_cancel:
> 	xfs_trans_cancel(tp, cancel_flags);
> 	goto unlock_return;
> }
>
> or do an additional unlock and return directly in the error stack
> and let the compiler optimise it appropriately.
>
> Cheers,
>
> Dave.

Thanks for catching that.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
