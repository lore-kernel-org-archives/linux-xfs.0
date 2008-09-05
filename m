Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 23:14:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m856DrSJ029332
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 23:13:55 -0700
Message-ID: <48C0D04E.1010708@sgi.com>
Date: Fri, 05 Sep 2008 16:23:10 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Filesystem corruption writing out unlinked inodes
References: <48BCC5B1.7080300@sgi.com> <20080902051524.GC15962@disturbed> <48BCD622.1080406@sgi.com> <20080902062155.GE15962@disturbed> <48BF33EC.7080406@sgi.com> <20080904090835.GE15950@disturbed>
In-Reply-To: <20080904090835.GE15950@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Thu, Sep 04, 2008 at 11:03:40AM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Tue, Sep 02, 2008 at 03:58:58PM +1000, Lachlan McIlroy wrote:
>>>> I'm just not sure about the assumption
>>>> that if the flush lock cannot be acquired in xfs_ifree_cluster() then
>>>> the inode must be in the process of being flushed. The flush could
>>>> be aborted due to the inode being pinned or some other case and the
>>>> inode never gets marked as stale.
>>> Did that happen?
>>>
>>> Basically I'm asking what the sequence of events is that leads up
>>> to this problem - we need to identify the actual race condition
>>> before speculating on potential fixes....
>>>
>> In the trace below pid 7731 is unlinking an inode and it's not the last
>> inode so it doesn't go through xfs_ifree_cluster() and mark the other
>> inodes as stale.  At the same time pid 12269 unlinks the final inode in
>> the cluster and calls xfs_ifree_cluster() but fails to lock the inode
>> held by pid 7731 so it skips it.  Pid 12269 deallocates the inode cluster
>> and the disk space is reallocated as user data (the data "temp28/file00006"
>> is what the test writes into it's files).  Meanwhile pid 7731 finally
>> continues and tries to flush the inode.
> 
> Ah - how are we unlinking two inodes in the one AG at the same time?
> That's supposed to be serialised by the AGI buffer lock....
> 
> Ah - I see - we hold the inode across the transaction commit in
> xfs_inactive(). That means that the AGI is unlocked well before the
> inode is unlocked, which allows the racing inode inactivate to lock
> the AGI and call xfs_icluster_free() before the inode is unlocked
> after the transaction commit.
> 
> Ok, now we understand the race condition....
> 
>> Looks like xfs_ifree_cluster() should do a blocking wait on the ilock and
>> maybe move the setting of XFS_ISTALE outside the flock.
> 
> No, we can't do a blocking wait on the ilock - we already hold the
> ilock on other inodes and so we could deadlock by doing that.
> 
> Hmmmm - I wonder what the reason for the holding of the inode lock
> over the transaction commit is.... Perhaps it is to make the
> detatching of the dquots atomic with the inactivation (seems like
> a valid reason to me).
> 
> Perhap we should also hold the AGI buffer across the transaction
> commit as well and only release that after the inode is
> unlocked so the cluster free does not make progress until after
> the inode inactivation of all inodes in the cluster is complete....
> 

Okay, I think I understand what you are saying and it makes some sense.
I think there is still a chance that the xfs_ilock_nowait() will fail in
xfs_ifree_cluster() if the inode it is trying to lock has just been locked
before entering xfs_finish_reclaim() and consequently we wont mark it stale.
The thread in xfs_ifree_cluster() may also grab the lock on the inode
cluster buffer before the xfs_finish_reclaim() thread so we wont find the
inode's log item attached to the buffer either.
