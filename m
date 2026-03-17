Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC021E51E0
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 02:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773713939; cv=none; b=Q5bnBOWsAHVTUf8ZL0oqR7XzTDSSFp8ofm+pKBufuxKUjAT9DdA/0R0t7sPpIkEV7VrabwOTRoBo1Vowd9ctLtUksw1GMyt3alor5ggcSz/1jZEdrDgGYB9o1Xy2Ow1HvSoJvgaCYqdRpRX4p/VvNU+R9fCTTC6xIxDBDzNSgBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773713939; c=relaxed/simple;
	bh=w0zwr9PZ0ZchMyGPjBfijM8adpHZbqj5V2fzE+cLKa4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJMO85VHLE0xG8ww6SYCZeVadhd1JBq1lM+p2MvPbj0SxKaceWp93OQNg1OIOBAr/Dydy9MVrSbiBlggK39jmch9GtMXbeK98SIEFg6APB4kykRUoHWmr0RQ7KSz9W+JjRJ2h87Ek2K+zFA66oRcIk9YcnAx2Y6Oz0lw2SH9IIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=KUldY10L; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="KUldY10L"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EbfwmWTJyL55LcYc7w0bOom4jGb1KuApP8xOlSbw9TA=;
	b=KUldY10LTvNwOzUk1SkE5tqNzD7FWcYpSR2nP3/Fm/cO/mqIp4alixdSdZPA71sJnxUrxdO6R
	/WxwIyziK2pJmebeg3ANm41gfebzdBtnVvq1j+axqXUETsTCB9EbJpDKYaeUoTa8vtv5Hy9bDEt
	ywht4V6ARn3ogew+W6n79dM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fZb936Jhtz1T4FW;
	Tue, 17 Mar 2026 10:13:27 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5083540569;
	Tue, 17 Mar 2026 10:18:47 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 10:18:47 +0800
Received: from localhost (10.50.85.155) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 17 Mar
 2026 10:18:46 +0800
Date: Tue, 17 Mar 2026 10:14:36 +0800
From: Long Li <leo.lilong@huawei.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <cem@kernel.org>, <linux-xfs@vger.kernel.org>, <david@fromorbit.com>,
	<yi.zhang@huawei.com>, <houtao1@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: Re: [PATCH 2/3] xfs: fix ri_total validation in
 xlog_recover_attri_commit_pass2
Message-ID: <abi5DL2O8-7xBtx8@localhost.localdomain>
References: <20260316012416.2413909-1-leo.lilong@huawei.com>
 <20260316012416.2413909-3-leo.lilong@huawei.com>
 <20260316223921.GD1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260316223921.GD1770774@frogsfrogsfrogs>
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn100013.china.huawei.com (7.202.194.116)

On Mon, Mar 16, 2026 at 03:39:21PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 16, 2026 at 09:24:15AM +0800, Long Li wrote:
> > The ri_total checks for SET/REPLACE operations are hardcoded to 3,
> > but xfs_attri_item_size() only emits a value iovec when value_len > 0,
> > so ri_total is 2 when value_len == 0.
> 
> When can you have a set/replace operation with no value?  Is this the
> weird case where you're trying to set an attr to zero-length buffer?
> 
> --D

Yes, the issue can be reproduced using the following command:

mkfs.xfs -f /dev/sda
mount /dev/sda /mnt/test/
touch /mnt/test/file
for i in {1..200}; do
	attr -s "user.attr_$i" -V "value_000000000000000_$i" /mnt/test/file > /dev/null
done
echo 1 > /sys/fs/xfs/debug/larp
mount /dev/sda /mnt/test/
echo 1 > /sys/fs/xfs/sda/errortag/larp
attr -s "user.zero" -V "" /mnt/test/file
echo 0 > /sys/fs/xfs/sda/errortag/larp
umount /mnt/test
mount /dev/sda /mnt/test/


Damage is reported when mounting again:

[45643.683467] XFS (sda): Internal error xlog_recover_attri_commit_pass2 at line 1052 of file fs/xfs/xfs_attr_item.c.  Caller xlog_recover_items_pass2+0xe1/0x290
[45643.684743] CPU: 2 UID: 0 PID: 2328 Comm: mount Tainted: G    B               7.0.0-rc3-next-20260312-gcb0d985e40d9-dirty #352 PREEMPT(full)
[45643.684749] Tainted: [B]=BAD_PAGE
[45643.684751] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
[45643.684753] Call Trace:
[45643.684755]  <TASK>
[45643.684757]  dump_stack_lvl+0x53/0x70
[45643.684764]  xfs_corruption_error+0xf9/0x150
[45643.684770]  ? xlog_recover_items_pass2+0xe1/0x290
[45643.684774]  xlog_recover_attri_commit_pass2+0x866/0x1380
[45643.684778]  ? xlog_recover_items_pass2+0xe1/0x290
[45643.684782]  xlog_recover_items_pass2+0xe1/0x290
[45643.684786]  xlog_recover_commit_trans+0x6ca/0xa30
[45643.684791]  ? __pfx_xlog_recover_commit_trans+0x10/0x10
[45643.684794]  ? xlog_recover_process_ophdr+0x18f/0x400
[45643.684798]  xlog_recovery_process_trans+0x11b/0x150
[45643.684802]  xlog_recover_process_data+0x185/0x360
[45643.684806]  xlog_do_recovery_pass+0x810/0xbf0
[45643.684811]  ? __pfx_xlog_do_recovery_pass+0x10/0x10
[45643.684814]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[45643.684821]  ? kasan_save_track+0x14/0x30
[45643.684826]  ? __kasan_kmalloc+0x8f/0xa0
[45643.684830]  xlog_do_log_recovery+0x66/0xb0
[45643.684833]  xlog_do_recover+0x75/0x3b0
[45643.684837]  xlog_recover+0x25b/0x460
[45643.684841]  ? __pfx_xlog_recover+0x10/0x10
[45643.684845]  xfs_log_mount+0x1c1/0x420
[45643.684850]  xfs_mountfs+0xc9e/0x1c20
[45643.684853]  ? __link_object+0x10f/0x210
[45643.684858]  ? __pfx_xfs_mountfs+0x10/0x10
[45643.684861]  ? xfs_mru_cache_create+0x10a/0x5e0
[45643.684865]  ? __pfx_xfs_fstrm_free_func+0x10/0x10
[45643.684869]  ? xfs_mru_cache_create+0x3b5/0x5e0
[45643.684872]  xfs_fs_fill_super+0xdcd/0x18d0
[45643.684878]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[45643.684882]  get_tree_bdev_flags+0x2ec/0x550
[45643.684888]  ? __pfx_get_tree_bdev_flags+0x10/0x10
[45643.684893]  ? __pfx_vfs_parse_fs_qstr+0x10/0x10
[45643.684898]  vfs_get_tree+0x87/0x2d0
[45643.684903]  fc_mount+0x15/0x1b0
[45643.684908]  path_mount+0x116b/0x1b00
[45643.684912]  ? __pfx_path_mount+0x10/0x10
[45643.684916]  ? kasan_save_track+0x14/0x30
[45643.684919]  ? user_path_at+0x43/0x50
[45643.684922]  ? kmem_cache_free+0x248/0x490
[45643.684928]  __x64_sys_mount+0x210/0x270
[45643.684932]  ? __pfx___x64_sys_mount+0x10/0x10
[45643.684936]  do_syscall_64+0xb4/0x5c0
[45643.684941]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[45643.684945] RIP: 0033:0x7fe945b1123a
[45643.684949] Code: 48 8b 0d 51 dc 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1e dc 2b 00 f7 d8 64 89 01 48
[45643.684953] RSP: 002b:00007ffc3102ede8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
[45643.684957] RAX: ffffffffffffffda RBX: 0000559d1d098030 RCX: 00007fe945b1123a
[45643.684960] RDX: 0000559d1d098230 RSI: 0000559d1d09af20 RDI: 0000559d1d098210
[45643.684962] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007ffc3102dce8
[45643.684963] R10: 00000000c0ed0000 R11: 0000000000000246 R12: 0000559d1d098210
[45643.684966] R13: 0000559d1d098230 R14: 0000000000000000 R15: 00007fe947052184



