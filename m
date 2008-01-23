Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 23:34:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0N7YUNJ020844
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 23:34:32 -0800
Date: Wed, 23 Jan 2008 18:34:46 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Prevent AIL lock contention during transaction completion
Message-ID: <20080123073446.GU155259@sgi.com>
References: <20080121052330.GG155259@sgi.com> <4796E8C8.3030702@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4796E8C8.3030702@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jan 23, 2008 at 06:12:08PM +1100, Timothy Shimmin wrote:
> Hi Dave,
> 
> So all cosmetic except for moving of xlog_assign_tail_lsn().
> 
> Looking at the code the l_tail_lsn is used by more than just
> when we are writing out the iclog.
> Certainly, that is where we set the h_tail_lsn in the iclog
> header, so we can find the tail later on during mount/recovery.

Right, but the critical usage here is to update it before it
gets written into the iclog.

> However, we also use l_tail_lsn when trying to work out
> how much space is left in the log
> i.e.
> - xlog_space_left(), xlog_grant_push_tail(),
>   xlog_grant_log_space(), xlog_regrant_write_log_space()
> 
> I guess this could mean that we may fail to update the l_tail_lsn
> now if we don't sync the iclog (not in want-sync state etc..)
> and so there could be more space
> in the log than we realise until a bit later.
> Maybe not a big deal.
> Not sure if this really happens though or not.

All correct.

> 
> Looking who assigns to l_tail_lsn (apart from initialisation
> and recovery) we have xlog_assign_tail_lsn and xfs_log_move_tail.
> And (apart from recovery) xlog_assign_tail_lsn is called by our
> xlog_state_release_iclog.
> So I presume the other place where we update the l_tail_lsn in
> general is in calls to xfs_log_move_tail.

Correct.

> And xfs_log_move_tail is called by:
> * xfs_trans_update_ail, xfs_trans_delete_ail,
>   (xfs_trans_unlocked_item and xlog_ungrant_log_space who call
>    xfs_log_move_tail call it with param 1 which doesn't modify
>    l_tail_lsn)
> I would have thought update_ail and delete_ail would cover the
> changes to the ail and hence what the new min item in the ail list
> is and hence the change in the tail.

Right - the tail gets moved by (re)moving the tail object in the AIL

> In the case of an empty AIL, I guess it needs to use l_last_sync_lsn
> which is what xlog_assign_tail_lsn gives you that xfs_log_move_tail
> doesn't.

No, if a value of zero is passed to xfs_log_move_tail(), the lsn is
grabbed from l_last_sync_lsn, so when we remove the last object from
the AIL from xfs_trans_delete_ail() we set the l_tail_lsn to l_last_sync_lsn,
same as xlog_assign_tail_lsn does.

IOWs, xlog_assign_tail_lsn() could really be considered redundant as
the I/O completion keeps the l_tail_lsn up to date via the AIL manipulation
functions. I decided to split the difference and ensure that what is
written to the iclog does not change by calling it just before the
tail lsn is written into the header....

IOWs, I don't think calling xlog_assign_tail_lsn() in
xlog_state_release_iclog() ever changes the l_tail_lsn because
it is always kept up to date via the notifications in the AIL
code.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
