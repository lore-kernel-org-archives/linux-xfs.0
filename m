Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C83F224CF
	for <linux-xfs@vger.kernel.org>; Fri, 13 Sep 2024 06:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726207847; cv=none; b=KjJEAaNWSRwM62hYDzhiA9a8toerTT6+19qP4s1EESTnpZZZe2rmPEHGCrCIy7QktmXsXUqjbKf3zGsge7Sf99djb16HansyEXu7bTenu+/gkZrnUzjVsvHG910TWo23Y73YKR4fdvWul+MWUUQD4D05TpxGwwbQb5vDzQj0iPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726207847; c=relaxed/simple;
	bh=Zwz1gA145ltwbuYihkTsfozLGcxFlnMP7BDoQ2/AUzM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=tMNLbFXAzyqN/6nnD1Sg3ZTCI4WQ6Sj7CZf4IP7oKSOyMGEmFpiDDp0sODRolsyuBathz3QKd+YjnFQnsGhkx5Aahn5y7TOScgf3ZbrVlZ0wdD5cRMqaHxFz4DJci275le5+95BOTyhTuo5Dn8U5OabktTGs5FAHftUzlMYNFNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJAw2Pzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJAw2Pzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D694C4CEC0;
	Fri, 13 Sep 2024 06:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726207847;
	bh=Zwz1gA145ltwbuYihkTsfozLGcxFlnMP7BDoQ2/AUzM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=OJAw2PzfTPijfp6PLEoETMJcKM1ACyjC01dlHcs1wbWHfFAFdJiexalJni5Y9lmo4
	 Rv821hzI5G6NPJugAn0c9sHdo/ATpQ0KwNAsgKYAjjJVbcfClqqDjGsQZeNicTT/vt
	 ddIT2XTgiXlcAHbklYvM/ISu+7rbfS6ltoAHvnhpQ+RbXol2QMowJ6ZpSC7rDhtapC
	 sjMGQxVXPL6mmgk42MdmPL9+6TM3qX7N9UVWz0xHYs5TgSZc594r7U7fIINGipyCCV
	 UwKPpf+rsTH8D6dWn2OhPJoEFiqSylNfnq30Dis6kKh5pfnnBe5187SplUy9nXmYcM
	 jji7+soETTQlA==
References: <20240902075045.1037365-1-chandanbabu@kernel.org>
 <ZtW8cIgjK88RrB77@dread.disaster.area>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Prevent umount from indefinitely waiting on
 XFS_IFLUSHING flag on stale inodes
Date: Thu, 05 Sep 2024 18:12:29 +0530
In-reply-to: <ZtW8cIgjK88RrB77@dread.disaster.area>
Message-ID: <87v7z0xevx.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Sep 02, 2024 at 11:24:00 PM +1000, Dave Chinner wrote:
> On Mon, Sep 02, 2024 at 01:20:41PM +0530, Chandan Babu R wrote:
>> Executing xfs/057 can lead to an unmount task to wait indefinitely for
>> XFS_IFLUSHING flag on some inodes to be cleared. The following timeline
>> describes as to how inodes can get into such a state.
>> 
>>   Task A               Task B                      Iclog endio processing
>>   ----------------------------------------------------------------------------
>>   Inodes are freed
>> 
>>   Inodes items are
>>   added to the CIL
>> 
>>   CIL contents are
>>   written to iclog
>> 
>>   iclog->ic_fail_crc
>>   is set to true
>> 
>>   iclog is submitted
>>   for writing to the
>>   disk
>> 
>>                        Last inode in the cluster
>>                        buffer is freed
>> 
>>                        XFS_[ISTALE/IFLUSHING] is
>>                        set on all inodes in the
>>                        cluster buffer
>> 
>>                        XFS_STALE is set on
>>                        the cluster buffer
>>                                                    iclog crc error is detected
>>                        ...                         during endio processing
>>                        During xfs_trans_commit,    Set XFS_LI_ABORTED on inode
>>                        log shutdown is detected    items
>>                        on xfs_buf_log_item         - Unpin the inode since it
>>                                                    is stale and return -1
>>                        xfs_buf_log_item is freed
>
> How do we get the buffer log item freed here? It should be in the
> CIL and/or the AIL because the unlinked inode list updates should
> have already logged directly to that buffer and committed in in
> previous transactions. 
>

Apologies for the late response. I was held up with other work and also
accidently overwrote the perf.data file. I had to spend some time to get a
good trace file.

Apart from the inode freed by Task B (the last inode to be freed), the
remaining inodes of the cluster buffer would have gone through the following
steps during inode inactivation processing,
1. Add the corresponding inode items to the list at bp->b_li_list.
2. Free the corresponding buffer log item because it is neither dirty nor
   stale and the refcount of buffer log item was 1 before executing
   xfs_buf_item_put(). Please refer to xfs_inode_item_precommit() =>
   xfs_trans_brelse() => xfs_buf_item_put().
3. The inode log item is then added to the CIL.

At this point in execution, I can't seem to find the reason for the buffer log
item to be on either the CIL or AIL.


The new trace file has a slightly different timeline,

  Task A             Task B                      Iclog endio processing        CIL push worker               
 ------------------+---------------------------+-----------------------------+------------------------------ 
  Inodes are freed                                                                                           
                                                                                                             
  Inodes items are                                                                                           
  added to the CIL                                                                                           
                                                                                                             
                                                                                                             
                     Last inode in the cluster                                                               
                     buffer is freed                                                                         
                                                                                                             
                     XFS_[ISTALE/IFLUSHING] is                                                               
                     set on all inodes in the                                                                
                     cluster buffer                                                                          
                                                                                                             
                     XFS_STALE is set on                                       Probably waiting on           
                     the cluster buffer                                        cil->xc_[start/commit]_wait
                                                                                           
                     ...                         iclog crc error is detected   ...                           
                                                 during endio processing.                                    
                                                 This checkpoint transaction                                 
                                                 was mostly submitted before                                 
                                                 any of the inodes from the                                  
                                                 cluster buffer were freed.                                  
                                                                                                             
                                                 Set XLOG_IO_ERROR and                                       
                                                 XFS_OPSTATE_SHUTDOWN.                                       
                                                                                                             
                                                 Wake up waiters waiting on                                  
                                                 cil->xc_[start/commit]_wait                                 
                     During xfs_trans_commit,                                  Execute xlog_cil_committed()  
                     log shutdown is detected                                  as part of error handling.    
                                                                                                             
                     XFS_LI_ABORTED is set                                     Set XFS_LI_ABORTED on inode   
                     on xfs_buf_log_item                                       items.                        
                                                                                                             
                     xfs_buf_log_item is freed                                 xfs_inode_item_committed()    
                                                                               - Unpin the inode since it    
                     xfs_buf is not freed here                                 is stale and return -1        
                     since b_hold has a                                                                      
                     non-zero value                                            Inode log items are not       
                                                                               processed further since       
                                                                               xfs_inode_item_committed()    
                                                                               returns -1                    
 
The above time line was contructed based on the following trace data,

xfs__xfs_iunlink_remove     2 02114.099694694     9903 kworker/2:3-eve
dev=7340037, agno=0, agino=53801  
	[ffffffffc1a9e039] xfs_iunlink_remove_inode+0x4c9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1a9e039] xfs_iunlink_remove_inode+0x4c9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1aa0254] xfs_iunlink_remove+0x94 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1aa0745] xfs_inode_uninit+0x95 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4c1f6] xfs_ifree+0x246 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4c68e] xfs_inactive_ifree+0x18e (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4cdcd] xfs_inactive+0x4fd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b2f443] xfs_inodegc_worker+0x273 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])

53801 is the last inode in the cluster buffer to be freed.


xfs__xfs_trans_binval 2 02114.128632378 9903 kworker/2:3-eve dev=7340037,
buf_bno=53792, buf_len=32, buf_hold=35, buf_pincount=0, buf_lockval=0,
buf_flags=DONE | INODES | PAGES, bli_recur=0, bli_refcount=1,
bli_flags=STALE_INODE, li_flags=
	[ffffffffc1bdac19] xfs_trans_binval+0x2b9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1bdac19] xfs_trans_binval+0x2b9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b48611] xfs_ifree_cluster+0x4a1 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4c336] xfs_ifree+0x386 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4c68e] xfs_inactive_ifree+0x18e (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4cdcd] xfs_inactive+0x4fd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b2f443] xfs_inodegc_worker+0x273 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])

Cluster buffer is invalidated.


xfs__xfs_buf_item_release 2 02114.128823015 9903 kworker/2:3-eve dev=7340037,
buf_bno=53792, buf_len=32, buf_hold=34, buf_pincount=0, buf_lockval=0,
buf_flags=DONE | STALE | INODES | PAGES, bli_recur=0, bli_refcount=1,
bli_flags=STALE | STALE_INODE, li_flags=ABORTED
	[ffffffffc1b9e488] xfs_buf_item_release+0x3d8 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b9e488] xfs_buf_item_release+0x3d8 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b7528d] xfs_trans_free_items+0xcd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b77b5b] __xfs_trans_commit+0x29b (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b796da] xfs_trans_roll+0x11a (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1a306ba] xfs_defer_trans_roll+0x11a (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1a31b27] xfs_defer_finish_noroll+0x667 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b77ce6] __xfs_trans_commit+0x426 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4c6f0] xfs_inactive_ifree+0x1f0 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4cdcd] xfs_inactive+0x4fd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b2f443] xfs_inodegc_worker+0x273 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])

Buffer log item is aborted by the higher level transaction. Please note that
buffer log items's refcount is set to 1.

xfs__xfs_buf_rele        2 02114.129083754     9903 kworker/2:3-eve
dev=7340037, bno=53792, nblks=32, hold=33, pincount=0, lockval=1, flags=DONE |
STALE | INODES | PAGES, caller_ip=18446744072664601229,
buf_ops=18446744072669101824
	[ffffffffc1af372d] xfs_buf_rele_cached+0x3ed (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1af372d] xfs_buf_rele_cached+0x3ed (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b7528d] xfs_trans_free_items+0xcd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b77b5b] __xfs_trans_commit+0x29b (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b796da] xfs_trans_roll+0x11a (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1a306ba] xfs_defer_trans_roll+0x11a (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1a31b27] xfs_defer_finish_noroll+0x667 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b77ce6] __xfs_trans_commit+0x426 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4c6f0] xfs_inactive_ifree+0x1f0 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b4cdcd] xfs_inactive+0x4fd (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b2f443] xfs_inodegc_worker+0x273 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])

xfs_buf is not released since the new 'hold' count will be 32; However the
caller i.e. xfs_buf_item_relse() will free the xfs_buf_log_item 

xfs__xfs_inode_unpin 2 02115.142605975 5368 kworker/u16:0-e dev=7340037,
ino=53792, count=0, pincount=2, caller_ip=18446744072664863980
	[ffffffffc1bb5344] xfs_inode_item_unpin+0x174 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1bb5344] xfs_inode_item_unpin+0x174 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1bb54ec] xfs_inode_item_committed+0x9c (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b915a0] xlog_cil_ail_insert+0x330 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b92104] xlog_cil_committed+0x454 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b94569] xlog_cil_push_work+0x11a9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])

CIL push worker is executing error handling code; 53792 is one of the inodes
which was freed and committed to the CIL by Task A. It is being unpinned since
the inode is stale.

xfs__xfs_inode_unpin     2 02115.312093611     5368 kworker/u16:0-e
dev=7340037, ino=53800, count=0, pincount=1,
caller_ip=18446744072664863980 
	[ffffffffc1bb5344] xfs_inode_item_unpin+0x174 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1bb5344] xfs_inode_item_unpin+0x174 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1bb54ec] xfs_inode_item_committed+0x9c (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b915a0] xlog_cil_ail_insert+0x330 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b92104] xlog_cil_committed+0x454 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffffc1b94569] xlog_cil_push_work+0x11a9 (/lib/modules/6.11.0-rc3+/kernel/fs/xfs/xfs.ko)
	[ffffffff878623a3] process_one_work+0x603 ([kernel.kallsyms])
	[ffffffff87865560] worker_thread+0x7d0 ([kernel.kallsyms])
	[ffffffff8787f9cb] kthread+0x2eb ([kernel.kallsyms])
	[ffffffff876d9424] ret_from_fork+0x34 ([kernel.kallsyms])
	[ffffffff876094ea] ret_from_fork_asm+0x1a ([kernel.kallsyms])

Another stale inode being unpinned.

>>
>> To overcome this bug, this commit removes the check for log shutdown during
>> high level transaction commit operation. The log items in the high level
>> transaction will now be committed to the CIL despite the log being
>> shutdown. This will allow the CIL processing logic (i.e. xlog_cil_push_work())
>> to invoke xlog_cil_committed() as part of error handling. This will cause
>> xfs_buf log item to to be unpinned and the corresponding inodes to be aborted
>> and have their XFS_IFLUSHING flag cleared.
>
> I don't know exactly how the problem arose, but I can say for
> certain that the proposed fix is not valid.  Removing that specific
> log shutdown check re-opens a race condition which can causes on
> disk corruption. The shutdown was specifically placed to close that
> race - See commit 3c4cb76bce43 ("xfs: xfs_trans_commit() path must
> check for log shutdown") for details.
>
> I have no idea what the right way to fix this is yet, but removing
> the shutdown check isn't it...
>

I haven't read the commit yet. I will do so and get back.

-- 
Chandan
