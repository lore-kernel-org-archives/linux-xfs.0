Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7E2CD37B0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Sep 2023 16:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjIRQ4e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjIRQ41 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 12:56:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B594268F
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 09:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695055495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zNzVC11m2ZojWENcI1KzZA1ENuJtuB5TBjlW2wXXVEQ=;
        b=YHEtg16PF4+u/+EKxxLAVA7tFoOMM/BLkwBYnqyfJk5ooCo9PhXoll+n1mznTCSrGOI6oP
        zL3Cj3Dz0l6+x2zoqFv8IACOsqe4xn+qS/SN4+yNPUOKaVirWHoGBOyiU01FhnzuDHE5F7
        seshcvyAuwPhPcOIOFSO8lpOVPlR6NE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-smC2t6hjNFOVq84MVjzTpQ-1; Mon, 18 Sep 2023 12:44:54 -0400
X-MC-Unique: smC2t6hjNFOVq84MVjzTpQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1c43334badcso24854625ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2023 09:44:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695055493; x=1695660293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zNzVC11m2ZojWENcI1KzZA1ENuJtuB5TBjlW2wXXVEQ=;
        b=dMNML/BPEPWPVwFeR7Vz7TjLkpV0B44Z/6LWllnkdV2oVxCVweKV6/UJXb4PVo5UF3
         m6DZHBXf1u+gL7gfszGeliGmzaMmKf3aoWSIpfFIllFoTyobq9vNkG35oanE96Y9cnCI
         MfWwdaolANv3sTPhzVMXlQm83Sa3DNRoUb/PjdWKCCUPF8CtJfUjYLi9VcCTgfOpaab4
         U+6W/A5jJU5W7EIU+ZicifOArk7MRBiwv7l2CAGQJ9hm7mmReXp5M0PxCNF+90s9ngJL
         781fM6K4zKHdPUrzbrsLkM0sbEhReoZ1oUvHzjOM4zORWQYfwke595cv0bZqRU2gZIid
         V7eg==
X-Gm-Message-State: AOJu0YwGEddSpkfSjNvyv9A4zchx/A2S8FjC04mZ7gOUM+c3iB4dxL/J
        ialQS/pBm4sjZ9sXItZoh6+zFC/nlAMuCW7dmei+uenSEgvZEUwt8xeC6Y+M6uYxlR3wYKz6g/m
        fuvA8HqfuERjB9ED6ihwg
X-Received: by 2002:a17:903:2352:b0:1c4:56c8:27f8 with SMTP id c18-20020a170903235200b001c456c827f8mr5100873plh.68.1695055492954;
        Mon, 18 Sep 2023 09:44:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGc0fyMpBcDil0FJRnre+wYgSwx130qTmNc9umKiP05hS42fH6hwOTD96kt/wTtrBEJQ/NYfA==
X-Received: by 2002:a17:903:2352:b0:1c4:56c8:27f8 with SMTP id c18-20020a170903235200b001c456c827f8mr5100852plh.68.1695055492516;
        Mon, 18 Sep 2023 09:44:52 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z12-20020a170902ee0c00b001c452f827casm4567789plb.257.2023.09.18.09.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:44:52 -0700 (PDT)
Date:   Tue, 19 Sep 2023 00:44:49 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v2 0/2] fstests: fix ro mounting with unknown rocompat
 features
Message-ID: <20230918164449.hbk3dllbv76bp3ow@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <169335058807.3526409.15604604578540143202.stgit@frogsfrogsfrogs>
 <20230917164440.y27qdcugzodz6mw6@zlang-mailbox>
 <20230918151756.GA348004@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918151756.GA348004@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2023 at 08:17:56AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 18, 2023 at 12:44:40AM +0800, Zorro Lang wrote:
> > Hi Darrick,
> > 
> > Hi Darrick,
> > 
> > Do these two changes cover new xfs bug fix? I hit xfs/270 fails on
> > latest upstream mainline kernel testing, e.g. [1][2]. But the xfs/270
> > always test passed on my side before.
> 
> Yes, the changes in xfs/270 reflect the corrections to the ro mounting
> behavior in this fix series:
> https://lore.kernel.org/linux-xfs/169454023347.3411463.3256623887249978768.stg-ugh@frogsfrogsfrogs/T/#u
> 
> The ro mount behavior regressed some 7-8 years ago; this test was
> written to test the broken fix; and we didn't notice any of this until
> 6.1 added the incore unlinked list.  xfs/270 didn't check the usability
> of the mounted ro filesystem, so nobody noticed that the mount failed
> when it should have succeeded.
> 
> (That's the first + line)
> 
> The second diff here checks what happens when you try to ro mount with a
> dirty log.

Thanks Darrick,

With the "[PATCH 1/2] xfs/270: actually test file readability", the x/270 only
fails as [1], but with the "[PATCH 2/2] xfs/270: actually test log recovery with
unknown rocompat feature", I hit one more kernel assertion failure as [2].

Are these two kind of failures all as known, and will be fixed by :
 [GIT PULL 3/8] xfs: fix ro mounting with unknown rocompat features
?

Thanks,
Zorro


> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > [1]
> > --- /dev/fd/63	2023-09-16 20:33:38.373115157 -0400
> > +++ xfs/270.out.bad	2023-09-16 20:33:37.959115275 -0400
> > @@ -1,6 +1,9 @@
> >  QA output created by 270
> >  rw mount test
> >  ro mount test
> > +cat: /mnt/xfstests/scratch/testfile: Input/output error
> >  rw remount test
> >  rw mount test
> >  ro mount test
> > +ro mount test failed
> > +(see /var/lib/xfstests/results//xfs/270.full for details)
> > 
> > [2]
> > [57829.436755] run fstests xfs/270 at 2023-09-16 20:33:31
> > [57832.373519] XFS (vda3): Mounting V5 Filesystem b31f9652-417d-4dd2-a5ed-54ee957fbfcb
> > [57832.398699] XFS (vda3): Ending clean mount
> > [57832.551895] XFS (vda3): Unmounting Filesystem b31f9652-417d-4dd2-a5ed-54ee957fbfcb
> > [57832.909487] XFS (vda3): Mounting V5 Filesystem 08403da7-afbe-4bfa-a45c-487e28280acc
> > [57832.934603] XFS (vda3): Ending clean mount
> > [57832.963287] XFS (vda3): User initiated shutdown received.
> > [57832.967959] XFS (vda3): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x4b/0x180 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
> > [57832.974742] XFS (vda3): Please unmount the filesystem and rectify the problem(s)
> > [57833.002720] XFS (vda3): Unmounting Filesystem 08403da7-afbe-4bfa-a45c-487e28280acc
> > [57833.376473] XFS (vda3): Mounting V5 Filesystem 801b25ca-acc4-4232-9955-dc3448680467
> > [57833.403380] XFS (vda3): Ending clean mount
> > [57833.443719] XFS (vda3): Unmounting Filesystem 801b25ca-acc4-4232-9955-dc3448680467
> > [57833.516114] [TTM] Buffer eviction failed
> > [57833.519490] qxl 0000:00:02.0: object_init failed for (3149824, 0x00000001)
> > [57833.523184] [drm:qxl_alloc_bo_reserved [qxl]] *ERROR* failed to allocate VRAM BO
> > [57833.955746] XFS (vda3): Superblock has unknown read-only compatible features (0x80000000) enabled.
> > [57833.960383] XFS (vda3): Attempted to mount read-only compatible filesystem read-write.
> > [57833.964353] XFS (vda3): Filesystem can only be safely mounted read only.
> > [57833.967997] XFS (vda3): SB validate failed with error -22.
> > [57834.039637] XFS (vda3): Superblock has unknown read-only compatible features (0x80000000) enabled.
> > [57834.046289] XFS (vda3): Mounting V5 Filesystem 801b25ca-acc4-4232-9955-dc3448680467
> > [57834.075451] XFS (vda3): Ending clean mount
> > [57834.082359] XFS (vda3): Corruption detected in superblock read-only compatible features (0x80000000)!
> > [57834.086487] XFS (vda3): Metadata corruption detected at xfs_sb_write_verify+0x11d/0x380 [xfs], xfs_sb block 0x0 
> > [57834.090716] XFS (vda3): Unmount and run xfs_repair
> > [57834.093708] XFS (vda3): First 128 bytes of corrupted metadata buffer:
> > [57834.096953] 00000000: 58 46 53 42 00 00 10 00 00 00 00 00 00 3c 00 00  XFSB.........<..
> > [57834.100635] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > [57834.104330] 00000020: 80 1b 25 ca ac c4 42 32 99 55 dc 34 48 68 04 67  ..%...B2.U.4Hh.g
> > [57834.108273] 00000030: 00 00 00 00 00 20 00 06 00 00 00 00 00 00 00 80  ..... ..........
> > [57834.112176] 00000040: 00 00 00 00 00 00 00 81 00 00 00 00 00 00 00 82  ................
> > [57834.116043] 00000050: 00 00 00 01 00 0f 00 00 00 00 00 04 00 00 00 00  ................
> > [57834.119693] 00000060: 00 00 40 00 b4 a5 02 00 02 00 00 08 00 00 00 00  ..@.............
> > [57834.123459] 00000070: 00 00 00 00 00 00 00 00 0c 09 09 03 14 00 00 19  ................
> > [57834.127159] XFS (vda3): Corruption of in-memory data (0x8) detected at _xfs_buf_ioapply+0x50b/0x5f0 [xfs] (fs/xfs/xfs_buf.c:1558).  Shutting down filesystem.
> > [57834.134557] XFS (vda3): Please unmount the filesystem and rectify the problem(s)
> > [57834.253491] XFS (vda3): ro->rw transition prohibited on unknown (0x80000000) ro-compat filesystem
> > [57834.281980] XFS (vda3): Unmounting Filesystem 801b25ca-acc4-4232-9955-dc3448680467
> > [57834.655120] XFS (vda3): Mounting V5 Filesystem 29902d21-a146-4095-8747-562850110ff6
> > [57834.682299] XFS (vda3): Ending clean mount
> > [57834.723067] XFS (vda3): User initiated shutdown received.
> > [57834.730954] XFS (vda3): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x4b/0x180 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
> > [57834.738710] XFS (vda3): Please unmount the filesystem and rectify the problem(s)
> > [57834.768607] XFS (vda3): Unmounting Filesystem 29902d21-a146-4095-8747-562850110ff6
> > [57835.270472] XFS (vda3): Superblock has unknown read-only compatible features (0x80000000) enabled.
> > [57835.275655] XFS (vda3): Attempted to mount read-only compatible filesystem read-write.
> > [57835.279434] XFS (vda3): Filesystem can only be safely mounted read only.
> > [57835.283124] XFS (vda3): SB validate failed with error -22.
> > [57835.357336] XFS (vda3): Superblock has unknown read-only compatible features (0x80000000) enabled.
> > [57835.369968] XFS (vda3): Mounting V5 Filesystem 29902d21-a146-4095-8747-562850110ff6
> > [57835.398595] XFS (vda3): Starting recovery (logdev: internal)
> > [57835.410361] XFS (vda3): Superblock has unknown read-only compatible features (0x80000000) enabled.
> > [57835.414593] XFS (vda3): Attempted to mount read-only compatible filesystem read-write.
> > [57835.418495] XFS (vda3): Filesystem can only be safely mounted read only.
> > [57835.422152] XFS (vda3): metadata I/O error in "xlog_do_recover+0x3e8/0x540 [xfs]" at daddr 0x0 len 1 error 22
> > [57835.426851] XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 3321
> > [57835.430765] ------------[ cut here ]------------
> > [57835.434014] WARNING: CPU: 2 PID: 3426232 at fs/xfs/xfs_message.c:104 assfail+0x54/0x70 [xfs]
> > [57835.438380] Modules linked in: ext2 overlay dm_zero dm_log_writes dm_thin_pool dm_persistent_data dm_bio_prison sd_mod t10_pi sg dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod tls rfkill intel_rapl_msr sunrpc intel_rapl_common intel_uncore_frequency_common isst_if_common nfit snd_hda_codec_generic ledtrig_audio kvm_intel snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec kvm snd_hda_core snd_hwdep irqbypass snd_seq snd_seq_device snd_pcm qxl snd_timer drm_ttm_helper ttm pcspkr virtio_balloon snd drm_kms_helper soundcore i2c_piix4 joydev drm fuse xfs libcrc32c ata_generic crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ata_piix virtio_console virtio_net net_failover failover virtio_blk libata serio_raw [last unloaded: scsi_debug]
> > [57835.467794] CPU: 2 PID: 3426232 Comm: mount Kdump: loaded Tainted: G        W          6.6.0-rc1+ #1
> > [57835.472233] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> > [57835.475946] RIP: 0010:assfail+0x54/0x70 [xfs]
> > [57835.479708] Code: c0 48 ba 00 00 00 00 00 fc ff df 48 89 c1 83 e0 07 48 c1 e9 03 0f b6 14 11 38 c2 7f 04 84 d2 75 10 80 3d 6e 3f 1c 00 00 75 15 <0f> 0b c3 cc cc cc cc 48 c7 c7 10 47 99 c0 e8 79 fd 34 df eb e2 0f
> > [57835.489526] RSP: 0018:ffffc9000293f918 EFLAGS: 00010246
> > [57835.493381] RAX: 0000000000000000 RBX: ffff88817b73a000 RCX: 1ffffffff81328e2
> > [57835.497512] RDX: 0000000000000004 RSI: ffffc9000293f680 RDI: ffffffffc0afd780
> > [57835.501588] RBP: ffff8881964ea000 R08: 00000000ffffffea R09: fffff52000527ec1
> > [57835.505701] R10: ffffc9000293f60f R11: fffffffffff6c2b0 R12: 00000000ffffffea
> > [57835.509789] R13: ffff88817b73a0e0 R14: ffff8881b927ba80 R15: 
> > 
> > 
> > On Tue, Aug 29, 2023 at 04:09:48PM -0700, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > Dave pointed out some failures in xfs/270 when he upgraded Debian
> > > unstable and util-linux started using the new mount apis.  Upon further
> > > inquiry I noticed that XFS is quite a hot mess when it encounters a
> > > filesystem with unrecognized rocompat bits set in the superblock.
> > > 
> > > Whereas we used to allow readonly mounts under these conditions, a
> > > change to the sb write verifier several years ago resulted in the
> > > filesystem going down immediately because the post-mount log cleaning
> > > writes the superblock, which trips the sb write verifier on the
> > > unrecognized rocompat bit.  I made the observation that the ROCOMPAT
> > > features RMAPBT and REFLINK both protect new log intent item types,
> > > which means that we actually cannot support recovering the log if we
> > > don't recognize all the rocompat bits.
> > > 
> > > Therefore -- fix inode inactivation to work when we're recovering the
> > > log, disallow recovery when there's unrecognized rocompat bits, and
> > > don't clean the log if doing so would trip the rocompat checks.
> > > 
> > > v2: change direction of series to allow log recovery on ro mounts
> > > 
> > > If you're going to start using this code, I strongly recommend pulling
> > > from my git trees, which are linked below.
> > > 
> > > This has been running on the djcloud for months with no problems.  Enjoy!
> > > Comments and questions are, as always, welcome.
> > > 
> > > --D
> > > 
> > > fstests git tree:
> > > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-ro-mounts
> > > ---
> > >  tests/xfs/270     |   80 ++++++++++++++++++++++++++++++++++++++---------------
> > >  tests/xfs/270.out |    2 +
> > >  2 files changed, 59 insertions(+), 23 deletions(-)
> > > 
> > 
> 

