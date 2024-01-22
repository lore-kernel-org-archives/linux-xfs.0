Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E373CF4B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 13:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705929546; cv=none; b=h8zvJAuz4LPNhdUbg/fLq4E/2ebObL6bP2RZwhMBf9jN+IYDZngXJJ8ujCkbfQeOnAYxQIBbbfDDFSycNY3E5sbGb1bkJ/Aw97XQeL1NWL+yu+d7Q9CR7EHa1tGeESoTmOgNXcqwjJeGBxnkNpGAUfKg0JG7NYDNqp/n8o1tcTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705929546; c=relaxed/simple;
	bh=3Cp8hAYmIBx1KS3eHj97QbRo+ZzaE+J9jp8iz4aQSlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRjjmube7OgMC2YuJJzj7zGBFUw4Byeqv2aFS9fqLqJ2rt/wpWvox02BqwqpEoQwkPUWE8vN7Qbiy5zm50uNjq6LXt4T0PoDUwunt0ytWdrjTC0nq2wOfxUVvON978Z1jOd2RGnXcRM5FhvdPpgn67nBEjf98B8s2CHPYAExKtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XVyrOoaI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XVyrOoaI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705929543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CPrXkFg+fBVsiluIB1orBmecOTGi6tAnOkaNvBJN18Q=;
	b=XVyrOoaI3vi77zb6jsCwkuzpu4a5pQU2HfDrp/FRQ5emovUsQjlv7X5yjU6Ym77JhDpBzf
	WX/7VnlyOLKbvLN+pxhGUQj0sahQuUBSq9h8MosSulPqsxw1H52BH1nFixJPX5wtnb0Jo4
	ZLS8VGGTWfbXG4WUWp4JL3gSUVtDOR4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-Gb63VTFbNeG9j-4T96o2ng-1; Mon, 22 Jan 2024 08:19:02 -0500
X-MC-Unique: Gb63VTFbNeG9j-4T96o2ng-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6dbd11480b2so2271156b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 05:19:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705929540; x=1706534340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPrXkFg+fBVsiluIB1orBmecOTGi6tAnOkaNvBJN18Q=;
        b=iCU9nY21NYnj3PeR/EEQ3J+J3Wz7+sFSqPjpPLsFXt4MtEngdLlUCQqKdwS0nBfpyT
         FFmLZyrIL4av6Ko+Ni1vtPoYKhEbUPiMZbnIBWmAVzvM3P65ACo9721FXmKKgZpamWOe
         Eby+sajINjFZonFwTAMTvVBn5i3lfh9dQ2uuDu2jDTmQdMw9kHNM3Wd/IAf7RzAurL36
         J9k4dGPALY+gJN6yBM6bTQo56FHtuMs6m3m+2qSp7iTLPZ7iT3Jv+vWQtWgjh9XinhHp
         N/h0KfXwECY3SoB+9z5pAzOG25p4unMzfhXfwEN8npObEjR1KNf4ttky9F32vbnMzqUX
         bqzQ==
X-Gm-Message-State: AOJu0YzQqI+DLalb3JvTVTgrOZrjqArjgfQ7p7FQEgdwAi1FqC4izGDl
	Kk50A/ceZCwO6LL02zh34d18pbPUTvZGheO8b/bRruk8M8WHMYgCPpTHY14uOit5SVC/Ouho3IR
	orq4PZ2p2owNCrctfRVdUrg1vZkPo6vWcXHptoBuhQbc8D8xdlqLFTietm2ygBWWpaLMN
X-Received: by 2002:a05:6a00:ad1:b0:6da:d27b:7c52 with SMTP id c17-20020a056a000ad100b006dad27b7c52mr5681633pfl.53.1705929540484;
        Mon, 22 Jan 2024 05:19:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHErSznh6BjXcCTjyEZtbc3Q3mnfKGwUBwUji5e3LrF7YC3+9nZBKqQd6OHitiwOpQoEdwQnw==
X-Received: by 2002:a05:6a00:ad1:b0:6da:d27b:7c52 with SMTP id c17-20020a056a000ad100b006dad27b7c52mr5681619pfl.53.1705929540007;
        Mon, 22 Jan 2024 05:19:00 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id it22-20020a056a00459600b006dbcabc31c5sm4498878pfb.209.2024.01.22.05.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 05:18:59 -0800 (PST)
Date: Mon, 22 Jan 2024 21:18:56 +0800
From: Zorro Lang <zlang@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <20240122131856.2rtzmdtore25nj7k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaoiBF9KqyMt3URQ@dread.disaster.area>
 <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaxeOXSb0+jPYCe1@dread.disaster.area>
 <20240122072312.usotep2ajokhcuci@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <Za5PoyT0WZdqgphT@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za5PoyT0WZdqgphT@dread.disaster.area>

On Mon, Jan 22, 2024 at 10:21:07PM +1100, Dave Chinner wrote:
> On Mon, Jan 22, 2024 at 03:23:12PM +0800, Zorro Lang wrote:
> > On Sun, Jan 21, 2024 at 10:58:49AM +1100, Dave Chinner wrote:
> > > On Sat, Jan 20, 2024 at 07:26:00PM +0800, Zorro Lang wrote:
> > > > On Fri, Jan 19, 2024 at 06:17:24PM +1100, Dave Chinner wrote:
> > > > > Perhaps a bisect from 6.7 to 6.7+linux-xfs/for-next to identify what
> > > > > fixed it? Nothing in the for-next branch really looks relevant to
> > > > > the problem to me....
> > > > 
> > > > Hi Dave,
> > > > 
> > > > Finally, I got a chance to reproduce this issue on latest upstream mainline
> > > > linux (HEAD=9d64bf433c53) (and linux-xfs) again.
> > > > 
> > > > Looks like some userspace updates hide the issue, but I haven't found out what
> > > > change does that, due to it's a big change about a whole system version. I
> > > > reproduced this issue again by using an old RHEL distro (but the kernel is the newest).
> > > > (I'll try to find out what changes cause that later if it's necessary)
> > > > 
> > > > Anyway, I enabled the "CONFIG_XFS_ASSERT_FATAL=y" and "CONFIG_XFS_DEBUG=y" as
> > > > you suggested. And got the xfs metadump file after it crashed [1] and rebooted.
> > > > 
> > > > Due to g/648 tests on a loopimg in SCRATCH_MNT, so I didn't dump the SCRATCH_DEV,
> > > > but dumped the $SCRATCH_MNT/testfs file, you can get the metadump file from:
> > > > 
> > > > https://drive.google.com/file/d/14q7iRl7vFyrEKvv_Wqqwlue6vHGdIFO1/view?usp=sharing
> > > 
> > > Ok, I forgot the log on s390 is in big endian format. I don't have a
> > > bigendian machine here, so I can't replay the log to trace it or
> > > find out what disk address the buffer belongs. I can't even use
> > > xfs_logprint to dump the log.
> > > 
> > > Can you take that metadump, restore it on the s390 machine, and
> > > trace a mount attempt? i.e in one shell run 'trace-cmd record -e
> > > xfs\*' and then in another shell run 'mount testfs.img /mnt/test'
> > 
> > The 'mount testfs.img /mnt/test' will crash the kernel and reboot
> > the system directly ...
> 
> Turn off panic-on-oops. Some thing like 'echo 0 >
> /proc/sys/kernel/panic_on_oops' will do that, I think.

Thanks, it helps. I did below steps:

# trace-cmd record -e xfs\*
Hit Ctrl^C to stop recording
^CCPU0 data recorded at offset=0x5b7000
    90112 bytes in size
CPU1 data recorded at offset=0x5cd000
    57344 bytes in size
CPU2 data recorded at offset=0x5db000
    9945088 bytes in size
CPU3 data recorded at offset=0xf57000
    786432 bytes in size
# mount testfs.img /mnt/tmp
Segmentation fault
# (Ctrl^C the trace-cmd record process)
# dmesg
[180724.293443] loop: module loaded
[180724.294001] loop0: detected capacity change from 0 to 6876344
[180724.296987] XFS (loop0): Mounting V5 Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
[180724.309088] XFS (loop0): Starting recovery (logdev: internal)
[180724.335207] XFS (loop0): Bad dir block magic!
[180724.335210] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
[180724.335264] ------------[ cut here ]------------
[180724.335265] kernel BUG at fs/xfs/xfs_message.c:102!
[180724.335356] monitor event: 0040 ilc:2 [#1] SMP 
[180724.335362] Modules linked in: loop sunrpc rfkill vfio_ccw mdev vfio_iommu_type1 zcrypt_cex4 vfio iommufd drm fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c ghash_s390 prng virt
io_net des_s390 sha3_512_s390 net_failover sha3_256_s390 failover virtio_blk dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt aes_s390
[180724.335379] CPU: 2 PID: 6449 Comm: mount Kdump: loaded Not tainted 6.7.0+ #1
[180724.335382] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
[180724.335384] Krnl PSW : 0704e00180000000 000003ff7fe692ca (assfail+0x62/0x68 [xfs])
[180724.335727]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
[180724.335729] Krnl GPRS: c000000000000021 000003ff7fee3a40 ffffffffffffffea 000000000000000a
[180724.335731]            000003800005b3c0 0000000000000000 000003ff800004c4 0000000300014178
[180724.335732]            0000000090a87e80 0000000300014178 000000008bcf6000 00000000924a5000
[180724.335734]            000003ffbe72ef68 000003ff7ffe4c20 000003ff7fe692a8 000003800005b468
[180724.335742] Krnl Code: 000003ff7fe692bc: f0a8000407fe       srp     4(11,%r0),2046,8
                           000003ff7fe692c2: 47000700           bc      0,1792
                          #000003ff7fe692c6: af000000           mc      0,0
                          >000003ff7fe692ca: 0707               bcr     0,%r7
                           000003ff7fe692cc: 0707               bcr     0,%r7
                           000003ff7fe692ce: 0707               bcr     0,%r7
                           000003ff7fe692d0: c00400133e0c       brcl    0,000003ff800d0ee8
                           000003ff7fe692d6: eb6ff0480024       stmg    %r6,%r15,72(%r15)
[180724.335753] Call Trace:
[180724.335754]  [<000003ff7fe692ca>] assfail+0x62/0x68 [xfs] 
[180724.335835] ([<000003ff7fe692a8>] assfail+0x40/0x68 [xfs])
[180724.335915]  [<000003ff7fe8323e>] xlog_recover_validate_buf_type+0x2a6/0x5c8 [xfs] 
[180724.335997]  [<000003ff7fe845ba>] xlog_recover_buf_commit_pass2+0x382/0x448 [xfs] 
[180724.336078]  [<000003ff7fe8e89a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
[180724.336159]  [<000003ff7fe8f7ce>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
[180724.336240]  [<000003ff7fe8f930>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
[180724.336321]  [<000003ff7fe8f9f8>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
[180724.336402]  [<000003ff7fe9002e>] xlog_recover_process_data+0xb6/0x168 [xfs] 
[180724.336482]  [<000003ff7fe901e4>] xlog_recover_process+0x104/0x150 [xfs] 
[180724.336563]  [<000003ff7fe905e2>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
[180724.336643]  [<000003ff7fe90dd0>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
[180724.336727]  [<000003ff7fe90e6c>] xlog_do_recover+0x4c/0x218 [xfs] 
[180724.336808]  [<000003ff7fe9247a>] xlog_recover+0xda/0x1a0 [xfs] 
[180724.336888]  [<000003ff7fe78d36>] xfs_log_mount+0x11e/0x280 [xfs] 
[180724.336967]  [<000003ff7fe6a756>] xfs_mountfs+0x3e6/0x920 [xfs] 
[180724.337047]  [<000003ff7fe71ffc>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
[180724.337127]  [<00000000552adf88>] get_tree_bdev+0x120/0x1a8 
[180724.337142]  [<00000000552ab690>] vfs_get_tree+0x38/0x110 
[180724.337146]  [<00000000552dee28>] do_new_mount+0x188/0x2e0 
[180724.337150]  [<00000000552dfaa4>] path_mount+0x1ac/0x818 
[180724.337153]  [<00000000552e0214>] __s390x_sys_mount+0x104/0x148 
[180724.337156]  [<0000000055934796>] __do_syscall+0x21e/0x2b0 
[180724.337163]  [<0000000055944d60>] system_call+0x70/0x98 
[180724.337170] Last Breaking-Event-Address:
[180724.337221]  [<000003ff7fe692b2>] assfail+0x4a/0x68 [xfs]
[180724.337301] ---[ end trace 0000000000000000 ]---

# trace-cmd report > testfs.trace.txt
# bzip2 testfs.trace.txt

Please download it from:
https://drive.google.com/file/d/1FgpPidbMZHSjZinyc_WbVGfvwp2btA86/view?usp=sharing

Hope it's gotten what you need :)

Thanks,
Zorro

> 
> 
> > > and then after the assert fail terminate the tracing and run
> > > 'trace-cmd report > testfs.trace.txt'?
> > 
> > ... Can I still get the trace report after rebooting?
> 
> Not that I know of. But, then again, I don't reboot test machines
> when an oops or assert fail occurs - I like to have a warm corpse
> left behind that I can poke around in with various blunt instruments
> to see what went wrong....
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

