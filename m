Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB9A22A1E6
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 05:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744781407; cv=none; b=Q+yF34DN/68plK4MBSt8UaOoIrOJjzoftGsti05L7NJIU3RWdXNeuWRj+DM4xYsRLqniIXpC2jONuMgiNk6WR0L+/25vYcwiTUzd3Tjfq+Dlh9BljindtOGrjoUVZGf/CWkaFrZOExUkcYZWM5IH2NQ6/3sfDvIAzn/jKnvitfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744781407; c=relaxed/simple;
	bh=bOjz06/sczFPvtFthe1LDuVLr+tDQwNtoJ0fSZ/D2nY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jz3D0QxjKZAxaHKKB7+Lnh2xLcHQCjoE0Sin4dkCBBesrdsNMm2UXyNgBdsgB5xP0C84dbN8p8yuMapo791XZXu5JFmFibAjdyTxbibTv0cBbNVMscm8nn3OdzAMXE9L6j5j+arer2quwoGGlpC/8U0czq4iHj1b/UOwzbkju1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFLdgcxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFLdgcxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121E9C4CEE2;
	Wed, 16 Apr 2025 05:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744781407;
	bh=bOjz06/sczFPvtFthe1LDuVLr+tDQwNtoJ0fSZ/D2nY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EFLdgcxO9mxCsKwhG9BwU3cANG4ccXeK8DPEawOEG3YlPo0BV8WpWi07YcLW6H+Y/
	 x12rioXC3hgRcVp/bePUMsWl1AE4Q8/iaRFWeAPB/HZUznrWoBVBVW1IaeaVcNgH4x
	 /ZWzhBMF8Q/YHNCM+7sXJlQYYTTTbpcCjadg34DQtMtM7E7jLugfkOa0QGL9DlyPMN
	 EvaVVuCqezA6TmtDaDbO+3UXh9Dd2nEm+1l8DVSgHP6ifAcUnb9nZR/fvdVsjgD5S5
	 s+rdPM7yi+QY5FDW4qwkVKAq5CZyaiIe4fv8XLrauZx5tsgO/YsnrJ3fuMPG1bnxkE
	 yfaIuryDHVvcQ==
Date: Tue, 15 Apr 2025 22:30:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [6.15-rc2 regression] xfs: assertion failed in inode allocation
Message-ID: <20250416053006.GD25675@frogsfrogsfrogs>
References: <Z_829MY9Ob63Xg-M@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_829MY9Ob63Xg-M@dread.disaster.area>

On Wed, Apr 16, 2025 at 02:49:56PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> After upgrading to ia current TOT kernel from 6.15-rc1, I'm now
> seeing these assert failures during inode allocation when running
> check-parallel:
> 
> [  355.630225] XFS: Assertion failed: freecount == to_perag(cur->bc_group)->pagi_freecount, file: fs/xfs/libxfs/xfs_ialloc.c, line: 280

I haven't seen this assertion tripping any more than it has in the past.

But I will say that I've seen a number of other problems, like page
state corruption, null pointer derefs from the block layer, and weird
behavior from the rest of the kernel.  Turning off LBS support fixes a
lot of it.  -rc2 doesn't seem to have fixed anything over -rc1.

--D

> [  355.630301] ------------[ cut here ]------------                              
> [  355.630302] kernel BUG at fs/xfs/xfs_message.c:102!                           
> [  355.630310] Oops: invalid opcode: 0000 [#1] SMP NOPTI                         
> [  355.630315] CPU: 16 UID: 0 PID: 1167750 Comm: touch Not tainted 6.15.0-rc2-dgc+ #311 PREEMPT(full) 
> [  355.630318] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [  355.630320] RIP: 0010:assfail+0x3a/0x40                                       
> [  355.630330] Code: 89 f1 48 89 fe 48 c7 c7 bc bf ed 82 48 c7 c2 91 4e e8 82 e8 c8 fc ff ff 80 3d 01 03 51 03 01 74 09 0f 0b 5d c3 cc cc cc cc cc <0f> 0b 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
> [  355.630332] RSP: 0018:ffffc9001c75b930 EFLAGS: 00010246                       
> [  355.630335] RAX: 5e6224bd563a9c00 RBX: ffff888853518f30 RCX: 5e6224bd563a9c00 
> [  355.630336] RDX: ffffc9001c75b7f8 RSI: 000000000000000a RDI: ffffffff82edbfbc 
> [  355.630337] RBP: ffffc9001c75b930 R08: 0000000000000000 R09: 000000000000000a 
> [  355.630338] R10: 0000000000000000 R11: 0000000000000021 R12: 0000000000000000 
> [  355.630339] R13: 0000000000000000 R14: ffffc9001c75b948 R15: ffffc9001c75b944 
> [  355.630341] FS:  00007f07d8216740(0000) GS:ffff88909a489000(0000) knlGS:0000000000000000
> [  355.630343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                 
> [  355.630345] CR2: 00007f07d82fbca0 CR3: 0000000905200000 CR4: 0000000000350ef0 
> [  355.630348] Call Trace:                                                       
> [  355.630351]  <TASK>                                                           
> [  355.630353]  xfs_check_agi_freecount+0xf1/0x100                               
> [  355.630358]  xfs_dialloc_ag_inobt+0xd5/0x8a0                                  
> [  355.630360]  ? xfs_ialloc_read_agi+0x43/0x1b0                                 
> [  355.630362]  xfs_dialloc+0x362/0x8e0                                          
> [  355.630363]  ? xfs_trans_alloc+0x13c/0x240                                    
> [  355.630368]  ? xfs_trans_alloc_icreate+0xa0/0x150                             
> [  355.630370]  xfs_create+0x1d4/0x430                                           
> [  355.630374]  ? __get_acl+0x29/0x1d0                                           
> [  355.630379]  xfs_generic_create+0x141/0x3e0                                   
> [  355.630381]  xfs_vn_create+0x14/0x20                                          
> [  355.630382]  path_openat+0x50e/0xe30                                          
> [  355.630386]  do_filp_open+0xbc/0x170                                          
> [  355.630388]  ? kmem_cache_alloc_noprof+0x188/0x320                            
> [  355.630393]  ? getname_flags+0x47/0x1e0                                       
> [  355.630395]  ? _raw_spin_unlock+0xe/0x30                                      
> [  355.630400]  ? alloc_fd+0x165/0x190                                           
> [  355.630404]  do_sys_openat2+0x75/0xd0                                         
> [  355.630407]  __x64_sys_openat+0x7d/0xa0                                       
> [  355.630408]  x64_sys_call+0x1b2/0x2f60                                        
> [  355.630413]  do_syscall_64+0x68/0x130                                         
> [  355.630415]  ? exc_page_fault+0x62/0xc0                                       
> [  355.630419]  entry_SYSCALL_64_after_hwframe+0x76/0x7e                         
> [  355.630420] RIP: 0033:0x7f07d831bc7c                                          
> [  355.630423] Code: 83 e2 40 75 51 89 f0 f7 d0 a9 00 00 41 00 74 46 80 3d f7 c3 0e 00 00 74 6a 89 da 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 90 00 00 00 48 8b 54 24 28 64 48 2b 14 25              
> [  355.630424] RSP: 002b:00007fffaddfbdc0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
> [  355.630426] RAX: ffffffffffffffda RBX: 0000000000000941 RCX: 00007f07d831bc7c 
> [  355.630427] RDX: 0000000000000941 RSI: 00007fffaddfe3c3 RDI: 00000000ffffff9c 
> [  355.630427] RBP: 00007fffaddfe3c3 R08: 0000000000000000 R09: 0000000000000000 
> [  355.630428] R10: 00000000000001b6 R11: 0000000000000202 R12: 000055ed247bfb50 
> [  355.630429] R13: 000055ed247be11f R14: 00007fffaddfe3c3 R15: 0000000000000000 
> [  355.630430]  </TASK>                                                          
> 
> I'm running on x86-64, using mkfs defaults (4k block size) and no
> mount options on the test/scratch devices, so this is as normal a
> configuration as you can get. I see this at least every second high
> concurrency run, but I haven't been able to isolate which test(s)
> are causing it because the failure either does not occur or some
> other block device related weirdness crops up when I run the tests
> sequentially in a single task context.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
