Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0313620299B
	for <linux-xfs@vger.kernel.org>; Fri,  7 Nov 2025 23:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559934; cv=none; b=sP4NdTtRbFkwKbei7gpJ1cRXsAmHjjERoiz/bFwN6CEWqM09Z/64p6cPorYfPQJOtfDVPRC/RbPRDFSZKfMoHlW71WuFDpjPCijMSoGwKA7KAwNIRPrmKcyiD1kpsVW7Jy63gsqagAJnDAczIO+/qQeUxKXawVX0Dc97PrS0s2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559934; c=relaxed/simple;
	bh=/RgXkbgxqvhhJPf1dRr/uzni7vsGVekvFb4v7z5KRfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HefqY5v/6aPhzSm4NVnOmmmHDDyG0KHGbF81UWNRqwI7IWMCyhMOH8AeZPVfH2FXAiUmdJW+Jt1pV0PnQJM5TPS8T7j1RASEV8G8m4Ml2fZ8orieoO6nrb3qgdtXk1pkXhyMwd1NIhmlVMeKbGgjc+JGCqU62ORHJKVOM1wrSAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzKaQ4fM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzKaQ4fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7497AC4CEF5;
	Fri,  7 Nov 2025 23:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762559933;
	bh=/RgXkbgxqvhhJPf1dRr/uzni7vsGVekvFb4v7z5KRfY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UzKaQ4fMpxHutXBU9YgaTSt+jfJBU/P5O3bjOhUGDYQoK2+cUphzxQz90PHo3NusA
	 XsrD8/gPUK8WZG/6WEPEjEIttapcAGYmvqmP+nQsnCysz++rItij0hbv7EhYoEAlKg
	 qt9Tno5DfUWw/Zrnus9IfG9GdWgSNWFMRK5ZHzEJPbcINET0VOKd4qbr4Bx1KUr3Ih
	 53BWvBSfWaujoJ7saIcONvNtEBbtV5D0+vj/YuIf3P8p8uL+l91rNWe7aL+1i6xz3H
	 5oh+s0kXokRd9lBiyv6+zLI4hDs6kXMtB4aq5U0NDsmjVP6s+TV4T0lp9qLXbeG0RQ
	 eG986oA6pbjng==
Date: Fri, 7 Nov 2025 15:58:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: generic/648 metadata corruption
Message-ID: <20251107235852.GN196370@frogsfrogsfrogs>
References: <gjureda6lp7phaaum3ffwmcumu5q2zisatei73o6u2mgvohkkk@n2i2bwltxjqu>
 <aQ5uj_hWPiZQD1Wy@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ5uj_hWPiZQD1Wy@dread.disaster.area>

On Sat, Nov 08, 2025 at 09:11:27AM +1100, Dave Chinner wrote:
> On Fri, Nov 07, 2025 at 10:42:21AM +0100, Carlos Maiolino wrote:
> > Hello, has anybody has found any issues with generic/648 recently?
> > 
> > I've hit it on my test batch this evening, running a 2k block size a
> > metadata corruption error o generic/648.
> > 
> > I'll rerun the tests now and it later today, sharing it for a broader
> > audience.
> > 
> > This is running xfs's branch xfs-6.18-fixes.
> > 
> > I don't remember have seen this on my previous runs, but
> > I'll check the logs just in case.
> > 
> > The fsstress process ended up getting stuck at:
> > 
> > $ sudo cat /proc/2969171/stack 
> > [<0>] folio_wait_bit_common+0x138/0x340
> > [<0>] folio_wait_bit+0x1c/0x30
> > [<0>] folio_wait_writeback+0x2f/0x90
> > [<0>] __filemap_fdatawait_range+0x8d/0xf0
> > [<0>] filemap_fdatawait_keep_errors+0x22/0x50
> > [<0>] sync_inodes_sb+0x22c/0x2d0
> > [<0>] sync_filesystem+0x70/0xb0
> > [<0>] __x64_sys_syncfs+0x4e/0xd0
> > [<0>] x64_sys_call+0x778/0x1da0
> > [<0>] do_syscall_64+0x7f/0x7b0
> > [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Yeah, no surprise, the kernel is oopsing in IO completion with the
> folio still in writeback state - nothing will ever change the state
> on that folio now, so sync operations will block forever on it.
> 
> > The kernel log from the last mount.
> > 
> > [ 7467.362544] XFS (loop0): EXPERIMENTAL metadata directory tree feature enabled.  Use at your own risk!
> > [ 7467.363481] XFS (loop0): Mounting V5 Filesystem 2b40a1e4-f2f6-4a87-8f86-bbfc8a748329
> > [ 7467.880205] XFS (loop0): Starting recovery (logdev: internal)
> > [ 7468.006067] XFS (loop0): Ending recovery (logdev: internal)
> > [ 7470.131605] buffer_io_error: 8 callbacks suppressed
> > [ 7470.131613] Buffer I/O error on dev dm-1, logical block 243952, async page read
> > [ 7470.148095] I/O error, dev loop0, sector 10071568 op 0x0:(READ) flags 0x81700 phys_seg 1 prio class 2
> > [ 7470.148145] dm-0: writeback error on inode 71, offset 239466496, sector 668620
> ....
> > [ 7470.195987] XFS (loop0): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x1fe/0x4c0 [xfs] (fs/xfs/xfs_trans_buf.c:311).  Shutting down filesystem.
> > [ 7470.200555] XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> > [ 7470.201821] XFS (loop0): Metadata corruption detected at xfs_dinode_verify.part.0+0x434/0xcb0 [xfs], inode 0x40d422 xfs_inode_item_precommit_check
> 
> So what check did this fail? Convert
> xfs_dinode_verify.part.0+0x434xfs_dinode_verify.part.0+0x434 to a
> line number and that will tell us what the actual corruption
> detected was.
> 
> > [ 7470.206186] XFS (loop0): Unmount and run xfs_repair
> > [ 7470.207577] XFS (loop0): First 128 bytes of corrupted metadata buffer:
> > [ 7470.209043] 00000000: 49 4e 81 b6 03 02 00 00 00 00 03 8b 00 00 02 1c  IN..............
> > [ 7470.210242] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 0d  ................
> > [ 7470.211633] 00000020: 36 42 da 8b dd 84 5e ec 36 42 da 8b ea d0 f9 2c  6B....^.6B.....,
> > [ 7470.212668] 00000030: 36 42 da 8b ea d0 f9 2c 00 00 00 00 00 25 b8 00  6B.....,.....%..
> > [ 7470.213878] 00000040: 00 00 00 00 00 00 03 32 00 00 00 00 00 00 00 00  .......2........
> > [ 7470.215056] 00000050: 00 00 18 01 00 00 00 00 00 00 00 02 6e b2 b8 ce  ............n...
> > [ 7470.216375] 00000060: 00 00 00 00 9f bb e2 1f 00 00 00 00 00 00 00 2f  .............../
> > [ 7470.217157] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1a  ................
> > [ 7470.218462] XFS: Assertion failed: fa == NULL, file: fs/xfs/xfs_inode_item.c, line: 62
> > [ 7470.219749] ------------[ cut here ]------------
> > [ 7470.220602] kernel BUG at fs/xfs/xfs_message.c:102!
> > [ 7470.221232] Oops: invalid opcode: 0000 [#1] SMP NOPTI
> > [ 7470.221907] CPU: 9 UID: 0 PID: 2967999 Comm: kworker/9:2 Not tainted 6.18.0-rc2.xfsRC5+ #23 PREEMPT(voluntary) 
> > [ 7470.223443] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
> > [ 7470.224773] Workqueue: xfs-conv/loop0 xfs_end_io [xfs]
> > [ 7470.225855] RIP: 0010:assfail+0x35/0x3f [xfs]
> > [ 7470.226665] Code: 89 d0 41 89 c9 48 c7 c2 98 04 a0 c0 48 89 f1 48 89 fe 48 c7 c7 48 d6 9e c0 48 89 e5 e8 a4 fd ff ff 80 3d b5 62 26 00 00 74 02 <0f> 0b 0f 0b 5d e9 91 1d ba f8 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > [ 7470.228907] RSP: 0018:ffffb2e087bcfc60 EFLAGS: 00010202
> > [ 7470.229492] RAX: 0000000000000000 RBX: ffff9e399129e400 RCX: 000000007fffffff
> > [ 7470.230298] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc09ed648
> > [ 7470.231094] RBP: ffffb2e087bcfc60 R08: 0000000000000000 R09: 000000000000000a
> > [ 7470.231871] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff9e3988311800
> > [ 7470.232670] R13: ffff9e399a358000 R14: ffff9e3c05054318 R15: ffff9e3999d0d790
> > [ 7470.233457] FS:  0000000000000000(0000) GS:ffff9e3d3e65f000(0000) knlGS:0000000000000000
> > [ 7470.234362] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 7470.235002] CR2: 00007f2f373b20d8 CR3: 0000000114904005 CR4: 0000000000772ef0
> > [ 7470.235805] PKRU: 55555554
> > [ 7470.236113] Call Trace:
> > [ 7470.236417]  <TASK>
> > [ 7470.236688]  xfs_inode_item_precommit+0x1b8/0x370 [xfs]
> > [ 7470.237601]  __xfs_trans_commit+0xba/0x410 [xfs]
> > [ 7470.238453]  xfs_trans_commit+0x3b/0x70 [xfs]
> > [ 7470.239245]  xfs_setfilesize+0xff/0x160 [xfs]
> 
> Hmmmm. I wonder. The issue was detected from IO completion
> processing.....
> 
> We've just written the in-memory inode to the buffer, calculated the
> CRC, and then we verify what we've written. Something in the dinode
> is coming out invalid, so either there is a code bug writing an
> invalid value somewhere, or the in-memory VFS/XFS inode metadata has
> been corrupted prior to this IO completion transaction commit being
> run.
> 
> Willy has been seeing unexpected transaction overruns on similar IO
> error based tests in IO completion processing that smell of
> memory corruption. These have been on 6.18-rc4-next and
> 6.18-rc4-fs-next kernels, IIUC.
> 
> Now we have a debug check of an inode in IO completion detecting
> in-memory corruption during a test that has triggered IO error
> processing on a plain 6.18-rc2 kernel
> 
> Coincidence? Maybe, but I'm is starting to think a new memory
> corruption bug has been introduced in the 6.18 merge cycle
> somewhere in the IO error processing paths....

Oh, there definitely is *something* wrong.  I turned on kasan to try to
take another stab at fixing the maple_node leak.  KASAN reported a UAF
in blkdev_put (which iirc has been reported already) in two of the VMs.
The rest of the VMs reported inode precommit errors in the UUID check
but no KASAN reports.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
