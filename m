Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F206AC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 14:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbjKIOKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 09:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjKIOKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 09:10:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41262D77
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 06:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699538978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LQxo4IuuflC7q/AKaSS2VKFTZfT/xy6yf5Kuwab4PSk=;
        b=OksRcwYRztYb15tBV9xjT9VoRzhw2DL7zKTpliNtSt+Tn69pBi+QFN5JQF9vaBZXEL+805
        ReBJ2NNRS2EExHAF7FXoWaRC+VKRZEbWTpkP6dq58ONWCqUv7slLhviB9ab0aCJgvQFqhk
        FWueJ/pJMaVluKlwzmpcTcvGfWISaeE=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-q2AZotijNkiiBVVt9LWwgQ-1; Thu, 09 Nov 2023 09:09:36 -0500
X-MC-Unique: q2AZotijNkiiBVVt9LWwgQ-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6c33863fd0bso921840b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Nov 2023 06:09:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699538975; x=1700143775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQxo4IuuflC7q/AKaSS2VKFTZfT/xy6yf5Kuwab4PSk=;
        b=CGTg/e1lD9lip7vQErk689IOqpOZVeLoPYooX5QhqvuC/GKcxRA99j+nvsZUJSIqDT
         ZIKLy0gtFGo0OtSk/PiNw7IvLHrJOmUk6Ot5YNKBl5KZv3JSWmPwCDPuY3zaOmyinBSJ
         nGdFdmK4I8xJlbM9EavNLP8Yslx2IGaM7DbH2nf4fixwQwXSFgdlFpWsCulwkIFWxGND
         PMHYG0cXee6ugRGWRxAUVCma1Ree++AfX3egBrDqlRXGgD9dNryJJfZflb1mywXpSNKe
         TJUvSiHV/6fCYxDajNMDfiDaYQZhoo6EgdpVuFK0pKRELWkum+pYp2q4JNB2SemDjiWm
         ClWg==
X-Gm-Message-State: AOJu0YzpzuZfTuenqYOI0KVIdNJK1/pyxAYz4MFi65w/rQiWfHvzyUAC
        wh5jrDKe2MlhBx7NqInoLnAuSIxDzlhz8bavE/elHSl2XIukB8p8wCmWLyDPTa6hcvqXdG4TKv/
        me1zZhSgT8WjInegWlhZh
X-Received: by 2002:a05:6300:8084:b0:15e:a653:fed5 with SMTP id ap4-20020a056300808400b0015ea653fed5mr5618584pzc.16.1699538974478;
        Thu, 09 Nov 2023 06:09:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuMZW2eAgd2gJPK6tc/ERoDfZYtP16LTEPc4zYDs6CnR0U3OUwxMU7hqYW5EXbR4CuhC44YQ==
X-Received: by 2002:a05:6300:8084:b0:15e:a653:fed5 with SMTP id ap4-20020a056300808400b0015ea653fed5mr5618543pzc.16.1699538973876;
        Thu, 09 Nov 2023 06:09:33 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g24-20020aa78758000000b006c003d9897bsm10704241pfo.138.2023.11.09.06.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 06:09:33 -0800 (PST)
Date:   Thu, 9 Nov 2023 22:09:29 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <20231109140929.jq7bpnuustsup3xf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUiECgUWZ/8HKi3k@dread.disaster.area>
 <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUlNroz8l5h1s1oF@dread.disaster.area>
 <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUstA+1+IvHJ87eP@dread.disaster.area>
 <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
 <ZUx429/S9H07xLrA@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUx429/S9H07xLrA@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 05:14:51PM +1100, Dave Chinner wrote:
> On Thu, Nov 09, 2023 at 10:43:58AM +0800, Zirong Lang wrote:
> > By changing the generic/047 as below, I got 2 dump files and 2 log files.
> > Please check the attachment,
> > and feel free to tell me if you need more.
> 
> Well, we've narrowed down to some weird recovery issue - the journal
> is intact, recovery recovers the inode from the correct log item in
> the journal, but the inode written to disk by recovery is corrupt.
> 
> What this points out is that we don't actually verify the inode we
> recover is valid before writeback is queued, nor do we detect the
> specific corruption being encountered in the verifier (i.e. non-zero
> nblocks count when extent count is zero).
> 
> Can you add the patch below and see if/when the verifier fires on
> the reproducer? I'm particularly interested to know where it fires -
> in recovery before writeback, or when the root inode is re-read from
> disk. It doesn't fire on x64-64....

Hi Dave,

I just re-tested with your patch, the steps as [1]. The trace-cmd output
can be downloaded from [2].

Please tell me if I misunderstood anything.

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
    +++ /var/lib/xfstests/results//generic/047.out.bad  2023-11-09 08:41:50.026163756 -0500
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
[ 8272.820617] run fstests generic/047 at 2023-11-09 08:36:39
[ 8273.231657] XFS (loop1): Mounting V5 Filesystem 9faf1858-4d74-4b58-b0e7-68fd1d90762a
[ 8273.233769] XFS (loop1): Ending clean mount
[ 8273.235510] XFS (loop1): User initiated shutdown received.
[ 8273.235520] XFS (loop1): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x5a/0xf8 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
[ 8273.235772] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
[ 8273.236810] XFS (loop1): Unmounting Filesystem 9faf1858-4d74-4b58-b0e7-68fd1d90762a
[ 8273.284005] XFS (loop1): Mounting V5 Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
[ 8273.285668] XFS (loop1): Ending clean mount
[ 8275.789831] XFS (loop1): User initiated shutdown received.
[ 8275.789846] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
[ 8275.790170] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
[ 8275.795171] XFS (loop1): Unmounting Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
[ 8282.714748] XFS (loop1): Mounting V5 Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
[ 8282.728494] XFS (loop1): Starting recovery (logdev: internal)
[ 8282.741350] 00000000: 49 4e 81 80 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
[ 8282.741357] 00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
[ 8282.741360] 00000020: 35 63 5c e5 7f d2 65 f2 35 63 5c e5 7f d2 65 f2  5c\...e.5c\...e.
[ 8282.741363] 00000030: 35 63 5c e5 7f d2 65 f2 00 00 00 00 00 00 80 00  5c\...e.........
[ 8282.741366] 00000040: 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00 00  ................
[ 8282.741368] 00000050: 00 00 00 02 00 00 00 00 00 00 00 00 5d b8 45 2b  ............].E+
[ 8282.741371] 00000060: ff ff ff ff 77 bb a7 2f 00 00 00 00 00 00 00 04  ....w../........
[ 8282.741375] 00000070: 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 18  ................
[ 8282.741378] 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[ 8282.741381] 00000090: 35 63 5c e5 7f d2 65 f2 00 00 00 00 00 00 00 83  5c\...e.........
[ 8282.741397] 000000a0: 89 0f 60 68 8e b1 4a fa b1 fb 5d eb 3d 93 7f ce  ..`h..J...].=...
[ 8282.741399] XFS (loop1): Internal error Bad dinode after recovery at line 536 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x72/0xf0 [xfs]
[ 8282.741739] CPU: 1 PID: 7645 Comm: mount Kdump: loaded Not tainted 6.6.0+ #1
[ 8282.741743] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
[ 8282.741746] Call Trace:
[ 8282.741748]  [<000000004e7af67a>] dump_stack_lvl+0x62/0x80 
[ 8282.741756]  [<000003ff800b1cb0>] xfs_corruption_error+0x70/0xa0 [xfs] 
[ 8282.741863]  [<000003ff800f0032>] xlog_recover_inode_commit_pass2+0x63a/0xb10 [xfs] 
[ 8282.741973]  [<000003ff800f400a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
[ 8282.742082]  [<000003ff800f4cc6>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
[ 8282.742192]  [<000003ff800f4e28>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
[ 8282.742302]  [<000003ff800f4ef0>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
[ 8282.742413]  [<000003ff800f59b6>] xlog_recover_process_data+0xb6/0x168 [xfs] 
[ 8282.742528]  [<000003ff800f5b6c>] xlog_recover_process+0x104/0x150 [xfs] 
[ 8282.742638]  [<000003ff800f5f6a>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
[ 8282.742747]  [<000003ff800f6758>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
[ 8282.742856]  [<000003ff800f67f4>] xlog_do_recover+0x4c/0x218 [xfs] 
[ 8282.742965]  [<000003ff800f7cfa>] xlog_recover+0xda/0x1a0 [xfs] 
[ 8282.743073]  [<000003ff800dde96>] xfs_log_mount+0x11e/0x280 [xfs] 
[ 8282.743181]  [<000003ff800cfcc6>] xfs_mountfs+0x3e6/0x928 [xfs] 
[ 8282.743289]  [<000003ff800d7554>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
[ 8282.743397]  [<000000004e160fec>] get_tree_bdev+0x144/0x1d0 
[ 8282.743403]  [<000000004e15ea20>] vfs_get_tree+0x38/0x110 
[ 8282.743406]  [<000000004e19140a>] do_new_mount+0x17a/0x2d0 
[ 8282.743411]  [<000000004e192084>] path_mount+0x1ac/0x818 
[ 8282.743414]  [<000000004e1927f4>] __s390x_sys_mount+0x104/0x148 
[ 8282.743417]  [<000000004e7d5910>] __do_syscall+0x1d0/0x1f8 
[ 8282.743420]  [<000000004e7e5bc0>] system_call+0x70/0x98 
[ 8282.743423] XFS (loop1): Corruption detected. Unmount and run xfs_repair
[ 8282.743425] XFS (loop1): Metadata corruption detected at xfs_dinode_verify.part.0+0x2c6/0x580 [xfs], inode 0x83
[ 8282.743582] XFS (loop1): log mount/recovery failed: error -117
[ 8282.743846] XFS (loop1): log mount failed
[ 8282.778368] XFS (loop0): Unmounting Filesystem a488de9e-d346-4098-aff4-84e6ca6936c7
[ 8458.453977] XFS (loop1): Mounting V5 Filesystem 890f6068-8eb1-4afa-b1fb-5deb3d937fce
[ 8458.467682] XFS (loop1): Starting recovery (logdev: internal)
...
...
[ 8611.351331] XFS (loop1): Internal error Bad dinode after recovery at line 536 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x72/0xf0 [xfs]
[ 8611.351612] CPU: 1 PID: 10548 Comm: mount Kdump: loaded Not tainted 6.6.0+ #1
[ 8611.351614] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
[ 8611.351615] Call Trace:
[ 8611.351617]  [<000000004e7af67a>] dump_stack_lvl+0x62/0x80 
[ 8611.351624]  [<000003ff800b1cb0>] xfs_corruption_error+0x70/0xa0 [xfs] 
[ 8611.351707]  [<000003ff800f0032>] xlog_recover_inode_commit_pass2+0x63a/0xb10 [xfs] 
[ 8611.351792]  [<000003ff800f400a>] xlog_recover_items_pass2+0x72/0xf0 [xfs] 
[ 8611.351886]  [<000003ff800f4cc6>] xlog_recover_commit_trans+0x39e/0x3c0 [xfs] 
[ 8611.351989]  [<000003ff800f4e28>] xlog_recovery_process_trans+0x140/0x148 [xfs] 
[ 8611.352073]  [<000003ff800f4ef0>] xlog_recover_process_ophdr+0xc0/0x180 [xfs] 
[ 8611.352157]  [<000003ff800f59b6>] xlog_recover_process_data+0xb6/0x168 [xfs] 
[ 8611.352243]  [<000003ff800f5b6c>] xlog_recover_process+0x104/0x150 [xfs] 
[ 8611.352326]  [<000003ff800f5f6a>] xlog_do_recovery_pass+0x3b2/0x748 [xfs] 
[ 8611.352409]  [<000003ff800f6758>] xlog_do_log_recovery+0x88/0xd8 [xfs] 
[ 8611.352497]  [<000003ff800f67f4>] xlog_do_recover+0x4c/0x218 [xfs] 
[ 8611.352582]  [<000003ff800f7cfa>] xlog_recover+0xda/0x1a0 [xfs] 
[ 8611.352668]  [<000003ff800dde96>] xfs_log_mount+0x11e/0x280 [xfs] 
[ 8611.352767]  [<000003ff800cfcc6>] xfs_mountfs+0x3e6/0x928 [xfs] 
[ 8611.352851]  [<000003ff800d7554>] xfs_fs_fill_super+0x40c/0x7d8 [xfs] 
[ 8611.352935]  [<000000004e160fec>] get_tree_bdev+0x144/0x1d0 
[ 8611.352941]  [<000000004e15ea20>] vfs_get_tree+0x38/0x110 
[ 8611.352944]  [<000000004e19140a>] do_new_mount+0x17a/0x2d0 
[ 8611.352948]  [<000000004e192084>] path_mount+0x1ac/0x818 
[ 8611.352950]  [<000000004e1927f4>] __s390x_sys_mount+0x104/0x148 
[ 8611.352953]  [<000000004e7d5910>] __do_syscall+0x1d0/0x1f8 
[ 8611.352955]  [<000000004e7e5bc0>] system_call+0x70/0x98 
[ 8611.352958] XFS (loop1): Corruption detected. Unmount and run xfs_repair
[ 8611.352960] XFS (loop1): Metadata corruption detected at xfs_dinode_verify.part.0+0x2c6/0x580 [xfs], inode 0x83
[ 8611.353061] XFS (loop1): log mount/recovery failed: error -117
[ 8611.353227] XFS (loop1): log mount failed

# trace-cmd record -e xfs\* -e xlog\* -e printk mount /dev/loop1 /mnt/test
# trace-cmd report > events-with-dave-patch.txt

[2]
https://drive.google.com/file/d/1EeWhmhS9yETegPM4oPcAe5Nuj5fUBu3V/view?usp=sharing


> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: inode recovery does not validate the recovered inode
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Discovered when trying to track down a weird recovery corruption
> issue that wasn't detected at recovery time.
> 
> The specific corruption was a zero extent count field when big
> extent counts are in use, and it turns out the dinode verifier
> doesn't detect that specific corruption case, either. So fix it too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
>  fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index a35781577cad..0f970a0b3382 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -508,6 +508,9 @@ xfs_dinode_verify(
>  	if (mode && nextents + naextents > nblocks)
>  		return __this_address;
>  
> +	if (nextents + naextents == 0 && nblocks != 0)
> +		return __this_address;
> +
>  	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
>  		return __this_address;
>  
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 6b09e2bf2d74..f4c31c2b60d5 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
>  	struct xfs_log_dinode		*ldip;
>  	uint				isize;
>  	int				need_free = 0;
> +	xfs_failaddr_t			fa;
>  
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
>  		in_f = item->ri_buf[0].i_addr;
> @@ -529,8 +530,19 @@ xlog_recover_inode_commit_pass2(
>  	    (dip->di_mode != 0))
>  		error = xfs_recover_inode_owner_change(mp, dip, in_f,
>  						       buffer_list);
> -	/* re-generate the checksum. */
> +	/* re-generate the checksum and validate the recovered inode. */
>  	xfs_dinode_calc_crc(log->l_mp, dip);
> +	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
> +	if (fa) {
> +		XFS_CORRUPTION_ERROR(
> +			"Bad dinode after recovery",
> +				XFS_ERRLEVEL_LOW, mp, dip, sizeof(*dip));
> +		xfs_alert(mp,
> +			"Metadata corruption detected at %pS, inode 0x%llx",
> +			fa, in_f->ilf_ino);
> +		error = -EFSCORRUPTED;
> +		goto out_release;
> +	}
>  
>  	ASSERT(bp->b_mount == mp);
>  	bp->b_flags |= _XBF_LOGRECOVERY;
> 

