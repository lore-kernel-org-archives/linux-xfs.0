Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4A117589
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h4leQcl5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705327997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mr6mr30z4Qk2lOdK8Mcyhzn3fR+ctPvC09La47pjBn8=;
	b=h4leQcl59OWLhz3GfpepSQw/CWJldD3FX/H9Svetufu0rx+0LyVdf99aAWC0eY/PrZtsdg
	vGrYVbvLsDCSGXhrrERxlJXVR5iUF+OxS441vnyYYxPxAr3lDXX/dlflgo+2/81b099jOT
	Kaq0pbeUKlA4wA2yxFlvhe/wbe02tXo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-dkYs20OMP0ePvQmmKNPkyQ-1; Mon, 15 Jan 2024 09:13:13 -0500
X-MC-Unique: dkYs20OMP0ePvQmmKNPkyQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CAD08B39A2;
	Mon, 15 Jan 2024 14:13:13 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA58F3C25;
	Mon, 15 Jan 2024 14:13:12 +0000 (UTC)
Date: Mon, 15 Jan 2024 09:14:30 -0500
From: Brian Foster <bfoster@redhat.com>
To: Long Li <leo.lilong@huawei.com>
Cc: Dave Chinner <david@fromorbit.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <ZaU9xmrLRREwQ9Aa@bfoster>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZ86sxUcO0xUpqno@dread.disaster.area>
 <20240112125547.GA3459971@ceph-admin>
 <ZaGH79UhpFUz8hOs@bfoster>
 <20240115133103.GA1665392@ceph-admin>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115133103.GA1665392@ceph-admin>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

On Mon, Jan 15, 2024 at 09:31:03PM +0800, Long Li wrote:
> On Fri, Jan 12, 2024 at 01:42:32PM -0500, Brian Foster wrote:
> > On Fri, Jan 12, 2024 at 08:55:47PM +0800, Long Li wrote:
> > > On Thu, Jan 11, 2024 at 11:47:47AM +1100, Dave Chinner wrote:
> > > > On Thu, Dec 28, 2023 at 08:46:46PM +0800, Long Li wrote:
> > > > > In order to make sure that submits buffers on lsn boundaries in the
> > > > > abnormal paths, we need to check error status before submit buffers that
> > > > > have been added from the last record processed. If error status exist,
> > > > > buffers in the bufffer_list should be canceled.
> > > > > 
> > > > > Canceling the buffers in the buffer_list directly isn't correct, unlike
> > > > > any other place where write list was canceled, these buffers has been
> > > > > initialized by xfs_buf_item_init() during recovery and held by buf
> > > > > item, buf items will not be released in xfs_buf_delwri_cancel(). If
> > > > > these buffers are submitted successfully, buf items assocated with
> > > > > the buffer will be released in io end process. So releasing buf item
> > > > > in write list cacneling process is needed.
> > > > 
> > > > I still don't think this is correct.
> > > > 
> > > > > Fixes: 50d5c8d8e938 ("xfs: check LSN ordering for v5 superblocks during recovery")
> > > > > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > > > > ---
> > > > >  fs/xfs/xfs_buf.c         |  2 ++
> > > > >  fs/xfs/xfs_log_recover.c | 22 +++++++++++++---------
> > > > >  2 files changed, 15 insertions(+), 9 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > > index 8e5bd50d29fe..6a1b26aaf97e 100644
> > > > > --- a/fs/xfs/xfs_buf.c
> > > > > +++ b/fs/xfs/xfs_buf.c
> > > > > @@ -2075,6 +2075,8 @@ xfs_buf_delwri_cancel(
> > > > >  		xfs_buf_lock(bp);
> > > > >  		bp->b_flags &= ~_XBF_DELWRI_Q;
> > > > >  		xfs_buf_list_del(bp);
> > > > > +		if (bp->b_log_item)
> > > > > +			xfs_buf_item_relse(bp);
> > > > >  		xfs_buf_relse(bp);
> > > > 
> > > > I still don't think this is safe.  The buffer log item might still be
> > > > tracked in the AIL when the delwri list is cancelled, so the delwri
> > > > list cancelling cannot release the BLI without removing the item
> > > > from the AIL, too. The delwri cancelling walk really shouldn't be
> > > > screwing with AIL state, which means it can't touch the BLIs here.
> > > > 
> > > > At minimum, it's a landmine for future users of
> > > > xfs_buf_delwri_cancel().  A quick look at the quotacheck code
> > > > indicates that it can cancel delwri lists that have BLIs in the AIL
> > > > (for newly allocated dquot chunks), so I think this is a real concern.
> > > > 
> > > > This is one of the reasons for submitting the delwri list on error;
> > > > the IO completion code does all the correct cleanup of log items
> > > > including removing them from the AIL because the buffer is now
> > > > either clean or stale and no longer needs to be tracked by the AIL.
> > > 
> > > Yes, it's not a safety solution.
> > > 
> > > > 
> > > > If the filesystem has been shut down, then delwri list submission
> > > > will error out all buffers on the list via IO submission/completion
> > > > and do all the correct cleanup automatically.
> > > > 
> > > > I note that write IO errors during log recovery will cause immediate
> > > > shutdown of the filesytsem via xfs_buf_ioend_handle_error():
> > > > 
> > > > 	/*
> > > >          * We're not going to bother about retrying this during recovery.
> > > >          * One strike!
> > > >          */
> > > >         if (bp->b_flags & _XBF_LOGRECOVERY) {
> > > >                 xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> > > >                 return false;
> > > >         }
> > > > 
> > > > So I'm guessing that the IO error injection error that caused this
> > > > failure was on a buffer read part way through recovering items.
> > > > 
> > > > Can you confirm that the failure is only seen after read IO error
> > > > injection and that write IO error injection causes immediate
> > > > shutdown and so avoids the problem altogether?
> > > 
> > > This problem reproduce very hard, we reproduce it only three times.
> > > There may be several mounts between writing buffer not on LSN boundaries
> > > and reporting free space btree corruption, I can't distinguish the
> > > violation happend in which mount during test. So judging by the message
> > > I've reprodced, I can't confirm that the failure is only seen after read
> > > IO error injection. Look at one of the kernel message I've reprodced,
> > > there are several mount fails before reporting free space btree corruption,
> > > the reasons of mount fail include read IO error and write IO error.
> > > 
> > > [51555.801349] XFS (dm-3): Mounting V5 Filesystem
> > > [51555.982130] XFS (dm-3): Starting recovery (logdev: internal)
> > > [51558.153638] FAULT_INJECTION: forcing a failure.
> > >                name fail_make_request, interval 20, probability 1, space 0, times -1
> > > [51558.153723] XFS (dm-3): log recovery read I/O error at daddr 0x3972 len 1 error -5
> > > [51558.165996] XFS (dm-3): log mount/recovery failed: error -5
> > > [51558.166880] XFS (dm-3): log mount failed
> > > [51558.410963] XFS (dm-3): EXPERIMENTAL big timestamp feature in use. Use at your own risk!
> > > [51558.410981] XFS (dm-3): EXPERIMENTAL inode btree counters feature in use. Use at your own risk!
> > > [51558.413074] XFS (dm-3): Mounting V5 Filesystem
> > > [51558.595739] XFS (dm-3): Starting recovery (logdev: internal)
> > > [51559.592552] FAULT_INJECTION: forcing a failure.
> > >                name fail_make_request, interval 20, probability 1, space 0, times -1
> > > [51559.593008] XFS (dm-3): metadata I/O error in "xfs_buf_ioend_handle_error+0x170/0x760 [xfs]" at daddr 0x1879e0 len 32 error 5
> > > [51559.593335] XFS (dm-3): Metadata I/O Error (0x1) detected at xfs_buf_ioend_handle_error+0x63c/0x760 [xfs] (fs/xfs/xfs_buf.c:1272).  Shutting down filesystem.
> > > [51559.593346] XFS (dm-3): Please unmount the filesystem and rectify the problem(s)
> > > [51559.602833] XFS (dm-3): log mount/recovery failed: error -5
> > > [51559.603772] XFS (dm-3): log mount failed
> > > [51559.835690] XFS (dm-3): EXPERIMENTAL big timestamp feature in use. Use at your own risk!
> > > [51559.835708] XFS (dm-3): EXPERIMENTAL inode btree counters feature in use. Use at your own risk!
> > > [51559.837829] XFS (dm-3): Mounting V5 Filesystem
> > > [51560.024083] XFS (dm-3): Starting recovery (logdev: internal)
> > > [51562.155545] FAULT_INJECTION: forcing a failure.
> > >                name fail_make_request, interval 20, probability 1, space 0, times -1
> > > [51562.445074] XFS (dm-3): Ending recovery (logdev: internal)
> > > [51563.553960] XFS (dm-3): Internal error ltbno + ltlen > bno at line 1976 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x558/0xd80 [xfs]
> > > [51563.558629] XFS (dm-3): Corruption detected. Unmount and run xfs_repair
> > > 
> > > > 
> > > > If so, then all we need to do to handle instantiation side errors (EIO, ENOMEM,
> > > > etc) is this:
> > > > 
> > > > 	/*
> > > > 	 * Submit buffers that have been dirtied by the last record recovered.
> > > > 	 */
> > > > 	if (!list_empty(&buffer_list)) {
> > > > 		if (error) {
> > > > 			/*
> > > > 			 * If there has been an item recovery error then we
> > > > 			 * cannot allow partial checkpoint writeback to
> > > > 			 * occur.  We might have multiple checkpoints with the
> > > > 			 * same start LSN in this buffer list, and partial
> > > > 			 * writeback of a checkpoint in this situation can
> > > > 			 * prevent future recovery of all the changes in the
> > > > 			 * checkpoints at this start LSN.
> > > > 			 *
> > > > 			 * Note: Shutting down the filesystem will result in the
> > > > 			 * delwri submission marking all the buffers stale,
> > > > 			 * completing them and cleaning up _XBF_LOGRECOVERY
> > > > 			 * state without doing any IO.
> > > > 			 */
> > > > 			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> > > > 		}
> > > > 		error2 = xfs_buf_delwri_submit(&buffer_list);
> > > > 	}
> > > >
> > > 
> > > This solution is also used in our internally maintained linux branch,
> > > and after several months of testing, the problem no longer arises. It
> > > seems safe and reasonable enough.
> > > 
> > 
> > I assume you're referring to the xfs_buf_delwri_cancel() change..? If
> 
> I'm not referring to the xfs_buf_delwri_cancel() solution, but to the
> use of the xlog_force_shutdown() solution. We believe that the shutdown
> solution is less risky because buffer list can be cleanup automatically
> via IO submission/completion, it would not change any other logic, so
> we've used it in our internally maintained linux branch.
> 
> On the other hand, I thought it would be better to positively cancel
> the buffer list, so I sent it out, but I overlooked potential issues... 
> 

Ah, Ok. Sorry for the confusion. Thanks.

Brian

> > so, this is a valid data point but doesn't necessarily help explain
> > whether the change is correct in any other context. I/O cancel probably
> > doesn't happen often for one, and even if it does, it's not totally
> > clear if you're reproducing a situation where the item might be AIL
> > resident or not at the time (or it is and you have a use after free that
> > goes undetected). And even if none of that is relevant, that still
> > doesn't protect against future code changes if this code doesn't respect
> > the established bli lifecycle rules.
> 
> Yes, agree with you.
> 
> > 
> > IIRC, the bli_refcount (sampled via xfs_buf_item_relse()) is not
> > necessarily an object lifecycle refcount. It simply reflects whether the
> > item exists in a transaction where it might eventually be dirtied. This
> > is somewhat tricky, but can also be surmised from some of the logic in
> > xfs_buf_item_put(), for example.
> > 
> > IOW, I think in the simple (non-recovery) case of a buffer being read,
> > modified and committed by a transaction, the bli would eventually end up
> > in a state where bli_refcount == 0 but is still resident in the AIL
> > until eventually written back by xfsaild. That metadata writeback
> > completion is what eventually frees the bli via xfs_buf_item_done().
> > 
> > So if I'm not mistaken wrt to the above example sequence, the
> > interesting question is if we suppose a buffer is in that intermediate
> > state of waiting for writeback, and then somebody were to hypothetically
> > execute a bit of code that simply added the associated buffer to a
> > delwri q and immediately cancelled it, what would happen with this
> > change in place? ISTM the remove would prematurely free the buffer/bli
> > while it's still resident in the AIL and pending writeback, thus
> > resulting in use-after-free or potential memory/list corruption, etc. Is
> > that not the case?
> 
> Yes, if buf item still in the AIL, it is obviously not right to release
> the buf item.
> 
> Thanks,
> Long Li
> 

