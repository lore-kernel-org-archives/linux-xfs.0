Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367E04BAA6
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708516808; cv=none; b=SdGSqsx+2U6CPmKNMEr7j1Xsi426yc52XIGffTtmyjEU118lcCPYxn/ARWmUBS+1d8foul+1kyFNjuMkPtHH2VZ3Njf17cavl5L+nitoRSQHa18mPEW/eik5cB7lrYPcAldi0s48YGcJHxGcpEuRcqjVk3zVS/R3Tc25AxtKEpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708516808; c=relaxed/simple;
	bh=19sCkX+J/Vq51FImN4Cmh6sCy7qs7l5377DOVvOVXE8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VRrm05ppvZhB1c10b18J+5yIbwNnlLRCiYexmoZlM+tPJ5AGzot+hUm+VqxdEztWTqGu3Nap6zKQwTj5m3M+CGOFvBDcP9+qr9txlz16YrQymvXj3wQHGi7KpMoB7L7MgbtRkf7NCKMckl8SRyCGrE+ZjOiN+bIA+J77Kim6vrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Tfvsl5bCJz1X2rF;
	Wed, 21 Feb 2024 19:57:47 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 076F818005F;
	Wed, 21 Feb 2024 19:59:57 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 21 Feb
 2024 19:59:56 +0800
Date: Wed, 21 Feb 2024 20:01:52 +0800
From: Long Li <leo.lilong@huawei.com>
To: Chandan Babu R <chandanbabu@kernel.org>
CC: <djwong@kernel.org>, <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [PATCH v2] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <20240221120152.GA2836909@ceph-admin>
References: <20240117123126.2019059-1-leo.lilong@huawei.com>
 <87bk8ja5x5.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <87bk8ja5x5.fsf@debian-BULLSEYE-live-builder-AMD64>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Wed, Feb 14, 2024 at 12:23:40PM +0530, Chandan Babu R wrote:
> On Wed, Jan 17, 2024 at 08:31:26 PM +0800, Long Li wrote:
> > While performing the IO fault injection test, I caught the following data
> > corruption report:
> >
> >  XFS (dm-0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x79c/0x1130
> >  CPU: 3 PID: 33 Comm: kworker/3:0 Not tainted 6.5.0-rc7-next-20230825-00001-g7f8666926889 #214
> >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> >  Workqueue: xfs-inodegc/dm-0 xfs_inodegc_worker
> >  Call Trace:
> >   <TASK>
> >   dump_stack_lvl+0x50/0x70
> >   xfs_corruption_error+0x134/0x150
> >   xfs_free_ag_extent+0x7d3/0x1130
> >   __xfs_free_extent+0x201/0x3c0
> >   xfs_trans_free_extent+0x29b/0xa10
> >   xfs_extent_free_finish_item+0x2a/0xb0
> >   xfs_defer_finish_noroll+0x8d1/0x1b40
> >   xfs_defer_finish+0x21/0x200
> >   xfs_itruncate_extents_flags+0x1cb/0x650
> >   xfs_free_eofblocks+0x18f/0x250
> >   xfs_inactive+0x485/0x570
> >   xfs_inodegc_worker+0x207/0x530
> >   process_scheduled_works+0x24a/0xe10
> >   worker_thread+0x5ac/0xc60
> >   kthread+0x2cd/0x3c0
> >   ret_from_fork+0x4a/0x80
> >   ret_from_fork_asm+0x11/0x20
> >   </TASK>
> >  XFS (dm-0): Corruption detected. Unmount and run xfs_repair
> >
> > After analyzing the disk image, it was found that the corruption was
> > triggered by the fact that extent was recorded in both inode datafork
> > and AGF btree blocks. After a long time of reproduction and analysis,
> > we found that the reason of free sapce btree corruption was that the
> > AGF btree was not recovered correctly.
> >
> > Consider the following situation, Checkpoint A and Checkpoint B are in
> > the same record and share the same start LSN1, buf items of same object
> > (AGF btree block) is included in both Checkpoint A and Checkpoint B. If
> > the buf item in Checkpoint A has been recovered and updates metadata LSN
> > permanently, then the buf item in Checkpoint B cannot be recovered,
> > because log recovery skips items with a metadata LSN >= the current LSN
> > of the recovery item. If there is still an inode item in Checkpoint B
> > that records the Extent X, the Extent X will be recorded in both inode
> > datafork and AGF btree block after Checkpoint B is recovered. Such
> > transaction can be seen when allocing enxtent for inode bmap, it record
> > both the addition of extent to the inode extent list and the removing
> > extent from the AGF.
> >
> >   |------------Record (LSN1)------------------|---Record (LSN2)---|
> >   |-------Checkpoint A----------|----------Checkpoint B-----------|
> >   |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
> >   |     Extent X is freed       |     Extent X is allocated       |
> >
> > After commit 12818d24db8a ("xfs: rework log recovery to submit buffers
> > on LSN boundaries") was introduced, we submit buffers on lsn boundaries
> > during log recovery. The above problem can be avoided under normal paths,
> > but it's not guaranteed under abnormal paths. Consider the following
> > process, if an error was encountered after recover buf item in Checkpoint
> > A and before recover buf item in Checkpoint B, buffers that have been
> > added to the buffer_list will still be submitted, this violates the
> > submits rule on lsn boundaries. So buf item in Checkpoint B cannot be
> > recovered on the next mount due to current lsn of transaction equal to
> > metadata lsn on disk. The detailed process of the problem is as follows.
> >
> > First Mount:
> >
> >   xlog_do_recovery_pass
> >     error = xlog_recover_process
> >       xlog_recover_process_data
> >         xlog_recover_process_ophdr
> >           xlog_recovery_process_trans
> >             ...
> >               /* recover buf item in Checkpoint A */
> >               xlog_recover_buf_commit_pass2
> >                 xlog_recover_do_reg_buffer
> >                 /* add buffer of agf btree block to buffer_list */
> >                 xfs_buf_delwri_queue(bp, buffer_list)
> >             ...
> >             ==> Encounter read IO error and return
> >     /* submit buffers regardless of error */
> >     if (!list_empty(&buffer_list))
> >       xfs_buf_delwri_submit(&buffer_list);
> >
> >     <buf items of agf btree block in Checkpoint A recovery success>
> >
> > Second Mount:
> >
> >   xlog_do_recovery_pass
> >     error = xlog_recover_process
> >       xlog_recover_process_data
> >         xlog_recover_process_ophdr
> >           xlog_recovery_process_trans
> >             ...
> >               /* recover buf item in Checkpoint B */
> >               xlog_recover_buf_commit_pass2
> >                 /* buffer of agf btree block wouldn't added to
> >                    buffer_list due to lsn equal to current_lsn */
> >                 if (XFS_LSN_CMP(lsn, current_lsn) >= 0)
> >                   goto out_release
> >
> >     <buf items of agf btree block in Checkpoint B wouldn't recovery>
> >
> > In order to make sure that submits buffers on lsn boundaries in the
> > abnormal paths, we need to check error status before submit buffers that
> > have been added from the last record processed. If error status exist,
> > buffers in the bufffer_list should not be writen to disk.
> >
> > Canceling the buffers in the buffer_list directly isn't correct, unlike
> > any other place where write list was canceled, these buffers has been
> > initialized by xfs_buf_item_init() during recovery and held by buf item,
> > buf items will not be released in xfs_buf_delwri_cancel(), it's not easy
> > to solve.
> >
> > If the filesystem has been shut down, then delwri list submission will
> > error out all buffers on the list via IO submission/completion and do
> > all the correct cleanup automatically. So shutting down the filesystem
> > could prevents buffers in the bufffer_list from being written to disk.
> >
> 
> Hi,
> 
> The patch did not apply cleanly on the collection of XFS patches due for
> Linux-v6.9. This was due to a trivial conflict with one of the patches that
> was included earlier in the collection.
> 
> Can you please review your patch at
> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=9ee85f235efeebd5146c4436fb255d636e8063d6
> and let me know if you have any disagreements.

It looks ok for me. 

Thanks,
Long Li
