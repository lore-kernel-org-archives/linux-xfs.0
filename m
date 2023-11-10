Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94745C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 01:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjKJBiF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 20:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjKJBiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 20:38:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBED44A4
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 17:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699580219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nRePweDU/Vnpop27p3m0/PrJnLrG6/anLbvqk9r7ero=;
        b=H8eInEkz4hNX/dTsguf/HrUOIM82jMV6xMo7QjilQTNJfbkaq1p11c0A8tw6iGevYWdsyK
        ZwdJXahMg4sMhUZqNTFPAt0W2volfBpE3O+GOsZYKF8dMC6DsBu8X+i/YpG/7bmiCnSO2s
        qTyaXbGmUsKJbyJZZe4Nuy8e0iYlp4o=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-loyWuIX3MxuWky1dBP1T-Q-1; Thu, 09 Nov 2023 20:36:57 -0500
X-MC-Unique: loyWuIX3MxuWky1dBP1T-Q-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3b3447c72c4so1610129b6e.1
        for <linux-xfs@vger.kernel.org>; Thu, 09 Nov 2023 17:36:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699580217; x=1700185017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRePweDU/Vnpop27p3m0/PrJnLrG6/anLbvqk9r7ero=;
        b=d1WboP88SqnqCVFzqVqMgN7uw9yis9Gi0d5fSSpkng3P/bIbPUr5e2h+beqQiC2TJM
         iTV2snZHk+ihvXRKzgy283O9Q29N7x+3zpnW6iZS3Ur3XkdqPolE0bp7/DBzSucVCpiA
         hsAc8NMEEBlxK4xlhz2tVBy6JE757rB9Bj9Jh49o+xE3p1aZjp4aDKxKtf/sUr8lNUtq
         k/p6efOYmLK9kAjiax0+CDTHQtwqOVDjXGEFIHjAQg3msJAxvdZ85CCPWOpBafhYWaBo
         aHmPw9AeNiA+xaeIF9WRL12eY0vmFQBsPZ5LeDEWnvFcaxchftD3tA3OMcML/t7+0Gh+
         S2UQ==
X-Gm-Message-State: AOJu0Yz9GQdR8e012rbPhU42KFD94/nXQW2IzFQbvJojFxGItJuApbum
        12lQ1Zp6Be+A2AIetaS4Ua0dDWU3yC2J/bQu5rgTFx0/9LExGRMh7hv6BPiUk0hPNmsHZLGWl2k
        z7eiPcsRf5AEJwW/4K9aZ
X-Received: by 2002:a05:6808:2d3:b0:3a8:4e27:3af3 with SMTP id a19-20020a05680802d300b003a84e273af3mr3533776oid.48.1699580216930;
        Thu, 09 Nov 2023 17:36:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKXSr035nOQ6lq2ZE51e/57rPzYWP0qNATGALlM/Wshrs2fs2CJa9ArRId00ZpnGwWJuhYlA==
X-Received: by 2002:a05:6808:2d3:b0:3a8:4e27:3af3 with SMTP id a19-20020a05680802d300b003a84e273af3mr3533759oid.48.1699580216414;
        Thu, 09 Nov 2023 17:36:56 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 34-20020a630c62000000b005b83bc255fbsm5354941pgm.71.2023.11.09.17.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 17:36:55 -0800 (PST)
Date:   Fri, 10 Nov 2023 09:36:51 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <20231110013651.fw3j6khkdtjfe2bj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUlNroz8l5h1s1oF@dread.disaster.area>
 <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUstA+1+IvHJ87eP@dread.disaster.area>
 <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
 <ZUx429/S9H07xLrA@dread.disaster.area>
 <20231109140929.jq7bpnuustsup3xf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZU1nltE2X6qLJ8EL@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZU1nltE2X6qLJ8EL@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 10, 2023 at 10:13:26AM +1100, Dave Chinner wrote:
> On Thu, Nov 09, 2023 at 10:09:29PM +0800, Zorro Lang wrote:
> > On Thu, Nov 09, 2023 at 05:14:51PM +1100, Dave Chinner wrote:
> > > On Thu, Nov 09, 2023 at 10:43:58AM +0800, Zirong Lang wrote:
> > > > By changing the generic/047 as below, I got 2 dump files and 2 log files.
> > > > Please check the attachment,
> > > > and feel free to tell me if you need more.
> > > 
> > > Well, we've narrowed down to some weird recovery issue - the journal
> > > is intact, recovery recovers the inode from the correct log item in
> > > the journal, but the inode written to disk by recovery is corrupt.
> > > 
> > > What this points out is that we don't actually verify the inode we
> > > recover is valid before writeback is queued, nor do we detect the
> > > specific corruption being encountered in the verifier (i.e. non-zero
> > > nblocks count when extent count is zero).
> > > 
> > > Can you add the patch below and see if/when the verifier fires on
> > > the reproducer? I'm particularly interested to know where it fires -
> > > in recovery before writeback, or when the root inode is re-read from
> > > disk. It doesn't fire on x64-64....
> > 
> > Hi Dave,
> > 
> > I just re-tested with your patch, the steps as [1]. The trace-cmd output
> > can be downloaded from [2].
> > 
> > Please tell me if I misunderstood anything.
> 
> You got it right, that's exactly what I wanted to see. :)
> 
> ....
> > [ 8272.820617] run fstests generic/047 at 2023-11-09 08:36:39
> > [ 8273.231657] XFS (loop1): Mounting V5 Filesystem 9faf1858-4d74-4b58-b0e7-68fd1d90762a
> > [ 8273.233769] XFS (loop1): Ending clean mount
> > [ 8273.235510] XFS (loop1): User initiated shutdown received.
> > [ 8273.235520] XFS (loop1): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x5a/0xf8 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
> > [ 8273.235772] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
> > [ 8273.236810] XFS (loop1): Unmounting Filesystem 9faf1858-4d74-4b58-b0e7-68fd1d90762a
> > [ 8273.284005] XFS (loop1): Mounting V5 Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
> > [ 8273.285668] XFS (loop1): Ending clean mount
> > [ 8275.789831] XFS (loop1): User initiated shutdown received.
> > [ 8275.789846] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
> > [ 8275.790170] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
> > [ 8275.795171] XFS (loop1): Unmounting Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
> > [ 8282.714748] XFS (loop1): Mounting V5 Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
> > [ 8282.728494] XFS (loop1): Starting recovery (logdev: internal)
> > [ 8282.741350] 00000000: 49 4e 81 80 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> > [ 8282.741357] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [ 8282.741360] 00000020: 35 63 5c e5 7f d2 65 f2 35 63 5c e5 7f d2 65 f2  5c\...e.5c\...e.
> > [ 8282.741363] 00000030: 35 63 5c e5 7f d2 65 f2 00 00 00 00 00 00 80 00  5c\...e.........
> > [ 8282.741366] 00000040: 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00 00  ................
> > [ 8282.741368] 00000050: 00 00 00 02 00 00 00 00 00 00 00 00 5d b8 45 2b  ............].E+
> > [ 8282.741371] 00000060: ff ff ff ff 77 bb a7 2f 00 00 00 00 00 00 00 04  ....w../........
> > [ 8282.741375] 00000070: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 18  ................
> > [ 8282.741378] 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [ 8282.741381] 00000090: 35 63 5c e5 7f d2 65 f2 00 00 00 00 00 00 00 83  5c\...e.........
> > [ 8282.741397] 000000a0: 89 0f 60 68 8e b1 4a fa b1 fb 5d eb 3d 93 7f ce  ..`h..J...].=...
> 
> Ok, so that's the inode core that was recovered and it's in memory
> before being written to disk. It's clearly not been recovered
> correctly - as it's triggered the new extent vs block count check
> I added to the verifier.
> 
> > [ 8282.741399] XFS (loop1): Internal error Bad dinode after recovery at line 536 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x72/0xf0 [xfs]
> > [ 8282.741739] CPU: 1 PID: 7645 Comm: mount Kdump: loaded Not tainted 6.6.0+ #1
> > [ 8282.741743] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
> > [ 8282.741746] Call Trace:
> > [ 8282.741748]  [<000000004e7af67a>] dump_stack_lvl+0x62/0x80 
> > [ 8282.741756]  [<000003ff800b1cb0>] xfs_corruption_error+0x70/0xa0 [xfs] 
> > [ 8282.741863]  [<000003ff800f0032>] xlog_recover_inode_commit_pass2+0x63a/0xb10 [xfs] 
> > [ 8282.741973]  [<000003ff800f400a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
> > [ 8282.742082]  [<000003ff800f4cc6>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
> > [ 8282.742192]  [<000003ff800f4e28>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
> > [ 8282.742302]  [<000003ff800f4ef0>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
> > [ 8282.742413]  [<000003ff800f59b6>] xlog_recover_process_data+0xb6/0x168 [xfs] 
> > [ 8282.742528]  [<000003ff800f5b6c>] xlog_recover_process+0x104/0x150 [xfs] 
> > [ 8282.742638]  [<000003ff800f5f6a>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
> > [ 8282.742747]  [<000003ff800f6758>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
> > [ 8282.742856]  [<000003ff800f67f4>] xlog_do_recover+0x4c/0x218 [xfs] 
> > [ 8282.742965]  [<000003ff800f7cfa>] xlog_recover+0xda/0x1a0 [xfs] 
> > [ 8282.743073]  [<000003ff800dde96>] xfs_log_mount+0x11e/0x280 [xfs] 
> > [ 8282.743181]  [<000003ff800cfcc6>] xfs_mountfs+0x3e6/0x928 [xfs] 
> > [ 8282.743289]  [<000003ff800d7554>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
> > [ 8282.743397]  [<000000004e160fec>] get_tree_bdev+0x144/0x1d0 
> > [ 8282.743403]  [<000000004e15ea20>] vfs_get_tree+0x38/0x110 
> > [ 8282.743406]  [<000000004e19140a>] do_new_mount+0x17a/0x2d0 
> > [ 8282.743411]  [<000000004e192084>] path_mount+0x1ac/0x818 
> > [ 8282.743414]  [<000000004e1927f4>] __s390x_sys_mount+0x104/0x148 
> > [ 8282.743417]  [<000000004e7d5910>] __do_syscall+0x1d0/0x1f8 
> > [ 8282.743420]  [<000000004e7e5bc0>] system_call+0x70/0x98 
> > [ 8282.743423] XFS (loop1): Corruption detected. Unmount and run xfs_repair
> > [ 8282.743425] XFS (loop1): Metadata corruption detected at xfs_dinode_verify.part.0+0x2c6/0x580 [xfs], inode 0x83
> 
> Ok inode 0x83 - that's not the root inode, so slightly unexpected.
> The trace, however, tells me that this is the first inode recovered
> from the checkpoint (the root inode is the other in the checkpoint)
> and we knew that the regular file inodes were bad, too.
> 
> Essentially, the inode dump tells use that everything but the extent
> counts were recovered correctly from the inode log item. I guess we
> now need to do specific trace_printk debugging to find out what,
> exactly, is being processed incorrectly on s390.
> 
> Can you add the debug patch below on top of the corruption detection
> patch? If it fails, run the same trace-cmd on the failed mount as
> you've done here?
> 
> If it does not fail, it would still be good to get a trace of the
> mount that performs recovery successfully. To do that you'll
> have to modify the test to trace the specific mount rather than do
> it separately after the test fails...

The g/047 still fails with this 2nd patch. So I did below steps [1],
and get the trace output as [2], those dump_inodes() messages you
added have been printed, please check.

Thanks,
Zorro

[1]
# ./check generic/047
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/s390x ibm-z-507 6.6.0+ #1 SMP Wed Nov  8 12:51:20 EST 2023
MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=0,reflink=1,bigtime=1,inobtcount=1 /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR

generic/047       [failed, exit status 1]_check_dmesg: something found in dmesg (see /var/lib/xfstests/results//generic/047.dmesg)
- output mismatch (see /var/lib/xfstests/results//generic/047.out.bad)
    --- tests/generic/047.out   2023-11-08 13:02:38.424036829 -0500
    +++ /var/lib/xfstests/results//generic/047.out.bad  2023-11-09 20:19:37.313375849 -0500
    @@ -1 +1,4 @@
     QA output created by 047
    +mount: /mnt/fstests/SCRATCH_DIR: mount(2) system call failed: Structure needs cleaning.
    +mount -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR failed
    +(see /var/lib/xfstests/results//generic/047.full for details)
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/047.out /var/lib/xfstests/results//generic/047.out.bad'  to see the entire diff)
Ran: generic/047
Failures: generic/047
Failed 1 of 1 tests

# mount /dev/loop1 /mnt/fstests/SCRATCH_DIR
mount: /mnt/fstests/SCRATCH_DIR: mount(2) system call failed: Structure needs cleaning.

# dmesg
[  220.067517] run fstests generic/047 at 2023-11-09 20:19:33
[  220.509393] XFS (loop1): Mounting V5 Filesystem 83788739-5d56-4018-a6ae-f808f4d9ac0b
[  220.511726] XFS (loop1): Ending clean mount
[  220.513584] XFS (loop1): User initiated shutdown received.
[  220.513591] XFS (loop1): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x5a/0xf8 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
[  220.513909] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
[  220.515071] XFS (loop1): Unmounting Filesystem 83788739-5d56-4018-a6ae-f808f4d9ac0b
[  220.566039] XFS (loop1): Mounting V5 Filesystem d53516b1-cb48-4c9b-b7bf-0d522a3ed6a0
[  220.568044] XFS (loop1): Ending clean mount
[  223.389303] XFS (loop1): User initiated shutdown received.
[  223.389320] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
[  223.389661] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
[  223.396485] XFS (loop1): Unmounting Filesystem d53516b1-cb48-4c9b-b7bf-0d522a3ed6a0
[  223.405668] XFS (loop1): Mounting V5 Filesystem d53516b1-cb48-4c9b-b7bf-0d522a3ed6a0
[  223.422333] XFS (loop1): Starting recovery (logdev: internal)
[  223.436377] 00000000: 49 4e 81 80 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
[  223.436387] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  223.436390] 00000020: 35 63 83 41 18 01 21 e9 35 63 83 41 18 01 21 e9  5c.A..!.5c.A..!.
[  223.436394] 00000030: 35 63 83 41 18 01 21 e9 00 00 00 00 00 00 80 00  5c.A..!.........
[  223.436397] 00000040: 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00 00  ................
[  223.436400] 00000050: 00 00 00 02 00 00 00 00 00 00 00 00 5a be 98 f1  ............Z...
[  223.436417] 00000060: ff ff ff ff 5e c5 ed 0a 00 00 00 00 00 00 00 04  ....^...........
[  223.436418] 00000070: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 18  ................
[  223.436420] 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  223.436422] 00000090: 35 63 83 41 18 01 21 e9 00 00 00 00 00 00 00 83  5c.A..!.........
[  223.436424] 000000a0: d5 35 16 b1 cb 48 4c 9b b7 bf 0d 52 2a 3e d6 a0  .5...HL....R*>..
[  223.436426] XFS (loop1): Internal error Bad dinode after recovery at line 580 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x72/0xf0 [xfs]
[  223.436696] CPU: 1 PID: 7579 Comm: mount Kdump: loaded Not tainted 6.6.0+ #1
[  223.436700] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
[  223.436701] Call Trace:
[  223.436703]  [<00000000e1f5f67a>] dump_stack_lvl+0x62/0x80 
[  223.436711]  [<000003ff7ff8bcd8>] xfs_corruption_error+0x70/0xa0 [xfs] 
[  223.436800]  [<000003ff7ffca1f4>] xlog_recover_inode_commit_pass2+0x674/0xb40 [xfs] 
[  223.436894]  [<000003ff7ffce1c2>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
[  223.436985]  [<000003ff7ffcee7e>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
[  223.437067]  [<000003ff7ffcefe0>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
[  223.437164]  [<000003ff7ffcf0a8>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
[  223.437272]  [<000003ff7ffcfb6e>] xlog_recover_process_data+0xb6/0x168 [xfs] 
[  223.437381]  [<000003ff7ffcfd24>] xlog_recover_process+0x104/0x150 [xfs] 
[  223.437490]  [<000003ff7ffd0122>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
[  223.437594]  [<000003ff7ffd0910>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
[  223.437697]  [<000003ff7ffd09ac>] xlog_do_recover+0x4c/0x218 [xfs] 
[  223.437799]  [<000003ff7ffd1eb2>] xlog_recover+0xda/0x1a0 [xfs] 
[  223.437905]  [<000003ff7ffb7ebe>] xfs_log_mount+0x11e/0x280 [xfs] 
[  223.438013]  [<000003ff7ffa9cee>] xfs_mountfs+0x3e6/0x928 [xfs] 
[  223.438120]  [<000003ff7ffb157c>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
[  223.438228]  [<00000000e1910fec>] get_tree_bdev+0x144/0x1d0 
[  223.438233]  [<00000000e190ea20>] vfs_get_tree+0x38/0x110 
[  223.438236]  [<00000000e194140a>] do_new_mount+0x17a/0x2d0 
[  223.438240]  [<00000000e1942084>] path_mount+0x1ac/0x818 
[  223.438243]  [<00000000e19427f4>] __s390x_sys_mount+0x104/0x148 
[  223.438246]  [<00000000e1f85910>] __do_syscall+0x1d0/0x1f8 
[  223.438249]  [<00000000e1f95bc0>] system_call+0x70/0x98 
[  223.438252] XFS (loop1): Corruption detected. Unmount and run xfs_repair
[  223.438255] XFS (loop1): Metadata corruption detected at xfs_dinode_verify.part.0+0x2c6/0x580 [xfs], inode 0x83
[  223.438415] XFS (loop1): log mount/recovery failed: error -117
[  223.438903] XFS (loop1): log mount failed
[  223.486754] XFS (loop0): Unmounting Filesystem a488de9e-d346-4098-aff4-84e6ca6936c7
[  345.343101] XFS (loop1): Mounting V5 Filesystem d53516b1-cb48-4c9b-b7bf-0d522a3ed6a0
[  345.354273] XFS (loop1): Starting recovery (logdev: internal)
[  345.362837] 00000000: 49 4e 81 80 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
[  345.362840] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  345.362842] 00000020: 35 63 83 41 18 01 21 e9 35 63 83 41 18 01 21 e9  5c.A..!.5c.A..!.
[  345.362845] 00000030: 35 63 83 41 18 01 21 e9 00 00 00 00 00 00 80 00  5c.A..!.........
[  345.362847] 00000040: 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00 00  ................
[  345.362849] 00000050: 00 00 00 02 00 00 00 00 00 00 00 00 5a be 98 f1  ............Z...
[  345.362851] 00000060: ff ff ff ff 5e c5 ed 0a 00 00 00 00 00 00 00 04  ....^...........
[  345.362853] 00000070: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 18  ................
[  345.362855] 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  345.362858] 00000090: 35 63 83 41 18 01 21 e9 00 00 00 00 00 00 00 83  5c.A..!.........
[  345.362919] 000000a0: d5 35 16 b1 cb 48 4c 9b b7 bf 0d 52 2a 3e d6 a0  .5...HL....R*>..
[  345.362928] XFS (loop1): Internal error Bad dinode after recovery at line 580 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x72/0xf0 [xfs]
...
...
[  345.362928] XFS (loop1): Internal error Bad dinode after recovery at line 580 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x72/0xf0 [xfs]
[  345.363185] CPU: 0 PID: 7657 Comm: mount Kdump: loaded Not tainted 6.6.0+ #1
[  345.363188] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
[  345.363190] Call Trace:
[  345.363192]  [<00000000e1f5f67a>] dump_stack_lvl+0x62/0x80 
[  345.363199]  [<000003ff7ff8bcd8>] xfs_corruption_error+0x70/0xa0 [xfs] 
[  345.363305]  [<000003ff7ffca1f4>] xlog_recover_inode_commit_pass2+0x674/0xb40 [xfs] 
[  345.363387]  [<000003ff7ffce1c2>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
[  345.363469]  [<000003ff7ffcee7e>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
[  345.363550]  [<000003ff7ffcefe0>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
[  345.363631]  [<000003ff7ffcf0a8>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
[  345.363713]  [<000003ff7ffcfb6e>] xlog_recover_process_data+0xb6/0x168 [xfs] 
[  345.363824]  [<000003ff7ffcfd24>] xlog_recover_process+0x104/0x150 [xfs] 
[  345.363906]  [<000003ff7ffd0122>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
[  345.363987]  [<000003ff7ffd0910>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
[  345.364067]  [<000003ff7ffd09ac>] xlog_do_recover+0x4c/0x218 [xfs] 
[  345.364146]  [<000003ff7ffd1eb2>] xlog_recover+0xda/0x1a0 [xfs] 
[  345.364228]  [<000003ff7ffb7ebe>] xfs_log_mount+0x11e/0x280 [xfs] 
[  345.364307]  [<000003ff7ffa9cee>] xfs_mountfs+0x3e6/0x928 [xfs] 
[  345.364386]  [<000003ff7ffb157c>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
[  345.364465]  [<00000000e1910fec>] get_tree_bdev+0x144/0x1d0 
[  345.364470]  [<00000000e190ea20>] vfs_get_tree+0x38/0x110 
[  345.364472]  [<00000000e194140a>] do_new_mount+0x17a/0x2d0 
[  345.364476]  [<00000000e1942084>] path_mount+0x1ac/0x818 
[  345.364478]  [<00000000e19427f4>] __s390x_sys_mount+0x104/0x148 
[  345.364480]  [<00000000e1f85910>] __do_syscall+0x1d0/0x1f8 
[  345.364483]  [<00000000e1f95bc0>] system_call+0x70/0x98 
[  345.364485] XFS (loop1): Corruption detected. Unmount and run xfs_repair
[  345.364486] XFS (loop1): Metadata corruption detected at xfs_dinode_verify.part.0+0x2c6/0x580 [xfs], inode 0x83
[  345.364596] XFS (loop1): log mount/recovery failed: error -117
[  345.364877] XFS (loop1): log mount failed

# trace-cmd record -e xfs\* -e xlog\* -e printk mount /dev/loop1 /mnt/test
mount: /mnt/test: mount(2) system call failed: Structure needs cleaning.
CPU0 data recorded at offset=0x634000
    6385664 bytes in size
CPU1 data recorded at offset=0xc4b000
    0 bytes in size
# trace-cmd report > events-with-dave-patch2.txt
# bzip2 events-with-dave-patch2.txt

[2]
https://drive.google.com/file/d/1Ut1EUmlkxqxuyIhrLcLfhwEhLfeCABs4/view?usp=sharing

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: s390 inode recovery debug
> 
> ---
>  fs/xfs/xfs_inode_item_recover.c | 44 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index f4c31c2b60d5..2a0166702192 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -165,6 +165,41 @@ xfs_log_dinode_to_disk_iext_counters(
>  
>  }
>  
> +static void dump_inodes(
> +	struct xfs_log_dinode	*ldip,
> +	struct xfs_dinode	*dip,
> +	char			*ctx)
> +{
> +	smp_mb();
> +
> +	trace_printk(
> +"disk ino 0x%llx: %s nblocks 0x%llx nextents 0x%x/0x%llx anextents 0x%x/0x%llx v3_pad 0x%llx nrext64_pad 0x%x di_flags2 0x%llx",
> +		be64_to_cpu(dip->di_ino),
> +		ctx,
> +		be64_to_cpu(dip->di_nblocks),
> +		be32_to_cpu(dip->di_nextents),
> +		be64_to_cpu(dip->di_big_nextents),
> +		be32_to_cpu(dip->di_anextents),
> +		be64_to_cpu(dip->di_big_anextents),
> +		be64_to_cpu(dip->di_v3_pad),
> +		be16_to_cpu(dip->di_nrext64_pad),
> +		be64_to_cpu(dip->di_flags2));
> +	trace_printk(
> +"log ino 0x%llx: %s nblocks 0x%llx nextents 0x%x/0x%llx anextents 0x%x/0x%x v3_pad 0x%llx nrext64_pad 0x%x di_flags2 0x%llx %s",
> +		ldip->di_ino,
> +		ctx,
> +		ldip->di_nblocks,
> +		ldip->di_nextents,
> +		ldip->di_big_nextents,
> +		ldip->di_anextents,
> +		ldip->di_big_anextents,
> +		ldip->di_v3_pad,
> +		ldip->di_nrext64_pad,
> +		ldip->di_flags2,
> +		xfs_log_dinode_has_large_extent_counts(ldip) ? "big" : "small");
> +	smp_mb();
> +}
> +
>  STATIC void
>  xfs_log_dinode_to_disk(
>  	struct xfs_log_dinode	*from,
> @@ -196,6 +231,8 @@ xfs_log_dinode_to_disk(
>  	to->di_flags = cpu_to_be16(from->di_flags);
>  	to->di_gen = cpu_to_be32(from->di_gen);
>  
> +	dump_inodes(from, to, "before v3");
> +
>  	if (from->di_version == 3) {
>  		to->di_changecount = cpu_to_be64(from->di_changecount);
>  		to->di_crtime = xfs_log_dinode_to_disk_ts(from,
> @@ -212,6 +249,8 @@ xfs_log_dinode_to_disk(
>  		memset(to->di_v2_pad, 0, sizeof(to->di_v2_pad));
>  	}
>  
> +	dump_inodes(from, to, "before iext");
> +
>  	xfs_log_dinode_to_disk_iext_counters(from, to);
>  }
>  
> @@ -337,6 +376,7 @@ xlog_recover_inode_commit_pass2(
>  		goto out_release;
>  	}
>  
> +	dump_inodes(ldip, dip, "init");
>  	/*
>  	 * If the inode has an LSN in it, recover the inode only if the on-disk
>  	 * inode's LSN is older than the lsn of the transaction we are
> @@ -441,6 +481,7 @@ xlog_recover_inode_commit_pass2(
>  		goto out_release;
>  	}
>  
> +	dump_inodes(ldip, dip, "pre");
>  	/*
>  	 * Recover the log dinode inode into the on disk inode.
>  	 *
> @@ -453,6 +494,8 @@ xlog_recover_inode_commit_pass2(
>  	 */
>  	xfs_log_dinode_to_disk(ldip, dip, current_lsn);
>  
> +	dump_inodes(ldip, dip, "post");
> +
>  	fields = in_f->ilf_fields;
>  	if (fields & XFS_ILOG_DEV)
>  		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
> @@ -530,6 +573,7 @@ xlog_recover_inode_commit_pass2(
>  	    (dip->di_mode != 0))
>  		error = xfs_recover_inode_owner_change(mp, dip, in_f,
>  						       buffer_list);
> +	dump_inodes(ldip, dip, "done");
>  	/* re-generate the checksum and validate the recovered inode. */
>  	xfs_dinode_calc_crc(log->l_mp, dip);
>  	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
> 

