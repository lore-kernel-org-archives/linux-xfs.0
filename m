Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61DD182D9
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736473489; cv=none; b=P7el6w82slQ2aqA3NYpDw/Tm6WgIj8K4YQckK0oequaYs4NxYRlpeiR/iXNzDLv0vpBYGPWx9gMlPTXFh6RHUjN1+CMyyJkF65GAPCJhqeijTySIE36Yff11FK3M1TckVZaMoOaHROeKBfxcwkggcaZNodPPshM8tcE+9IpaZ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736473489; c=relaxed/simple;
	bh=svLML4wMWWwv1AigsewckX5rfi3s5X1cifxe805bbTA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJuWBGgr2UBnHrO9xnUkATMZMf8J4D64BPi37BAjldb0bTXjkB39u+3iyugajiBZB10hMXBmm7BnzPNGIScIPhjLS5tuF/1OmopGdqyf980ZMZrQM52s7XzDXIhMJBQpvjB4RA1z4/KNTYqsDjVLepljkIL8ZFroAkAV0SCvqOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YTkrV6plbz1W3t6;
	Fri, 10 Jan 2025 09:40:58 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id D51D41800D1;
	Fri, 10 Jan 2025 09:44:42 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jan
 2025 09:44:42 +0800
Date: Fri, 10 Jan 2025 09:40:15 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH v2] xfs: fix mount hang during primary superblock
 recovery failure
Message-ID: <Z4B6f9DdpQX0IIbj@localhost.localdomain>
References: <20250109021320.429625-1-leo.lilong@huawei.com>
 <20250109044142.GM1306365@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20250109044142.GM1306365@frogsfrogsfrogs>
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Wed, Jan 08, 2025 at 08:41:42PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 09, 2025 at 10:13:20AM +0800, Long Li wrote:
> > When mounting an image containing a log with sb modifications that require
> > log replay, the mount process hang all the time and stack as follows:
> > 
> >   [root@localhost ~]# cat /proc/557/stack
> >   [<0>] xfs_buftarg_wait+0x31/0x70
> >   [<0>] xfs_buftarg_drain+0x54/0x350
> >   [<0>] xfs_mountfs+0x66e/0xe80
> >   [<0>] xfs_fs_fill_super+0x7f1/0xec0
> >   [<0>] get_tree_bdev_flags+0x186/0x280
> >   [<0>] get_tree_bdev+0x18/0x30
> >   [<0>] xfs_fs_get_tree+0x1d/0x30
> >   [<0>] vfs_get_tree+0x2d/0x110
> >   [<0>] path_mount+0xb59/0xfc0
> >   [<0>] do_mount+0x92/0xc0
> >   [<0>] __x64_sys_mount+0xc2/0x160
> >   [<0>] x64_sys_call+0x2de4/0x45c0
> >   [<0>] do_syscall_64+0xa7/0x240
> >   [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > 
> > During log recovery, while updating the in-memory superblock from the
> > primary SB buffer, if an error is encountered, such as superblock
> > corruption occurs or some other reasons, we will proceed to out_release
> > and release the xfs_buf. However, this is insufficient because the
> > xfs_buf's log item has already been initialized and the xfs_buf is held
> > by the buffer log item as follows, the xfs_buf will not be released,
> > causing the mount thread to hang.
> 
> Can you post a regression test for us, pretty please? :)
> 

I performed regression testing by mounting specific images that can be
obtained through fault injection on kernels without metadir feature support.
I can provide it if anyone needs it.The image is big and inconvenient to send
in the mail. The detailed steps are as follows:

1) Kernel Build
  - The latest realtime AG update bug [1] remains unfixed
  - Build kernel without CONFIG_XFS_RT
  
2) Mount XFS Image (superblock needs replay, incompatible with metadir and
   no realtime subvolume)

3) Mount Result Verification
  - Without the current patch: mount thread hangs indefinitely
  - With the current patch: mount thread does not hang, but XFS is shut down

The xfstests already have the fault injection test, and this test requires
mounting specific images on specifically-compiled kernels, making it impractical
to incorporate into xfstests.

> >   xlog_recover_do_primary_sb_buffer
> >     xlog_recover_do_reg_buffer
> >       xlog_recover_validate_buf_type
> >         xfs_buf_item_init(bp, mp)
> > 
> > The solution is straightforward, we simply need to allow it to be
> > handled by the normal buffer write process. The filesystem will be
> > shutdown before the submission of buffer_list in xlog_do_recovery_pass(),
> > ensuring the correct release of the xfs_buf as follows:
> > 
> >   xlog_do_recovery_pass
> >     error = xlog_recover_process
> >       xlog_recover_process_data
> >         xlog_recover_process_ophdr
> >           xlog_recovery_process_trans
> >             ...
> >               xlog_recover_buf_commit_pass2
> >                 error = xlog_recover_do_primary_sb_buffer
> >                   //Encounter error and return
> >                 if (error)
> >                   goto out_writebuf
> >                 ...
> >               out_writebuf:
> >                 xfs_buf_delwri_queue(bp, buffer_list) //add bp to list
> >                 return  error
> >             ...
> >     if (!list_empty(&buffer_list))
> >       if (error)
> >         xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR); //shutdown first
> >       xfs_buf_delwri_submit(&buffer_list); //write buffer in list
> >         __xfs_buf_submit
> >           if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
> >             xfs_buf_ioend_fail(bp)  //release bp correctly
> > 
> 
> Please add:
> Cc: <stable@vger.kernel.org> # v6.12
> 
> > Fixes: 6a18765b54e2 ("xfs: update the file system geometry after recoverying superblock buffers")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> > v1->v2: Add code comments and add the fixed stack description to the 
> >         commit message.
> >  fs/xfs/xfs_buf_item_recover.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> > index 3d0c6402cb36..04122bbdd5f3 100644
> > --- a/fs/xfs/xfs_buf_item_recover.c
> > +++ b/fs/xfs/xfs_buf_item_recover.c
> > @@ -1079,7 +1079,7 @@ xlog_recover_buf_commit_pass2(
> >  		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
> >  				current_lsn);
> >  		if (error)
> > -			goto out_release;
> > +			goto out_writebuf;
> >  
> >  		/* Update the rt superblock if we have one. */
> >  		if (xfs_has_rtsb(mp) && mp->m_rtsb_bp) {
> > @@ -1096,6 +1096,15 @@ xlog_recover_buf_commit_pass2(
> >  		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
> >  	}
> >  
> > +	/*
> > +	 * Buffer held by buf log item during 'normal' buffer recovery must
> > +	 * be committed through buffer I/O submission path to ensure proper
> > +	 * release. When error occurs during do sb buffer recovery, log
> 
> "...during sb buffer recovery..."
> 
> and with those two things amended,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D

Ok, thanks for your review.

Long Li.
