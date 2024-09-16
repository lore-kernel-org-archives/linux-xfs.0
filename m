Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2765EF9DA
	for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2024 08:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726476455; cv=none; b=gwa4kkl6MJr/Xrw8Rssj2iwLRQAQVkulGKFnn34DTxcBczX2ntxW/m2nCgV+hBpOUNuFuUMgZDkCrCWNd8tfaGhfIeW95gGEKeFQrQZOWBwXRRpY5k9kv2beJg9H8UMQSaU8LOTFHQUuMpLfYslIaZIn3g76JU8EhQi3AXIOd+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726476455; c=relaxed/simple;
	bh=ZiCRb1ZsLMvc4rVRdjJvvR5BLyrrJ4CFyEtpNq/fqvk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=avfhn3ROOTaeQ5bSMJ3e3KkNY0L/nNtJhrKjY8VT99sN/JDiLn9vWAxw2WSzcZzjx0sFadZDtNuYsmw4G92aREyEDLkAGBf7Ag9U8AM/LU+N+rYWvVZAeVj7S+OOqI9nNtLuJNczsds0g3k0QirE9YXnnxE6RNVfQFPo/l5nn9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uu85k5gm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uu85k5gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C27C4CEC4;
	Mon, 16 Sep 2024 08:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726476454;
	bh=ZiCRb1ZsLMvc4rVRdjJvvR5BLyrrJ4CFyEtpNq/fqvk=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=uu85k5gmjsOQNazfws2SpWa5h+J2VLm/HDZDcPH3xVaJoRrYJ1jPmXCOtGuPJPnCO
	 Nj6kzk8kLWrKAdi9YvTT+MFuH83IlA4Uw+LcrwoT3rHpZYbVjAtD73vhMhH/zGb+uR
	 2pG84o/nHETt9q2uAwWkDVTu6EmURIGYKUFsc4LaDl9rmi1h+Ih7Y2GwMuMQ0oXc2n
	 oq4yxKBwcvyCt0L2yFXaZV+MxyMuqpg5lKC9Yrmy/fjTXZbGIVNftDdvPHSnmdCz2x
	 IOKXSOoBFOXP8jd3P/HdX/78ZhO6fQGU9JK8ybLPh0O76gcwtFXNOTtnLQq9YqYsbN
	 xwIt4kkMVND2g==
References: <20240902075045.1037365-1-chandanbabu@kernel.org>
 <ZtW8cIgjK88RrB77@dread.disaster.area>
 <87v7z0xevx.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Prevent umount from indefinitely waiting on
 XFS_IFLUSHING flag on stale inodes
Date: Mon, 16 Sep 2024 11:14:32 +0530
In-reply-to: <87v7z0xevx.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87zfo8dly5.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Sep 05, 2024 at 06:12:29 PM +0530, Chandan Babu R wrote:
> On Mon, Sep 02, 2024 at 11:24:00 PM +1000, Dave Chinner wrote:
>> On Mon, Sep 02, 2024 at 01:20:41PM +0530, Chandan Babu R wrote:
>>> Executing xfs/057 can lead to an unmount task to wait indefinitely for
>>> XFS_IFLUSHING flag on some inodes to be cleared. The following timeline
>>> describes as to how inodes can get into such a state.
>>> 
>>>   Task A               Task B                      Iclog endio processing
>>>   ----------------------------------------------------------------------------
>>>   Inodes are freed
>>> 
>>>   Inodes items are
>>>   added to the CIL
>>> 
>>>   CIL contents are
>>>   written to iclog
>>> 
>>>   iclog->ic_fail_crc
>>>   is set to true
>>> 
>>>   iclog is submitted
>>>   for writing to the
>>>   disk
>>> 
>>>                        Last inode in the cluster
>>>                        buffer is freed
>>> 
>>>                        XFS_[ISTALE/IFLUSHING] is
>>>                        set on all inodes in the
>>>                        cluster buffer
>>> 
>>>                        XFS_STALE is set on
>>>                        the cluster buffer
>>>                                                    iclog crc error is detected
>>>                        ...                         during endio processing
>>>                        During xfs_trans_commit,    Set XFS_LI_ABORTED on inode
>>>                        log shutdown is detected    items
>>>                        on xfs_buf_log_item         - Unpin the inode since it
>>>                                                    is stale and return -1
>>>                        xfs_buf_log_item is freed
>>
>> How do we get the buffer log item freed here? It should be in the
>> CIL and/or the AIL because the unlinked inode list updates should
>> have already logged directly to that buffer and committed in in
>> previous transactions. 
>>
>
> Apologies for the late response. I was held up with other work and also
> accidently overwrote the perf.data file. I had to spend some time to get a
> good trace file.
>
> Apart from the inode freed by Task B (the last inode to be freed), the
> remaining inodes of the cluster buffer would have gone through the following
> steps during inode inactivation processing,
> 1. Add the corresponding inode items to the list at bp->b_li_list.
> 2. Free the corresponding buffer log item because it is neither dirty nor
>    stale and the refcount of buffer log item was 1 before executing
>    xfs_buf_item_put(). Please refer to xfs_inode_item_precommit() =>
>    xfs_trans_brelse() => xfs_buf_item_put().
> 3. The inode log item is then added to the CIL.
>
> At this point in execution, I can't seem to find the reason for the buffer log
> item to be on either the CIL or AIL.
>
>
> The new trace file has a slightly different timeline,
>
>   Task A             Task B                      Iclog endio processing        CIL push worker               
>  ------------------+---------------------------+-----------------------------+------------------------------ 
>   Inodes are freed                                                                                           
>                                                                                                              
>   Inodes items are                                                                                           
>   added to the CIL                                                                                           
>                                                                                                              
>                                                                                                              
>                      Last inode in the cluster                                                               
>                      buffer is freed                                                                         
>                                                                                                              
>                      XFS_[ISTALE/IFLUSHING] is                                                               
>                      set on all inodes in the                                                                
>                      cluster buffer                                                                          
>                                                                                                              
>                      XFS_STALE is set on                                       Probably waiting on           
>                      the cluster buffer                                        cil->xc_[start/commit]_wait
>                                                                                            
>                      ...                         iclog crc error is detected   ...                           
>                                                  during endio processing.                                    
>                                                  This checkpoint transaction                                 
>                                                  was mostly submitted before                                 
>                                                  any of the inodes from the                                  
>                                                  cluster buffer were freed.                                  
>                                                                                                              
>                                                  Set XLOG_IO_ERROR and                                       
>                                                  XFS_OPSTATE_SHUTDOWN.                                       
>                                                                                                              
>                                                  Wake up waiters waiting on                                  
>                                                  cil->xc_[start/commit]_wait                                 
>                      During xfs_trans_commit,                                  Execute xlog_cil_committed()  
>                      log shutdown is detected                                  as part of error handling.    
>                                                                                                              
>                      XFS_LI_ABORTED is set                                     Set XFS_LI_ABORTED on inode   
>                      on xfs_buf_log_item                                       items.                        
>                                                                                                              
>                      xfs_buf_log_item is freed                                 xfs_inode_item_committed()    
>                                                                                - Unpin the inode since it    
>                      xfs_buf is not freed here                                 is stale and return -1        
>                      since b_hold has a                                                                      
>                      non-zero value                                            Inode log items are not       
>                                                                                processed further since       
>                                                                                xfs_inode_item_committed()    
>                                                                                returns -1                    
>  
> The above time line was contructed based on the following trace data,
>
> xfs__xfs_iunlink_remove     2 02114.099694694     9903 kworker/2:3-eve
> dev=7340037, agno=0, agino=53801  
> 	[ffffffffc1a9e039] xfs_iunlink_remove_inode+0x4c9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1a9e039] xfs_iunlink_remove_inode+0x4c9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1aa0254] xfs_iunlink_remove+0x94 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1aa0745] xfs_inode_uninit+0x95 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4c1f6] xfs_ifree+0x246 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4c68e] xfs_inactive_ifree+0x18e (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4cdcd] xfs_inactive+0x4fd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b2f443] xfs_inodegc_worker+0x273 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
> 	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
> 	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
> 	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
> 	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])
>
> 53801 is the last inode in the cluster buffer to be freed.
>
>
> xfs__xfs_trans_binval 2 02114.128632378 9903 kworker/2:3-eve dev=7340037,
> buf_bno=53792, buf_len=32, buf_hold=35, buf_pincount=0, buf_lockval=0,
> buf_flags=DONE | INODES | PAGES, bli_recur=0, bli_refcount=1,
> bli_flags=STALE_INODE, li_flags=
> 	[ffffffffc1bdac19] xfs_trans_binval+0x2b9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1bdac19] xfs_trans_binval+0x2b9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b48611] xfs_ifree_cluster+0x4a1 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4c336] xfs_ifree+0x386 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4c68e] xfs_inactive_ifree+0x18e (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4cdcd] xfs_inactive+0x4fd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b2f443] xfs_inodegc_worker+0x273 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
> 	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
> 	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
> 	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
> 	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])
>
> Cluster buffer is invalidated.
>
>
> xfs__xfs_buf_item_release 2 02114.128823015 9903 kworker/2:3-eve dev=7340037,
> buf_bno=53792, buf_len=32, buf_hold=34, buf_pincount=0, buf_lockval=0,
> buf_flags=DONE | STALE | INODES | PAGES, bli_recur=0, bli_refcount=1,
> bli_flags=STALE | STALE_INODE, li_flags=ABORTED
> 	[ffffffffc1b9e488] xfs_buf_item_release+0x3d8 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b9e488] xfs_buf_item_release+0x3d8 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b7528d] xfs_trans_free_items+0xcd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b77b5b] __xfs_trans_commit+0x29b (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b796da] xfs_trans_roll+0x11a (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1a306ba] xfs_defer_trans_roll+0x11a (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1a31b27] xfs_defer_finish_noroll+0x667 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b77ce6] __xfs_trans_commit+0x426 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4c6f0] xfs_inactive_ifree+0x1f0 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4cdcd] xfs_inactive+0x4fd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b2f443] xfs_inodegc_worker+0x273 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
> 	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
> 	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
> 	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
> 	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])
>
> Buffer log item is aborted by the higher level transaction. Please note that
> buffer log items's refcount is set to 1.
>
> xfs__xfs_buf_rele        2 02114.129083754     9903 kworker/2:3-eve
> dev=7340037, bno=53792, nblks=32, hold=33, pincount=0, lockval=1, flags=DONE |
> STALE | INODES | PAGES, caller_ip=18446744072664601229,
> buf_ops=18446744072669101824
> 	[ffffffffc1af372d] xfs_buf_rele_cached+0x3ed (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1af372d] xfs_buf_rele_cached+0x3ed (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b7528d] xfs_trans_free_items+0xcd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b77b5b] __xfs_trans_commit+0x29b (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b796da] xfs_trans_roll+0x11a (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1a306ba] xfs_defer_trans_roll+0x11a (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1a31b27] xfs_defer_finish_noroll+0x667 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b77ce6] __xfs_trans_commit+0x426 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4c6f0] xfs_inactive_ifree+0x1f0 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b4cdcd] xfs_inactive+0x4fd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b2f443] xfs_inodegc_worker+0x273 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
> 	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
> 	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
> 	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
> 	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])
>
> xfs_buf is not released since the new 'hold' count will be 32; However the
> caller i.e. xfs_buf_item_relse() will free the xfs_buf_log_item 
>
> xfs__xfs_inode_unpin 2 02115.142605975 5368 kworker/u16:0-e dev=7340037,
> ino=53792, count=0, pincount=2, caller_ip=18446744072664863980
> 	[ffffffffc1bb5344] xfs_inode_item_unpin+0x174 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1bb5344] xfs_inode_item_unpin+0x174 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1bb54ec] xfs_inode_item_committed+0x9c (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b915a0] xlog_cil_ail_insert+0x330 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b92104] xlog_cil_committed+0x454 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b94569] xlog_cil_push_work+0x11a9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
> 	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
> 	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
> 	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
> 	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])
>
> CIL push worker is executing error handling code; 53792 is one of the inodes
> which was freed and committed to the CIL by Task A. It is being unpinned since
> the inode is stale.
>
> xfs__xfs_inode_unpin     2 02115.312093611     5368 kworker/u16:0-e
> dev=7340037, ino=53800, count=0, pincount=1,
> caller_ip=18446744072664863980 
> 	[ffffffffc1bb5344] xfs_inode_item_unpin+0x174 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1bb5344] xfs_inode_item_unpin+0x174 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1bb54ec] xfs_inode_item_committed+0x9c (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b915a0] xlog_cil_ail_insert+0x330 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b92104] xlog_cil_committed+0x454 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffffc1b94569] xlog_cil_push_work+0x11a9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
> 	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
> 	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
> 	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
> 	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
> 	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])
>
> Another stale inode being unpinned.
>
>>>
>>> To overcome this bug, this commit removes the check for log shutdown during
>>> high level transaction commit operation. The log items in the high level
>>> transaction will now be committed to the CIL despite the log being
>>> shutdown. This will allow the CIL processing logic (i.e. xlog_cil_push_work())
>>> to invoke xlog_cil_committed() as part of error handling. This will cause
>>> xfs_buf log item to to be unpinned and the corresponding inodes to be aborted
>>> and have their XFS_IFLUSHING flag cleared.
>>
>> I don't know exactly how the problem arose, but I can say for
>> certain that the proposed fix is not valid.  Removing that specific
>> log shutdown check re-opens a race condition which can causes on
>> disk corruption. The shutdown was specifically placed to close that
>> race - See commit 3c4cb76bce43 ("xfs: xfs_trans_commit() path must
>> check for log shutdown") for details.
>>
>> I have no idea what the right way to fix this is yet, but removing
>> the shutdown check isn't it...
>>

Commit 3c4cb76bce43 describes the following scenario,

1. Filesystem is shutdown but the log remains operational.
2. High-level transaction commit (i.e. xfs_trans_commit()) notices the fs
   shutdown. Hence it aborts the dirty log items. One of the log items being
   aborted is an inode log item.
3. An inode cluster writeback is executed. Here, we come across the previously
   aborted inode log item. The inode log item is currently unpinned and
   dirty. Hence, the inode is included in the cluster buffer writeback.
4. Cluster buffer IO completion tries to remove the inode log item from the
   AIL and hence trips over an assert statement since the log item was never
   on the AIL. This indicates that the inode was never written to the journal.

Hence the commit 3c4cb76bce43 will abort the transaction commit only when the
log has been shutdown.

With the log shutdown check removed, we can end up with the following cases
during high-level transaction commit operation,
1. The filesystem is shutdown while the log remains operational.
   In this case, the log items are committed to the CIL where they are pinned
   before unlocking them. This should prevent the inode cluster writeback code
   from including such an inode for writeback since the corresponding log item
   is pinned. From here onwards, the normal flow of log items from the CIL to
   the AIL occurs after the contents of the log items are written to the
   journal and then later unpinned.
   The above logic holds true even without applying the "RFC patch" presented
   in the mail.
 
2. The log is shutdown.
   As in the previous case, the log items are moved to the CIL where they are
   pinned before unlocking them. The pinning of the log items prevents
   the inode cluster writeback code from including the pinned inode in its
   writeback operation. These log items are then processed by
   xlog_cil_committed() which gets invoked as part of error handling by
   xlog_cil_push_work().

   I can't seem to find the scenario in which the above "RFC patch" can cause
   the aborted log item's inode to be included by the cluster writeback code.

-- 
Chandan
