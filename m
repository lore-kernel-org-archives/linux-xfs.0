Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727BE23C8A0
	for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2026 06:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788847658; cv=none; b=GvFJk+cg5JR818htESuifllzTFgKR31f+l7Hl4XHVBN8Nz0E4zixkg9crmabo8QbAAzrhsM3YzvynlyJAmH8+U/Or4G9wHPW2a6+nBDBL0kbJhQ+4rVs44QVO0MBzI2NKOxoZJHpQ3wsLMCdC7u7azxO4sFodBMEg33aQ7OAQfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788847658; c=relaxed/simple;
	bh=xEWvVVpRa7bv+GOZJewQ/JX/s/kmhuDK6X/7ZhEGQWs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=V7e6Yr1vfoUPNr/34YFsnELzXp9Me3q3ux9IshEHkqVi1siKXiT5VugaAlA849I/w9Yop4GOWHpZyFzWIX8G9cjf1YUyQp02DbYUdBig7UsU8fMWePbWT4iAkjhrMfeBY8unUijYKZakSoGq5CrdFsaxdtki0dIaZheEAiRvJkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByiXQmXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByiXQmXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCF81F00A3D;
	Tue,  8 Sep 2026 06:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788847657;
	bh=0XHyPQnB3MMMrTNwfgAqeSwHarXrXeAN9WMT8FJQlcI=;
	h=Date:From:To:Cc:Subject;
	b=ByiXQmXM769bhIPOaBLX/qphL8h8VI8y1/Du3YgurrxF1JI+ktg33SKROQGFbuoms
	 0/zsumziT4X0XqeV9bwNhTDF63PiOD32KYqvNhrkSjg5tacLbRUid7JU16A8Mc2Rnn
	 TJcUsRWxU8hMXsJiYUYIBbgmNNI0U9ntJTvf66Vrfsgm5S86Uo9089CnqMVS0ki7B2
	 FXdchzSYJXQMUAEROhbrzFSRI5CRjbIsLeP4YIcHtPJLTYtMtubaSSdKoTacqVvxs/
	 QgFEkHQ8uAq4lg5GnfQKMnm14LLjCTbJxSCardCtJOrx/G7nN7Lr1W/eW2HAo6kk/u
	 zOqTm6oIPaxeQ==
Date: Tue, 8 Sep 2026 16:07:28 +1000
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Javier Tia <floss@jetm.me>, "Darrick J. Wong" <djwong@kernel.org>
Subject: [bug v7.3-rc2] dabtree block accounting assertion failure in xfs/286
Message-ID: <ap-mIH9nTNkpWq9K@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

I was just running fstests on a current for-next tree w/ 1kB block
size and xfs/286 failed with this assert failure:

[ 5720.261905] run fstests xfs/286 at 2026-09-08 02:42:32
[ 5720.382012] XFS (loop0): Mounting V5 Filesystem aaab8bad-f78e-4b15-90af-934da55632d5
[ 5720.384253] XFS (loop0): Ending clean mount
[ 5720.703809] XFS (loop1): Mounting V5 Filesystem f74932e0-a70e-42e4-8383-07b59a89c978
[ 5720.704963] XFS (loop1): Ending clean mount
** replaying previous printk message **
[ 5725.316568] XFS: Assertion failed: args->total >= dp->i_nblocks - nblks, file: fs/xfs/libxfs/xfs_da_btree.c, line: 2387
[ 5725.316628] ------------[ cut here ]------------
[ 5725.316629] kernel BUG at fs/xfs/xfs_message.c:102!
[ 5725.316638] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[ 5725.319916] CPU: 7 UID: 0 PID: 516939 Comm: xfs_scrub Not tainted 7.3.0-rc2+ #28 PREEMPT(lazy) 
[ 5725.320388] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-10.fc44 06/10/2025
[ 5725.320844] RIP: 0010:assfail+0x31/0x3a [xfs]
[ 5725.321292] Code: 00 00 49 89 d0 41 89 c9 48 c7 c2 c8 3f 3e c1 48 89 f1 48 89 fe 48 c7 c7 13 1a 3d c1 e8 b8 fd ff ff 80 3d 99 98 04 00 00 74 02 <0f> 0b 0f 0b c3 cc cc cc cc 48 8d 45 10 48 89 e2 48 89 de 4c 89 34
[ 5725.322406] RSP: 0018:ffffca7ec1e8b810 EFLAGS: 00010202
[ 5725.322713] RAX: 0000000000000000 RBX: ffffca7ec1e8b9c0 RCX: 00000000ffffffd1
[ 5725.323216] RDX: 0000000000000000 RSI: 0000000000000021 RDI: ffffffffc13d1a13
[ 5725.323686] RBP: ffff89bf97f82940 R08: 0fffffffffffffff R09: 0000000000000000
[ 5725.324140] R10: 000000000000000a R11: 000000000000000a R12: 0000000000000001
[ 5725.324604] R13: 0000000000000004 R14: ffffca7ec1e8b8b0 R15: ffffca7ec1e8b848
[ 5725.325058] FS:  00007f6b163fe680(0000) GS:ffff89c01b93c000(0000) knlGS:0000000000000000
[ 5725.325595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5725.325980] CR2: 0000555c1d393a28 CR3: 00000001096ca002 CR4: 0000000000772ef0
[ 5725.326422] PKRU: 55555554
[ 5725.326626] Call Trace:
[ 5725.326809]  <TASK>
[ 5725.326969]  xfs_da_grow_inode_int+0x31c/0x340 [xfs]
[ 5725.327467]  xfs_dir2_grow_inode+0x69/0x140 [xfs]
[ 5725.327939]  xfs_dir2_sf_to_block+0x143/0x800 [xfs]
[ 5725.328417]  xrep_dir_swap_prep+0x134/0x170 [xfs]
[ 5725.328846]  xrep_dir_swap+0x117/0x350 [xfs]
[ 5725.329258]  xrep_dir_rebuild_tree+0xa1/0x100 [xfs]
[ 5725.329687]  xrep_directory+0x8f/0x1c0 [xfs]
[ 5725.330132]  xrep_attempt+0x63/0x210 [xfs]
[ 5725.330701]  xfs_scrub_metadata+0x414/0x650 [xfs]
[ 5725.331311]  xfs_ioc_scrubv_metadata+0x384/0x610 [xfs]
[ 5725.331943]  xfs_file_ioctl+0x606/0xf30 [xfs]
[ 5725.332546]  ? do_syscall_64+0xfe/0x560
[ 5725.332883]  __x64_sys_ioctl+0xb9/0x100
[ 5725.333227]  ? do_syscall_64+0xfe/0x560
[ 5725.333564]  do_syscall_64+0xc1/0x560
[ 5725.333887]  ? xfs_ioc_getparents_by_handle+0x168/0x190 [xfs]
[ 5725.334623]  ? __pfx_xfs_getparents_put_listent+0x10/0x10 [xfs]
[ 5725.335352]  ? xfs_file_ioctl+0x6ba/0xf30 [xfs]
[ 5725.335946]  ? do_syscall_64+0xfe/0x560
[ 5725.336279]  ? do_syscall_64+0xfe/0x560
[ 5725.336607]  ? __x64_sys_ioctl+0xd4/0x100
[ 5725.336948]  ? do_syscall_64+0xfe/0x560
[ 5725.337275]  ? do_syscall_64+0x37/0x560
[ 5725.337603]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Standard fstests, stock xfsprogs from debian unstable (7.1.0 IIRC),
only mkfs parameter that was non-default was '-b size=1k'. I did not
see this on 7.2.0, so it seems like a recent regression.

Ok, that'll be the cause:

$ gl -n 1 -p 0fe77e57588b9
commit 0fe77e57588b989450d668f7c978bb0264c5c340
Author: Javier Tia <javier@peridio.com>
Date:   Mon Aug 10 17:06:18 2026 -0600

    xfs: assert the reservation covers each da fork growth

    xfs_da_grow_inode_int() subtracts the blocks it just allocated from
    args->total, the caller's remaining block reservation.  The subtraction
    is unsigned, so a caller that reaches it with too small a total wraps
    the field instead of failing, and every allocation afterwards runs with
    a bogus reservation.  Assert the remaining reservation still covers the
    step, so an under-reserved or uninitialised total trips in debug builds
    instead of silently wrapping.

    Suggested-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Javier Tia <floss@jetm.me>
    Reviewed-by: Darrick J. Wong <djwong@kernel.org>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 7938d2324e87..8cbdd6574755 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2384,6 +2384,7 @@ xfs_da_grow_inode_int(
        }

        /* account for newly allocated blocks in reserved blocks total */
+       ASSERT(args->total >= dp->i_nblocks - nblks);
        args->total -= dp->i_nblocks - nblks;

 out_free_map:

Javier, Darrick, over to you...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
