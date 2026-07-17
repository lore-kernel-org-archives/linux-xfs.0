Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7955F379960
	for <linux-xfs@vger.kernel.org>; Fri, 17 Jul 2026 17:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784310994; cv=none; b=GN2Opw47Kvbk5nd2s0UNGE+yaH0NZ1vGZ9LJFZXoGaiIeD+se3ozY5XyOLuUZnvIkouXXW5L4uS4jApu7aHcarnFqF3XG1oA6qz2QfUOqPiI/W49WPaw8aIIougPw4qer5whr9jx59f1ADP/yUCMLxL2lJnjIsQJTcWN3tAhL5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784310994; c=relaxed/simple;
	bh=zU2EUblC5ojI3NGg6YBmc/IqJM1UJJUsJVDJQwI8iSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehJRPZAdAs0+VHJy7n48DSA3VACPHanvATLcuKbHK8ns1N76pRetNGWbHThTgYDUcpBZ/wKRcXXbQa76LJGE1+QfAfqNaejpH6U1And89e/YtExP9b7/rBRJe/B/1xpiwGBAgrMfObuf8PdX/XR1oOs5ew3Hk7iutg+B0a7r1ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CXfPxign; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CXfPxign"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784310990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ybUqtZTWhgthdz13VQRQ0b9hZmi4YsLqMzz+CRzsib0=;
	b=CXfPxignoDeCHFljjd9MBeDRdR6yfEWaKspo58/d+ByKYbk90ieiXKX3gjkDHeu3A0kd/T
	POQdA/H9iaoRs5wkviw71hrKkkauozmYyAA9uB/Gynm3TcJBWq5ycIH0FJPbTDhY6YgIK5
	5WffXM6/1oAzkBX+/hqVlRwvwu/xdH0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-FsSGb3zbNo644yJEsaeoCA-1; Fri,
 17 Jul 2026 13:56:26 -0400
X-MC-Unique: FsSGb3zbNo644yJEsaeoCA-1
X-Mimecast-MFC-AGG-ID: FsSGb3zbNo644yJEsaeoCA_1784310985
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79CC1180288E;
	Fri, 17 Jul 2026 17:55:46 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.111])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1288130040BF;
	Fri, 17 Jul 2026 17:55:44 +0000 (UTC)
Date: Fri, 17 Jul 2026 13:55:42 -0400
From: Brian Foster <bfoster@redhat.com>
To: Matt Fleming <matt@readmodwrite.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [BUG] xfs: sparse inode allocation can trip i != 1 after AGFL
 growth
Message-ID: <alpsniDzp5kWl0xA@bfoster>
References: <20260717130429.1838767-1-matt@readmodwrite.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717130429.1838767-1-matt@readmodwrite.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Jul 17, 2026 at 02:04:29PM +0100, Matt Fleming wrote:
> Hi,
> 
> We're hitting an XFS shutdown in the sparse inode allocation path on
> 6.18-based kernels.  The xfstests reproducer below also fails on
> v7.2-rc3.  The failure looks like this:
> 
> ```
> [   18.785047][  T580] XFS (loop0): Internal error i != 1 at line 3768 of file fs/xfs/libxfs/xfs_btree.c.  Caller xfs_btree_insert+0x1b8/0x270
> [   18.786901][  T580] CPU: 6 UID: 0 PID: 580 Comm: krn1319-trigger Not tainted 6.18.37-cloudflare-2026.6.20 #1 PREEMPT(voluntary) 
> [   18.786905][  T580] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> [   18.786907][  T580] Call Trace:
> [   18.786918][  T580]  <TASK>
> [   18.786923][  T580]  dump_stack_lvl+0x4b/0x70
> [   18.786930][  T580]  xfs_corruption_error+0xac/0xc0
> [   18.786934][  T580]  ? xfs_btree_insert+0x1b8/0x270
> [   18.786937][  T580]  xfs_btree_insert+0x1ee/0x270
> [   18.786944][  T580]  ? xfs_btree_insert+0x1b8/0x270
> [   18.786950][  T580]  ? xfs_inobt_insert_sprec.constprop.0+0x88/0x2d0
> [   18.786953][  T580]  xfs_inobt_insert_sprec.constprop.0+0x88/0x2d0
> [   18.786956][  T580]  xfs_ialloc_ag_alloc+0x25e/0x610
> [   18.786960][  T580]  osnoise_arch_unregister+0x210/0x210
> [   18.786964][  T580]  ? xfs_trans_alloc_icreate+0x89/0x110
> [   18.786967][  T580]  xfs_create+0x165/0x460
> [   18.786971][  T580]  xfs_generic_create+0x301/0x390
> [   18.786975][  T580]  ? d_splice_alias_ops+0x1a8/0x660
> [   18.786979][  T580]  path_openat+0x10e5/0x13c0
> [   18.786984][  T580]  do_filp_open+0xc7/0x170
> [   18.786987][  T580]  ? _raw_spin_unlock+0xe/0x30
> [   18.786991][  T580]  ? change_protection+0x89e/0x1840
> [   18.786995][  T580]  ? __x64_sys_prctl+0x27b/0xda0
> [   18.786999][  T580]  ? kmem_cache_alloc_noprof+0x354/0x5b0
> [   18.787002][  T580]  ? __check_object_size+0x1d6/0x1f0
> [   18.787006][  T580]  do_sys_openat2+0x6e/0xc0
> [   18.787010][  T580]  __x64_sys_openat+0x61/0xa0
> [   18.787013][  T580]  do_syscall_64+0x74/0xa00
> [   18.787018][  T580]  ? flush_tlb_func+0x2be/0x340
> [   18.787021][  T580]  ? mod_memcg_lruvec_state+0xc5/0x1f0
> [   18.787024][  T580]  ? __lruvec_stat_mod_folio+0x97/0x130
> [   18.787027][  T580]  ? __folio_mod_stat+0x2d/0x90
> [   18.787029][  T580]  ? folio_add_new_anon_rmap+0xa1/0x360
> [   18.787032][  T580]  ? _raw_spin_unlock+0xe/0x30
> [   18.787033][  T580]  ? do_wp_page+0x5ee/0x13a0
> [   18.787036][  T580]  ? __handle_mm_fault+0x8b3/0xdf0
> [   18.787040][  T580]  ? count_memcg_events+0xc2/0x190
> [   18.787041][  T580]  ? handle_mm_fault+0x19b/0x280
> [   18.787044][  T580]  ? do_user_addr_fault+0x22a/0x6e0
> [   18.787046][  T580]  ? exc_page_fault+0x8f/0x1b0
> [   18.787048][  T580]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   18.787051][  T580] RIP: 0033:0x4398d1
> [   18.787054][  T580] Code: 75 57 89 f0 25 00 00 41 00 3d 00 00 41 00 74 49 80 3d 9a e7 06 00 00 74 6d 89 da 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 93 00 00 00 48 8b 54 24 28 64 48 2b 14 25
> [   18.787056][  T580] RSP: 002b:00007ffd378317d0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
> [   18.787059][  T580] RAX: ffffffffffffffda RBX: 00000000000800c1 RCX: 00000000004398d1
> [   18.787061][  T580] RDX: 00000000000800c1 RSI: 00007ffd37831860 RDI: 00000000ffffff9c
> [   18.787065][  T580] RBP: 00007ffd37831860 R08: 0000000000000000 R09: 0000000000000000
> [   18.787067][  T580] R10: 0000000000000180 R11: 0000000000000202 R12: 00007ffd37832a78
> [   18.787068][  T580] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000003
> [   18.787070][  T580]  </TASK>
> [   18.825732][  T580] XFS (loop0): Corruption detected. Unmount and run xfs_repair
> [   18.827101][  T580] XFS (loop0): invalid sparse inode record: ino 0x6500 holemask 0xff00 count 32
> [   18.828459][  T580] XFS (loop0): Corruption of in-memory data (0x8) detected at xfs_ialloc_ag_alloc+0x466/0x610 (fs/xfs/libxfs/xfs_ialloc.c:920).  Shutting down filesystem.
> [   18.830702][  T580] XFS (loop0): Please unmount the filesystem and rectify the problem(s)
> ```
> 
> The sparse inode record does not appear to be corrupt.  The problem looks
> like an allocator invariant violation caused by AGFL requirements changing
> between the sparse inode extent allocation and the subsequent inobt insert.
> 
> I have an xfstests reproducer here:
> 
>   https://github.com/mfleming/xfstests-dev/commit/01a530256e47e15e4d54a08798fa3112067c793e
> 
> It formats the fs with:
> 
> ```
> mkfs.xfs -f -K \
>         -s size=4096 \
>         -m crc=1,finobt=1,rmapbt=1,reflink=1,inobtcount=1,bigtime=1 \
>         -i size=512,sparse=1,maxpct=25,nrext64=1 \
>         -d agcount=2,su=512k,sw=2 \
>         <loopdev>
> ```
> 
> The reproducer sets AG0 to this precondition immediately before the
> final file create:
> 
> ```
> inobt leaf:        252/252 records
> bnobt/cntbt:       505/505 records
> AGFL:              flcount=8, min_freelist=8
> levels:            bno/cnt/rmap = 1/1/2
> free/reservation:  xfs_db agresv free=2522, reservation=2505
> pagf_freeblks:     2514        # xfs_db free includes AGFL blocks
> available:         2514 + min(8, 8) - 2505 - 8 - 2 = 7
> trigger extent:    agbno=3330, len=8
> ```
> 
> The failure sequence seems to be:
> 
> 1. AG0 has no free inodes, so inode allocation needs a new chunk.
> 2. Full chunk allocation cannot fit.
> 3. Sparse chunk allocation can fit and passes the old AGFL minimum check.
> 4. Removing the sparse extent from free space grows both bnobt and cntbt.

I assume this means we happen to alloc a sparse chunk out of the middle
of a free extent, causing an additional record and thus splits in both
trees.

It also looks like we set args.minleft = igeo->inobt_maxlevels in the
chunk alloc path, presumably with the intent to leave enough blocks
around for inode record insertion. I assume the above available value is
prior to the sparse chunk alloc. It would be interesting to see what the
same values/calculations are after the chunk alloc at the time of the
inobt block alloc that fails.

> 5. That raises `xfs_alloc_min_freelist()` and drains the AGFL.
> 6. The later inobt leaf split needs one ordinary block and gets no block.
> 7. The no-progress result becomes `i != 1` and is treated as corruption.
> 

I am a little curious if this is really specific to sparse inode
functionality or whether it just leads to allocation circumstances that
make it more reproducible. I.e., sparse inode chunks are just smaller
chunk allocations and special formatted inode records that rely on the
same allocation and inode btrees as regular inode chunks.

Regardless, I'm about to head on holiday for the next week so I won't be
able to take a deeper look until later. I'm mainly responding to say I'm
not ignoring this. Unless somebody else happens to get to it in the
meantime I'll take a closer look when I'm back. Thanks for the analysis
and reproducer.

Brian

> I think the sparse-inode logic was introduced by commit 56d1115c9bc7
> ("xfs: allocate sparse inode chunks on full chunk allocation failure").
> 
> rmapbt/per-AG reservations make this much easier to hit because most of an AG's
> raw free space can be reserved for metadata growth, but the sparse inode path
> above is what turns the allocation failure into a filesystem shutdown.
> 
> Thanks,
> Matt
> 

