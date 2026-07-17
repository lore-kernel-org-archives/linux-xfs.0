Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7893FCB0B
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 13:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293476; cv=none; b=hxNNkxFyItrGGIQ+nv+sXLFPJ4dlVQg5EXonOxt0/c+WVEOVdSaLc+ziPXLrUYI/SwPtLKRjPo9jzoQj3OjInCcD33BIRJXC8lclix3xa7CBiib2M2t+AFU/c66iuN3KVF/jBgRdJr73XGGSOt/a/ChdoPAm4YqkYXagxWXDU0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293476; c=relaxed/simple;
	bh=uM41wcbh6bNVM4Mjp+GuOYMO7rgKlh3QSgR6C6XRvb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U7p5tf8RGadpJsVrVnzO2VEiDLHZPOt7O5hJReUp1XYRbnxUbgbSaqqcn+W/zJ6fc+foRAwqV8tmr/TocMMTccT31zR/8zVaKsj77ZKGs0D0ZKVmr234LGVmuW5QUsPD2pQ/IXWspQp5uX4Ge04kWoD0PgNmO0TOTQaYZu2z4lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com; spf=none smtp.mailfrom=readmodwrite.com; dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b=Zz1ul4JX; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=readmodwrite.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.b="Zz1ul4JX"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so22385405e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 06:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1784293473; x=1784898273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mHKecs5UO4Qj0vdfs0Itdm9xPYqFnVygrDIq1m0xZGU=;
        b=Zz1ul4JXClgIWqoTuS40aik/0nabUmmQ6Phz3UWpCM0ipeOTcDCTPot7gw/6flJo1D
         zTIBnT9AfsrsJy6oucE0zkwcCZYTCqF491E7FbrI7Qq2spPHa+EX10RS0OCSY2w21OpH
         GsQ89WWbT12Dpe/ds+N+4Yy0VZjS4cr3wnpGKvh/QD7jGTgifdV6gqGGjOFzrtTr/gFP
         xrDo7cuurs0wda1iLx9duFneqcdAxT9T78/37QSSHTuO7JFTIUywUHAObB+QB4W1uU8z
         vmUQVnh5IWJOb1NpSaBqWGQvgj+diwkG2lhwQAUuaM3uSE27e6cURibzPXsQwtc6hxLD
         pKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784293473; x=1784898273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mHKecs5UO4Qj0vdfs0Itdm9xPYqFnVygrDIq1m0xZGU=;
        b=aIM2dPrH0mQbTL9AD0TkAhvfyH+W7ASuczN2ux2qfHzoBjABuZscdMOjeQIaAVBOBB
         lm7ld5GqpHyOZJOJEIiXO8DxnfeMKAcbh5Ah3TviNzw43A09t9GssifkXWXcXCqiiK2u
         I+iYnomDm3zhqxIZ+IW9lZfuFe0E1fYQC0vCbZinvNmwtmJ9tI31/jVqhBeBODc5nYwp
         CtbMxaLXPD+L4ZTzq8w1UGSbnYTUd0Dt6s2mIi6exrnhR7d7SPW4NeBck+mP4VPm8hMG
         p1PjLuTbV64lRex4jAFYjh53dS85P4Rn//CQqrubhE7MaRlczp65LebZ4QcXHlxqCTLB
         M9Ww==
X-Gm-Message-State: AOJu0Ywkuzvo7gWaDiYjgMT3Ni6LwYmA9XlQtk9s9SEVtAWnrgj04dPO
	bwqmlPBwqANQzhJtiKaMPtT3yiyir/CON6iJ82EQL6WGbqR62S+6A6RlfoDX5WLkAo8lcG8oRol
	P/1Fp
X-Gm-Gg: AfdE7cnRimPyVe+GcOqxyf1tt1x04rGGwmMQL3OlIfX3IyyLLLWzR8VBxPTzhOgX4qw
	Id+AP4G+79/fDbHKx3ihcZEPrR/xiILSrFc6RQ1r+b124tdQk3nev59+ZWMFDWPea/yGuDRCYBR
	M7iQAWM54lC3snO2h7JWQAJR2kAC9X5PrrdUGmiIubni8VgnIGpSb5zErR2D5ekn990wQJwUgzb
	Ekl0XlKRHJUraJm4PZlT8gD4ixfs2aKVNrT5fEotgQBebVZMU4aqnA+QZDZcpmn6stWY0UKafkZ
	sd7LZMZFz8+HgTPe954k8QpJi6LoBbce1Yr/co/zNrT6Bs3JDUHQ9nfkOFQ+rQrEof4xYT6JhGj
	uOQko8/T8aQdDeHd3czj37iSExgJSihpNLbtROwCsmmBQNcSPwGNt/ilf7gLvbCS/Xb9apWUxKB
	wvfF0e
X-Received: by 2002:a05:600c:3587:b0:493:bb0:3b43 with SMTP id 5b1f17b1804b1-4954a3d06d9mr28652455e9.2.1784293472531;
        Fri, 17 Jul 2026 06:04:32 -0700 (PDT)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:1cdc::2e0:ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954c841a0dsm20184085e9.5.2026.07.17.06.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 06:04:31 -0700 (PDT)
From: Matt Fleming <matt@readmodwrite.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: [BUG] xfs: sparse inode allocation can trip i != 1 after AGFL growth
Date: Fri, 17 Jul 2026 14:04:29 +0100
Message-ID: <20260717130429.1838767-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

We're hitting an XFS shutdown in the sparse inode allocation path on
6.18-based kernels.  The xfstests reproducer below also fails on
v7.2-rc3.  The failure looks like this:

```
[   18.785047][  T580] XFS (loop0): Internal error i != 1 at line 3768 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1b8/0x270
[   18.786901][  T580] CPU: 6 UID: 0 PID: 580 Comm: krn1319-trigger Not tainted 6.18.37-cloudflare-2026.6.20 #1 PREEMPT(voluntary) 
[   18.786905][  T580] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[   18.786907][  T580] Call Trace:
[   18.786918][  T580]  <TASK>
[   18.786923][  T580]  dump_stack_lvl+0x4b/0x70
[   18.786930][  T580]  xfs_corruption_error+0xac/0xc0
[   18.786934][  T580]  ? xfs_btree_insert+0x1b8/0x270
[   18.786937][  T580]  xfs_btree_insert+0x1ee/0x270
[   18.786944][  T580]  ? xfs_btree_insert+0x1b8/0x270
[   18.786950][  T580]  ? xfs_inobt_insert_sprec.constprop.0+0x88/0x2d0
[   18.786953][  T580]  xfs_inobt_insert_sprec.constprop.0+0x88/0x2d0
[   18.786956][  T580]  xfs_ialloc_ag_alloc+0x25e/0x610
[   18.786960][  T580]  osnoise_arch_unregister+0x210/0x210
[   18.786964][  T580]  ? xfs_trans_alloc_icreate+0x89/0x110
[   18.786967][  T580]  xfs_create+0x165/0x460
[   18.786971][  T580]  xfs_generic_create+0x301/0x390
[   18.786975][  T580]  ? d_splice_alias_ops+0x1a8/0x660
[   18.786979][  T580]  path_openat+0x10e5/0x13c0
[   18.786984][  T580]  do_filp_open+0xc7/0x170
[   18.786987][  T580]  ? _raw_spin_unlock+0xe/0x30
[   18.786991][  T580]  ? change_protection+0x89e/0x1840
[   18.786995][  T580]  ? __x64_sys_prctl+0x27b/0xda0
[   18.786999][  T580]  ? kmem_cache_alloc_noprof+0x354/0x5b0
[   18.787002][  T580]  ? __check_object_size+0x1d6/0x1f0
[   18.787006][  T580]  do_sys_openat2+0x6e/0xc0
[   18.787010][  T580]  __x64_sys_openat+0x61/0xa0
[   18.787013][  T580]  do_syscall_64+0x74/0xa00
[   18.787018][  T580]  ? flush_tlb_func+0x2be/0x340
[   18.787021][  T580]  ? mod_memcg_lruvec_state+0xc5/0x1f0
[   18.787024][  T580]  ? __lruvec_stat_mod_folio+0x97/0x130
[   18.787027][  T580]  ? __folio_mod_stat+0x2d/0x90
[   18.787029][  T580]  ? folio_add_new_anon_rmap+0xa1/0x360
[   18.787032][  T580]  ? _raw_spin_unlock+0xe/0x30
[   18.787033][  T580]  ? do_wp_page+0x5ee/0x13a0
[   18.787036][  T580]  ? __handle_mm_fault+0x8b3/0xdf0
[   18.787040][  T580]  ? count_memcg_events+0xc2/0x190
[   18.787041][  T580]  ? handle_mm_fault+0x19b/0x280
[   18.787044][  T580]  ? do_user_addr_fault+0x22a/0x6e0
[   18.787046][  T580]  ? exc_page_fault+0x8f/0x1b0
[   18.787048][  T580]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   18.787051][  T580] RIP: 0033:0x4398d1
[   18.787054][  T580] Code: 75 57 89 f0 25 00 00 41 00 3d 00 00 41 00 74 49 80 3d 9a e7 06 00 00 74 6d 89 da 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 93 00 00 00 48 8b 54 24 28 64 48 2b 14 25
[   18.787056][  T580] RSP: 002b:00007ffd378317d0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
[   18.787059][  T580] RAX: ffffffffffffffda RBX: 00000000000800c1 RCX: 00000000004398d1
[   18.787061][  T580] RDX: 00000000000800c1 RSI: 00007ffd37831860 RDI: 00000000ffffff9c
[   18.787065][  T580] RBP: 00007ffd37831860 R08: 0000000000000000 R09: 0000000000000000
[   18.787067][  T580] R10: 0000000000000180 R11: 0000000000000202 R12: 00007ffd37832a78
[   18.787068][  T580] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000003
[   18.787070][  T580]  </TASK>
[   18.825732][  T580] XFS (loop0): Corruption detected. Unmount and run xfs_repair
[   18.827101][  T580] XFS (loop0): invalid sparse inode record: ino 0x6500 holemask 0xff00 count 32
[   18.828459][  T580] XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_ialloc_ag_alloc+0x466/0x610 (fs/xfs/libxfs/xfs_ialloc.c:920).  Shutting down filesystem.
[   18.830702][  T580] XFS (loop0): Please unmount the filesystem and rectify the problem(s)
```

The sparse inode record does not appear to be corrupt.  The problem looks
like an allocator invariant violation caused by AGFL requirements changing
between the sparse inode extent allocation and the subsequent inobt insert.

I have an xfstests reproducer here:

  https://github.com/mfleming/xfstests-dev/commit/01a530256e47e15e4d54a08798fa3112067c793e

It formats the fs with:

```
mkfs.xfs -f -K \
        -s size=4096 \
        -m crc=1,finobt=1,rmapbt=1,reflink=1,inobtcount=1,bigtime=1 \
        -i size=512,sparse=1,maxpct=25,nrext64=1 \
        -d agcount=2,su=512k,sw=2 \
        <loopdev>
```

The reproducer sets AG0 to this precondition immediately before the
final file create:

```
inobt leaf:        252/252 records
bnobt/cntbt:       505/505 records
AGFL:              flcount=8, min_freelist=8
levels:            bno/cnt/rmap = 1/1/2
free/reservation:  xfs_db agresv free=2522, reservation=2505
pagf_freeblks:     2514        # xfs_db free includes AGFL blocks
available:         2514 + min(8, 8) - 2505 - 8 - 2 = 7
trigger extent:    agbno=3330, len=8
```

The failure sequence seems to be:

1. AG0 has no free inodes, so inode allocation needs a new chunk.
2. Full chunk allocation cannot fit.
3. Sparse chunk allocation can fit and passes the old AGFL minimum check.
4. Removing the sparse extent from free space grows both bnobt and cntbt.
5. That raises `xfs_alloc_min_freelist()` and drains the AGFL.
6. The later inobt leaf split needs one ordinary block and gets no block.
7. The no-progress result becomes `i != 1` and is treated as corruption.

I think the sparse-inode logic was introduced by commit 56d1115c9bc7
("xfs: allocate sparse inode chunks on full chunk allocation failure").

rmapbt/per-AG reservations make this much easier to hit because most of an AG's
raw free space can be reserved for metadata growth, but the sparse inode path
above is what turns the allocation failure into a filesystem shutdown.

Thanks,
Matt
