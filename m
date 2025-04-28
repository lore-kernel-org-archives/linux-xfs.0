Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C900D268FEB
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745851375; cv=none; b=NfYJwVmRNt98dLVJZiYfTlIpRfY0QVa6kp2yGFj6bP9S2HU4ky+07sTxMwedkl58lKuNNu4JwitG5qL2LyT4AU4zdPMwIMe4ekwZrjfLBtlnmju8uxv9UQL4GdENnH6y0qZAZ98zInm48zuDM9iSCp66yJ6Pn3wBqRxrVDIudFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745851375; c=relaxed/simple;
	bh=2xgAAGLeN+eLBlFyWDR5ICKH8STz76Z9bvwsf8R2Swo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lnOL3hhChOll/BzQtqWh4wbgiFITNMW7+HPxl8DUe8Man71My3kNnLBZW5+xFKtb51woeoQUcKgogrjOmcpbuQCZhTgpbagEL6AqsrhCbyVdMYqp425DSx0GNTynQYdHVtnZ4wM7eWy2AgVUe+JFUWlNH32rprkbOqdsUGsxDFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LLPVYsTJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LLPVYsTJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745851372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=M/L7WTx3gAsnvDvTLkhXxUOeAtuqwPYzjGBb3TUodOA=;
	b=LLPVYsTJP+mrn5+wQ8B9AqZMVWJs71iz90iUh0G/JrnMa+9Hklg5yuN4jSfLdliFtIMJTn
	hxqSqYtraOAvoK4+W7dbGl9b6zIc8BFzlSCg8C2EeLwyw9yOtBt2OQd6phwnz8Wnfc0FyP
	vMJ8if8hHmFbnSFzvVp3bhIrQ3p1d6Y=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-B2CRlXB7Mh65EChoEtB6lg-1; Mon, 28 Apr 2025 10:42:51 -0400
X-MC-Unique: B2CRlXB7Mh65EChoEtB6lg-1
X-Mimecast-MFC-AGG-ID: B2CRlXB7Mh65EChoEtB6lg_1745851370
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-225107fbdc7so47021105ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 07:42:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745851370; x=1746456170;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/L7WTx3gAsnvDvTLkhXxUOeAtuqwPYzjGBb3TUodOA=;
        b=THJFFLN2m+W6odb975J9g70IdgiBRr9QBa4jFNbhtm7F7tJ8wHFTaZqYkgd4lQhDyv
         8eIf0fn+zowEdKXyb5vZAYu+m29Wqhl+7XhVfv1/PpXqOnVUbuOYOCLAo9Kg5NGlHeVA
         sIi7zIoLmfov4DkJ0dnrC1pvgNUmC7Q72UTOv0amFZPmrbEwCsDKx1HnZRz9fPZl0uVj
         eoxlkoHZn1fRYfM6tzJ9J7Bz6R0XIOig4rFaiLTgX7p9o/pdKORBYiWCdv7fRKk3Z1dE
         H/CDxQuHJ9FRzu8lYUCD7nWvwnbCqFGup7dBGYg+E4nsxBQWWbfs93T9GfTtZaC85cHT
         uFyQ==
X-Gm-Message-State: AOJu0YyvQLW3T0AObvsUG5vkbDoslqzFundx4hx2ppq75d7CSXi/Alkb
	bWfXFuUjyjYubGvK5g2Qu6uaeNqXzlTEVZBcMHfgp4OnMydsfDpqTr6tFb6Ik91fjgam3byb+mG
	Z2ViA28QJU1ZddjesfsNbBmfXOjPfrjeklkyjMMVVm2MlKy7aIEFPTJOlEiDCHTmBXsD3hHvQON
	yNQolzeFDlkxdIOflo3VU37l3F3wr1myRTspMAbA==
X-Gm-Gg: ASbGncs0s4pkVmth1z71UPXpTAMNlb/tBdcV86AwU2CpXAPpLalvadHByvVenseqvkB
	Q7PouR2O7JscEwbff4KJbEikqMOo/vs6wQuGS7Lcmsbt6aTJVczfTEgkxNsHJwtUV03YCDgPxSY
	yEKxnsS81A/HK/063hTjrlc2MYaB7tpYOy3EQBE6RVxO1sdQXkPCW3/5v6pDQLigXNKt5AJ2p0I
	cSCZWLobCtLMF/czlU0QQczpf5QAItyZBs8aqBXNHYvblYDbMWlvMWqsYL0qqZlzyz6i01NfUyo
	15OKrtdian0z0OSvB9c/JGJi/Rg+6eS+xZv/AWugE3j7na1GIgyq
X-Received: by 2002:a17:903:120e:b0:22d:b243:2fee with SMTP id d9443c01a7336-22dbf5e7f9fmr165675075ad.13.1745851369768;
        Mon, 28 Apr 2025 07:42:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGK3aVxbN5AfFCcT4bnYr2DA0Jf1EVKelfn0UGlJlf4+VEwflPoz4qWt1SpwlhAPrSgAM/tlA==
X-Received: by 2002:a17:903:120e:b0:22d:b243:2fee with SMTP id d9443c01a7336-22dbf5e7f9fmr165674705ad.13.1745851369230;
        Mon, 28 Apr 2025 07:42:49 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbb1a0sm83666255ad.58.2025.04.28.07.42.47
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 07:42:48 -0700 (PDT)
Date: Mon, 28 Apr 2025 22:42:45 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [xfstests xfs/538] XFS: Assertion failed: pathlen == 0, file:
 fs/xfs/libxfs/xfs_symlink_remote.c, line: 383
Message-ID: <20250428144245.gxesqz7emzrdxqyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Recently I hit below kernel assertion[1] many times, by running xfstests xfs/538
on xfs. I reproduced it on s390x with 1k blocksize xfs, I'll try it on other
arches if you need.

Thanks,
Zorro

[1]
[  459.264036] run fstests xfs/538 at 2025-04-27 11:33:00
[  459.517809] XFS (loop1): Mounting V5 Filesystem 1598811d-b0ce-47b2-99f9-265f2a1cd4ab
[  459.519201] XFS (loop1): Ending clean mount
[  524.631247] xfs_errortag_test: 65989 callbacks suppressed
[  524.631254] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  524.631259] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  524.631289] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  524.631303] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  524.631309] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
...
[  544.675052] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  544.675066] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  544.675107] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  544.675176] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  547.476961] XFS: Assertion failed: pathlen == 0, file: fs/xfs/libxfs/xfs_symlink_remote.c, line: 383
[  547.477050] ------------[ cut here ]------------
[  547.477052] WARNING: CPU: 1 PID: 82934 at fs/xfs/xfs_message.c:104 assfail+0x4e/0x70 [xfs]
[  547.477585] Modules linked in: sunrpc rfkill virtio_net net_failover failover pkey_pckmo vfio_ccw mdev vfio_iommu_type1 vfio iommufd drm fuse drm_panel_orientation_quirks loop i2c_core nfnetlink vsock_loopback vmw_vsock_virtio_transport_common vsock ctcm fsm qeth ccwgroup zfcp scsi_transport_fc qdio dasd_fba_mod dasd_eckd_mod dasd_mod xfs ghash_s390 prng des_s390 sha3_512_s390 virtio_blk sha3_256_s390 dm_mirror dm_region_hash dm_log dm_mod pkey aes_s390
[  547.477628] CPU: 1 UID: 0 PID: 82934 Comm: fsstress Kdump: loaded Not tainted 6.15.0-rc3+ #1 NONE 
[  547.477633] Hardware name: IBM 8561 LT1 400 (KVM/Linux)
[  547.477637] Krnl PSW : 0704c00180000000 0000016b2022a642 (assfail+0x52/0x70 [xfs])
[  547.477864]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[  547.477868] Krnl GPRS: 00000000ffffffea 0000016b202f0770 ffffffffffffffea 000000000000000a
[  547.477872]            000000ebffffffea 0000000000000000 0000016b20465d94 0000000000000001
[  547.477874]            0000000000000000 00000000f2a19000 0000000000000025 0000000094ff0740
[  547.477876]            0000000000000001 00000000de4eb838 0000016b2022a630 000000eba0d679e8
[  547.477887] Krnl Code: 0000016b2022a636: 95001018		cli	24(%r1),0
                          0000016b2022a63a: a774000a		brc	7,0000016b2022a64e
                         #0000016b2022a63e: af000000		mc	0,0
                         >0000016b2022a642: eb6ff0a80004	lmg	%r6,%r15,168(%r15)
                          0000016b2022a648: 07fe		bcr	15,%r14
                          0000016b2022a64a: 47000700		bc	0,1792
                          0000016b2022a64e: af000000		mc	0,0
                          0000016b2022a652: 0707		bcr	0,%r7
[  547.477909] Call Trace:
[  547.477911]  [<0000016b2022a642>] assfail+0x52/0x70 [xfs] 
[  547.478145] ([<0000016b2022a630>] assfail+0x40/0x70 [xfs])
[  547.478381]  [<0000016b201f45be>] xfs_symlink_write_target+0x30e/0x320 [xfs] 
[  547.478589]  [<0000016b20234a52>] xfs_symlink+0x432/0x530 [xfs] 
[  547.478822]  [<0000016b20222c7e>] xfs_vn_symlink+0x9e/0x1d0 [xfs] 
[  547.479043]  [<0000016ba04b00f2>] vfs_symlink+0x172/0x210 
[  547.479050]  [<0000016ba04b4b86>] do_symlinkat+0xe6/0x110 
[  547.479054]  [<0000016ba04b4d5a>] __s390x_sys_symlink+0x5a/0x70 
[  547.479057]  [<0000016ba0bef49c>] __do_syscall+0x15c/0x260 
[  547.479064]  [<0000016ba0bfa7e4>] system_call+0x74/0x98 
[  547.479068] Last Breaking-Event-Address:
[  547.479069]  [<0000016b202e29d6>] xfs_printk_level+0x9e/0xa8 [xfs]
[  547.479299] ---[ end trace 0000000000000000 ]---
[  549.680432] xfs_errortag_test: 65876 callbacks suppressed
[  549.680440] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  549.680864] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
[  549.680950] XFS (loop1): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3660, on filesystem "loop1"
...

