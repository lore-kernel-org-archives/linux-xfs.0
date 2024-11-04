Received: from gmmr-3.centrum.cz (gmmr-3.centrum.cz [46.255.225.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A3913CA93;
	Mon,  4 Nov 2024 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.225.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730729853; cv=none; b=ndAa4F2IGnmgmUCYJYH8v/+N3smiX4Fa9Qm1ZeIl75sZO/NyHV61aUdi+O+lVy3kNiKAa89i/UP+0SM4Y39vi3YUXtXYrd+aDLfABnmaWpi1vjMdjSfmd1ZkOI9xfO6lrqywyttZ+yscfMYoc5I7QdHJpxR4+lBa+zdFLdDlsRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730729853; c=relaxed/simple;
	bh=L6aJ3NZqSZ/+hsgqclmhjh5i8JRVUS1CrJ/0FBzQhsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AOeCT40c0c1EWJ5GHC9gMlxqEBB01rPomkI21GV1kGs0AoNJRxfPl/J3gZs8l4l1GRq/N/j12skZN/nh+KdQ2PQEAmZEtByxvJ5kaDtzYUtKdAH6ACGTwcN10YPoYS1dmo6/Y3BAZmPPquaYgRj2ZqfdoOrAO5kz1VUsysFbmDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atlas.cz; spf=pass smtp.mailfrom=atlas.cz; dkim=pass (1024-bit key) header.d=atlas.cz header.i=@atlas.cz header.b=DvU1BwIn; arc=none smtp.client-ip=46.255.225.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=atlas.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atlas.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=atlas.cz header.i=@atlas.cz header.b="DvU1BwIn"
Received: from gmmr-3.centrum.cz (localhost [127.0.0.1])
	by gmmr-3.centrum.cz (Postfix) with ESMTP id 66DF32013D13;
	Mon,  4 Nov 2024 15:15:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=atlas.cz; s=mail;
	t=1730729754; bh=TC5W8Ens0o/r/Nmy8Nks8OaA9d5dQo+yB5k1wDZykXg=;
	h=Date:From:To:Cc:Subject:From;
	b=DvU1BwInOszjid/ekQuFGFIaO7C+Nv8L3/VSEqz1fC4f1HV1y1Zq4rT/QRCZ273bd
	 97K3V8UDwoiRXPhl2+4QTe3mZ+VTiFso6ZywJ84IDjLraGGXdXfFiwBJEBPxgGoq/Q
	 Du+F1UQjk/h7kD49oJfUuLuBB1cXopV+sYBGFsqU=
Received: from antispam68.centrum.cz (antispam68.cent [10.30.208.68])
	by gmmr-3.centrum.cz (Postfix) with ESMTP id E6F6C2015468;
	Mon,  4 Nov 2024 15:15:52 +0100 (CET)
X-CSE-ConnectionGUID: 7KCIdGNPSi2m63gbCnvSIw==
X-CSE-MsgGUID: mOBBEY15SHCtLqz+M4jj6g==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2FMAwCL1Shn/03h/y5SCBwBAQEBAQEHAQESAQEEBAEBS?=
 =?us-ascii?q?YFKiXuRboMojiNijWkIBwEBAQEBAQEBAQQFRAQBAT4BhEiKNSc4EwECBAEBA?=
 =?us-ascii?q?QEDAgMBAQEBAQEBAQENAQEGAQEBAQEBBgYBAoEdhTVTgmIBhClRBSg1AoNyA?=
 =?us-ascii?q?YIvATSvAYEyGgJl3G8CgSNhgRoQgUiBWIZpCwGBWoQOAYU5gg2BFYNogQUBg?=
 =?us-ascii?q?nUhhAKCaQSCR4E0g1kSJYkVh1CEUoMCiBqBaQNZIAERAVUTFwsHBYF5A4NRg?=
 =?us-ascii?q?TmBUYMgSoUbRj+CSmlNOgINAjaCJH2CUIUdgQ6DYoRsQh1AAwttPTUUGwaaO?=
 =?us-ascii?q?AhKgRyGeikYHAEwG3E8cjuSZ49tox+DHIEIhE2dDDOEBJNlA5JfmHeCVqEwh?=
 =?us-ascii?q?RuBfoF/MyIwgyNRGY48CwvIJ4EyAgcLAQEDCYI7jEwja2ABAQ?=
IronPort-PHdr: A9a23:0LAgbBccJG2XB3IliG6QZnKFlGM+StnLVj580XLHo4xHfqnrxZn+J
 kuXvawr0ASRG9+KtbkZ26L/iOPJZy8p2d65qncMcZhBBVcuqP49uEgNJvDAImDAaMDQUiohA
 c5ZX0Vk9XzoeWJcGcL5ekGA6ibqtW1aFRrwLxd6KfroEYDOkcu3y/qy+5rOaAlUmTaxe7x/I
 RuqoQnLqMUbhYpvJqkxxxbKv3BFZ/lYyWR0KF2cmBrx+t2+94N5/SRKvPIh+c9AUaHkcKk9U
 LdVEjcoPX0r6cPyrRXNQhOB6XQFXmgInRRGHhDJ4x7mUJj/tCv6rfd91zKBPcLqV7A0WC+t4
 LltRRT1lSoILT858GXQisxtkKJWpQ+qqhJjz4LIZoyeKeFzdb3Bc9wEWWVBX95RVy1fDYO6c
 4sPFPcKMeJBo4Xgu1cCsR6yCA+xD+3t1zBInGf706M63eo/DwzIwQ8uEN0Sv3vJt9j1O7seX
 PqvwaXU0TnObfVb0ir95ojSdRAhpOmBU6hufsrN00kkCgzKgU+WqYn7PDOey+MAvHKB7+pjT
 +2vjnQoqxtqrze12scsjpPGhpkPxl/Y9CR02YA4LsC3R0Bne9CrCodQtz2EOItsRMMvW25mt
 To6xLAYt5C3YTQHxYg5yxDfZPKKb5aE7g/hWeuRITl1mHJrdK+jixuu/0auxfPxW8u73lhEs
 iZIj9vBu3EL2hfO6caHUuNw80ig1DqVyQze6uFJLVoqmabFK5Mt2Lw9m5gLvUjdAyP7ll/6g
 LGIekk44OSk9evqbqn8qpKYNoJ5jBz1PL40lcylG+s4NxADX22c+euhyrLu5Vb5QLBWjv0ul
 anZrYzaKdwbpqGnBw9V1Z4u6xm6Dzu/y9QYmGUHLEpYdB6blYTmJ0/BIPbkDfelnlSslS1ny
 OzHP7H5A5XNKGbMkKv5cLty6kNQ0hQ/wNBf6p5OFL0NPvL+VlXzudHaFhM5Nha7w+fjCNVzz
 IMeXmePD7eDP6PIsl+H/OcvLPOWZIIOojn9N/wl6OT1jXMjhVAcfLGl3YELZ3CgAvRmP0KZb
 GLig9cAFWcKugo/QffriF2EXz5TfWy9UL8i6T4hFY2qF4DDRpqigLCZxie0AoVWZnxaClCLC
 Xrnap+LW+kNaC2POcJhiCILWqWhS4A7yRGirhP1y71iLubM4C0XqYrj1MRp5+3UjRwy8T10D
 8KA02CCVm10nX0HRyUw3K9hpUxw0UmD0admjPxCD9BT5O1GUh08NZHCy+x2EdfyWhjOftuRU
 lapXs2mAS0tTtI229IOZ0d9G9O/jhHMxiarDLEVl6eQCZwq/aLTwWLxK9x+y3nYzqkhiUcpQ
 s9VOW2hnK5/+BDfB4jSnEqBjaalabwc3DLR9GeE1WeDs1lUXxNzUaXEWHASflPYo9v36U3cU
 7GjFbIpPhNcxs6HMKRKcMHmgE1eSvn6INrQbHq9m3yoBRaG3r6CdJPkdX0S0naVNE9RlwEV4
 GbDJQYlLjmurniYDzF0E1/rJUT2/rpQsnS+G3c50xvCUURndLn9rhcPhvWZQuk7164AsTxno
 CciTwX15M7fF9fV/1kpR65be95opQ4fjQrk
IronPort-Data: A9a23:wjiJEKCG7Q+5dBVW/6/iw5YqxClBgxIJ4kV8jC+esDiIYAhSlGxQk
 DNbHCvTJK7JMVJBSKl0bYq09UJT6JHWn4dqG1Bu/3hgRi8Q+JrMD97AIBiuYyqfcsSeQU45s
 p4QNoaZIJ9uRXOE+kn9auCwpyUljPmBLlaQ5JYoHwgoLeMzYHd60nqP4tIEv7OEoeRVIiuEt
 dr+/MGOZFX6g2d+O2hIuv6Po0Mz7f2vtGJG4QRhO9lG7QTU/5U3JMlGefzudSuQrqp8Q7TmH
 baTlNlV2kuDon/B3/v8yu6TnnUiG+OUYE7XzCILBsBOuzAazgQqyKE3KfEAXklejjSNjrhZx
 c5E3XCKYV5B0pbkxqJECnG0LwkkZfcaoeaffSDm2SCu5xSun0XEkqgG4H4eYtVwFtZfWQlm6
 fEeITYRWRGP78re6K67UORlmvM4J8DtOo4F0lk4pd0OJatOrTjrGs0m1PcAtNsCrpkm8cX2O
 6L1XQFSgCHoOHWjDH9MUc5jw7347pXIW2YwRFq9/cLb6oVIpeB7+OCF3NH9IrRmSSjJ96oxS
 62vE2nRW3kn2NKjJTWtrVGHp+PguxvAWdgXSua3/NVsnmay2TlGYPEWfQPTTfiRhUv7QNdDM
 xVMvCEjq7Qo6UntRcuVsx+Q/CDC5ENBHYAKTqtlt2lhyYKNi+qdLmEeTTdEYcYOvdMyTCds3
 U3hc9bBWmM16OzOFiP1GrG8qBSYEwUkdDI5RQQYaRIXoPy/ooNtgUeaJjpkOOvv5jHvIhnvw
 jSOvQA/gbsJhMIG3qn9+krI6xqgr4bIQiYv6wnXV37j5QR8DKahZoq1+R3Y4OxGIYKxUFaMp
 j4HltKY4eRICouC/ASJQeMQDPS56e2tLjLRmxhsEoMn+jDr/GSsFb28+xkiegEzb5tCI2W0J
 hCM0e9M2KJu0LKRRfcfS+qM5w4Clvm9fTg5fpg4tuZzX6U=
IronPort-HdrOrdr: A9a23:GBWd56OV3k93RsBcTtqjsMiBIKoaSvp037Dk7S9MoDhuA66lfq
 GV7ZcmPHDP4gr5NEtMpTniAsm9qBHnlKKdiLN5VdyftWLd1ldAQrsP0bff
X-Talos-CUID: =?us-ascii?q?9a23=3ALky8lmil7pkTJShb2uBujRrVbDJuLV727Xv/BXe?=
 =?us-ascii?q?DCDxsFuaaQ3SW5phFjJ87?=
X-Talos-MUID: 9a23:uAWtZAsf+kofr24qzc2ngRZIHupZuvmVKGsRtYwU+OzYNy4uNGLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.11,257,1725314400"; 
   d="asc'?scan'208";a="77209379"
Received: from unknown (HELO gm-smtp10.centrum.cz) ([46.255.225.77])
  by antispam68.centrum.cz with ESMTP; 04 Nov 2024 15:11:22 +0100
Received: from arkam (ip-213-220-240-96.bb.vodafone.cz [213.220.240.96])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp10.centrum.cz (Postfix) with ESMTPSA id 7BE3B80911A0;
	Mon,  4 Nov 2024 15:11:22 +0100 (CET)
Date: Mon, 4 Nov 2024 15:11:21 +0100
From: Petr =?utf-8?B?VmFuxJtr?= <arkamar@atlas.cz>
To: linux-xfs@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: xfs: Xen/HPT related regression in v6.6
Message-ID: <2024114141121-ZyjWCQr5TJE0JoRT-arkamar@atlas.cz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sUYvu/K4Fz22JAk/"
Content-Disposition: inline


--sUYvu/K4Fz22JAk/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

I would like to report a regression in XFS introduced in kerenel v6.6 in
commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace"). On a
system running under Xen, when a process creates a file on an XFS file
system and writes exactly 2MB or more in a single write syscall,
accessing memory through mmap on that file causes the process to hang,
while dmesg is flooded with page fault warnings:

[   57.345925] ------------[ cut here ]------------
[   57.347471] WARNING: CPU: 1 PID: 440 at arch/x86/xen/multicalls.c:102 xen_mc_flush+0x13a/0x230
[   57.350226] CPU: 1 PID: 440 Comm: test Not tainted 6.6.59 #18
[   57.352088] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-20220807_005459-localhost 04/01/2014
[   57.355336] RIP: e030:xen_mc_flush+0x13a/0x230
[   57.356843] Code: 89 d0 48 c1 e2 06 48 01 da 85 c0 74 8a 48 8b 43 18 48 83 c3 40 48 c1 e8 3f 41 01 c6 48 39 d3 75 ec 45 85 f6 0f 84 6d ff ff ff <0f> 0b e8 ef 5a 6f 00 41 8b 55 00 44 89 f6 48 c7 c7 28 cf b6 81 89
[   57.362491] RSP: e02b:ffff888101253c38 EFLAGS: 00010082
[   57.364196] RAX: ffffffffffffffea RBX: ffff88823ff1a2c0 RCX: 0000000000000000
[   57.366438] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88823ff1aad0
[   57.368667] RBP: ffff888101253c58 R08: 0000000000000000 R09: 0000000000000001
[   57.370924] R10: 0000000000007ff0 R11: 0000000000000000 R12: 0000000080000002
[   57.373138] R13: ffff88823ff1a2c0 R14: 0000000000000001 R15: ffff8881003e2300
[   57.375365] FS:  00007f512be1c740(0000) GS:ffff88823ff00000(0000) knlGS:0000000000000000
[   57.377989] CS:  10000e030 DS: 0000 ES: 0000 CR0: 0000000080050033
[   57.379966] CR2: 00007f512ba00000 CR3: 0000000100fc8000 CR4: 0000000000050660
[   57.382184] Call Trace:
[   57.383059]  <TASK>
[   57.383881]  ? show_regs+0x61/0x70
[   57.385069]  ? __warn+0x80/0x150
[   57.386192]  ? xen_mc_flush+0x13a/0x230
[   57.387490]  ? report_bug+0x19b/0x1f0
[   57.388795]  ? handle_bug+0x40/0x80
[   57.390034]  ? exc_invalid_op+0x18/0x70
[   57.391345]  ? asm_exc_invalid_op+0x1b/0x20
[   57.392743]  ? xen_mc_flush+0x13a/0x230
[   57.394063]  ? xen_mc_flush+0x9a/0x230
[   57.395339]  xen_mc_issue+0x38/0x80
[   57.396532]  xen_set_pmd_hyper+0x58/0x90
[   57.397861]  xen_set_pmd+0x3b/0x90
[   57.399107]  do_set_pmd+0x21f/0x330
[   57.400321]  filemap_map_pages+0x5c5/0x6e0
[   57.401706]  ? __wake_up_common_lock+0x7c/0xa0
[   57.403207]  __handle_mm_fault+0x1344/0x1bf0
[   57.404656]  ? redirected_tty_write+0x75/0x90
[   57.406135]  handle_mm_fault+0x5b/0x190
[   57.407443]  exc_page_fault+0x271/0x750
[   57.408758]  asm_exc_page_fault+0x27/0x30
[   57.410124] RIP: 0033:0x564b7670b4f5
[   57.411359] Code: 00 eb 6b 48 8d 4d a0 48 8b 55 98 48 8b 05 43 2b 00 00 48 8d 35 76 0b 00 00 48 89 c7 b8 00 00 00 00 e8 3f fc ff ff 48 8b 45 98 <48> 8b 08 48 8b 58 08 48 89 4d a0 48 89 5d a8 48 8b 48 10 48 8b 58
[   57.417013] RSP: 002b:00007fffb864aae0 EFLAGS: 00010206
[   57.418675] RAX: 00007f512ba00000 RBX: 00007fffb864ac98 RCX: 0000000000000000
[   57.420945] RDX: 0000000000000000 RSI: 00007fffb864a930 RDI: 00007fffb864a900
[   57.426772] RBP: 00007fffb864ab80 R08: 0000000000000078 R09: 0000000000000000
[   57.429013] R10: 0000000000000004 R11: 0000000000000202 R12: 0000000000000000
[   57.431257] R13: 00007fffb864acb0 R14: 00007f512c03a000 R15: 0000564b7670dd78
[   57.433536]  </TASK>
[   57.434382] ---[ end trace 0000000000000000 ]---

When I terminate the process and delete the file, the following message
appears in the log:

[   62.337443] BUG: Bad page cache in process rm  pfn:102000
[   62.339929] page:00000000735abb58 refcount:518 mapcount:5 mapping:00000000e2099d9a index:0x0 pfn:0x102000
[   62.342832] head:00000000735abb58 order:9 entire_mapcount:5 nr_pages_mapped:0 pincount:0
[   62.345167] aops:0xffffffff81a424e0 ino:1c5
[   62.346420] flags: 0x4100000000069(locked|uptodate|lru|head|section=32|zone=2)
[   62.348594] page_type: 0xffffffff()
[   62.349804] raw: 0004100000000069 ffff8881fecc3908 ffff8881fecc7d08 ffff8881005e1aa0
[   62.352143] raw: 0000000000000000 0000000000000000 00000206ffffffff 0000000000000000
[   62.354409] page dumped because: still mapped when deleted
[   62.355987] CPU: 1 PID: 442 Comm: rm Tainted: G        W          6.6.59 #18
[   62.357978] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-20220807_005459-localhost 04/01/2014
[   62.360997] Call Trace:
[   62.361900]  <TASK>
[   62.362713]  dump_stack_lvl+0x48/0x60
[   62.363947]  dump_stack+0x10/0x20
[   62.365088]  filemap_unaccount_folio+0x191/0x220
[   62.366555]  delete_from_page_cache_batch+0x6c/0x310
[   62.368138]  ? folio_account_cleaned+0x85/0xa0
[   62.369583]  ? __folio_cancel_dirty+0x4b/0x50
[   62.370990]  truncate_inode_pages_range+0x12b/0x450
[   62.372570]  truncate_inode_pages_final+0x40/0x50
[   62.374077]  evict+0x271/0x290
[   62.375159]  ? dentry_unlink_inode+0xc2/0x120
[   62.376581]  ? preempt_count_add+0x74/0xc0
[   62.377913]  ? _raw_spin_lock+0x17/0x40
[   62.379168]  iput+0x189/0x230
[   62.380222]  do_unlinkat+0x1bd/0x2a0
[   62.381401]  __x64_sys_unlinkat+0x37/0x60
[   62.382698]  x64_sys_call+0x2e9/0x9b0
[   62.383909]  do_syscall_64+0x3d/0x90
[   62.385099]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
[   62.386678] RIP: 0033:0x7f5adf424f6b
[   62.387876] Code: 77 05 c3 0f 1f 40 00 48 8b 15 b9 ae 0d 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8d ae 0d 00 f7 d8 64 89 01 48
[   62.393339] RSP: 002b:00007ffcfbd77358 EFLAGS: 00000206 ORIG_RAX: 0000000000000107
[   62.395717] RAX: ffffffffffffffda RBX: 00005584136f65a0 RCX: 00007f5adf424f6b
[   62.397908] RDX: 0000000000000000 RSI: 00005584136f5380 RDI: 00000000ffffff9c
[   62.400075] RBP: 00005584136f52f0 R08: 00005584136f5380 R09: 00007ffcfbd7743c
[   62.402219] R10: 0000000000000007 R11: 0000000000000206 R12: 0000000000000000
[   62.404388] R13: 00007ffcfbd77520 R14: 00005584136f65a0 R15: 0000000000000002
[   62.406493]  </TASK>

As shown in the log above, the issue persists in kernel 6.6.59. However,
it was recently resolved in commit 2b0f922323cc ("mm: don't install PMD
mappings when THPs are disabled by the hw/process/vma"). The fix was
backported to 6.11. Would it make sense to backport it to 6.6 as well?

I encountered this issue while updating a Gentoo VM with an XFS
filesystem running under Xen. During a final stage of glibc update,
files were copied to the live system, but when locale-gen started, it
hung. I couldn't open a new shell, as it attempted to mmap an
LC_COLLATE-related file, resulting in the same page faults as reported
above.

I was able to reproduce it in qemu:

  qemu-system-x86_64 -cpu host -accel kvm -smp 2 -m 2G -nographic -serial mon:stdio \
    -kernel xen-4.16.5 -append "dom0_mem=1G,max:1G console=com1 nomodeset" \
	 -initrd "/tmp/linux/vmlinux console=hvc0 root=/dev/sda init=/bin/bash" -snapshot \
	 -device ahci,id=ahci -device ide-hd,drive=disk,bus=ahci.0 \
	 -drive file=disk.xfs.qcow,format=qcow2,if=none,id=disk

where disk.xfs.qcow is a qcow2 image directly formated as XFS with
gentoo-stage3 on it.

My distilled reproducer looks like this:

$ cat test.c
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

int
main(int argc, char * argv[]) {
	size_t size = 2 * 1024 * 1024;
	unsigned char buf[64];

	if (argc < 2) {
		printf("usage: example file [size]\n");
		return 0;
	}
	if (argc >= 3) {
		size = atoi(argv[2]);
	}

	const char * file = argv[1];
	fprintf(stderr, "file: %s\n", file);

	char * data = malloc(size);
	if (data == NULL) {
		perror("malloc");
		return 1;
	}

	for (size_t i = 0; i < size; i++) {
		data[i] = 'a' + (i / 8 % 26);
	}

	int fd = open(file, O_RDWR | O_CREAT, 0600);
	if (fd == -1) {
		perror("open");
		return 1;
	}
	if (write(fd, data, size) == -1) {
		perror("writev");
		return 2;
	}

	char * addr = mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (addr == MAP_FAILED) {
		perror("mmap");
		return 3;
	}
	fprintf(stderr, "mmaped to: %016zx\n", (intptr_t)addr);
	if (close(fd) == -1) {
		perror("close");
		return 4;
	}
	fprintf(stderr, "copy from: %016zx to: %016zx\n", (intptr_t)addr, (intptr_t)buf);
	/* process hangs in memcpy */
	memcpy(buf, addr, sizeof buf);

	return 0;
}

Ccing authors of mentioned commits.

Cheers,
Petr

--sUYvu/K4Fz22JAk/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEoDIFP/dmMcxNFBW7NR2RttffnlAFAmco1ggACgkQNR2Rttff
nlDIZA//Z89HBRO+fLux7tqvNKtUnF5ZZKpjR49BFBiek8C23ND+mJoiXWvQ+ey9
uALOEGaSjPu+pUkbc+wWU/lP1PlGfdGiEHr+3XFlGn7TifKapx0YeRuXIocQvf9Y
O7z/qjW/fAZ0f60xlhwUoVnBbjQmOZS3QSDo+Kk77SLu+dTss6add+Z2TEBWAnM7
OrvWyWV6KrCd1AJC/OXm1tutZZvvT1GJKaHGf1reSlqbCsDi9lfWmApwQT3H3SCY
m5HKm/RqinFcJltEcqu/pZD0bc4V1RZePPZ6dz+4mOVDYesHAvJkmyYw/8tmmBN0
QCUmiuT20ZVct59Mktl/e5EnUNXjHD18VisW3k3Vx/mzuX5rbB2aXBvbL12Ltsd/
bisy45n9hnhjTwPvCxWahfrEN45TU15m5iwItrPohA4DUwZFQwecDEObiHghElPc
Ecti+2JD1tPz3zchD6CvrWqujqHszIg4pWxpcynPsDIV3yVqjEQrMe25VHFxD/kM
kE8PXxpyl6ZtOVicnJdftWs84DYS/iKBlOS4pFHt8uoriSfdyXdCl8A+1eGLB834
ojVGC83KOnQIZ0Xp42M6vK7fdUnkRWcJ3ggWo6aX32If0ByoyxH3H3E5AW47AU7n
BbyK/vAGFzKJV4XtxA7WKl5iRD9H1JiZnd00UQVnnVzmq8vYlPE=
=zOaa
-----END PGP SIGNATURE-----

--sUYvu/K4Fz22JAk/--
