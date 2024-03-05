Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745151803A
	for <linux-xfs@vger.kernel.org>; Tue,  5 Mar 2024 05:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709615088; cv=none; b=rY4v7+zaHzRjrSJGKL3RFU61HWFISt4fig+DXhKUyXhGYJbLzjG/8GAh7CWl5a656sUKVElVn+tuI3QaySkQ12n3bBMe5Oyb2VBJoRyPhpIrn3JGYYNZhJsJ6buFZQXWxU8uNZPqc4VnrH5h6AqbKUPc0u7hmlmkD86VyfumDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709615088; c=relaxed/simple;
	bh=7lp5vAwdfstSj69E6JNxOqR742fYUsPqED+FLGuz2Ww=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aGXNJoKtuegsI7kU8KhSmIRrPgdmvxbkXe0e1xSuz+md5QdK6jnh5kEDYviBzoByzu10eCJrvgplbzX3ooyy4e4B24q0VWfCjaz7qrxE/RGmJCpX2v0LB9WNxpb7MM5/d6JtWnIjv1qmu+Bc/Q/7AZ84qpIj4oXT/WJWVVogTHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYbADKAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYbADKAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380D4C433C7
	for <linux-xfs@vger.kernel.org>; Tue,  5 Mar 2024 05:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709615087;
	bh=7lp5vAwdfstSj69E6JNxOqR742fYUsPqED+FLGuz2Ww=;
	h=From:To:Subject:Date:From;
	b=dYbADKAegwIPmEynDw/BOw8uGRuct+E1vim3R1pY/kzWNJLwKNgBDocTr+2a2sbad
	 6Gof420koTFg15YSEKQ+LPMRA+da+eZ9OumFx+eYicZ9f9wRlmRPTc6OSo6guai6Kt
	 1rKyJ86wDl3/RpZk2S0vaEXg6PUXYjKyJTi3PAQBTBQHQNmOcjHy1WISDy9OhmOxkT
	 uUg0sPndCU7klTr6JOdTclm6mawjatrvx/2H1kGrePReQ9xqukwGv+e2KEp8GUnOHo
	 ZT7qj2C53Rdq40qQrCNP1WCLLxQXeaBXJcZHKuKye8DBRX9z6a/Ysfs5Nyy2HF61jo
	 MkTH1x7FfVpeg==
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [BUG REPORT] Deadlock when executing xfs/168 on XFS' previous for-next
Date: Tue, 05 Mar 2024 10:18:45 +0530
Message-ID: <87frx5mfqi.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

I noticed the following call trace when executing xfs/168 on XFS' for-next
as on 3rd March. The top most commit was,

    commit 601f8bc2440a25a386b1283ce15330c9ea3aaa07
    Merge: 8d4dd9d741c3 27c86d43bcdb
    Author: Chandan Babu R <chandanbabu@kernel.org>
    Date:   Thu Feb 29 10:01:16 2024 +0530
    
        Merge tag 'xfs-6.8-fixes-4' into xfs-for-next
    
        Changes for 6.8-rc7:
    
          * Drop experimental warning for FSDAX.
    
        Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>

The fstests configuration file used was,

    TEST_DEV=/dev/loop16
    SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11 /dev/loop12"
    MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -d su=128k,sw=4'
    MOUNT_OPTIONS='-o usrquota,grpquota,prjquota'
    TEST_FS_MOUNT_OPTS="$TEST_FS_MOUNT_OPTS -o usrquota,grpquota,prjquota"
    USE_EXTERNAL=no
    LOGWRITES_DEV=/dev/loop15

Three tasks (i.e. 230900, 230901 and 230919) are blocked on
trying to lock AG 1's AGI and one task (i.e. 230902) is blocked on trying to
lock AG 1's AGF.

I have not been able to recreate the problem though.


[18444.642513] run fstests xfs/168 at 2024-03-03 15:26:09
[18445.197592] XFS (loop16): Mounting V5 Filesystem cabf23c7-326a-4664-9af6-e3910f485f96
[18445.215014] XFS (loop16): Ending clean mount
[18445.794439] XFS (loop5): Mounting V5 Filesystem dfa6ae65-8df4-4314-9397-ddf4b552e66c
[18445.806890] XFS (loop5): Ending clean mount
[18445.809393] XFS (loop5): Quotacheck needed: Please wait.
[18445.821641] XFS (loop5): Quotacheck: Done.
[18445.833753] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18445.847170] XFS (loop5): Unmounting Filesystem dfa6ae65-8df4-4314-9397-ddf4b552e66c
[18446.046156] XFS (loop5): Mounting V5 Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18446.058191] XFS (loop5): Ending clean mount
[18446.060376] XFS (loop5): Quotacheck needed: Please wait.
[18446.071858] XFS (loop5): Quotacheck: Done.
[18447.115270] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18447.169269] XFS (loop5): Unmounting Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18447.257627] XFS (loop5): Mounting V5 Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18447.274547] XFS (loop5): Ending clean mount
[18448.293957] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18448.481253] XFS (loop5): Unmounting Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18448.578741] XFS (loop5): Mounting V5 Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18448.593139] XFS (loop5): Ending clean mount
[18449.614367] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18449.809667] XFS (loop5): Unmounting Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18449.915102] XFS (loop5): Mounting V5 Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18449.927011] XFS (loop5): Ending clean mount
[18450.946462] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18451.173261] XFS (loop5): Unmounting Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18451.296348] XFS (loop5): Mounting V5 Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18451.310498] XFS (loop5): Ending clean mount
[18452.332334] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18452.537940] XFS (loop5): Unmounting Filesystem 216ac556-4f80-48ce-a0aa-a5307d37371e
[18452.919998] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18452.932107] XFS (loop5): Ending clean mount
[18452.934248] XFS (loop5): Quotacheck needed: Please wait.
[18452.946139] XFS (loop5): Quotacheck: Done.
[18453.991406] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18454.047375] XFS (loop5): Unmounting Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18454.132465] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18454.146569] XFS (loop5): Ending clean mount
[18455.167787] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18455.224962] XFS (loop5): Unmounting Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18455.337260] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18455.351028] XFS (loop5): Ending clean mount
[18456.372617] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18456.442288] XFS (loop5): Unmounting Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18456.544670] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18456.556827] XFS (loop5): Ending clean mount
[18457.577934] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18457.831311] XFS (loop5): Unmounting Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18457.947305] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18457.958781] XFS (loop5): Ending clean mount
[18458.982874] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18459.162722] XFS (loop5): Unmounting Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18459.292885] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18459.305733] XFS (loop5): Ending clean mount
[18460.329212] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18460.561010] XFS (loop5): Unmounting Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18460.730782] XFS (loop5): Mounting V5 Filesystem 68e1b71a-583f-41c8-8194-bb82c4e2fe0d
[18460.742765] XFS (loop5): Ending clean mount
[18461.786504] XFS (loop5): EXPERIMENTAL online shrink feature in use. Use at your own risk!
[18679.145200] INFO: task fsstress:230900 blocked for more than 122 seconds.
[18679.147164]       Tainted: G        W          6.8.0-rc6+ #1
[18679.148710] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[18679.150423] task:fsstress        state:D stack:0     pid:230900 tgid:230900 ppid:230899 flags:0x00000002
[18679.152186] Call Trace:
[18679.153257]  <TASK>
[18679.154307]  __schedule+0x69c/0x17a0
[18679.155486]  ? __pfx___schedule+0x10/0x10
[18679.156804]  ? xfs_vn_setattr+0xf3/0x240 [xfs]
[18679.158205]  ? orc_find.part.0+0x1eb/0x370
[18679.159456]  ? is_bpf_text_address+0x23/0x30
[18679.160855]  ? kernel_text_address+0xce/0xe0
[18679.162081]  schedule+0x80/0x230
[18679.163168]  schedule_timeout+0x259/0x2a0
[18679.164354]  ? __pfx_schedule_timeout+0x10/0x10
[18679.165676]  ? xfs_vn_symlink+0x15c/0x3d0 [xfs]
[18679.167041]  ? xfs_vn_symlink+0x15c/0x3d0 [xfs]
[18679.168457]  ___down_common+0x207/0x390
[18679.169670]  ? __pfx____down_common+0x10/0x10
[18679.170808]  ? __raw_spin_lock_irqsave+0x8d/0xf0
[18679.171968]  __down_common+0x22/0x1b0
[18679.173032]  ? xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.174407]  down+0x71/0xa0
[18679.175442]  xfs_buf_lock+0xa4/0x290 [xfs]
[18679.176816]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.178119]  ? arch_stack_walk+0xa2/0x100
[18679.179246]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
[18679.180683]  ? __pfx_xfs_buf_lookup.constprop.0+0x10/0x10 [xfs]
[18679.182127]  ? stack_trace_save+0x95/0xd0
[18679.183248]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
[18679.184531]  ? kasan_save_stack+0x34/0x50
[18679.185672]  ? kasan_save_stack+0x24/0x50
[18679.186727]  ? __pfx_xfs_buf_get_map+0x10/0x10 [xfs]
[18679.188020]  ? xfs_trans_alloc_dqinfo+0x39/0x80 [xfs]
[18679.189309]  ? xfs_trans_dqresv+0x1a5/0xda0 [xfs]
[18679.190618]  ? xfs_trans_reserve_quota_bydquots+0x90/0x1b0 [xfs]
[18679.191945]  ? xfs_trans_reserve_quota_icreate+0x88/0xe0 [xfs]
[18679.193335]  ? xfs_vn_symlink+0x15d/0x3d0 [xfs]
[18679.194585]  ? vfs_symlink+0x35a/0x5a0
[18679.195676]  ? do_symlinkat+0x1f3/0x260
[18679.196660]  ? __x64_sys_symlink+0x79/0xa0
[18679.197631]  ? do_syscall_64+0x6a/0x180
[18679.198661]  xfs_buf_read_map+0xbb/0x900 [xfs]
[18679.199812]  ? xfs_read_agi+0x1cd/0x500 [xfs]
[18679.200929]  ? kasan_save_stack+0x34/0x50
[18679.201879]  ? kasan_save_stack+0x24/0x50
[18679.202851]  ? kasan_save_track+0x14/0x30
[18679.203753]  ? __pfx_xfs_buf_read_map+0x10/0x10 [xfs]
[18679.205002]  ? xfs_trans_alloc_icreate+0xa8/0x1a0 [xfs]
[18679.206208]  ? xfs_symlink+0x562/0xdc0 [xfs]
[18679.207324]  ? xfs_vn_symlink+0x15d/0x3d0 [xfs]
[18679.208477]  ? vfs_symlink+0x35a/0x5a0
[18679.209417]  ? do_symlinkat+0x1f3/0x260
[18679.210318]  ? __x64_sys_symlink+0x79/0xa0
[18679.211226]  ? do_syscall_64+0x6a/0x180
[18679.212007]  ? entry_SYSCALL_64_after_hwframe+0x6e/0x76
[18679.212987]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
[18679.214112]  ? xfs_read_agi+0x1cd/0x500 [xfs]
[18679.215192]  ? __pfx_xfs_trans_read_buf_map+0x10/0x10 [xfs]
[18679.216401]  ? xlog_grant_head_check+0x169/0x450 [xfs]
[18679.217609]  ? kmem_cache_alloc+0x156/0x390
[18679.218573]  ? __pfx_xlog_grant_head_check+0x10/0x10 [xfs]
[18679.219754]  xfs_read_agi+0x1cd/0x500 [xfs]
[18679.221051]  ? xfs_trans_alloc_dqinfo+0x39/0x80 [xfs]
[18679.222230]  ? __pfx_xfs_read_agi+0x10/0x10 [xfs]
[18679.223431]  ? __pfx_mutex_unlock+0x10/0x10
[18679.224471]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
[18679.225625]  ? xfs_trans_dqresv+0x2b0/0xda0 [xfs]
[18679.226701]  ? __pfx_xfs_ialloc_read_agi+0x10/0x10 [xfs]
[18679.227863]  xfs_dialloc+0x60e/0xbc0 [xfs]
[18679.228899]  ? __pfx_xfs_dialloc+0x10/0x10 [xfs]
[18679.230019]  ? down_write+0xb8/0x140
[18679.230909]  ? __pfx_down_write+0x10/0x10
[18679.231823]  ? xfs_dir_lookup+0x6e5/0xa00 [xfs]
[18679.232961]  xfs_symlink+0x855/0xdc0 [xfs]
[18679.234015]  ? __pfx_xfs_symlink+0x10/0x10 [xfs]
[18679.235196]  ? avc_has_perm+0x91/0x130
[18679.236079]  ? __pfx_avc_has_perm+0x10/0x10
[18679.236970]  ? __d_alloc+0x31/0x8e0
[18679.237828]  ? may_create+0x293/0x310
[18679.238776]  xfs_vn_symlink+0x15d/0x3d0 [xfs]
[18679.239835]  ? __pfx_xfs_vn_symlink+0x10/0x10 [xfs]
[18679.240925]  ? generic_permission+0xcd/0x4c0
[18679.241843]  ? from_kgid+0x88/0xd0
[18679.242688]  vfs_symlink+0x35a/0x5a0
[18679.243535]  do_symlinkat+0x1f3/0x260
[18679.244410]  ? __pfx_do_symlinkat+0x10/0x10
[18679.245395]  ? getname_flags.part.0+0xb9/0x450
[18679.246400]  __x64_sys_symlink+0x79/0xa0
[18679.247316]  do_syscall_64+0x6a/0x180
[18679.248202]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[18679.249273] RIP: 0033:0x7f3d1863eabb
[18679.250109] RSP: 002b:00007ffcf92ed008 EFLAGS: 00000206 ORIG_RAX: 0000000000000058
[18679.251470] RAX: ffffffffffffffda RBX: 00007ffcf92ed170 RCX: 00007f3d1863eabb
[18679.252711] RDX: 00000000000002cb RSI: 00000000016697e0 RDI: 00000000016522b0
[18679.254038] RBP: 00000000016697e0 R08: 000000000000006d R09: 0000000000000030
[18679.255386] R10: 0000000000000001 R11: 0000000000000206 R12: 0000000000000396
[18679.256629] R13: 00000000016522b0 R14: 00000000016522b0 R15: 00007f3d1880e6c0
[18679.257867]  </TASK>
[18679.258633] INFO: task fsstress:230901 blocked for more than 122 seconds.
[18679.260151]       Tainted: G        W          6.8.0-rc6+ #1
[18679.261337] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[18679.262738] task:fsstress        state:D stack:0     pid:230901 tgid:230901 ppid:230899 flags:0x00000002
[18679.264387] Call Trace:
[18679.265231]  <TASK>
[18679.266005]  __schedule+0x69c/0x17a0
[18679.266932]  ? __pfx___schedule+0x10/0x10
[18679.267880]  ? xfs_btree_check_ptr+0x25/0x450 [xfs]
[18679.269210]  schedule+0x80/0x230
[18679.270063]  schedule_timeout+0x259/0x2a0
[18679.270965]  ? __pfx_schedule_timeout+0x10/0x10
[18679.272007]  ? xfs_btree_insert+0x238/0x6d0 [xfs]
[18679.273203]  ? xfs_generic_create+0x46e/0x600 [xfs]
[18679.274414]  ? xfs_generic_create+0x46e/0x600 [xfs]
[18679.275656]  ___down_common+0x207/0x390
[18679.276628]  ? __pfx____down_common+0x10/0x10
[18679.277646]  ? __raw_spin_lock_irqsave+0x8d/0xf0
[18679.278730]  ? __pfx___raw_spin_lock_irqsave+0x10/0x10
[18679.279903]  __down_common+0x22/0x1b0
[18679.280866]  ? xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.282122]  down+0x71/0xa0
[18679.282962]  xfs_buf_lock+0xa4/0x290 [xfs]
[18679.284134]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.285249]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
[18679.286567]  ? __pfx_xfs_buf_lookup.constprop.0+0x10/0x10 [xfs]
[18679.287895]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
[18679.289085]  ? kasan_save_stack+0x34/0x50
[18679.290062]  ? __pfx_xfs_buf_get_map+0x10/0x10 [xfs]
[18679.291360]  ? kmem_cache_alloc+0x13b/0x390
[18679.292368]  ? xfs_trans_mod_dquot+0x4e6/0x730 [xfs]
[18679.293658]  ? xfs_trans_dqresv+0x1a5/0xda0 [xfs]
[18679.294879]  ? xfs_trans_reserve_quota_bydquots+0x90/0x1b0 [xfs]
[18679.296212]  ? xfs_create+0x57a/0xf60 [xfs]
[18679.297377]  ? xfs_generic_create+0x46f/0x600 [xfs]
[18679.298704]  ? vfs_mknod+0x45a/0x740
[18679.299659]  ? do_mknodat+0x27b/0x4d0
[18679.300697]  ? __x64_sys_mknodat+0xb5/0xf0
[18679.301750]  xfs_buf_read_map+0xbb/0x900 [xfs]
[18679.302955]  ? xfs_read_agi+0x1cd/0x500 [xfs]
[18679.304060]  ? kasan_save_stack+0x34/0x50
[18679.305100]  ? kasan_save_stack+0x24/0x50
[18679.306059]  ? __pfx_xfs_buf_read_map+0x10/0x10 [xfs]
[18679.307298]  ? xfs_trans_alloc+0x36d/0x780 [xfs]
[18679.308459]  ? xfs_trans_alloc_icreate+0xa8/0x1a0 [xfs]
[18679.309700]  ? xfs_create+0x57a/0xf60 [xfs]
[18679.310828]  ? xfs_generic_create+0x46f/0x600 [xfs]
[18679.312018]  ? vfs_mknod+0x45a/0x740
[18679.312925]  ? do_mknodat+0x27b/0x4d0
[18679.313830]  ? __x64_sys_mknodat+0xb5/0xf0
[18679.314782]  ? do_syscall_64+0x6a/0x180
[18679.315706]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
[18679.316842]  ? xfs_read_agi+0x1cd/0x500 [xfs]
[18679.317950]  ? __pfx_xfs_trans_read_buf_map+0x10/0x10 [xfs]
[18679.319126]  ? xlog_grant_head_check+0x169/0x450 [xfs]
[18679.320326]  ? __pfx_xlog_grant_head_check+0x10/0x10 [xfs]
[18679.321739]  xfs_read_agi+0x1cd/0x500 [xfs]
[18679.322808]  ? kmem_cache_alloc+0x156/0x390
[18679.323726]  ? xfs_trans_alloc_dqinfo+0x39/0x80 [xfs]
[18679.324917]  ? __pfx_xfs_read_agi+0x10/0x10 [xfs]
[18679.326107]  ? __pfx_mutex_unlock+0x10/0x10
[18679.326984]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
[18679.328129]  ? xfs_trans_dqresv+0x2b0/0xda0 [xfs]
[18679.329318]  ? __pfx_xfs_ialloc_read_agi+0x10/0x10 [xfs]
[18679.330566]  xfs_dialloc+0x60e/0xbc0 [xfs]
[18679.331654]  ? __pfx_xfs_dialloc+0x10/0x10 [xfs]
[18679.332798]  ? down_write+0xb8/0x140
[18679.333690]  ? __pfx_down_write+0x10/0x10
[18679.334623]  ? kasan_save_free_info+0x3f/0x60
[18679.335605]  xfs_create+0x5d9/0xf60 [xfs]
[18679.336668]  ? __pfx_xfs_create+0x10/0x10 [xfs]
[18679.337807]  ? __pfx_xfs_dir_lookup+0x10/0x10 [xfs]
[18679.338990]  ? avc_has_perm_noaudit+0x8b/0x130
[18679.339981]  ? get_cached_acl+0x172/0x1e0
[18679.340928]  ? __pfx_get_cached_acl+0x10/0x10
[18679.341883]  ? avc_has_perm+0x91/0x130
[18679.342766]  ? __pfx_avc_has_perm+0x10/0x10
[18679.343710]  xfs_generic_create+0x46f/0x600 [xfs]
[18679.344808]  ? __pfx_xfs_generic_create+0x10/0x10 [xfs]
[18679.345978]  ? selinux_inode_permission+0x294/0x3f0
[18679.346983]  ? generic_permission+0xcd/0x4c0
[18679.347946]  ? security_inode_mknod+0x8d/0xf0
[18679.348897]  vfs_mknod+0x45a/0x740
[18679.349783]  do_mknodat+0x27b/0x4d0
[18679.350707]  ? __pfx_do_mknodat+0x10/0x10
[18679.351642]  ? getname_flags.part.0+0xb9/0x450
[18679.352615]  __x64_sys_mknodat+0xb5/0xf0
[18679.353622]  do_syscall_64+0x6a/0x180
[18679.354541]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[18679.355662] RIP: 0033:0x7f3d1873e2a5
[18679.356612] RSP: 002b:00007ffcf92ecff8 EFLAGS: 00000246 ORIG_RAX: 0000000000000103
[18679.357869] RAX: ffffffffffffffda RBX: 00007ffcf92ed170 RCX: 00007f3d1873e2a5
[18679.359175] RDX: 0000000000002124 RSI: 000000000164aa70 RDI: 00000000ffffff9c
[18679.360401] RBP: 0000000000002124 R08: 0000000000000020 R09: 0000000000000020
[18679.361614] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000002e7
[18679.362863] R13: 0000000000000000 R14: 0000000000406800 R15: 00007f3d1880e6c0
[18679.364119]  </TASK>
[18679.364871] INFO: task fsstress:230902 blocked for more than 123 seconds.
[18679.366049]       Tainted: G        W          6.8.0-rc6+ #1
[18679.367018] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[18679.368160] task:fsstress        state:D stack:0     pid:230902 tgid:230902 ppid:230899 flags:0x00000002
[18679.369871] Call Trace:
[18679.370678]  <TASK>
[18679.371538]  __schedule+0x69c/0x17a0
[18679.372585]  ? __pfx___raw_spin_lock_irqsave+0x10/0x10
[18679.373665]  ? __pfx___schedule+0x10/0x10
[18679.374669]  ? xfs_buf_lock+0xa4/0x290 [xfs]
[18679.375827]  ? xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.376994]  schedule+0x80/0x230
[18679.377873]  schedule_timeout+0x259/0x2a0
[18679.378858]  ? __pfx_schedule_timeout+0x10/0x10
[18679.379851]  ? xfs_vn_rename+0x24f/0x410 [xfs]
[18679.381010]  ? xfs_vn_rename+0x24f/0x410 [xfs]
[18679.382187]  ? __module_address.part.0+0x22/0x190
[18679.383256]  ? xfs_vn_rename+0x24f/0x410 [xfs]
[18679.384496]  ___down_common+0x207/0x390
[18679.385539]  ? __pfx____down_common+0x10/0x10
[18679.386650]  ? __raw_spin_lock_irqsave+0x8d/0xf0
[18679.387700]  ? __pfx___raw_spin_lock_irqsave+0x10/0x10
[18679.388747]  __down_common+0x22/0x1b0
[18679.389677]  ? xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.390879]  down+0x71/0xa0
[18679.391730]  xfs_buf_lock+0xa4/0x290 [xfs]
[18679.392845]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.394012]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
[18679.395261]  ? __pfx_xfs_buf_lookup.constprop.0+0x10/0x10 [xfs]
[18679.396643]  ? unwind_get_return_address+0x5e/0xa0
[18679.397685]  ? arch_stack_walk+0xa2/0x100
[18679.398640]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
[18679.400173]  ? xfs_vn_rename+0x24f/0x410 [xfs]
[18679.402257]  ? xfs_vn_rename+0x24f/0x410 [xfs]
[18679.404157]  ? __pfx_xfs_buf_get_map+0x10/0x10 [xfs]
[18679.406300]  ? xfs_vn_rename+0x24f/0x410 [xfs]
[18679.408197]  ? __module_address.part.0+0x22/0x190
[18679.410101]  ? xfs_generic_create+0x46e/0x600 [xfs]
[18679.412264]  ? xfs_generic_create+0x46e/0x600 [xfs]
[18679.414394]  xfs_buf_read_map+0xbb/0x900 [xfs]
[18679.415862]  ? xfs_read_agf+0x1be/0x4d0 [xfs]
[18679.416978]  ? __pfx_xfs_buf_read_map+0x10/0x10 [xfs]
[18679.419072]  ? is_bpf_text_address+0x23/0x30
[18679.420348]  ? kernel_text_address+0xce/0xe0
[18679.421339]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
[18679.422649]  ? xfs_read_agf+0x1be/0x4d0 [xfs]
[18679.423729]  ? __pfx_xfs_trans_read_buf_map+0x10/0x10 [xfs]
[18679.424920]  ? __raw_spin_lock_irqsave+0x8d/0xf0
[18679.425923]  ? __pfx___raw_spin_lock_irqsave+0x10/0x10
[18679.426929]  xfs_read_agf+0x1be/0x4d0 [xfs]
[18679.427974]  ? _raw_spin_unlock_irqrestore+0xe/0x40
[18679.428962]  ? stack_depot_save_flags+0x349/0x4b0
[18679.429915]  ? __pfx_xfs_read_agf+0x10/0x10 [xfs]
[18679.430980]  ? kasan_save_stack+0x34/0x50
[18679.431980]  xfs_alloc_read_agf+0xdf/0xf90 [xfs]
[18679.433060]  ? xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
[18679.434199]  ? xfs_dialloc+0x60e/0xbc0 [xfs]
[18679.435339]  ? xfs_create+0x5d9/0xf60 [xfs]
[18679.436411]  ? xfs_generic_create+0x46f/0x600 [xfs]
[18679.437583]  ? vfs_mknod+0x45a/0x740
[18679.438553]  ? __pfx_xfs_alloc_read_agf+0x10/0x10 [xfs]
[18679.439743]  ? xfs_alloc_space_available+0x133/0x3d0 [xfs]
[18679.441008]  xfs_alloc_fix_freelist+0x7f2/0x970 [xfs]
[18679.442181]  ? __pfx_xfs_buf_lookup.constprop.0+0x10/0x10 [xfs]
[18679.443540]  ? __pfx_xfs_alloc_fix_freelist+0x10/0x10 [xfs]
[18679.444734]  ? xfs_buf_get_map+0x43c/0xe40 [xfs]
[18679.445825]  ? xfs_perag_put+0x6a/0x160 [xfs]
[18679.446893]  ? xfs_buf_get_map+0x43c/0xe40 [xfs]
[18679.448035]  ? kasan_save_stack+0x34/0x50
[18679.449006]  ? __pfx_xfs_buf_get_map+0x10/0x10 [xfs]
[18679.450175]  ? kasan_save_track+0x14/0x30
[18679.451081]  ? __kasan_slab_alloc+0x87/0x90
[18679.452021]  ? kmem_cache_alloc+0x156/0x390
[18679.452943]  ? xfs_buf_item_init+0x13f/0x810 [xfs]
[18679.454115]  ? xfs_buf_item_init+0x474/0x810 [xfs]
[18679.455283]  ? xfs_buf_hold+0x25/0xf0 [xfs]
[18679.456394]  xfs_alloc_vextent_prepare_ag+0x75/0x410 [xfs]
[18679.457598]  xfs_alloc_vextent_exact_bno+0x2b8/0x440 [xfs]
[18679.458821]  ? __pfx_xfs_alloc_vextent_exact_bno+0x10/0x10 [xfs]
[18679.460057]  ? _xfs_trans_bjoin+0x1a2/0x2b0 [xfs]
[18679.461189]  ? xfs_trans_read_buf_map+0x545/0xb10 [xfs]
[18679.462437]  xfs_ialloc_ag_alloc+0x513/0x18d0 [xfs]
[18679.463586]  ? __pfx_xfs_ialloc_ag_alloc+0x10/0x10 [xfs]
[18679.464879]  ? xfs_ialloc_check_shrink+0x34f/0x350 [xfs]
[18679.466114]  ? xfs_trans_alloc_dqinfo+0x39/0x80 [xfs]
[18679.467330]  ? __pfx_xfs_read_agi+0x10/0x10 [xfs]
[18679.468543]  ? __pfx_xfs_ialloc_read_agi+0x10/0x10 [xfs]
[18679.469776]  xfs_dialloc+0x683/0xbc0 [xfs]
[18679.470850]  ? __pfx_xfs_dialloc+0x10/0x10 [xfs]
[18679.471954]  ? __pfx_down_write+0x10/0x10
[18679.472922]  ? kasan_save_free_info+0x3f/0x60
[18679.473892]  xfs_create+0x5d9/0xf60 [xfs]
[18679.474933]  ? __pfx_xfs_create+0x10/0x10 [xfs]
[18679.476015]  ? __pfx_xfs_dir_lookup+0x10/0x10 [xfs]
[18679.477208]  ? avc_has_perm_noaudit+0x8b/0x130
[18679.478182]  ? get_cached_acl+0x172/0x1e0
[18679.479145]  ? __pfx_get_cached_acl+0x10/0x10
[18679.480040]  ? avc_has_perm+0x91/0x130
[18679.480915]  ? __pfx_avc_has_perm+0x10/0x10
[18679.481977]  xfs_generic_create+0x46f/0x600 [xfs]
[18679.483158]  ? __pfx_xfs_generic_create+0x10/0x10 [xfs]
[18679.484392]  ? selinux_inode_permission+0x294/0x3f0
[18679.485467]  ? generic_permission+0xcd/0x4c0
[18679.486494]  ? security_inode_mknod+0x8d/0xf0
[18679.487565]  vfs_mknod+0x45a/0x740
[18679.488465]  do_mknodat+0x27b/0x4d0
[18679.489340]  ? __pfx_do_mknodat+0x10/0x10
[18679.490291]  ? getname_flags.part.0+0xb9/0x450
[18679.491253]  __x64_sys_mknodat+0xb5/0xf0
[18679.492159]  do_syscall_64+0x6a/0x180
[18679.493022]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[18679.494004] RIP: 0033:0x7f3d1873e2a5
[18679.494853] RSP: 002b:00007ffcf92ecff8 EFLAGS: 00000246 ORIG_RAX: 0000000000000103
[18679.496156] RAX: ffffffffffffffda RBX: 00007ffcf92ed170 RCX: 00007f3d1873e2a5
[18679.497632] RDX: 0000000000002124 RSI: 00000000016725a0 RDI: 00000000ffffff9c
[18679.498903] RBP: 0000000000002124 R08: 0000000000000030 R09: 0000000000000030
[18679.500150] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000351
[18679.501459] R13: 0000000000000000 R14: 0000000000406800 R15: 00007f3d1880e6c0
[18679.502677]  </TASK>
[18679.503461] INFO: task xfs_growfs:230919 blocked for more than 123 seconds.
[18679.504795]       Tainted: G        W          6.8.0-rc6+ #1
[18679.505954] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[18679.507357] task:xfs_growfs      state:D stack:0     pid:230919 tgid:230919 ppid:228451 flags:0x00000002
[18679.508912] Call Trace:
[18679.509738]  <TASK>
[18679.510609]  __schedule+0x69c/0x17a0
[18679.511622]  ? __pfx___schedule+0x10/0x10
[18679.512764]  ? unwind_get_return_address+0x5e/0xa0
[18679.513852]  ? __pfx_stack_trace_consume_entry+0x10/0x10
[18679.514953]  schedule+0x80/0x230
[18679.515850]  schedule_timeout+0x259/0x2a0
[18679.516839]  ? __pfx_schedule_timeout+0x10/0x10
[18679.517881]  ? kasan_save_stack+0x34/0x50
[18679.518828]  ? kasan_save_stack+0x24/0x50
[18679.519770]  ? kasan_save_track+0x14/0x30
[18679.520748]  ? __kasan_slab_alloc+0x87/0x90
[18679.521706]  ? kmem_cache_alloc+0x13b/0x390
[18679.522649]  ? xfs_buf_item_init+0x13f/0x810 [xfs]
[18679.523860]  ? _xfs_trans_bjoin+0x75/0x2b0 [xfs]
[18679.525033]  ? xfs_trans_read_buf_map+0x545/0xb10 [xfs]
[18679.526355]  ? xfs_btree_read_buf_block+0x21d/0x5b0 [xfs]
[18679.527679]  ? xfs_btree_lookup_get_block.part.0+0x131/0x7a0 [xfs]
[18679.529298]  ___down_common+0x207/0x390
[18679.530357]  ? do_syscall_64+0x6a/0x180
[18679.531340]  ? __pfx____down_common+0x10/0x10
[18679.532420]  ? __raw_spin_lock_irqsave+0x8d/0xf0
[18679.533573]  ? __pfx___raw_spin_lock_irqsave+0x10/0x10
[18679.534668]  __down_common+0x22/0x1b0
[18679.535626]  ? xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.536829]  down+0x71/0xa0
[18679.537657]  xfs_buf_lock+0xa4/0x290 [xfs]
[18679.538731]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
[18679.539920]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
[18679.541265]  ? __pfx_xfs_buf_lookup.constprop.0+0x10/0x10 [xfs]
[18679.542628]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
[18679.543767]  ? __pfx_xfs_buf_get_map+0x10/0x10 [xfs]
[18679.544993]  ? __pfx_stack_trace_save+0x10/0x10
[18679.546032]  ? stack_depot_save_flags+0x45/0x4b0
[18679.547076]  xfs_buf_read_map+0xbb/0x900 [xfs]
[18679.548258]  ? xfs_read_agi+0x1cd/0x500 [xfs]
[18679.549450]  ? kasan_save_stack+0x34/0x50
[18679.550510]  ? kasan_save_stack+0x24/0x50
[18679.551533]  ? kasan_save_track+0x14/0x30
[18679.552591]  ? __pfx_xfs_buf_read_map+0x10/0x10 [xfs]
[18679.553743]  ? kmem_cache_free+0x171/0x3f0
[18679.554706]  ? __xfs_trans_commit+0x297/0xb60 [xfs]
[18679.555872]  ? xfs_trans_roll+0x11a/0x2a0 [xfs]
[18679.556981]  ? xfs_ag_shrink_space+0x6d8/0xd30 [xfs]
[18679.558189]  ? xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
[18679.559498]  ? xfs_growfs_data+0x2f1/0x410 [xfs]
[18679.560597]  ? xfs_file_ioctl+0xd1e/0x1370 [xfs]
[18679.561709]  ? __x64_sys_ioctl+0x132/0x1a0
[18679.562616]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
[18679.563905]  ? xfs_read_agi+0x1cd/0x500 [xfs]
[18679.564991]  ? __pfx_xfs_trans_read_buf_map+0x10/0x10 [xfs]
[18679.566221]  ? xfs_buf_rele_cached+0x575/0x870 [xfs]
[18679.567441]  ? xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
[18679.568674]  ? xfs_growfs_data+0x2f1/0x410 [xfs]
[18679.569778]  xfs_read_agi+0x1cd/0x500 [xfs]
[18679.570827]  ? __pfx_xfs_read_agi+0x10/0x10 [xfs]
[18679.571923]  ? xfs_buf_rele_cached+0x575/0x870 [xfs]
[18679.573126]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
[18679.574295]  ? kasan_save_free_info+0x3f/0x60
[18679.575279]  ? __pfx_xfs_ialloc_read_agi+0x10/0x10 [xfs]
[18679.576585]  ? __pfx_xfs_alloc_read_agf+0x10/0x10 [xfs]
[18679.577752]  ? __kasan_slab_free+0x46/0x80
[18679.578708]  xfs_finobt_calc_reserves+0xe7/0x4d0 [xfs]
[18679.579902]  ? xfs_refcountbt_calc_reserves+0x2d9/0x460 [xfs]
[18679.581181]  ? __pfx_xfs_finobt_calc_reserves+0x10/0x10 [xfs]
[18679.582480]  xfs_ag_resv_init+0x2c5/0x490 [xfs]
[18679.583644]  ? __pfx_xfs_ag_resv_init+0x10/0x10 [xfs]
[18679.584864]  ? _xfs_trans_bjoin+0x1a2/0x2b0 [xfs]
[18679.586023]  xfs_ag_shrink_space+0x736/0xd30 [xfs]
[18679.587281]  ? __pfx_xfs_ag_shrink_space+0x10/0x10 [xfs]
[18679.588601]  ? ksys_write+0xf1/0x1c0
[18679.589580]  ? xfs_trans_alloc+0x32f/0x780 [xfs]
[18679.590730]  xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
[18679.592000]  ? cred_has_capability.isra.0+0x102/0x200
[18679.593096]  ? __pfx_xfs_growfs_data_private.isra.0+0x10/0x10 [xfs]
[18679.594510]  ? __kasan_slab_free+0x46/0x80
[18679.595564]  ? __wake_up+0x44/0x60
[18679.596558]  ? jbd2_journal_stop+0x444/0xd50 [jbd2]
[18679.597782]  ? __pfx_mutex_trylock+0x10/0x10
[18679.598774]  ? security_capable+0x57/0xa0
[18679.599764]  xfs_growfs_data+0x2f1/0x410 [xfs]
[18679.600893]  ? __pfx_xfs_growfs_data+0x10/0x10 [xfs]
[18679.602212]  xfs_file_ioctl+0xd1e/0x1370 [xfs]
[18679.603459]  ? balance_dirty_pages_ratelimited_flags+0x5ec/0xc80
[18679.604622]  ? __pfx_xfs_file_ioctl+0x10/0x10 [xfs]
[18679.605830]  ? generic_perform_write+0x314/0x500
[18679.606874]  ? __pfx_generic_perform_write+0x10/0x10
[18679.607968]  ? __mark_inode_dirty+0xdb/0x800
[18679.608992]  ? generic_update_time+0x88/0xb0
[18679.610017]  ? up_write+0x53/0xa0
[18679.610924]  ? ext4_buffered_write_iter+0xfa/0x320 [ext4]
[18679.612131]  ? __pfx_do_vfs_ioctl+0x10/0x10
[18679.613096]  ? vfs_write+0x420/0xc80
[18679.614030]  ? ioctl_has_perm.constprop.0.isra.0+0x279/0x440
[18679.615144]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10
[18679.616327]  ? mutex_unlock+0x84/0xd0
[18679.617355]  ? __pfx_mutex_unlock+0x10/0x10
[18679.618416]  ? __count_memcg_events+0xcc/0x320
[18679.619512]  ? security_file_ioctl+0x51/0x90
[18679.620615]  __x64_sys_ioctl+0x132/0x1a0
[18679.621693]  do_syscall_64+0x6a/0x180
[18679.622659]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[18679.623750] RIP: 0033:0x7fc3fd43ec6b
[18679.624655] RSP: 002b:00007ffd789100f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[18679.625972] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc3fd43ec6b
[18679.627277] RDX: 00007ffd78910300 RSI: 000000004010586e RDI: 0000000000000003
[18679.628724] RBP: 0000000000000003 R08: 0000000000009f00 R09: 0000000000000000
[18679.630006] R10: 000000000002e5d5 R11: 0000000000000246 R12: 0000000000000000
[18679.631344] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
[18679.632675]  </TASK>



-- 
Chandan
