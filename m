Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69FEDDA8;
	Wed,  6 Mar 2024 07:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709710539; cv=none; b=PETe6mENlGZ9rxncAJsCSSc27WYm/P3lFBJ1WtDxakt6FTgNjCb9xeO88Evo4G/AXAW4V7MG8rcSYGBRRCKU1HnTTCqg2ByG9YEZQDa+qcfe9w14QPkcs+s1t8BckkWFCFlbqmaF4uk0KBuk0BUdmLvC9GrCc4unek+dfQB2Nms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709710539; c=relaxed/simple;
	bh=ZxEsLNm9Va7/5G2C6LzLhTCIEf6+xBkDskPbkaC6IXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t11+YLAtt7A08K3ULthVuIeAdl2QXRPgu3mDIzfqRDOrGNPWjdgg7d2mFD4GR4AKuWuzpyk5GNfBO4JnnkcAj4fq+rpHE1ZH6tFg0A/iFJ69JvtQzG6jM3tBpU+HF3H80WsbKyd9qGDIfzJ7kapQW+BSrgvy27UVBk1wHgMlBCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ny7ucwHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ny7ucwHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88BFC433C7;
	Wed,  6 Mar 2024 07:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709710539;
	bh=ZxEsLNm9Va7/5G2C6LzLhTCIEf6+xBkDskPbkaC6IXE=;
	h=From:To:Cc:Subject:Date:From;
	b=ny7ucwHPWM0rKDUF3x02vOyXH05F4iUc/nR8ps3Mq6ryfeUbmxoh/6stpvsdyh/28
	 U7D0yfLVdN+9i+b1sktona474Shl+1L6/QXeOl0KUevYc1Rz81+oaywdtV1wqQp6w5
	 SBD0Xnelz7IukR8By1e5MEaox8MCqlkOfC1d2O441Zt457jNMHtrAtQql19hLPzsWj
	 SynP194sW0mLpJZn8W01HuSeQpUwRgrngrpzXUGxXgAyL44H5E5hUJ7VWmc6+8LFMo
	 VFNutsNGIoYV/7lW1cWuaNXKGQWiSKJ570BxFhD70R4zLFqPRUZ/sTubFvFD+aL5LM
	 iBZKPVJ9fKX7g==
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: kbusch@kernel.org
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [BUG REPORT] General protection fault while discarding extents on
 XFS on next-20240305
Date: Wed, 06 Mar 2024 12:49:29 +0530
Message-ID: <87y1avlsmw.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

Executing generic/251 on an XFS filesystem with next-20240305 kernel caused
the following call trace,

[ 6105.092156] XFS (loop5): discard failed for extent [0x344,4], error -4
[ 6105.094267] general protection fault, probably for non-canonical address 0xdffffc000000002a: 0000 [#1] PREEMPT SMP KASAN NOPTI
[ 6105.097056] KASAN: null-ptr-deref in range [0x0000000000000150-0x0000000000000157]
[ 6105.098639] CPU: 1 PID: 906401 Comm: fstrim Kdump: loaded Not tainted 6.8.0-rc7-next-20240305+ #1
[ 6105.100368] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.6.6 08/22/2023
[ 6105.102049] RIP: 0010:submit_bio_noacct+0x3bc/0x17e0
[ 6105.103441] Code: 00 00 41 89 c5 41 83 e5 01 0f 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 4d 63 ed 4a 8d bc 2b 56 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 d3 0f 00 00
[ 6105.107067] RSP: 0018:ffa00000056a7898 EFLAGS: 00010203
[ 6105.108547] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1fe2200032629a49
[ 6105.110107] RDX: 000000000000002a RSI: 00000000007fffff RDI: 0000000000000157
[ 6105.111686] RBP: ff1100019314d200 R08: 0000000000000000 R09: ff110001026e0880
[ 6105.113281] R10: ff110001026e0887 R11: 0000000000000001 R12: ff1100019314d210
[ 6105.114871] R13: 0000000000000001 R14: ff1100019314d208 R15: ff110001026e0860
[ 6105.116446] FS:  00007f6f4bbfd800(0000) GS:ff110003ee480000(0000) knlGS:0000000000000000
[ 6105.118185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6105.119630] CR2: 000055997361d4a8 CR3: 000000016f144004 CR4: 0000000000771ef0
[ 6105.121230] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6105.122772] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 6105.124510] PKRU: 55555554
[ 6105.125601] Call Trace:
3[ 6105.126672]  <TASK>
[ 6105.133971]  xfs_discard_extents+0x340/0x860 [xfs]
[ 6105.139534]  xfs_ioc_trim+0x4b1/0x960 [xfs]
[ 6105.150011]  xfs_file_ioctl+0xc49/0x1370 [xfs]
[ 6105.167691]  __x64_sys_ioctl+0x132/0x1a0
[ 6105.168725]  do_syscall_64+0x69/0x170
[ 6105.169681]  entry_SYSCALL_64_after_hwframe+0x6c/0x74

The above *probably* occured because __blkdev_issue_discard() noticed a pending
signal, processed the bio, freed the bio and returned a non-NULL bio pointer
to the caller (i.e. xfs_discard_extents()).

xfs_discard_extents() then tries to process the freed bio once again.

-- 
Chandan
