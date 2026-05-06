Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A2221A447
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778079916; cv=none; b=tq7KgWG1d/S7AsYTbklzXHalKPlC5jmlMl5lGNrZjgU9WZQxuDeqwrUtWkJAU6ua9r/93llr0FXo+241u3WYMfIZN1/TAwa5/lzGbNMCRENP14vkhnTZ/i59TYTGpz5e2292l2MgK4KWEG6F2BrGwwWQfHf6LX1sns9iSehJ2iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778079916; c=relaxed/simple;
	bh=urs3YFlTV46KBbZeBcGifT0K1wHHN/W61Ulg5d8+iGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KiFRtBA1jL5Jsqyj8pSxdSJuqngOV1o0qfWjsQaIlsXUZmHgF4xUzQlB8bfR237/zlKgmCkoLm+JmJaFk7BjmO+dwp2nsvGcV4lVh9pi1oBYSYLXYUcBUBgrGsxU4nd7kuMW4T4KmS4yEdztJ1ZD4Thn3scykr+UjNww+lIqhl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZjfVeo4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZjfVeo4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF0DC2BCB8;
	Wed,  6 May 2026 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778079916;
	bh=urs3YFlTV46KBbZeBcGifT0K1wHHN/W61Ulg5d8+iGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZjfVeo4JXH31kHEWMJjdJlZbHh1G2GnVizF0mO+kX8IhcJCgwAKiSBcvI8hy/YISS
	 mdSAtJJNCB0Jm8l7cAu6tWlNjJlV/nwhi8eUXyGBnnIwAzcLvq5LGuV0cEecKzAA+P
	 w9z9N/Xwum776fxLV9aTL0jqS++3TGVfmIupi70mhikdO+WjqcAzpmUhZOSy8XgpJT
	 81MzQ1hffQHXAHg7mxl8C7tCMrE/xCeO4rAQGylUzLPlXLI5Pi0siT4XL4SYD4RI7h
	 s/R0NiGHPsjSQfzTTdZ7j0E9F33TTOEhcizjinwZVbFtUe/gMmNTcgbPRkhAoMDr+J
	 Puf2IgsxlfnLw==
Date: Wed, 6 May 2026 17:05:11 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Andres Freund <andres@anarazel.de>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	Christian Brauner <brauner@kernel.org>, Pankaj <pankaj.raghav@linux.dev>
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
Message-ID: <aftQP63r22Q9SWb9@andromeda.toxiclabs.cc>
References: <IS8F8EYS5pW4UU5a3jxOTy-f18EgkDa_2zAUswRgTm6NVtvmajAaQyu9CDxkTelDnfXfCl7L_692C77zRAxwFQ==@protonmail.internalid>
 <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r>

On Wed, May 06, 2026 at 09:26:25AM -0400, Andres Freund wrote:
> Hi,
> 
> While looking at performance issues on Samsung client drives due to slow FUA,
> I tried to reproduce older numbers on a recent kernel.  And couldn't, at first
> - but not because the problem went away, but because the fdatasync numbers
> (which shouldn't use FUA) got *much* worse.
> 
> These drives have FUA writes that are slower than full flushes, making
> O_DIRECT|O_DSYNC writes perform poorly and fdatasync() comparatively better.
> 
> 
> What I'm seeing is that with recent kernels the fdatasync() performance is
> roughly as bad as the O_DSYNC, whereas previously it was > 2x as
> fasts. blktrace showed that there are ongoing FUA writes during a workload
> with just overwriting writes and an fdatasync after every write.
> 
> 
> At first I thought it was a regression between 7.0..7.1-rc2, but that turned
> out to be only because the 7.0 machine did not have lazytime enabled. After
> fixing that discrepancy, the regression is also visible in 7.0.  I have
> confirmed it's not visible in 6.18.
> 
> Repro Workload:
> 
> fio --directory ${mountpoint}/fio/ --overwrite 1 --size=$((4096*123)) --buffered 0 --bs=4096 --rw=write --name write-fdatasync --fdatasync=1 |grep IOPS
> 
> On v7.1-rc2-5-g6d35786de2811:
> 
> mounted with lazytime:
> write: IOPS=158, BW=636KiB/s (651kB/s)(492KiB/774msec); 0 zone resets
> 
> mounted with nolazyatime:
> write: IOPS=594, BW=2377KiB/s (2434kB/s)(492KiB/207msec); 0 zone resets
> 
> 
> 
> Running it with perf stat and a few events [1] shows:
> 
> using lazytime
>   write: IOPS=174, BW=697KiB/s (714kB/s)(492KiB/706msec); 0 zone resets
> 
>  Performance counter stats for 'fio --directory /srv/fio/ --overwrite 1 --size=503808 --buffered 0 --bs=4096 --rw=write --name write-fdatasync --fdatasync=1':
> 
>                123      syscalls:sys_enter_pwrite64
>                122      syscalls:sys_exit_fdatasync
>                121      xfs:xlog_iclog_write
>                121      xfs:xlog_iclog_sync
>                123      xfs:xfs_file_direct_write
>                122      xfs:xfs_update_time
>                122      xfs:xfs_log_reserve
>                123      xfs:xfs_trans_add_item
>                  8      writeback:writeback_dirty_inode
>                122      xfs:xfs_trans_commit
> 
>        1.170287744 seconds time elapsed
> 
>        0.192673000 seconds user
>        0.054510000 seconds sys
> 
> 
> using nolazytime
>   write: IOPS=672, BW=2689KiB/s (2753kB/s)(492KiB/183msec); 0 zone resets
> 
>  Performance counter stats for 'fio --directory /srv/fio/ --overwrite 1 --size=503808 --buffered 0 --bs=4096 --rw=write --name write-fdatasync --fdatasync=1':
> 
>                123      syscalls:sys_enter_pwrite64
>                122      syscalls:sys_exit_fdatasync
>                  1      xfs:xlog_iclog_write
>                  1      xfs:xlog_iclog_sync
>                123      xfs:xfs_file_direct_write
>                 55      xfs:xfs_update_time
>                 55      xfs:xfs_log_reserve
>                 55      xfs:xfs_trans_add_item
>                  7      writeback:writeback_dirty_inode
>                 55      xfs:xfs_trans_commit
> 
>        0.667253953 seconds time elapsed
> 
>        0.160385000 seconds user
>        0.061264000 seconds sys
> 
> 
> The relevant difference presumably is that nolazytime has a lot more log
> flushes (xfs:xlog_iclog_sync).
> 
> 
> ext4 does not show that behaviour.
> 
> 
> Presumably this happened as part of
> 
> commit 74554251dfc9374ebf1a9dfc54d6745d56bb9265
> Merge: 996812c453caf 77ef2c3ff5916
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   2026-02-09 11:25:01 -0800
> 
>     Merge tag 'vfs-7.0-rc1.nonblocking_timestamps' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs
> 
>     Pull vfs timestamp updates from Christian Brauner:
>      "This contains the changes to support non-blocking timestamp updates.
> 
> Or in one of the followup fixes.  Hence CCing the folks involved in that.

Thanks for the info, I'll look into it next week assuming nobody looks
into it first.

> 
> 
> Greetings,
> 
> Andres Freund
> 
> 
> [1] mountpoint=/srv; for opt in lazytime nolazytime; do echo "using $opt"; mount $mountpoint -o remount,$opt && perf stat -e syscalls:sys_enter_pwrite64,syscalls:sys_exit_fdatasync,xfs:xlog_iclog_write,xfs:xlog_iclog_sync,xfs:xfs_file_direct_write,xfs:xfs_update_time,xfs:xfs_log_reserve,xfs:xfs_trans_add_item,writeback:writeback_dirty_inode,xfs:xfs_trans_commit fio --directory ${mountpoint}/fio/ --overwrite 1 --size=$((4096*123)) --buffered 0 --bs=4096 --rw=write --name write-fdatasync --fdatasync=1 |grep IOPS || break;done
