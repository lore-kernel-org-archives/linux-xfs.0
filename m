Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86BEEAC2
	for <linux-xfs@vger.kernel.org>; Sat, 20 Jan 2024 11:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705749972; cv=none; b=GSJC6bI4E8ijfXUpluaddhpV/aM0QxPE2Xg9JZpTdHmM+DHVFczsTrIKlDlaa3YNiRyDieVgMSMdUoQkRX8jsT0IrZyTFrgzXSL8j8qmnyYcFfE1UH3bC1LBC0j5hZ5eo7ofhgb9Je4hZLzddPLc7Xy73OYweXJEkCfeZB9KDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705749972; c=relaxed/simple;
	bh=xL36tNb9irSXWk8+A9wXXjD3Ecy8cIIQtztChGD2Wsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0zS3LrDGDoBhKPds38xTOTt8DN9/s9/h7cuR+KCCpWDgw4Z8pNmxSqwcn1UC96+H9eCoxm2Nt3JqZDHEC28b768nWsYLB8EUqwHUiw74iXsGUc7oP05dyHkmOpixo9eIeRsa/b5jwWku6vm7NGQCXpUiI1S9t0IHcIX7wY6CBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YJ0jNIYD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJ0jNIYD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705749968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Hnw2eWOVf0/JmP8RLlm4tSPxDe47NfyUvH8iqffkjgA=;
	b=YJ0jNIYD4n5+m4Et6RaKR02aL5y1x0uVilagRScvCMPQftU+vLHQCjl4jEBTnZbn2pWEmk
	rJ9JYxdsf4tlK4vYHkB8Y0u16Iyep8sc2p+ClbnjBcAIFUKd9Tjzroe1jFb0a+j2teHeyY
	9LziGCTk23xkDu8y81lz2YSwXNfexUU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-jXSOolDfPUKjfeTs33BdtA-1; Sat, 20 Jan 2024 06:26:06 -0500
X-MC-Unique: jXSOolDfPUKjfeTs33BdtA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1d714a62656so14791045ad.1
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jan 2024 03:26:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705749965; x=1706354765;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hnw2eWOVf0/JmP8RLlm4tSPxDe47NfyUvH8iqffkjgA=;
        b=m0iDZ6GoRUWmYT72AgH+S4Y3v3n08XLM2L8wWdFdJXWD9lw2A4R0L0m7GJlSugs1BQ
         xQj4rgF0AY+eIUDtvD2yWWWDvYNJBT54m7hxdvoYCnTAj36NQnhflAbZ11zOxMXk9gFB
         ZAEb/y+FrlYjhstQBXSIAMZjAOJdO0NsJPYEs4Sh7rLzvWr0WawZHOOoIjUJU8QEOSfT
         CHIEQvUqrngkKfO119UWKnKGR99+48T5oS5HD5TD2t4aVjT+nOcc9bLLGwPZHtRDo6qk
         sEkmFvP82d1obikeBOxYq1pF/B9+cK/eydnsfuvjOW/t7n/jYP4DDg9eY5y6mWEoMtpq
         IVng==
X-Gm-Message-State: AOJu0Yw0mnq8yVJoHXwDV3IS1fgfcFR+lCBbpCo0StkT2g8IvtpSMqTZ
	lA5AkCkKlgeJjMo32/x/c1Yx3ePAi0XkpnZrzk1DtnhnNJYJ2QSwXL8RNWvO0z9DHX9Hsn/USJm
	xzb0GSXlc8FPVsLSUKkxm/E0916qXRHyCKw8tjM153T8fGHNwRXhXxWYnAhioVP7pXg==
X-Received: by 2002:a17:902:eb4b:b0:1d5:71c5:4d58 with SMTP id i11-20020a170902eb4b00b001d571c54d58mr1517659pli.47.1705749964582;
        Sat, 20 Jan 2024 03:26:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECUkzxxo7WWY8ukbUQ1vTt8pBCeStiqyXIyK8VNUDbQPgplyiDFFAcn3KFRpCEph5QjmM1yA==
X-Received: by 2002:a17:902:eb4b:b0:1d5:71c5:4d58 with SMTP id i11-20020a170902eb4b00b001d571c54d58mr1517645pli.47.1705749963960;
        Sat, 20 Jan 2024 03:26:03 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jv13-20020a170903058d00b001d72bd542d7sm1108697plb.139.2024.01.20.03.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 03:26:03 -0800 (PST)
Date: Sat, 20 Jan 2024 19:26:00 +0800
From: Zorro Lang <zlang@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [xfstests generic/648] 64k directory block size (-n size=65536)
 crash on _xfs_buf_ioapply
Message-ID: <20240120112600.phkv37z4nx3pj2jn@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231218140134.gql6oecpezvj2e66@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZainBd2Jz6I0Pgm1@dread.disaster.area>
 <20240119013807.ivgvwe7yxweamg2m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZaoiBF9KqyMt3URQ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaoiBF9KqyMt3URQ@dread.disaster.area>

On Fri, Jan 19, 2024 at 06:17:24PM +1100, Dave Chinner wrote:
> On Fri, Jan 19, 2024 at 09:38:07AM +0800, Zorro Lang wrote:
> > On Thu, Jan 18, 2024 at 03:20:21PM +1100, Dave Chinner wrote:
> > > On Mon, Dec 18, 2023 at 10:01:34PM +0800, Zorro Lang wrote:
> > > > Hi,
> > > > 
> > > > Recently I hit a crash [1] on s390x with 64k directory block size xfs
> > > > (-n size=65536 -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1),
> > > > even not panic, a assertion failure will happen.
> > > > 
> > > > I found it from an old downstream kernel at first, then reproduced it
> > > > on latest upstream mainline linux (v6.7-rc6). Can't be sure how long
> > > > time this issue be there, just reported it at first.
> > > >  [  978.591588] XFS (loop3): Mounting V5 Filesystem c1954438-a18d-4b4a-ad32-0e29c40713ed
> > > >  [  979.216565] XFS (loop3): Starting recovery (logdev: internal)
> > > >  [  979.225078] XFS (loop3): Bad dir block magic!
> > > >  [  979.225081] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
> > > 
> > > Ok, so we got a XFS_BLFT_DIR_BLOCK_BUF buf log item, but the object
> > > that we recovered into the buffer did not have a
> > > XFS_DIR3_BLOCK_MAGIC type.
> > > 
> > > Perhaps the buf log item didn't contain the first 128 bytes of the
> > > buffer (or maybe any of it), and so didn't recovery the magic number?
> > > 
> > > Can you reproduce this with CONFIG_XFS_ASSERT_FATAL=y so the failure
> > > preserves the journal contents when the issue triggers, then get a
> > > metadump of the filesystem so I can dig into the contents of the
> > > journal?  I really want to see what is in the buf log item we fail
> > > to recover.
> > > 
> > > We don't want recovery to continue here because that will result in
> > > the journal being fully recovered and updated and so we won't be
> > > able to replay the recovery failure from it. 
> > > 
> > > i.e. if we leave the buffer we recovered in memory without failure
> > > because the ASSERT is just a warn, we continue onwards and likely
> > > then recover newer changes over the top of it. This may or may
> > > not result in a correctly recovered buffer, depending on what parts
> > > of the buffer got relogged.
> > > 
> > > IOWs, we should be expecting corruption to be detected somewhere
> > > further down the track once we've seen this warning, and really we
> > > should be aborting journal recovery if we see a mismatch like this.
> > > 
> > > .....
> > > 
> > > >  [  979.227613] XFS (loop3): Metadata corruption detected at __xfs_dir3_data_check+0x372/0x6c0 [xfs], xfs_dir3_block block 0x1020 
> > > >  [  979.227732] XFS (loop3): Unmount and run xfs_repair
> > > >  [  979.227733] XFS (loop3): First 128 bytes of corrupted metadata buffer:
> > > >  [  979.227736] 00000000: 58 44 42 33 00 00 00 00 00 00 00 00 00 00 10 20  XDB3........... 
> > > 
> > > XDB3 is XFS_DIR3_BLOCK_MAGIC, so it's the right type, but given it's
> > > the tail pointer (btp->count) that is bad, this indicates that maybe
> > > the tail didn't get written correctly by subsequent checkpoint
> > > recoveries. We don't know, because that isn't in the output below.
> > > 
> > > It likely doesn't matter, because I think the problem is either a
> > > runtime problem writing bad stuff into the journal, or a recovery
> > > problem failing to handle the contents correctly. Hence the need for
> > > a metadump.
> > 
> > Hi Dave,
> > 
> > Thanks for your reply. It's been a month passed, since I reported this
> > bug last time. Now I can't reproduce this issue on latest upstream
> > mainline linux and xfs-linux for-next branch. I've tried to do the
> > same testing ~1000 times, still can't reproduce it...
> > 
> > If you think it might not be fixed but be hided, I can try it on older
> > kernel which can reproduce this bug last time, to get a metadump. What
> > do you think?
> 
> Perhaps a bisect from 6.7 to 6.7+linux-xfs/for-next to identify what
> fixed it? Nothing in the for-next branch really looks relevant to
> the problem to me....

Hi Dave,

Finally, I got a chance to reproduce this issue on latest upstream mainline
linux (HEAD=9d64bf433c53) (and linux-xfs) again.

Looks like some userspace updates hide the issue, but I haven't found out what
change does that, due to it's a big change about a whole system version. I
reproduced this issue again by using an old RHEL distro (but the kernel is the newest).
(I'll try to find out what changes cause that later if it's necessary)

Anyway, I enabled the "CONFIG_XFS_ASSERT_FATAL=y" and "CONFIG_XFS_DEBUG=y" as
you suggested. And got the xfs metadump file after it crashed [1] and rebooted.

Due to g/648 tests on a loopimg in SCRATCH_MNT, so I didn't dump the SCRATCH_DEV,
but dumped the $SCRATCH_MNT/testfs file, you can get the metadump file from:

https://drive.google.com/file/d/14q7iRl7vFyrEKvv_Wqqwlue6vHGdIFO1/view?usp=sharing

I can reproduce this issue by restoring and mounting this xfs:
  # xfs_mdrestore testfs.metadump testfs.img
  # mount testfs.img /mnt/tmp
then the system crashed [2] directly.

Thanks,
Zorro



[1]
...
 [ 1700.892578] blk_print_req_error: 7 callbacks suppressed
 [ 1700.892580] I/O error, dev loop3, sector 3518365 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 0
 [ 1700.892583] I/O error, dev loop3, sector 3518365 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 0
 [ 1700.892587] XFS (loop3): log I/O error -5
 [ 1700.892590] XFS (loop3): Filesystem has been shut down due to log error (0x2).
 [ 1700.892591] XFS (loop3): Please unmount the filesystem and rectify the problem(s).
 [ 1700.895245] Buffer I/O error on dev dm-3, logical block 20971392, async page read
 [ 1700.895251] Buffer I/O error on dev dm-3, logical block 20971393, async page read
 [ 1701.499437] XFS (loop3): Unmounting Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
 [ 1701.504307] iomap_finish_ioend: 47 callbacks suppressed
 [ 1701.504308] dm-3: writeback error on inode 131, offset 1801400320, sector 4585184
 [ 1701.504315] I/O error, dev loop3, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
 [ 1702.507024] XFS (dm-3): log I/O error -5
 [ 1702.507034] XFS (dm-3): Filesystem has been shut down due to log error (0x2).
 [ 1702.507037] XFS (dm-3): Please unmount the filesystem and rectify the problem(s).
 [ 1702.522361] XFS (dm-3): Unmounting Filesystem cd0c2e0e-6afe-4460-ab7a-186f4cf3d3c5
 [ 1702.532965] XFS (dm-3): Mounting V5 Filesystem cd0c2e0e-6afe-4460-ab7a-186f4cf3d3c5
 [ 1702.548545] XFS (dm-3): Starting recovery (logdev: internal)
 [ 1702.606253] XFS (dm-3): Ending recovery (logdev: internal)
 [ 1702.608865] loop3: detected capacity change from 0 to 6876346
 [ 1702.622241] XFS (loop3): Mounting V5 Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
 [ 1703.228237] XFS (loop3): Starting recovery (logdev: internal)
 [ 1703.321680] XFS (loop3): Ending recovery (logdev: internal)
 [ 1705.345881] XFS (dm-3): log I/O error -5
 [ 1705.345890] XFS (dm-3): Filesystem has been shut down due to log error (0x2).
 [ 1705.345891] XFS (dm-3): Please unmount the filesystem and rectify the problem(s).
 [ 1705.345905] I/O error, dev loop3, sector 3549974 op 0x1:(WRITE) flags 0x9800 phys_seg 1 prio class 0
 [ 1705.345913] XFS (loop3): log I/O error -5
 [ 1705.345916] XFS (loop3): Filesystem has been shut down due to log error (0x2).
 [ 1705.345917] XFS (loop3): Please unmount the filesystem and rectify the problem(s).
 [ 1705.346697] loop3: writeback error on inode 8003302, offset 4964352, sector 3208280
 [ 1705.346698] loop3: writeback error on inode 8003302, offset 4968448, sector 3208688
 [ 1705.346700] loop3: writeback error on inode 8003302, offset 4972544, sector 3207016
 [ 1705.346702] loop3: writeback error on inode 8003302, offset 4976640, sector 3205616
 [ 1705.346704] loop3: writeback error on inode 8003302, offset 4988928, sector 3205472
 [ 1705.346706] loop3: writeback error on inode 8003302, offset 5005312, sector 3205344
 [ 1705.348167] buffer_io_error: 6 callbacks suppressed
 [ 1705.348169] Buffer I/O error on dev dm-3, logical block 20971392, async page read
 [ 1705.348175] Buffer I/O error on dev dm-3, logical block 20971393, async page read
 [ 1705.348177] Buffer I/O error on dev dm-3, logical block 20971394, async page read
 [ 1705.348178] Buffer I/O error on dev dm-3, logical block 20971395, async page read
 [ 1705.348180] Buffer I/O error on dev dm-3, logical block 20971396, async page read
 [ 1705.348182] Buffer I/O error on dev dm-3, logical block 20971397, async page read
 [ 1705.348184] Buffer I/O error on dev dm-3, logical block 20971398, async page read
 [ 1705.348185] Buffer I/O error on dev dm-3, logical block 20971399, async page read
 [ 1705.892860] XFS (loop3): Unmounting Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
 [ 1705.898719] I/O error, dev loop3, sector 0 op 0x1:(WRITE) flags 0x800 phys_seg 0 prio class 0
 [ 1706.916137] XFS (dm-3): Unmounting Filesystem cd0c2e0e-6afe-4460-ab7a-186f4cf3d3c5
 [ 1706.957851] XFS (dm-3): Mounting V5 Filesystem cd0c2e0e-6afe-4460-ab7a-186f4cf3d3c5
 [ 1706.972954] XFS (dm-3): Starting recovery (logdev: internal)
 [ 1707.037394] XFS (dm-3): Ending recovery (logdev: internal)
 [ 1707.038974] loop3: detected capacity change from 0 to 6876346
 [ 1707.044730] XFS (loop3): Mounting V5 Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
 [ 1707.061925] XFS (loop3): Starting recovery (logdev: internal)
 [ 1707.079549] XFS (loop3): Bad dir block magic!
 [ 1707.079552] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
 [ 1707.079593] ------------[ cut here ]------------
 [ 1707.079594] kernel BUG at fs/xfs/xfs_message.c:102!
 [ 1707.079680] monitor event: 0040 ilc:2 [#1] SMP 
 [ 1707.079685] Modules linked in: tls loop rfkill sunrpc vfio_ccw mdev vfio_iommu_type1 zcrypt_cex4 vfio iommufd drm fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c ghash_s390 virtio_net prng des_s390 net_failover sha3_512_s390 failover virtio_blk sha3_256_s390 dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt aes_s390
 [ 1707.079707] CPU: 0 PID: 139643 Comm: mount Kdump: loaded Not tainted 6.7.0+ #1
 [ 1707.079710] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
 [ 1707.079712] Krnl PSW : 0704e00180000000 000003ff7ff1b2ca (assfail+0x62/0x68 [xfs])
 [ 1707.079981]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
 [ 1707.079984] Krnl GPRS: c000000100000021 000003ff7ff95a40 ffffffffffffffea 000000000000000a
 [ 1707.079986]            00000380004133f0 0000000000000000 000003ff800b24c4 0000000300014178
 [ 1707.079988]            000000009580b840 0000000300014178 00000000816ae000 0000000094190a00
 [ 1707.079989]            000003ff8a92ef68 000003ff80096c20 000003ff7ff1b2a8 0000038000413498
 [ 1707.079998] Krnl Code: 000003ff7ff1b2bc: f0a8000407fe	srp	4(11,%r0),2046,8
 [ 1707.079998]            000003ff7ff1b2c2: 47000700		bc	0,1792
 [ 1707.079998]           #000003ff7ff1b2c6: af000000		mc	0,0
 [ 1707.079998]           >000003ff7ff1b2ca: 0707		bcr	0,%r7
 [ 1707.079998]            000003ff7ff1b2cc: 0707		bcr	0,%r7
 [ 1707.079998]            000003ff7ff1b2ce: 0707		bcr	0,%r7
 [ 1707.079998]            000003ff7ff1b2d0: c00400133e0c	brcl	0,000003ff80182ee8
 [ 1707.079998]            000003ff7ff1b2d6: eb6ff0480024	stmg	%r6,%r15,72(%r15)
 [ 1707.080011] Call Trace:
 [ 1707.080012]  [<000003ff7ff1b2ca>] assfail+0x62/0x68 [xfs] 
 [ 1707.080112] ([<000003ff7ff1b2a8>] assfail+0x40/0x68 [xfs])
 [ 1707.080209]  [<000003ff7ff3523e>] xlog_recover_validate_buf_type+0x2a6/0x5c8 [xfs] 
 [ 1707.080307]  [<000003ff7ff365ba>] xlog_recover_buf_commit_pass2+0x382/0x448 [xfs] 
 [ 1707.080405]  [<000003ff7ff4089a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
 [ 1707.080504]  [<000003ff7ff417ce>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
 [ 1707.080605]  [<000003ff7ff41930>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
 [ 1707.080703]  [<000003ff7ff419f8>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
 [ 1707.080802]  [<000003ff7ff4202e>] xlog_recover_process_data+0xb6/0x168 [xfs] 
 [ 1707.080901]  [<000003ff7ff421e4>] xlog_recover_process+0x104/0x150 [xfs] 
 [ 1707.080999]  [<000003ff7ff425e2>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
 [ 1707.081098]  [<000003ff7ff42dd0>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
 [ 1707.081196]  [<000003ff7ff42e6c>] xlog_do_recover+0x4c/0x218 [xfs] 
 [ 1707.081294]  [<000003ff7ff4447a>] xlog_recover+0xda/0x1a0 [xfs] 
 [ 1707.081392]  [<000003ff7ff2ad36>] xfs_log_mount+0x11e/0x280 [xfs] 
 [ 1707.081489]  [<000003ff7ff1c756>] xfs_mountfs+0x3e6/0x920 [xfs] 
 [ 1707.081586]  [<000003ff7ff23ffc>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
 [ 1707.081682]  [<00000000a3d99f88>] get_tree_bdev+0x120/0x1a8 
 [ 1707.081690]  [<00000000a3d97690>] vfs_get_tree+0x38/0x110 
 [ 1707.081693]  [<00000000a3dcae28>] do_new_mount+0x188/0x2e0 
 [ 1707.081697]  [<00000000a3dcbaa4>] path_mount+0x1ac/0x818 
 [ 1707.081700]  [<00000000a3dcc214>] __s390x_sys_mount+0x104/0x148 
 [ 1707.081703]  [<00000000a4420796>] __do_syscall+0x21e/0x2b0 
 [ 1707.081707]  [<00000000a4430d60>] system_call+0x70/0x98 
 [ 1707.081711] Last Breaking-Event-Address:
 [ 1707.081712]  [<000003ff7ff1b2b2>] assfail+0x4a/0x68 [xfs]
 [ 1707.081810] Kernel panic - not syncing: Fatal exception: pan[    0.119599] Linux version 6.7.0+ (root@s390x-kvm-069.lab.eng.rdu2.redhat.com) (gcc (GCC) 11.4.1 20230605 (Red Hat 11.4.1-2), GNU ld version 2.35.2-42.el9) #1 SMP Sat Jan 20 01:55:04 EST 2024
 [    0.119601] setup: Linux is running under KVM in 64-bit mode
 [    0.122163] setup: The maximum memory size is 256MB
 [    0.122165] setup: Relocating AMODE31 section of size 0x00003000
 [    0.133428] cpu: 4 configured CPUs, 0 standby CPUs
 [    0.133481] Write protected kernel read-only data: 14604k
 [    0.133490] Zone ranges:
 [    0.133491]   DMA      [mem 0x0000000000000000-0x000000007fffffff]
 [    0.133493]   Normal   empty
 [    0.133494] Movable zone start for each node
...
(rebooting)
...

[2]
...
 [11866.409382] XFS (loop1): Mounting V5 Filesystem cd0c2e0e-6afe-4460-ab7a-186f4cf3d3c5
 [11866.430464] XFS (loop1): Starting recovery (logdev: internal)
 [11866.438192] XFS (loop1): Ending recovery (logdev: internal)
 [-- MARK -- Sat Jan 20 10:55:00 2024] 
[12116.079456] loop2: detected capacity change from 0 to 6876344
 [12116.085727] XFS (loop2): Mounting V5 Filesystem 59e2f6ae-ceab-4232-9531-a85417847238
 [12116.097020] XFS (loop2): Starting recovery (logdev: internal)
 [12116.113494] XFS (loop2): Bad dir block magic!
 [12116.113498] XFS: Assertion failed: 0, file: fs/xfs/xfs_buf_item_recover.c, line: 414
 [12116.113544] ------------[ cut here ]------------
 [12116.113546] kernel BUG at fs/xfs/xfs_message.c:102!
 [12116.113637] monitor event: 0040 ilc:2 [#1] SMP 
 [12116.113642] Modules linked in: loop rfkill sunrpc vfio_ccw zcrypt_cex4 mdev vfio_iommu_type1 vfio iommufd drm fuse i2c_core drm_panel_orientation_quirks xfs libcrc32c virtio_net ghash_s390 prng net_failover des_s390 sha3_512_s390 virtio_blk failover sha3_256_s390 dm_mirror dm_region_hash dm_log dm_mod pkey zcrypt aes_s390
 [12116.113673] CPU: 0 PID: 1538 Comm: mount Kdump: loaded Not tainted 6.7.0+ #1
 [12116.113676] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
 [12116.113677] Krnl PSW : 0704e00180000000 000003ff7fe9d2ca (assfail+0x62/0x68 [xfs])
 [12116.114117]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
 [12116.114120] Krnl GPRS: c000000000000021 000003ff7ff17a40 ffffffffffffffea 000000000000000a
 [12116.114123]            0000038000417438 0000000000000000 000003ff800344c4 0000000300014178
 [12116.114124]            000000008e50a480 0000000300014178 000000008144e000 000000008648be00
 [12116.114126]            000003ff8f52ef68 000003ff80018c20 000003ff7fe9d2a8 00000380004174e0
 [12116.114135] Krnl Code: 000003ff7fe9d2bc: f0a8000407fe	srp	4(11,%r0),2046,8
 [12116.114135]            000003ff7fe9d2c2: 47000700		bc	0,1792
 [12116.114135]           #000003ff7fe9d2c6: af000000		mc	0,0
 [12116.114135]           >000003ff7fe9d2ca: 0707		bcr	0,%r7
 [12116.114135]            000003ff7fe9d2cc: 0707		bcr	0,%r7
 [12116.114135]            000003ff7fe9d2ce: 0707		bcr	0,%r7
 [12116.114135]            000003ff7fe9d2d0: c00400133e0c	brcl	0,000003ff80104ee8
 [12116.114135]            000003ff7fe9d2d6: eb6ff0480024	stmg	%r6,%r15,72(%r15)
 [12116.114148] Call Trace:
 [12116.114149]  [<000003ff7fe9d2ca>] assfail+0x62/0x68 [xfs] 
 [12116.114274] ([<000003ff7fe9d2a8>] assfail+0x40/0x68 [xfs])
 [12116.114374]  [<000003ff7feb723e>] xlog_recover_validate_buf_type+0x2a6/0x5c8 [xfs] 
 [12116.114475]  [<000003ff7feb85ba>] xlog_recover_buf_commit_pass2+0x382/0x448 [xfs] 
 [12116.114577]  [<000003ff7fec289a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
 [12116.114679]  [<000003ff7fec37ce>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
 [12116.114782]  [<000003ff7fec3930>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
 [12116.114883]  [<000003ff7fec39f8>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
 [12116.114987]  [<000003ff7fec402e>] xlog_recover_process_data+0xb6/0x168 [xfs] 
 [12116.115089]  [<000003ff7fec41e4>] xlog_recover_process+0x104/0x150 [xfs] 
 [12116.115192]  [<000003ff7fec45e2>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
 [12116.115295]  [<000003ff7fec4dd0>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
 [12116.115397]  [<000003ff7fec4e6c>] xlog_do_recover+0x4c/0x218 [xfs] 
 [12116.115500]  [<000003ff7fec647a>] xlog_recover+0xda/0x1a0 [xfs] 
 [12116.115602]  [<000003ff7feacd36>] xfs_log_mount+0x11e/0x280 [xfs] 
 [12116.115706]  [<000003ff7fe9e756>] xfs_mountfs+0x3e6/0x920 [xfs] 
 [12116.115809]  [<000003ff7fea5ffc>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
 [12116.115911]  [<00000000ad9f1f88>] get_tree_bdev+0x120/0x1a8 
 [12116.115918]  [<00000000ad9ef690>] vfs_get_tree+0x38/0x110 
 [12116.115921]  [<00000000ada22e28>] do_new_mount+0x188/0x2e0 
 [12116.115925]  [<00000000ada23aa4>] path_mount+0x1ac/0x818 
 [12116.115928]  [<00000000ada24214>] __s390x_sys_mount+0x104/0x148 
 [12116.115931]  [<00000000ae078796>] __do_syscall+0x21e/0x2b0 
 [12116.115936]  [<00000000ae088d60>] system_call+0x70/0x98 
 [12116.115940] Last Breaking-Event-Address:
 [12116.115940]  [<000003ff7fe9d2b2>] assfail+0x4a/0x68 [xfs]
 [12[    0.117676] Linux version 6.7.0+ (root@s390x-kvm-069.lab.eng.rdu2.redhat.com) (gcc (GCC) 11.4.1 20230605 (Red Hat 11.4.1-2), GNU ld version 2.35.2-42.el9) #1 SMP Sat Jan 20 01:55:04 EST 2024
 [    0.117678] setup: Linux is running under KVM in 64-bit mode
 [    0.120239] setup: The maximum memory size is 256MB
 [    0.120241] setup: Relocating AMODE31 section of size 0x00003000
...

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

