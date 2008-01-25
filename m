Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 22:50:46 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0P6odNY031908
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 22:50:42 -0800
Message-ID: <479986F5.7070800@sgi.com>
Date: Fri, 25 Jan 2008 17:51:33 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch] Prevent AIL lock contention during transaction completion
References: <20080121052330.GG155259@sgi.com> <4796E8C8.3030702@sgi.com> <20080123073446.GU155259@sgi.com>
In-Reply-To: <20080123073446.GU155259@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner & Tim wrote:
>> And xfs_log_move_tail is called by:
>> * xfs_trans_update_ail, xfs_trans_delete_ail,
>>   (xfs_trans_unlocked_item and xlog_ungrant_log_space who call
>>    xfs_log_move_tail call it with param 1 which doesn't modify
>>    l_tail_lsn)
>> I would have thought update_ail and delete_ail would cover the
>> changes to the ail and hence what the new min item in the ail list
>> is and hence the change in the tail.
> 
> Right - the tail gets moved by (re)moving the tail object in the AIL
> 
>> In the case of an empty AIL, I guess it needs to use l_last_sync_lsn
>> which is what xlog_assign_tail_lsn gives you that xfs_log_move_tail
>> doesn't.
> 
> No, if a value of zero is passed to xfs_log_move_tail(), the lsn is
> grabbed from l_last_sync_lsn, so when we remove the last object from
> the AIL from xfs_trans_delete_ail() we set the l_tail_lsn to l_last_sync_lsn,
> same as xlog_assign_tail_lsn does.
> 
Yep, sorry missed that bit (we do the same in both).

> IOWs, xlog_assign_tail_lsn() could really be considered redundant as
> the I/O completion keeps the l_tail_lsn up to date via the AIL manipulation
> functions. I decided to split the difference and ensure that what is
> written to the iclog does not change by calling it just before the
> tail lsn is written into the header....
> 
> IOWs, I don't think calling xlog_assign_tail_lsn() in
> xlog_state_release_iclog() ever changes the l_tail_lsn because
> it is always kept up to date via the notifications in the AIL
> code.....
> 
Exactly.
When looking, I just couldn't see what calling xlog_assign_tail_lsn() is
going to do for us considering every time we change the AIL (from
metadata io completions etc) we update the l_tail_lsn immediately.
Which led me to look at what differences there could be (and found
a wrong difference ;-).
So do we really need to call xlog_assign_tail_lsn() then?
Or are we just being conservative in case we missed something?

--Tim
