Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BD01D127
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQAEz3hH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702908105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=WZxvz5J0BuU0cWi6Gwfb97TtynCFSAp6zts2TA/Z7pY=;
	b=WQAEz3hHLMbZkJj8l1GkDTzPEyxVLS+3ymnDKNMyY6QNYnEqQ/FAQ3UvE0flrk5Z8SZtm3
	lEiLVAbqjECh/Tsw2spZVJcGwq2G94PaGjiRixxdZLmMqX5Wrd3nAs1VErKh3UZBgHxT8w
	gwerFppAIpAsLgS+KmzMvTxRvpt5+EQ=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-m5AirenqP-6FVYLagejsfw-1; Mon, 18 Dec 2023 09:01:43 -0500
X-MC-Unique: m5AirenqP-6FVYLagejsfw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5c5d72fb5e6so1233572a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 06:01:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702908101; x=1703512901;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZxvz5J0BuU0cWi6Gwfb97TtynCFSAp6zts2TA/Z7pY=;
        b=buXFZs3NFugwvpB/biRkRy705LGut4afHS1vChwQ/jCN+Zr7tEdcK4KRfNypqFuwPi
         NQ1d5W+I8ZT1L0pzF8frOEk4yIZUBO5QkuyPKVBLcWC8b42EVSZ+X48eS+i736Ab9fDr
         5vq1DoeRpOJS64OHxTYUhwD9sgbHrLdeyTrzTzyIupeFsJYZYCe5SIB1G6I1gO+0gUYn
         t7wPejry67yzZCHviWrl/4eYHTLKl31nSLAXsJRiwjs2diPPLIrRfFCSFvC63JpLM8fd
         FzG2+7LnH+EmhqD1Kln8KyLnegmZeyaDShg5BDmXriw+DD1nsN+S6WAyhZ80dWMv6CMg
         fuuA==
X-Gm-Message-State: AOJu0Yy7XSGXULv2B5sisq3SgKGsYJMnX4Jqdweoy+Q5x+uV3rFZHO41
	HX4p581Jxrpq4NnKfNMSbFyl0wBfUr50L2sZ11vuOD/h0PHqmwww59KjhxCupFtOXin/I2hU+/T
	2A4MM0CKRYSDxpCIj7+4IeN5BbLeY1VHm0H87hqWyzba1C0SG4uWIMarMLCcAIB1+GuOyXXXAyG
	rMLK7fcw==
X-Received: by 2002:a05:6a20:5648:b0:18c:57a7:ea29 with SMTP id is8-20020a056a20564800b0018c57a7ea29mr7268829pzc.45.1702908100063;
        Mon, 18 Dec 2023 06:01:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoSHr0eiRYwHkoLAAKM/dPyPZe2XUvtp5ZTOmMeBSElPNQSucRU1VogsdOVNW4bsrRMXeiZg==
X-Received: by 2002:a05:6a20:5648:b0:18c:57a7:ea29 with SMTP id is8-20020a056a20564800b0018c57a7ea29mr7268749pzc.45.1702908098027;
        Mon, 18 Dec 2023 06:01:38 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id m18-20020a63fd52000000b005ccf10e73b8sm3372169pgj.91.2023.12.18.06.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 06:01:37 -0800 (PST)
Date: Mon, 18 Dec 2023 22:01:34 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org
Subject: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Recently I hit a crash [1] on s390x with 64k directory block size xfs
(-n size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1),
even not panic, a assertion failure will happen.

I found it from an old downstream kernel at first, then reproduced it
on latest upstream mainline linux (v6.7-rc6). Can't be sure how long
time this issue be there, just reported it at first.

I hit and reproduced it several times by running generic/648 on s390x
with "-n size=65536" xfs many times. Not sure if s390x is needed, I'll
try to check other arches.

Thanks,
Zorro

[1]
 [  899.271221] run fstests generic/648 at 2023-12-18 01:18:03
 [  899.454444] XFS (loop1): Mounting V5 Filesystem 9be840e1-9bd1-468e-81c5-179f2ebdce56
 [  899.455844] XFS (loop1): Ending clean mount
 [  899.463623] XFS (loop1): Unmounting Filesystem 9be840e1-9bd1-468e-81c5-179f2ebdce56
 [  899.587365] XFS (dm-3): Mounting V5 Filesystem d636e675-dfc9-4e5d-b777-ff856af136a9
 [  899.588501] XFS (dm-3): Ending clean mount
 ...
 ...
 [  974.217814] XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
 [  974.803146] XFS (loop3): Starting recovery (logdev: internal)
 [  974.804634] XFS (loop3): Ending recovery (logdev: internal)
 [  975.782734] Direct I/O collision with buffered writes! File: /p2/df/f4f Comm: fsstress
 [  976.831942] lo_write_bvec: 15 callbacks suppressed
 [  976.831946] loop: Write error at byte offset 1766129664, length 4096.
 [  976.831953] I/O error, dev loop3, sector 3449468 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 2
 [  976.831957] I/O error, dev loop3, sector 3449468 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 2
 [  976.831960] XFS (loop3): log I/O error -5
 [  976.831963] XFS (loop3): Filesystem has been shut down due to log error (0x2).
 [  976.831964] XFS (loop3): Please unmount the filesystem and rectify the problem(s).
 [  976.839603] buffer_io_error: 6 callbacks suppressed
 [  976.839604] Buffer I/O error on dev dm-3, logical block 20971392, async page read
 [  976.839607] Buffer I/O error on dev dm-3, logical block 20971393, async page read
 [  976.839609] Buffer I/O error on dev dm-3, logical block 20971394, async page read
 [  976.839611] Buffer I/O error on dev dm-3, logical block 20971395, async page read
 [  976.839612] Buffer I/O error on dev dm-3, logical block 20971396, async page read
 [  976.839613] Buffer I/O error on dev dm-3, logical block 20971397, async page read
 [  976.839614] Buffer I/O error on dev dm-3, logical block 20971398, async page read
 [  976.839616] Buffer I/O error on dev dm-3, logical block 20971399, async page read
 [  977.419266] XFS (loop3): Unmounting Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
 [  977.423981] iomap_finish_ioend: 15 callbacks suppressed
 [  977.423982] dm-3: writeback error on inode 131, offset 1766125568, sector 4059696
 [  977.423988] I/O error, dev loop3, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 2
 [  978.434124] XFS (dm-3): Unmounting Filesystem d636e675-dfc9-4e5d-b777-ff856af136a9
 [  978.449156] XFS (dm-3): log I/O error -5
 [  978.449159] XFS (dm-3): Filesystem has been shut down due to log error (0x2).
 [  978.449160] XFS (dm-3): Please unmount the filesystem and rectify the problem(s).
 [  978.449163] XFS (dm-3): log I/O error -5
 [  978.449164] XFS (dm-3): log I/O error -5
 [  978.449165] XFS (dm-3): log I/O error -5
 [  978.449166] XFS (dm-3): log I/O error -5
 [  978.449167] XFS (dm-3): log I/O error -5
 [  978.498053] XFS (dm-3): Mounting V5 Filesystem d636e675-dfc9-4e5d-b777-ff856af136a9
 [  978.513331] XFS (dm-3): Starting recovery (logdev: internal)
 [  978.584227] XFS (dm-3): Ending recovery (logdev: internal)
 [  978.587276] loop3: detected capacity change from 0 to 6876346
 [  978.591588] XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
 [  979.216565] XFS (loop3): Starting recovery (logdev: internal)
 [  979.225078] XFS (loop3): Bad dir block magic!
 [  979.225081] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
 [  979.225120] ------------[ cut here ]------------
 [  979.225122] WARNING: CPU: 1 PID: 157902 at fs/xfs/xfs_message.c:104 assfail+0x4e/0x68 [xfs]
 [  979.225349] Modules linked in: tls loop lcs ctcm fsm qeth ccwgroup zfcp qdio scsi_transport_fc dasd_fba_mod dasd_eckd_mod dasd_mod rfkill sunrpc vfio_ccw mdev vfio_iommu_type1 vfio drm fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c ghash_s390 prng des_s390 virtio_net net_failover sha3_512_s390 virtio_blk failover sha3_256_s390 dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt aes_s390
 [  979.225373] CPU: 1 PID: 157902 Comm: mount Kdump: loaded Not tainted 6.7.0-rc6 #1
 [  979.225376] Hardware name: IBM 8561 LT1 400 (KVM/Linux)
 [  979.225377] Krnl PSW : 0704c00180000000 000003ff7ffead7a (assfail+0x52/0x68 [xfs])
 [  979.225457]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
 [  979.225460] Krnl GPRS: c000000000000021 000003ff800549b0 ffffffffffffffea 000000000000000a
 [  979.225462]            0000038000363418 0000000000000000 000003ff80162b74 000000030001c127
 [  979.225464]            00000000ccc51d40 000000030001c127 00000000dfa03000 0000000163d19600
 [  979.225465]            000003ffa1f2ef68 000003ff80147c28 000003ff7ffead68 00000380003634c0
 [  979.225476] Krnl Code: 000003ff7ffead6e: 95001010		cli	16(%r1),0
 [  979.225476]            000003ff7ffead72: a774000a		brc	7,000003ff7ffead86
 [  979.225476]           #000003ff7ffead76: af000000		mc	0,0
 [  979.225476]           >000003ff7ffead7a: eb6ff0a80004	lmg	%r6,%r15,168(%r15)
 [  979.225476]            000003ff7ffead80: 07fe		bcr	15,%r14
 [  979.225476]            000003ff7ffead82: 47000700		bc	0,1792
 [  979.225476]            000003ff7ffead86: af000000		mc	0,0
 [  979.225476]            000003ff7ffead8a: 0707		bcr	0,%r7
 [  979.225487] Call Trace:
 [  979.225488]  [<000003ff7ffead7a>] assfail+0x52/0x68 [xfs] 
 [  979.225568] ([<000003ff7ffead68>] assfail+0x40/0x68 [xfs])
 [  979.225648]  [<000003ff80004b4e>] xlog_recover_validate_buf_type+0x2a6/0x5c8 [xfs] 
 [  979.225727]  [<000003ff80005eca>] xlog_recover_buf_commit_pass2+0x382/0x448 [xfs] 
 [  979.225807]  [<000003ff8001077a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
 [  979.225886]  [<000003ff80011436>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
 [  979.225965]  [<000003ff80011598>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
 [  979.226045]  [<000003ff80011660>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
 [  979.226124]  [<000003ff80012126>] xlog_recover_process_data+0xb6/0x168 [xfs] 
 [  979.226204]  [<000003ff800122dc>] xlog_recover_process+0x104/0x150 [xfs] 
 [  979.226285]  [<000003ff800125a4>] xlog_do_recovery_pass+0x27c/0x748 [xfs] 
 [  979.226366]  [<000003ff80012ec8>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
 [  979.226446]  [<000003ff80012f64>] xlog_do_recover+0x4c/0x218 [xfs] 
 [  979.226526]  [<000003ff8001446a>] xlog_recover+0xda/0x1a0 [xfs] 
 [  979.226607]  [<000003ff7fffa51e>] xfs_log_mount+0x11e/0x280 [xfs] 
 [  979.226686]  [<000003ff7ffec226>] xfs_mountfs+0x3e6/0x928 [xfs] 
 [  979.226765]  [<000003ff7fff3b4c>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
 [  979.226844]  [<00000001ef53bfd4>] get_tree_bdev+0x144/0x1d0 
 [  979.226850]  [<00000001ef539a08>] vfs_get_tree+0x38/0x110 
 [  979.226852]  [<00000001ef56c432>] do_new_mount+0x17a/0x2d0 
 [  979.226855]  [<00000001ef56d0ac>] path_mount+0x1ac/0x818 
 [  979.226857]  [<00000001ef56d81c>] __s390x_sys_mount+0x104/0x148 
 [  979.226860]  [<00000001efbb6e00>] __do_syscall+0x1d0/0x1f8 
 [  979.226864]  [<00000001efbc7088>] system_call+0x70/0x98 
 [  979.226868] Last Breaking-Event-Address:
 [  979.226868]  [<000003ff7ffeabc4>] xfs_printk_level+0xac/0xd8 [xfs]
 [  979.226949] ---[ end trace 0000000000000000 ]---
 [  979.227613] XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check+0x372/0x6c0 [xfs], xfs_dir3_block block 0x1020 
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
 [  979.227748] XFS (loop3): Corruption of in-memory data (0x8) detected at __xfs_buf_submit+0x78/0x230 [xfs] (fs/xfs/xfs_buf.c:1558).  Shutting down filesystem.
 [  979.227826] XFS (loop3): Please unmount the filesystem and rectify the problem(s)
 [  979.227912] XFS (loop3): log mount/recovery failed: error -117
 [  979.228061] XFS (loop3): log mount failed
 [  980.224124] XFS (dm-3): Unmounting Filesystem d636e675-dfc9-4e5d-b777-ff856af136a9
 [  980.318601] XFS (loop0): Unmounting Filesystem c8777546-cb21-46f2-9963-456588f60b85
 [  980.353946] XFS (loop0): Mounting V5 Filesystem c8777546-cb21-46f2-9963-456588f60b85
 [  980.355207] XFS (loop0): Ending clean mount
 [  982.585362] XFS (loop1): Mounting V5 Filesystem ec19bbbd-e925-41c9-befe-28218e74a23b
 [  982.586881] XFS (loop1): Ending clean mount
 [  982.588944] XFS (loop1): Unmounting Filesystem ec19bbbd-e925-41c9-befe-28218e74a23b
 [  982.603160] XFS (loop0): EXPERIMENTAL online scrub feature in use. Use at your own risk!
 [  982.620838] XFS (loop0): Unmounting Filesystem c8777546-cb21-46f2-9963-456588f60b85
 [  982.636206] XFS (loop0): Mounting V5 Filesystem c8777546-cb21-46f2-9963-456588f60b85
 [  982.637231] XFS (loop0): Ending clean mount
 

