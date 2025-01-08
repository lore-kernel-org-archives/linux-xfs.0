Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677854685
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 00:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736296450; cv=none; b=NB+WPmGrKfR13z059iwln9oyW8AdNrd8LraRwoirTbTMeTYPWzS0MKHJuE0D9R3VxaFnIo/Pwzc/3QlVGiDLgP50jZA3lb9hv1r79HRRkxegfjaD3k7wquO6js9IzKCwoHHI4QpuaJfZmIECYGRV/Ui/k2JH5I6a6hAnTYK84QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736296450; c=relaxed/simple;
	bh=vkvuXCW9gQ94mfIXsjmB5d/YuIFc7gqC/kLKuoJN740=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IoOABwd+/jwnaQNT73pIA5miLlt0bAqrXWFM6QKATtS9bmkNc6ULqNhYKGmMA2kk95luuZfUDcLtNBDhGY7ImVFvSKD+AIrqOtox4/Ioxl35/Vz/FuaqYUrDzVVHkx5GNDcy1WuOTsPlYxDaTfidClxWNiZiPpIfg+jFTBmV7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0P1xEQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0P1xEQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69B1C4CED6;
	Wed,  8 Jan 2025 00:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736296449;
	bh=vkvuXCW9gQ94mfIXsjmB5d/YuIFc7gqC/kLKuoJN740=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c0P1xEQTNGpYkSUWbM0SxsBLEPv8HebYj08HLwVh1HIJC29F4bmiPnobRriveafQH
	 HCMJ2OQ5coE4Ipal1G2ibzPoIUZoJ1MmYOuVHz5pyvldjXNp/5x6wtkaczRF5MsJnZ
	 Jr21Zk5rdtEHdv/Cft8Zp/eUR0Fx3epbL4kZf7lFkeZTQSvHaW4vg2pRQa0J0AWRWi
	 BjxrP/UC60F8OGdZWDEis/c5BR/Hk04Xfi4LxvDZqyYENKgnogqS2yDq1jcO1wgHTm
	 oYCfgqvp5vHsgQ0eHvs/zdIMccOUoXH9QW9AKD+70KI9w8kzsUynCwnZyc+U+4n9z2
	 THqyFO0YChKXQ==
Date: Tue, 7 Jan 2025 16:34:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 2/2] xfs: fix mount hang during primary superblock
 recovery failure
Message-ID: <20250108003409.GM6174@frogsfrogsfrogs>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-3-leo.lilong@huawei.com>
 <20250106195541.GL6174@frogsfrogsfrogs>
 <Z30ufg1tE3N-T1k_@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z30ufg1tE3N-T1k_@localhost.localdomain>

On Tue, Jan 07, 2025 at 09:39:10PM +0800, Long Li wrote:
> On Mon, Jan 06, 2025 at 11:55:41AM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 31, 2024 at 10:34:23AM +0800, Long Li wrote:
> > > When mounting an image containing a log with sb modifications that require
> > > log replay, the mount process hang all the time and stack as follows:
> > > 
> > >   [root@localhost ~]# cat /proc/557/stack
> > >   [<0>] xfs_buftarg_wait+0x31/0x70
> > >   [<0>] xfs_buftarg_drain+0x54/0x350
> > >   [<0>] xfs_mountfs+0x66e/0xe80
> > >   [<0>] xfs_fs_fill_super+0x7f1/0xec0
> > >   [<0>] get_tree_bdev_flags+0x186/0x280
> > >   [<0>] get_tree_bdev+0x18/0x30
> > >   [<0>] xfs_fs_get_tree+0x1d/0x30
> > >   [<0>] vfs_get_tree+0x2d/0x110
> > >   [<0>] path_mount+0xb59/0xfc0
> > >   [<0>] do_mount+0x92/0xc0
> > >   [<0>] __x64_sys_mount+0xc2/0x160
> > >   [<0>] x64_sys_call+0x2de4/0x45c0
> > >   [<0>] do_syscall_64+0xa7/0x240
> > >   [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > 
> > > During log recovery, while updating the in-memory superblock from the
> > > primary SB buffer, if an error is encountered, such as superblock
> > > corruption occurs or some other reasons, we will proceed to out_release
> > > and release the xfs_buf. However, this is insufficient because the
> > > xfs_buf's log item has already been initialized and the xfs_buf is held
> > > by the buffer log item as follows, the xfs_buf will not be released,
> > > causing the mount thread to hang.
> > > 
> > >   xlog_recover_do_primary_sb_buffer
> > >     xlog_recover_do_reg_buffer
> > >       xlog_recover_validate_buf_type
> > >         xfs_buf_item_init(bp, mp)
> > > 
> > > The solution is straightforward: we simply need to allow it to be
> > > handled by the normal buffer write process. The filesystem will be
> > > shutdown before the submission of buffer_list in xlog_do_recovery_pass(),
> > 
> > What shuts it down?  If xlog_recover_do_primary_sb_buffer trips over
> > something like "mp->m_sb.sb_rgcount < orig_rgcount" then we haven't shut
> > anything down yet.  Am I missing something? <confused>
> > 
> > --D
> > 
> 
> Hi Darrick,
> 
> Sorry for being unclear. I was referring to the shutdown in xlog_do_recovery_pass().
> Here's the specific flow after the fix: 
> 
>   xlog_do_recovery_pass
>    error = xlog_recover_process
>      xlog_recover_process_data
>        xlog_recover_process_ophdr
>          xlog_recovery_process_trans
>            ...
>              xlog_recover_buf_commit_pass2
>                error = xlog_recover_do_primary_sb_buffer
>                  //Encounter error and return
>                if (error)
>                  goto out_writebuf
>                ...
> out_writebuf:
>                xfs_buf_delwri_queue(bp, buffer_list)  //add bp to buffer_list
>                return  error
>            ...
>    if (!list_empty(&buffer_list))
>      if (error)
>        xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);  //log shutdown first
>      xfs_buf_delwri_submit(&buffer_list);
>        __xfs_buf_submit
>          if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
>            xfs_buf_ioend_fail(bp)  //release bp correctly
> 
> It might be clearer to put this process into a commit message.

Yes please, put that in a code comment.  That was too subtle for me to
figure out. :/

--D

> Thanks,
> Long Li
> 
