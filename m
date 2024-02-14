Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF671119C
	for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2024 06:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707893898; cv=none; b=XuhIagLUMdi4BVBAwkCLSy6jRTYWSlK79UOgCMfBo9Phnw0EH6oVLFoTLrc+6nDoYugRC169PJdwh+jdJunXObwsJ6ehTzN1vBJ89GBIRJIDmPQJS5PuBLQ9oJCUjLl7EbJUv6Dm9wfTR1C5IO1KW3GYL11E1D1/g5SExaBs1Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707893898; c=relaxed/simple;
	bh=ShcbM/eRCAlVjZH/4A4HbWJRoL60OP6PeQziQ4NeOBE=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=KAurJcoVepJymu+1VeTJle7ynYVFVvDRHpK8zfmpqjdgwV83x7HEvwq7FWBbg4ytqYZYV/gbBT6cWF18JNX8Bte/hzDaxPgoIPPkIbnBUTi6qpsZ0opaZ7eZiun3HnqQbVlXbGPx0D5KGXFGLl8gvCqZpyp1YOnWmGI5CKq/dQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qjp7QlFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qjp7QlFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29616C433F1;
	Wed, 14 Feb 2024 06:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707893897;
	bh=ShcbM/eRCAlVjZH/4A4HbWJRoL60OP6PeQziQ4NeOBE=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=Qjp7QlFkIRYM+dBoF3VwhBOD6K9oDoewMtgzjfkUbUVTXhAcoI2JSb1OBmHyr0vBM
	 NVpYlLjKiXG3vqQF/c0qu2uoiCqNwoDCr9Y4ETSbIzdEogQ3cxa85cLXue6QAyDcmA
	 LC9C+xEm9ohOTzkvzm0bvrKLTAE4Q7KrRDnr6CmvqTG7gvO6BXF33r5FowsgFPJCs7
	 vpW8anUmbDW0m0/yCNzRph+875ahrB9b1DzxORtpvlkP7dW1o0t7yh109S1tIWV3vW
	 9XAk9KHmmzHeCSREbdZ7BIuVF21XrTKtfNdgdTyXj2ZbkrD1Z6v7yC9Wv+uiJh1Kbq
	 CJTA7TGzaS9LA==
References: <20240117123126.2019059-1-leo.lilong@huawei.com>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
 houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2] xfs: ensure submit buffers on LSN boundaries in
 error handlers
Date: Wed, 14 Feb 2024 12:23:40 +0530
In-reply-to: <20240117123126.2019059-1-leo.lilong@huawei.com>
Message-ID: <87bk8ja5x5.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jan 17, 2024 at 08:31:26 PM +0800, Long Li wrote:
> While performing the IO fault injection test, I caught the following data
> corruption report:
>
>  XFS (dm-0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x79c/0x1130
>  CPU: 3 PID: 33 Comm: kworker/3:0 Not tainted 6.5.0-rc7-next-20230825-00001-g7f8666926889 #214
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
>  Workqueue: xfs-inodegc/dm-0 xfs_inodegc_worker
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x50/0x70
>   xfs_corruption_error+0x134/0x150
>   xfs_free_ag_extent+0x7d3/0x1130
>   __xfs_free_extent+0x201/0x3c0
>   xfs_trans_free_extent+0x29b/0xa10
>   xfs_extent_free_finish_item+0x2a/0xb0
>   xfs_defer_finish_noroll+0x8d1/0x1b40
>   xfs_defer_finish+0x21/0x200
>   xfs_itruncate_extents_flags+0x1cb/0x650
>   xfs_free_eofblocks+0x18f/0x250
>   xfs_inactive+0x485/0x570
>   xfs_inodegc_worker+0x207/0x530
>   process_scheduled_works+0x24a/0xe10
>   worker_thread+0x5ac/0xc60
>   kthread+0x2cd/0x3c0
>   ret_from_fork+0x4a/0x80
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
>  XFS (dm-0): Corruption detected. Unmount and run xfs_repair
>
> After analyzing the disk image, it was found that the corruption was
> triggered by the fact that extent was recorded in both inode datafork
> and AGF btree blocks. After a long time of reproduction and analysis,
> we found that the reason of free sapce btree corruption was that the
> AGF btree was not recovered correctly.
>
> Consider the following situation, Checkpoint A and Checkpoint B are in
> the same record and share the same start LSN1, buf items of same object
> (AGF btree block) is included in both Checkpoint A and Checkpoint B. If
> the buf item in Checkpoint A has been recovered and updates metadata LSN
> permanently, then the buf item in Checkpoint B cannot be recovered,
> because log recovery skips items with a metadata LSN >= the current LSN
> of the recovery item. If there is still an inode item in Checkpoint B
> that records the Extent X, the Extent X will be recorded in both inode
> datafork and AGF btree block after Checkpoint B is recovered. Such
> transaction can be seen when allocing enxtent for inode bmap, it record
> both the addition of extent to the inode extent list and the removing
> extent from the AGF.
>
>   |------------Record (LSN1)------------------|---Record (LSN2)---|
>   |-------Checkpoint A----------|----------Checkpoint B-----------|
>   |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
>   |     Extent X is freed       |     Extent X is allocated       |
>
> After commit 12818d24db8a ("xfs: rework log recovery to submit buffers
> on LSN boundaries") was introduced, we submit buffers on lsn boundaries
> during log recovery. The above problem can be avoided under normal paths,
> but it's not guaranteed under abnormal paths. Consider the following
> process, if an error was encountered after recover buf item in Checkpoint
> A and before recover buf item in Checkpoint B, buffers that have been
> added to the buffer_list will still be submitted, this violates the
> submits rule on lsn boundaries. So buf item in Checkpoint B cannot be
> recovered on the next mount due to current lsn of transaction equal to
> metadata lsn on disk. The detailed process of the problem is as follows.
>
> First Mount:
>
>   xlog_do_recovery_pass
>     error = xlog_recover_process
>       xlog_recover_process_data
>         xlog_recover_process_ophdr
>           xlog_recovery_process_trans
>             ...
>               /* recover buf item in Checkpoint A */
>               xlog_recover_buf_commit_pass2
>                 xlog_recover_do_reg_buffer
>                 /* add buffer of agf btree block to buffer_list */
>                 xfs_buf_delwri_queue(bp, buffer_list)
>             ...
>             ==> Encounter read IO error and return
>     /* submit buffers regardless of error */
>     if (!list_empty(&buffer_list))
>       xfs_buf_delwri_submit(&buffer_list);
>
>     <buf items of agf btree block in Checkpoint A recovery success>
>
> Second Mount:
>
>   xlog_do_recovery_pass
>     error = xlog_recover_process
>       xlog_recover_process_data
>         xlog_recover_process_ophdr
>           xlog_recovery_process_trans
>             ...
>               /* recover buf item in Checkpoint B */
>               xlog_recover_buf_commit_pass2
>                 /* buffer of agf btree block wouldn't added to
>                    buffer_list due to lsn equal to current_lsn */
>                 if (XFS_LSN_CMP(lsn, current_lsn) >= 0)
>                   goto out_release
>
>     <buf items of agf btree block in Checkpoint B wouldn't recovery>
>
> In order to make sure that submits buffers on lsn boundaries in the
> abnormal paths, we need to check error status before submit buffers that
> have been added from the last record processed. If error status exist,
> buffers in the bufffer_list should not be writen to disk.
>
> Canceling the buffers in the buffer_list directly isn't correct, unlike
> any other place where write list was canceled, these buffers has been
> initialized by xfs_buf_item_init() during recovery and held by buf item,
> buf items will not be released in xfs_buf_delwri_cancel(), it's not easy
> to solve.
>
> If the filesystem has been shut down, then delwri list submission will
> error out all buffers on the list via IO submission/completion and do
> all the correct cleanup automatically. So shutting down the filesystem
> could prevents buffers in the bufffer_list from being written to disk.
>

Hi,

The patch did not apply cleanly on the collection of XFS patches due for
Linux-v6.9. This was due to a trivial conflict with one of the patches that
was included earlier in the collection.

Can you please review your patch at
https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=9ee85f235efeebd5146c4436fb255d636e8063d6
and let me know if you have any disagreements.

-- 
Chandan
