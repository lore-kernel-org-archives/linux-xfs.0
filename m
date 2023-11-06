Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3583C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 19:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjKFT1Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 14:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjKFT1Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 14:27:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB25125
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 11:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699298794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QrglblGKu5t8qGXDp6Bxs0SVaAyV7q53TskJ/b754JQ=;
        b=ZzhJ1L1mYEx+hhw3t2qQ8B/N1EbRbCuFGIp0N84aSRQ6yauf7H7VJOcldqGJjSNwwaKrXH
        4mO/vXI8/P3PNg6ntupLRBLulLaTZkH5paGAYSPXyhIuRg4U07IzVQKalRhUjgdFWpAivJ
        hKJqvMr6p9gGrct5wEvfYiIXCnaBs5k=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-McAzrlX5PHi0y5OOzQm7eA-1; Mon, 06 Nov 2023 14:26:32 -0500
X-MC-Unique: McAzrlX5PHi0y5OOzQm7eA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6b6bc2f2bdbso3462045b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 06 Nov 2023 11:26:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699298791; x=1699903591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QrglblGKu5t8qGXDp6Bxs0SVaAyV7q53TskJ/b754JQ=;
        b=pHm4kJzdXWGW/0zn5Hub3i7cSFPbpaSMa2lVmnhCI+hYxjbHKBAZsEn311UTDeehQi
         g4H86+SOICneBQsNJB9bskWfT+lrigrUL+9cqz4yp1Lgv13AKBcSpdFeH8kvSIsseuLF
         ox5CxSPc23SiEl4q84nYd5eiiVA9guE8qKFhU5saboisdSuKI9NbbgKBYxNZZtpYdOpw
         dRrNkrsssnCrBZIoOG2IjHqFK9ShdBaxAqPuAs/MR4qENETpkt25X4laL6ZocxbSdzLF
         wNczvi14TORcJDNSUOI0eo6ZFdcYpGYwH1defeYRXVqdCbxZJI6kI7DRlV7H2HG/avZG
         rASQ==
X-Gm-Message-State: AOJu0YwD1hjFIW3QLcHjHCI3sOKXlkEiMBqJexP3yKRoql6jw9FYMUjx
        n+S11jBpH/Eb9MF9DZzMacNpSFlueIZ4Ekx7T8TPyxxU3r88NG/GtnNTNcOvb/+ycYO/LNyakYw
        skHepO2Srpn9GLPHUjw0g87hc0+04f/c=
X-Received: by 2002:a05:6a00:1797:b0:6b4:6b34:8cef with SMTP id s23-20020a056a00179700b006b46b348cefmr27971064pfg.34.1699298791471;
        Mon, 06 Nov 2023 11:26:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFkTpFxfcDo+DJ4iF8kHc463XZMDpUJNLKjSwczRFZ6FULYFHtF2R099VOnD2Y/88FKTWqHQQ==
X-Received: by 2002:a05:6a00:1797:b0:6b4:6b34:8cef with SMTP id s23-20020a056a00179700b006b46b348cefmr27971045pfg.34.1699298791118;
        Mon, 06 Nov 2023 11:26:31 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a0002c200b006c0685422e0sm5923116pft.214.2023.11.06.11.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 11:26:30 -0800 (PST)
Date:   Tue, 7 Nov 2023 03:26:27 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUiECgUWZ/8HKi3k@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUiECgUWZ/8HKi3k@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2023 at 05:13:30PM +1100, Dave Chinner wrote:
> On Sun, Oct 29, 2023 at 12:11:22PM +0800, Zorro Lang wrote:
> > Hi xfs list,
> > 
> > Recently I always hit xfs corruption by running fstests generic/047 [1], and
> > it show more failures in dmesg[2], e.g:
> 
> OK, g/047 is an fsync test.
> 
> > 
> >   XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
> 
> Ok, a directory block index translated to a hole in the file
> mapping. That's bad...
> 
> > [2]
> > [  376.468885] run fstests generic/047 at 2023-10-27 09:08:07
> >  [  376.675751] XFS (loop1): Mounting V5 Filesystem 716c9687-ee74-4c12-b6ad-a0b513194f2b
> >  [  376.677088] XFS (loop1): Ending clean mount
> >  [  376.678189] XFS (loop1): User initiated shutdown received.
> >  [  376.678194] XFS (loop1): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x5a/0xf8 [xfs] (fs/xfs/xfs_fsops.c:492).  Shutting down filesystem.
> >  [  376.678409] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
> >  [  376.679423] XFS (loop1): Unmounting Filesystem 716c9687-ee74-4c12-b6ad-a0b513194f2b
> >  [  376.714910] XFS (loop1): Mounting V5 Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
> >  [  376.716353] XFS (loop1): Ending clean mount
> 
> Files are created and fsync'd here.
> 
> >  [  380.375878] XFS (loop1): User initiated shutdown received.
> >  [  380.375888] XFS (loop1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xb4/0xf8 [xfs] (fs/xfs/xfs_fsops.c:495).  Shutting down filesystem.
> 
> Then the fs is shut down.
> 
> >  [  380.376101] XFS (loop1): Please unmount the filesystem and rectify the problem(s)
> >  [  380.380373] XFS (loop1): Unmounting Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
> >  [  380.383835] XFS (loop1): Mounting V5 Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
> >  [  380.397086] XFS (loop1): Starting recovery (logdev: internal)
> >  [  380.465934] XFS (loop1): Ending recovery (logdev: internal)
> 
> Then it is recovered....
> >  [  380.467409] XFS (loop1): Unmounting Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
> >  [  380.475431] XFS (loop1): Mounting V5 Filesystem 40196bb2-39f4-4c32-83ef-567f42216699
> >  [  380.477235] XFS (loop1): Ending clean mount
> >  [  380.477500] XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
> 
> .... and now the directory is bad.
> 
> >  [  380.477636] CPU: 0 PID: 337362 Comm: 047 Kdump: loaded Tainted: G        W          6.6.0-rc7+ #1
> >  [  380.477639] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
> >  [  380.477641] Call Trace:
> >  [  380.477642]  [<0000000032d71372>] dump_stack_lvl+0x62/0x80 
> >  [  380.477648]  [<000003ff7ff96c00>] xfs_corruption_error+0x70/0xa0 [xfs] 
> >  [  380.477762]  [<000003ff7ff551ce>] xfs_dabuf_map.constprop.0+0x2a6/0x368 [xfs] 
> >  [  380.477871]  [<000003ff7ff5773e>] xfs_da_read_buf+0x6e/0x128 [xfs] 
> >  [  380.477977]  [<000003ff7ff57838>] xfs_da3_node_read+0x40/0x78 [xfs] 
> >  [  380.478085]  [<000003ff7ff58c7a>] xfs_da3_node_lookup_int+0x82/0x558 [xfs] 
> >  [  380.478193]  [<000003ff7ff68d6e>] xfs_dir2_node_lookup+0x3e/0x140 [xfs] 
> 
> So it's supposed to be in node format, which means enough blocks to
> have an external free list. I guess a thousand dirents is enough to
> do that.
> 
> Yet fsync is run after every file is created and written, so the
> dirents and directory blocks should all be there....
> 
> .....
> 
> > _check_xfs_filesystem: filesystem on /dev/loop1 is inconsistent (r)
> > *** xfs_repair -n output ***
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> >         - found root inode chunk
> > Phase 3 - for each AG...
> >         - scan (but don't clear) agi unlinked lists...
> >         - process known inodes and perform inode discovery...
> >         - agno = 0
> > bad nblocks 9 for inode 128, would reset to 0
> > no . entry for directory 128
> > no .. entry for root directory 128
> > problem with directory contents in inode 128
> > would clear root inode 128
> > bad nblocks 8 for inode 131, would reset to 0
> > bad nblocks 8 for inode 132, would reset to 0
> > bad nblocks 8 for inode 133, would reset to 0
> > ...
> > bad nblocks 8 for inode 62438, would reset to 0
> > bad nblocks 8 for inode 62439, would reset to 0
> > bad nblocks 8 for inode 62440, would reset to 0
> > bad nblocks 8 for inode 62441, would reset to 0
> 
> Yet all the files - including the data files that were fsync'd - are
> all bad.
> 
> Aparently the journal has been recovered, but lots of metadata
> updates that should have been in the journal are missing after
> recovery has completed? That doesn't make a whole lot of sense -
> when did these tests start failing? Can you run a bisect?

Hi Dave,

Thanks for your reply :) I tried to do a kernel bisect long time, but
find nothing ... Then suddently, I found it's failed from a xfsprogs
change [1].

Although that's not the root cause of this bug (on s390x), it just
enabled "nrext64" by default, which I never tested on s390x before.
For now, we know this's an issue about this feature, and only on
s390x for now.

Thanks,
Zorro

[1]
commit e5b18d7d1d962e942ce3b0a9ccdb5872074e24df
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Mon Sep 25 14:59:25 2023 -0700

    mkfs: enable large extent counts by default

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

