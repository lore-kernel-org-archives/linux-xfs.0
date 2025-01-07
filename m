Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C36D1AC44D
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736257416; cv=none; b=nLxH45iC5jbEfSdlb2hjNyHBEZAWd0YsOHrlc6Btqr5UNxNQnE+3JOD6A4GEOlk48Mu5oe7DJQrLzcmhTQZ1hos4l0ZrTnmsLBf3vifPTtVtDCl7Q0hdusPxUdE55D8UcO3pfdwZzKqaQpJ6a1jGxOq1pfrvxwQ4/2b5pgGe9KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736257416; c=relaxed/simple;
	bh=+FatMjDwXU3HSfSUDCQkWHxeekx/bmIcMBF2xu2PUKk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jBLuhrVupc8Zs1C4sDQY6Irc/m7nAqxtRD5bh7F7IVSk8F78H1iOfOEkYw3nKV8aK7C8jR7vWJF8GPvJDiF74mJnm/QUikxGbyEFimT3x7NVeIQ/6FJGY/4O9n8IcOij5pUNdIxINgOKJJK3sRJfMWn0kOcoQ/yYZbQRS2rHLaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4YSByy5Cr2z22kh4;
	Tue,  7 Jan 2025 21:41:14 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id D486A14022E;
	Tue,  7 Jan 2025 21:43:28 +0800 (CST)
Received: from localhost (10.175.112.188) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 7 Jan
 2025 21:43:28 +0800
Date: Tue, 7 Jan 2025 21:39:10 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 2/2] xfs: fix mount hang during primary superblock
 recovery failure
Message-ID: <Z30ufg1tE3N-T1k_@localhost.localdomain>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-3-leo.lilong@huawei.com>
 <20250106195541.GL6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20250106195541.GL6174@frogsfrogsfrogs>
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500017.china.huawei.com (7.185.36.126)

On Mon, Jan 06, 2025 at 11:55:41AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 31, 2024 at 10:34:23AM +0800, Long Li wrote:
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
> > 
> >   xlog_recover_do_primary_sb_buffer
> >     xlog_recover_do_reg_buffer
> >       xlog_recover_validate_buf_type
> >         xfs_buf_item_init(bp, mp)
> > 
> > The solution is straightforward: we simply need to allow it to be
> > handled by the normal buffer write process. The filesystem will be
> > shutdown before the submission of buffer_list in xlog_do_recovery_pass(),
> 
> What shuts it down?  If xlog_recover_do_primary_sb_buffer trips over
> something like "mp->m_sb.sb_rgcount < orig_rgcount" then we haven't shut
> anything down yet.  Am I missing something? <confused>
> 
> --D
> 

Hi Darrick,

Sorry for being unclear. I was referring to the shutdown in xlog_do_recovery_pass().
Here's the specific flow after the fix: 

  xlog_do_recovery_pass
   error = xlog_recover_process
     xlog_recover_process_data
       xlog_recover_process_ophdr
         xlog_recovery_process_trans
           ...
             xlog_recover_buf_commit_pass2
               error = xlog_recover_do_primary_sb_buffer
                 //Encounter error and return
               if (error)
                 goto out_writebuf
               ...
out_writebuf:
               xfs_buf_delwri_queue(bp, buffer_list)  //add bp to buffer_list
               return  error
           ...
   if (!list_empty(&buffer_list))
     if (error)
       xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);  //log shutdown first
     xfs_buf_delwri_submit(&buffer_list);
       __xfs_buf_submit
         if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
           xfs_buf_ioend_fail(bp)  //release bp correctly

It might be clearer to put this process into a commit message.

Thanks,
Long Li
