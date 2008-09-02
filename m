Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Sep 2008 22:49:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m825no4C011832
	for <xfs@oss.sgi.com>; Mon, 1 Sep 2008 22:49:51 -0700
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id PAA03976 for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 15:51:15 +1000
Message-ID: <48BCD622.1080406@sgi.com>
Date: Tue, 02 Sep 2008 15:58:58 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: Filesystem corruption writing out unlinked inodes
References: <48BCC5B1.7080300@sgi.com> <20080902051524.GC15962@disturbed>
In-Reply-To: <20080902051524.GC15962@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Sep 02, 2008 at 02:48:49PM +1000, Lachlan McIlroy wrote:
>> I've been looking into a case of filesystem corruption and found
>> that we are flushing unlinked inodes after the inode cluster has
>> been freed - and potentially reallocated as something else.  The
>> case happens when we unlink the last inode in a cluster and that
>> triggers the cluster to be released.
>>
>> The code path of interest here is:
>>
>> xfs_fs_clear_inode()
>> 	->xfs_inactive()
>> 		->xfs_ifree()
>> 			->xfs_ifree_cluster()
> 
> Which should be marking the buffer as XBF_STALE, right?
> Which means the buffer is torn down at transaction completion
> rather than queued into the AIL for writeback?
> 
>> 	->xfs_reclaim()
>> 		-> queues inode on deleted inodes list
>>
>> ... and later on
>>
>> xfs_syncsub()
>> 	->xfs_finish_reclaim_all()
>> 		->xfs_finish_reclaim()
>> 			->xfs_iflush()
> 
> And here we re-read the buffer because it had been marked as
> stale and completely torn down when released...
> 
>> When the inode is unlinked it gets logged in a transaction so
>> xfs_iflush() considers it dirty and writes it out but by this
>> time the cluster has been reallocated.  If the cluster is
>> reallocated as user data then the checks in xfs_imap_to_bp will
>> complain because the inode magic will be incorrect but if the
>> cluster is reallocated as another inode cluster then these checks
>> wont detect that.
> 
> Right, because we've allowed the extent to be reused before we've
> really finished with it....
> 
>> I modified xfs_iflush() to bail out if we try to flush an
>> unlinked inode (ie nlink == 0) and that avoids the corruption but
>> xfs_repair now has problems with inodes marked as free but with
>> non-zero nlink counts.
> 
> You also break subtly break bulkstat by not writing out unlinked
> inodes. That is, bulkstat gets a bunch of inode data from the AGI
> btree and puts it into a temporary buffer. It then unlocks the AGI
> to read the inode buffers it found in the AGI. This can then race
> with unlink and cluster frees. If we have memory pressure, then the
> buffer pages can be freed, resulting in reading the inode buffers
> back from disk during bulkstat.  Bulkstat will now see inode buffers
> with linked inodes that have actually been freed....
> 
>> Do we really want to write out unlinked
>> inodes?  Seems a bit redundant.
> 
> The bulkstat problem makes it necessary. Otherwise, we could rely
> totally on the contents of the AGI and the AGI unlinked lists to
> determine what inodes are linked or unlinked during recovery or
> repair without problems.
> 
>> Other options could be to delay the release of the inode cluster
>> until the inode has been flushed or move the flush into xfs_ifree()
>> before releasing the cluster.  Looking at xfs_ifree_cluster() it
>> scans the inodes in a cluster and tries to lock them and mark them
>> stale - maybe we can leverage this and avoid flushing staled inodes.
>> If so we'd need to tighten up the locking.
> 
> Why aren't all inodes in memory marked XFS_ISTALE by the
> time xfs_ifree_cluster() completes? That is what is supposed to be
> used to avoid writeback of inodes in freed cluster buffers.
> 
> Basically xfs_ifree_cluster does:
> 
> 	loop over in memory inodes:
> 
> 		did we get the flush lock on them?
> 			yes - mark them XFS_ISTALE
> 			no - they must be locked for flush and
> 			     attached to the cluster buffer
> 
> 	get the cluster buffer
> 
> 	loop over log items on cluster buffer
> 		if XFS_LI_INODE
> 			mark it XFS_ISTALE
> 
> 	loop over all in memory inodes that were locked
> 		attach them to the cluster buffer
> 
> This is supposed to catch all the inodes in memory and mark them
> XFS_ISTALE to prevent them from being written back once the
> transaction is committed. The question is - how are dirty inodes
> slipping through this?
> 
> If we are freeing the cluster buffer, then there can be no other
> active references to any of the inodes, so if they are dirty it
> has to be due to inactivation transactions and so should be in
> the log and attached to the buffer due to removal from the
> unlinked list.
> 
> The question is - which bit of this is not working? i.e. what is the
> race condition that is allowing dirty inodes to slip through the
> locking here?
> 
> Hmmm - I see that xfs_iflush() doesn't check for XFS_ISTALE when
> flushing out inodes. Perhaps you could check to see if we are
> writing an inode marked as such.....

That's what I was suggesting.  I'm just not sure about the assumption
that if the flush lock cannot be acquired in xfs_ifree_cluster() then
the inode must be in the process of being flushed.  The flush could
be aborted due to the inode being pinned or some other case and the
inode never gets marked as stale.
