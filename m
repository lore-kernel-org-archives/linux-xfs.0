Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115036D24
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 06:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LZ7qkjTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702967670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=thP5R5DIytirb14QjmBGQDKYsu2g9Q+8DpDEEpKUwvw=;
	b=LZ7qkjTIB8eFh+k1VmksWC3+Vs6ynFDhF2ln4ju6jkYRRD0S+tQUVJ9ZgCUrAY2ZINaUey
	vsPeJdpemBK931oUPRdWwhG7UYmyrJeGOIVwB1AKkFOgV5tJc5fNixEZ8p2S0zvdmyz5X8
	UPYGvrec7aQ7wW0Z8i8wtEiauLU+raE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-huqXSTqQMemECgM0kFeSeg-1; Tue, 19 Dec 2023 01:34:26 -0500
X-MC-Unique: huqXSTqQMemECgM0kFeSeg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1d3c77082ccso13848695ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:34:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702967665; x=1703572465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thP5R5DIytirb14QjmBGQDKYsu2g9Q+8DpDEEpKUwvw=;
        b=wbYcez760V8QdANOYmLbAXip83uepx+sGrvUnUssbJzs5qEizPiSiqavMS6k6yF3Rl
         1RQmqEkCgY2HoHvttRCRrfwh5Oj/XxrBnGBO1QpsONN0jEXO+YZkvaA8V5/MvXL6tabA
         t9HBe161HWRy6npLglw9VdwizZDt74dZOfPevG+DH5O8Soql33U9CHxwXLFLsbzPGUMH
         Pm7uWNiqJiuVPAywIdRKjXKEE79thaOaCQCsJ6CsmzZZLRwPeCXFuuhzUg8bhd1iEX8/
         DM56mP8ibGDJYKZYods3ViH+ZlRmJUfbuB5GsIJpiaADXBOkk5H8bTVmBH8UL1YM6yb1
         bMCg==
X-Gm-Message-State: AOJu0Yyq5zS7PtuXFinLpYS75S/jtAtgd0ZvNhqtWaZITsUBoGE711pS
	T0D3v145EEyAj7jzox6vCaRfHB/XjiJZ65boFZVEnPSgzpMdMTj54ZE7/xi/X01EUdMm7OWKOvd
	xPyTa6hEQgNRAGlBDyZto
X-Received: by 2002:a17:902:bb8f:b0:1d3:8341:b928 with SMTP id m15-20020a170902bb8f00b001d38341b928mr7017610pls.115.1702967665191;
        Mon, 18 Dec 2023 22:34:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGouCVxowE+5fgKiJmkCXfhqDG47DJAnXHPN9/mkuej8XJmSy8XUC+4cbNqYXq4R4L/W1Ktqw==
X-Received: by 2002:a17:902:bb8f:b0:1d3:8341:b928 with SMTP id m15-20020a170902bb8f00b001d38341b928mr7017602pls.115.1702967664718;
        Mon, 18 Dec 2023 22:34:24 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902b10100b001d3a9676973sm358362plr.111.2023.12.18.22.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 22:34:24 -0800 (PST)
Date: Tue, 19 Dec 2023 14:34:20 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <20231219063420.qssutqqhr3hreevw@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20231218174836.GQ361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218174836.GQ361584@frogsfrogsfrogs>

On Mon, Dec 18, 2023 at 09:48:36AM -0800, Darrick J. Wong wrote:
> On Mon, Dec 18, 2023 at 10:01:34PM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > Recently I hit a crash [1] on s390x with 64k directory block size xfs
> > (-n size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1),
> > even not panic, a assertion failure will happen.
> > 
> > I found it from an old downstream kernel at first, then reproduced it
> > on latest upstream mainline linux (v6.7-rc6). Can't be sure how long
> > time this issue be there, just reported it at first.
> > 
> > I hit and reproduced it several times by running generic/648 on s390x
> > with "-n size=65536" xfs many times. Not sure if s390x is needed, I'll
> > try to check other arches.
> 
> XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check+0x372/0x6c0 [xfs], xfs_dir3_block block 0x1020
> 
> Where in the source code is this             ^^^^^^^^^^^^^^^^^^^^^^^^^^^?

The source is just based on HEAD="v6.7-rc6", the decode_stacktrace.sh output is:
  [  979.227613] XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check (fs/xfs/libxfs/xfs_dir2_data.c:137) xfs, xfs_dir3_block block 0x1020

The code is as below:

        switch (hdr->magic) {
        case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
        case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
                btp = xfs_dir2_block_tail_p(geo, hdr);
                lep = xfs_dir2_block_leaf_p(btp);

                if (be32_to_cpu(btp->count) >=
                    xfs_dir2_data_max_leaf_entries(geo))
137: ==>                 return __this_address;
                break;


More output as below:

[  979.225081] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
[  979.225120] ------------[ cut here ]------------
[  979.225122] WARNING: CPU: 1 PID: 157902 at fs/xfs/xfs_message.c:104 assfail (fs/xfs/xfs_message.c:104 (discriminator 3)) xfs
[  979.225349] Modules linked in: tls loop lcs ctcm fsm qeth ccwgroup zfcp qdio scsi_transport_fc dasd_fba_mod dasd_eckd_mod dasd_mod rfkill sunrpc vfio_ccw mdev vfio_iommu_type1 vfio drm
+fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c ghash_s390 prng des_s390 virtio_net net_failover sha3_512_s390 virtio_blk failover sha3_256_s390 dm_mirror dm_region_hash dm_log
+dm_mod pkey zcrypt aes_s390
[  979.225376] Hardware name: IBM 8561 LT1 400 (KVM/Linux)
[  979.225377] Krnl PSW : 0704c00180000000 000003ff7ffead7a (assfail+0x52/0x68 xfs])
[  979.225457]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[  979.225460] Krnl GPRS: c000000000000021 000003ff800549b0 ffffffffffffffea 000000000000000a
[  979.225462]            0000038000363418 0000000000000000 000003ff80162b74 000000030001c127
[  979.225464]            00000000ccc51d40 000000030001c127 00000000dfa03000 0000000163d19600
[  979.225465]            000003ffa1f2ef68 000003ff80147c28 000003ff7ffead68 00000380003634c0
[ 979.225476] Krnl Code: 000003ff7ffead6e: 95001010 cli 16(%r1),0
All code
========

Code starting with the faulting instruction
===========================================
[  979.225476]            000003ff7ffead72: a774000a           brc     7,000003ff7ffead86
[  979.225476]           #000003ff7ffead76: af000000           mc      0,0
[  979.225476]           >000003ff7ffead7a: eb6ff0a80004       lmg     %r6,%r15,168(%r15)
[  979.225476]            000003ff7ffead80: 07fe               bcr     15,%r14
[  979.225476]            000003ff7ffead82: 47000700           bc      0,1792
[  979.225476]            000003ff7ffead86: af000000           mc      0,0
[  979.225476]            000003ff7ffead8a: 0707               bcr     0,%r7
[  979.225487] Call Trace:
[  979.225488] assfail (fs/xfs/xfs_message.c:105 (discriminator 3)) xfs
[  979.225568] assfail+0x40/0x68 xfs])
[  979.225648] xlog_recover_validate_buf_type (fs/xfs/xfs_buf_item_recover.c:414 (discriminator 1)) xfs
[  979.225727] xlog_recover_buf_commit_pass2 (fs/xfs/xfs_buf_item_recover.c:971) xfs
[  979.225807] xlog_recover_items_pass2 (fs/xfs/xfs_log_recover.c:1957) xfs
[  979.225886] xlog_recover_commit_trans (./include/linux/list.h:373 ./include/linux/list.h:588 fs/xfs/xfs_log_recover.c:2028) xfs
[  979.225965] xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2257) xfs
[  979.226045] xlog_recover_process_ophdr (fs/xfs/xfs_log_recover.c:2405) xfs
[  979.226124] xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2447) xfs
[  979.226204] xlog_recover_process (fs/xfs/xfs_log_recover.c:2901) xfs
[  979.226285] xlog_do_recovery_pass (fs/xfs/xfs_log_recover.c:3153) xfs
[  979.226366] xlog_do_log_recovery (fs/xfs/xfs_log_recover.c:3265) xfs
[  979.226446] xlog_do_recover (fs/xfs/xfs_log_recover.c:3293) xfs
[  979.226526] xlog_recover (./arch/s390/include/asm/atomic_ops.h:71 (discriminator 1) ./arch/s390/include/asm/bitops.h:63 (discriminator 1) ./include/asm-generic/bitops/instrumented-atomic.h:29 (discriminator 1) fs/xfs/xfs_log_recover.c:3427 (discriminator 1)) xfs
[  979.226607] xfs_log_mount (fs/xfs/xfs_log.c:718) xfs
[  979.226686] xfs_mountfs (fs/xfs/xfs_mount.c:822) xfs
[  979.226765] xfs_fs_fill_super (fs/xfs/xfs_super.c:1734) xfs
[  979.226844] get_tree_bdev (fs/super.c:1598) 
[  979.226850] vfs_get_tree (fs/super.c:1771) 
[  979.226852] do_new_mount (fs/namespace.c:3337) 
[  979.226855] path_mount (fs/namespace.c:3664) 
[  979.226857] __s390x_sys_mount (fs/namespace.c:3677 fs/namespace.c:3886 fs/namespace.c:3863 fs/namespace.c:3863) 
[  979.226860] __do_syscall (arch/s390/kernel/syscall.c:144 arch/s390/kernel/syscall.c:168) 
[  979.226864] system_call (arch/s390/kernel/entry.S:309) 
[  979.226868] Last Breaking-Event-Address:
[  979.226868] xfs_printk_level (fs/xfs/xfs_message.c:52) xfs
[  979.226949] ---[ end trace 0000000000000000 ]---
[  979.227613] XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check (fs/xfs/libxfs/xfs_dir2_data.c:137) xfs, xfs_dir3_block block 0x1020
[  979.227732] XFS (loop3): Unmount and run xfs_repair
[  979.227733] XFS (loop3): First 128 bytes of corrupted metadata buffer:
[  979.227736] 00000000: 58 44 42 33 00 00 00 00 00 00 00 00 00 00 10 20  XDB3...........
[  979.227738] 00000010: 00 00 00 00 00 00 00 00 c1 95 44 38 a1 8d 4b 4a  ..........D8..KJ
[  979.227739] 00000020: ad 32 0e 29 c4 07 13 ed 00 00 00 00 00 00 00 80  .2.)............
[  979.227740] 00000030: 02 68 fc c8 00 00 00 00 00 00 00 00 00 00 00 00  .h..............
[  979.227741] 00000040: 00 00 00 00 00 00 00 80 01 2e 02 00 00 00 00 40  ...............@
[  979.227742] 00000050: 00 00 00 00 00 00 00 80 02 2e 2e 02 00 00 00 50  ...............P
[  979.227743] 00000060: 00 00 00 00 00 00 00 83 08 66 73 73 32 36 30 38  .........fss2608
[  979.227745] 00000070: 36 01 00 00 00 00 00 60 00 00 00 00 00 00 00 84  6......`........
[  979.227748] XFS (loop3): Corruption of in-memory data (0x8) detected at __xfs_buf_submit+0x78/0x230 [xfs] (fs/xfs/xfs_buf.c:1558). Shutting down filesystem.




> 
> Also, does "xfs: update dir3 leaf block metadata after swap" fix it?

OK, I'll merge and give it a try.

Thanks,
Zorro

> 
> (I suspect it won't because that's a dirent block, but for-next has a
> few directory fixes in it.)
> 
> --D
> 
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> >  [  899.271221] run fstests generic/648 at 2023-12-18 01:18:03
> >  [  899.454444] XFS (loop1): Mounting V5 Filesystem 9be840e1-9bd1-468e-81c5-179f2ebdce56
> >  [  899.455844] XFS (loop1): Ending clean mount
> >  [  899.463623] XFS (loop1): Unmounting Filesystem 9be840e1-9bd1-468e-81c5-179f2ebdce56
> >  [  899.587365] XFS (dm-3): Mounting V5 Filesystem d636e675-dfc9-4e5d-b777-ff856af136a9
> >  [  899.588501] XFS (dm-3): Ending clean mount
> >  ...
> >  ...
> >  [  974.217814] XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
> >  [  974.803146] XFS (loop3): Starting recovery (logdev: internal)
> >  [  974.804634] XFS (loop3): Ending recovery (logdev: internal)
> >  [  975.782734] Direct I/O collision with buffered writes! File: /p2/df/f4f Comm: fsstress
> >  [  976.831942] lo_write_bvec: 15 callbacks suppressed
> >  [  976.831946] loop: Write error at byte offset 1766129664, length 4096.
> >  [  976.831953] I/O error, dev loop3, sector 3449468 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 2
> >  [  976.831957] I/O error, dev loop3, sector 3449468 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 2
> >  [  976.831960] XFS (loop3): log I/O error -5
> >  [  976.831963] XFS (loop3): Filesystem has been shut down due to log error (0x2).
> >  [  976.831964] XFS (loop3): Please unmount the filesystem and rectify the problem(s).
> >  [  976.839603] buffer_io_error: 6 callbacks suppressed
> >  [  976.839604] Buffer I/O error on dev dm-3, logical block 20971392, async page read
> >  [  976.839607] Buffer I/O error on dev dm-3, logical block 20971393, async page read
> >  [  976.839609] Buffer I/O error on dev dm-3, logical block 20971394, async page read
> >  [  976.839611] Buffer I/O error on dev dm-3, logical block 20971395, async page read
> >  [  976.839612] Buffer I/O error on dev dm-3, logical block 20971396, async page read
> >  [  976.839613] Buffer I/O error on dev dm-3, logical block 20971397, async page read
> >  [  976.839614] Buffer I/O error on dev dm-3, logical block 20971398, async page read
> >  [  976.839616] Buffer I/O error on dev dm-3, logical block 20971399, async page read
> >  [  977.419266] XFS (loop3): Unmounting Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
> >  [  977.423981] iomap_finish_ioend: 15 callbacks suppressed
> >  [  977.423982] dm-3: writeback error on inode 131, offset 1766125568, sector 4059696
> >  [  977.423988] I/O error, dev loop3, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
> >  [  978.434124] XFS (dm-3): Unmounting Filesystem d636e675-dfc9-4e5d-b777-ff856af136a9
> >  [  978.449156] XFS (dm-3): log I/O error -5
> >  [  978.449159] XFS (dm-3): Filesystem has been shut down due to log error (0x2).
> >  [  978.449160] XFS (dm-3): Please unmount the filesystem and rectify the problem(s).
> >  [  978.449163] XFS (dm-3): log I/O error -5
> >  [  978.449164] XFS (dm-3): log I/O error -5
> >  [  978.449165] XFS (dm-3): log I/O error -5
> >  [  978.449166] XFS (dm-3): log I/O error -5
> >  [  978.449167] XFS (dm-3): log I/O error -5
> >  [  978.498053] XFS (dm-3): Mounting V5 Filesystem d636e675-dfc9-4e5d-b777-ff856af136a9
> >  [  978.513331] XFS (dm-3): Starting recovery (logdev: internal)
> >  [  978.584227] XFS (dm-3): Ending recovery (logdev: internal)
> >  [  978.587276] loop3: detected capacity change from 0 to 6876346
> >  [  978.591588] XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
> >  [  979.216565] XFS (loop3): Starting recovery (logdev: internal)
> >  [  979.225078] XFS (loop3): Bad dir block magic!
> >  [  979.225081] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
> >  [  979.225120] ------------[ cut here ]------------
> >  [  979.225122] WARNING: CPU: 1 PID: 157902 at fs/xfs/xfs_message.c:104 assfail+0x4e/0x68 [xfs]
> >  [  979.225349] Modules linked in: tls loop lcs ctcm fsm qeth ccwgroup zfcp qdio scsi_transport_fc dasd_fba_mod dasd_eckd_mod dasd_mod rfkill sunrpc vfio_ccw mdev vfio_iommu_type1 vfio drm fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c ghash_s390 prng des_s390 virtio_net net_failover sha3_512_s390 virtio_blk failover sha3_256_s390 dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt aes_s390
> >  [  979.225373] CPU: 1 PID: 157902 Comm: mount Kdump: loaded Not tainted 6.7.0-rc6 #1
> >  [  979.225376] Hardware name: IBM 8561 LT1 400 (KVM/Linux)
> >  [  979.225377] Krnl PSW : 0704c00180000000 000003ff7ffead7a (assfail+0x52/0x68 [xfs])
> >  [  979.225457]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> >  [  979.225460] Krnl GPRS: c000000000000021 000003ff800549b0 ffffffffffffffea 000000000000000a
> >  [  979.225462]            0000038000363418 0000000000000000 000003ff80162b74 000000030001c127
> >  [  979.225464]            00000000ccc51d40 000000030001c127 00000000dfa03000 0000000163d19600
> >  [  979.225465]            000003ffa1f2ef68 000003ff80147c28 000003ff7ffead68 00000380003634c0
> >  [  979.225476] Krnl Code: 000003ff7ffead6e: 95001010		cli	16(%r1),0
> >  [  979.225476]            000003ff7ffead72: a774000a		brc	7,000003ff7ffead86
> >  [  979.225476]           #000003ff7ffead76: af000000		mc	0,0
> >  [  979.225476]           >000003ff7ffead7a: eb6ff0a80004	lmg	%r6,%r15,168(%r15)
> >  [  979.225476]            000003ff7ffead80: 07fe		bcr	15,%r14
> >  [  979.225476]            000003ff7ffead82: 47000700		bc	0,1792
> >  [  979.225476]            000003ff7ffead86: af000000		mc	0,0
> >  [  979.225476]            000003ff7ffead8a: 0707		bcr	0,%r7
> >  [  979.225487] Call Trace:
> >  [  979.225488]  [<000003ff7ffead7a>] assfail+0x52/0x68 [xfs] 
> >  [  979.225568] ([<000003ff7ffead68>] assfail+0x40/0x68 [xfs])
> >  [  979.225648]  [<000003ff80004b4e>] xlog_recover_validate_buf_type+0x2a6/0x5c8 [xfs] 
> >  [  979.225727]  [<000003ff80005eca>] xlog_recover_buf_commit_pass2+0x382/0x448 [xfs] 
> >  [  979.225807]  [<000003ff8001077a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
> >  [  979.225886]  [<000003ff80011436>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
> >  [  979.225965]  [<000003ff80011598>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
> >  [  979.226045]  [<000003ff80011660>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
> >  [  979.226124]  [<000003ff80012126>] xlog_recover_process_data+0xb6/0x168 [xfs] 
> >  [  979.226204]  [<000003ff800122dc>] xlog_recover_process+0x104/0x150 [xfs] 
> >  [  979.226285]  [<000003ff800125a4>] xlog_do_recovery_pass+0x27c/0x748 [xfs] 
> >  [  979.226366]  [<000003ff80012ec8>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
> >  [  979.226446]  [<000003ff80012f64>] xlog_do_recover+0x4c/0x218 [xfs] 
> >  [  979.226526]  [<000003ff8001446a>] xlog_recover+0xda/0x1a0 [xfs] 
> >  [  979.226607]  [<000003ff7fffa51e>] xfs_log_mount+0x11e/0x280 [xfs] 
> >  [  979.226686]  [<000003ff7ffec226>] xfs_mountfs+0x3e6/0x928 [xfs] 
> >  [  979.226765]  [<000003ff7fff3b4c>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
> >  [  979.226844]  [<00000001ef53bfd4>] get_tree_bdev+0x144/0x1d0 
> >  [  979.226850]  [<00000001ef539a08>] vfs_get_tree+0x38/0x110 
> >  [  979.226852]  [<00000001ef56c432>] do_new_mount+0x17a/0x2d0 
> >  [  979.226855]  [<00000001ef56d0ac>] path_mount+0x1ac/0x818 
> >  [  979.226857]  [<00000001ef56d81c>] __s390x_sys_mount+0x104/0x148 
> >  [  979.226860]  [<00000001efbb6e00>] __do_syscall+0x1d0/0x1f8 
> >  [  979.226864]  [<00000001efbc7088>] system_call+0x70/0x98 
> >  [  979.226868] Last Breaking-Event-Address:
> >  [  979.226868]  [<000003ff7ffeabc4>] xfs_printk_level+0xac/0xd8 [xfs]
> >  [  979.226949] ---[ end trace 0000000000000000 ]---
> >  [  979.227613] XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check+0x372/0x6c0 [xfs], xfs_dir3_block block 0x1020 
> >  [  979.227732] XFS (loop3): Unmount and run xfs_repair
> >  [  979.227733] XFS (loop3): First 128 bytes of corrupted metadata buffer:
> >  [  979.227736] 00000000: 58 44 42 33 00 00 00 00 00 00 00 00 00 00 10 20  XDB3........... 
> >  [  979.227738] 00000010: 00 00 00 00 00 00 00 00 c1 95 44 38 a1 8d 4b 4a  ..........D8..KJ
> >  [  979.227739] 00000020: ad 32 0e 29 c4 07 13 ed 00 00 00 00 00 00 00 80  .2.)............
> >  [  979.227740] 00000030: 02 68 fc c8 00 00 00 00 00 00 00 00 00 00 00 00  .h..............
> >  [  979.227741] 00000040: 00 00 00 00 00 00 00 80 01 2e 02 00 00 00 00 40  ...............@
> >  [  979.227742] 00000050: 00 00 00 00 00 00 00 80 02 2e 2e 02 00 00 00 50  ...............P
> >  [  979.227743] 00000060: 00 00 00 00 00 00 00 83 08 66 73 73 32 36 30 38  .........fss2608
> >  [  979.227745] 00000070: 36 01 00 00 00 00 00 60 00 00 00 00 00 00 00 84  6......`........
> >  [  979.227748] XFS (loop3): Corruption of in-memory data (0x8) detected at __xfs_buf_submit+0x78/0x230 [xfs] (fs/xfs/xfs_buf.c:1558).  Shutting down filesystem.
> >  [  979.227826] XFS (loop3): Please unmount the filesystem and rectify the problem(s)
> >  [  979.227912] XFS (loop3): log mount/recovery failed: error -117
> >  [  979.228061] XFS (loop3): log mount failed
> >  [  980.224124] XFS (dm-3): Unmounting Filesystem d636e675-dfc9-4e5d-b777-ff856af136a9
> >  [  980.318601] XFS (loop0): Unmounting Filesystem c8777546-cb21-46f2-9963-456588f60b85
> >  [  980.353946] XFS (loop0): Mounting V5 Filesystem c8777546-cb21-46f2-9963-456588f60b85
> >  [  980.355207] XFS (loop0): Ending clean mount
> >  [  982.585362] XFS (loop1): Mounting V5 Filesystem ec19bbbd-e925-41c9-befe-28218e74a23b
> >  [  982.586881] XFS (loop1): Ending clean mount
> >  [  982.588944] XFS (loop1): Unmounting Filesystem ec19bbbd-e925-41c9-befe-28218e74a23b
> >  [  982.603160] XFS (loop0): EXPERIMENTAL online scrub feature in use. Use at your own risk!
> >  [  982.620838] XFS (loop0): Unmounting Filesystem c8777546-cb21-46f2-9963-456588f60b85
> >  [  982.636206] XFS (loop0): Mounting V5 Filesystem c8777546-cb21-46f2-9963-456588f60b85
> >  [  982.637231] XFS (loop0): Ending clean mount
> >  
> > 
> > 
> 

