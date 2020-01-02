Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97446C2D0DC
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 16:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 527BF21D7D
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 16:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLuhPJYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgABQIQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:08:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50148 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728744AbgABQIQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 11:08:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577981293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+R302pVk+go2BaELUjPg4idOT/nymm+s8iXF6IuDHe0=;
        b=ZLuhPJYtl8u0FaxNKRmKceJRFwC4jeNcn+dMdU9SPnCPPP5z68LX6NBmywsPcE0OyDScNy
        +5KQkoVs7juEQnuuUvo4xehK2kox0Xwri7CL3U09PisxJG+qAM89topu/KAjDYygQqh5V2
        f6cBXVtwluIRyKzatA/m0mzC/sx+lRQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-RW8RypWuNHOuDodgon4KIg-1; Thu, 02 Jan 2020 11:08:12 -0500
X-MC-Unique: RW8RypWuNHOuDodgon4KIg-1
Received: by mail-wr1-f72.google.com with SMTP id b13so4174334wrx.22
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jan 2020 08:08:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=+R302pVk+go2BaELUjPg4idOT/nymm+s8iXF6IuDHe0=;
        b=IdCqEI122ItvA7pUr1k7lOA5R1vf1noDjlgO91OUn46eZrmktX6ucZ5KWi4V+YbeUK
         XwTzkMOVZZHlpiWo3WAGa9X6Ees7Jkl1uW/DV1tHQ1Ot2ZQEcw/Nn9gi2zkJwi0KhmHe
         ZILwFwrwvnMlgqBCClCE8y1fjVAPFFuF7UngNQKLnVsNLhh2RElxiPThV50xMlqPIRUf
         vn+Y1Hy6bIWOBJy4H7BRprcVTmRgGx3rFSJXtI6BO5RKtuFGmSPGCXiFpOGDgUwjdeuF
         9+775nXSjpPIKFilsiimyuOHXVpNvkeeZ3CoTAO25f3MxAjkBQc1cyeZ33nB8tRrMv8o
         sSUA==
X-Gm-Message-State: APjAAAW03h+Q/XtJcB6ORuKBTjPspZsSI3u7zs8NR0lO9gu77wLzOdj3
        hH95lfvQ9EK+TyDPAmm9xfYKDzOw3ATDOmfLHQsDq+06deQv2QdjKZZE6xFIB6lZtAPEyzingBd
        c0DkmhaPfu2ALWP8GoeGU
X-Received: by 2002:a5d:4044:: with SMTP id w4mr48839573wrp.322.1577981291212;
        Thu, 02 Jan 2020 08:08:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqzk9kF3l2VUbLYjQz0SAk0TY5I4zrngX/NMluxM7IfJs8WOa/ZDAhix09UjrKbm3dZbm6ZpuA==
X-Received: by 2002:a5d:4044:: with SMTP id w4mr48839539wrp.322.1577981290698;
        Thu, 02 Jan 2020 08:08:10 -0800 (PST)
Received: from orion.redhat.com (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id s10sm57274339wrw.12.2020.01.02.08.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 08:08:09 -0800 (PST)
Date:   Thu, 2 Jan 2020 17:08:07 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Daniel Storey <daniel.storey@rededucation.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: xfs_repair: superblock read failed, fatal error -- Input/output
 error
Message-ID: <20200102160807.dsoozldhtq7glw6z@orion.redhat.com>
Mail-Followup-To: Daniel Storey <daniel.storey@rededucation.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <FF3D9678-1449-467B-AA27-DA8C4B6A6DA2@rededucation.com>
 <379BEB4C-D422-4EE8-8C1C-CDF8AA3016E0@rededucation.com>
 <6C0FFC4B-AE04-4C97-87FF-BD86E610F549@rededucation.com>
 <0D8F4E6F-CA2E-4032-BFD5-E87F651E2585@rededucation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0D8F4E6F-CA2E-4032-BFD5-E87F651E2585@rededucation.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

> I’ve not got a lot of experience with XFS, so please be gentle.
>  
> I’ve got 2 external HDD’s mounted through ESXi to a machine called USB-3 which each have vdo running on them and then a Logical Volume called vdovg-vdolvm on it.

I believe you're talking about VMWare ESXi and you are mounting these external
HDDs into a virtual machine.


>  
> It’s currently unable to be mounted.  It gives the error:
>  
> [daniel.storey@usb-3 ~]$ sudo mount /data
> mount: mount /dev/mapper/vdovg-vdolvm on /data failed: Structure needs cleaning
> And then when I try to run xfs_repair it throws the following error:

Ok, so, sounds like your FS is corrupted?!

>  
> [daniel.storey@usb-3 ~]$ sudo xfs_repair /dev/dm-4
> Phase 1 - find and verify superblock...
> superblock read failed, offset 6597069742080, size 131072, ag 6, rval -1
>  
> fatal error -- Input/output error

You are having I/O errors on your device. Have you ever tried to mount this
device on a machine other than VMWare hosted machine? Bare-metal specially.

Also, why are you pointing /dev/dm-4 directly, instead of using the VDO link you
mentioned above?

>  
> However, I’m able to view the file system with ufs explorer, so I think it’s still there.
>  

Also on a vmware machine? On the same hypervisor? For sure not on the same host,
since UFS explorer (AFAIK) does not have a Linux version.

And btw, UFS Explorer is built so that you can scan/recover data on very damaged
filesystems and disks, while filesystems won't let you mount a corrupted
filesystem to avoid doing even more damage. So, yeah, you might still see
filesystem data/metadata using UFS explorer with damaged filesystems or block
devices.


Now, looking at the dmesg output you sent:

> [52244.526969] kvdo1:logQ0: Completing read VIO for LBN 1610612991 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [52244.526978] kvdo1:cpuQ0: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [52244.527440] kvdo1:logQ0: Completing read VIO for LBN 1610612990 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [52244.527447] kvdo1:cpuQ0: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [52244.527851] kvdo1:logQ0: Completing read VIO for LBN 1610612987 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [52244.527856] kvdo1:cpuQ0: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [52316.831349] kvdo1:logQ0: Completing read VIO for LBN 1610612991 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [52316.831364] kvdo1:cpuQ1: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [52316.832085] kvdo1:logQ0: Completing read VIO for LBN 1610612990 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [52316.832092] kvdo1:cpuQ1: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [52316.832802] kvdo1:logQ0: Completing read VIO for LBN 1610612987 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [52316.832809] kvdo1:cpuQ1: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [52819.634153] kvdo1:logQ0: Completing read VIO for LBN 1610612987 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [52819.634177] kvdo1:cpuQ1: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [52819.637152] kvdo1:logQ0: Completing read VIO for LBN 1610612987 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [52819.637173] kvdo1:cpuQ1: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO


Even VDO driver is having problems to issue IO to your device. So either your
device is reaching End-Of-Life, or VMWare has something to do there which is
causing IO Errors.

So, again, I'd try to open these devices on a bare-metal machine and check the
device for errors. If the errors are still present, replace the devices.


Cheers.

> [52819.637179] Buffer I/O error on dev dm-4, logical block 1610612731, async page read
> [54235.537518] XFS (dm-4): Mounting V5 Filesystem
> [54236.686544] XFS (dm-4): Starting recovery (logdev: internal)
> [54236.966501] XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x30064db50
> [54236.968126] XFS (dm-4): Unmount and run xfs_repair
> [54236.968683] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [54236.969267] ffffb9ad71884000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [54236.969836] ffffb9ad71884010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [54236.970422] ffffb9ad71884020: 5d e1 4f 12 1b a2 b7 8a 5d e1 4f 11 37 5a 0d c5  ].O.....].O.7Z..
> [54236.971012] ffffb9ad71884030: 5d e1 4f 11 37 5a 0d c5 00 00 00 00 01 50 50 00  ].O.7Z.......PP.
> [54236.971582] XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x30064db50
> [54236.972721] XFS (dm-4): Unmount and run xfs_repair
> [54236.973297] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [54236.973843] ffffb9ad71884000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [54236.974433] ffffb9ad71884010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [54236.975009] ffffb9ad71884020: 5d e1 4f 12 1b a2 b7 8a 5d e1 4f 11 37 5a 0d c5  ].O.....].O.7Z..
> [54236.975564] ffffb9ad71884030: 5d e1 4f 11 37 5a 0d c5 00 00 00 00 01 50 50 00  ].O.7Z.......PP.
> [54236.976161] XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x30064db50
> [54236.977296] XFS (dm-4): Unmount and run xfs_repair
> [54236.977837] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [54236.978414] ffffb9ad71884000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [54236.978993] ffffb9ad71884010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [54236.979547] ffffb9ad71884020: 5d e1 4f 12 1b a2 b7 8a 5d e1 4f 11 37 5a 0d c5  ].O.....].O.7Z..
> [54236.980129] ffffb9ad71884030: 5d e1 4f 11 37 5a 0d c5 00 00 00 00 01 50 50 00  ].O.7Z.......PP.
> [54236.980701] XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x30064db50
> [54236.981835] XFS (dm-4): Unmount and run xfs_repair
> [54236.982407] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [54236.982952] ffffb9ad71884000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [54236.983544] ffffb9ad71884010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [54236.984119] ffffb9ad71884020: 5d e1 4f 12 1b a2 b7 8a 5d e1 4f 11 37 5a 0d c5  ].O.....].O.7Z..
> [54236.984671] ffffb9ad71884030: 5d e1 4f 11 37 5a 0d c5 00 00 00 00 01 50 50 00  ].O.7Z.......PP.
> [54236.985268] XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x30064db50
> [54236.986400] XFS (dm-4): Unmount and run xfs_repair
> [54236.986943] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [54236.987517] ffffb9ad71884000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [54236.988094] ffffb9ad71884010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [54236.988620] ffffb9ad71884020: 5d e1 4f 12 1b a2 b7 8a 5d e1 4f 11 37 5a 0d c5  ].O.....].O.7Z..
> [54236.989178] ffffb9ad71884030: 5d e1 4f 11 37 5a 0d c5 00 00 00 00 01 50 50 00  ].O.7Z.......PP.
> [54236.989719] XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x30064db50
> [54236.990808] XFS (dm-4): Unmount and run xfs_repair
> [54236.991373] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [54236.991911] ffffb9ad71884000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [54236.992483] ffffb9ad71884010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [54236.993041] ffffb9ad71884020: 5d e1 4f 12 1b a2 b7 8a 5d e1 4f 11 37 5a 0d c5  ].O.....].O.7Z..
> [54236.993568] ffffb9ad71884030: 5d e1 4f 11 37 5a 0d c5 00 00 00 00 01 50 50 00  ].O.7Z.......PP.
> [54236.994139] XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x30064db50
> [54236.995228] XFS (dm-4): Unmount and run xfs_repair
> [54236.995761] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [54236.996329] ffffb9ad71884000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [54236.996870] ffffb9ad71884010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [54236.997428] ffffb9ad71884020: 5d e1 4f 12 1b a2 b7 8a 5d e1 4f 11 37 5a 0d c5  ].O.....].O.7Z..
> [54236.997954] ffffb9ad71884030: 5d e1 4f 11 37 5a 0d c5 00 00 00 00 01 50 50 00  ].O.7Z.......PP.
> [54236.998529] XFS (dm-4): Metadata corruption detected at xfs_inode_buf_verify+0x79/0x100 [xfs], xfs_inode block 0x30064db50
> [54236.999621] XFS (dm-4): Unmount and run xfs_repair
> [54237.000183] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [54237.000727] ffffb9ad71884000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> [54237.001469] ffffb9ad71884010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [54237.002026] ffffb9ad71884020: 5d e1 4f 12 1b a2 b7 8a 5d e1 4f 11 37 5a 0d c5  ].O.....].O.7Z..
> [54237.002553] ffffb9ad71884030: 5d e1 4f 11 37 5a 0d c5 00 00 00 00 01 50 50 00  ].O.7Z.......PP.
> [54237.003195] XFS (dm-4): metadata I/O error: block 0x30064db50 ("xlog_recover_do..(read#2)") error 117 numblks 32
> [54237.004631] XFS (dm-4): log mount/recovery failed: error -117
> [54237.004945] XFS (dm-4): log mount failed
> [54289.229381] kvdo1:logQ0: Completing read VIO for LBN 1610612991 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [54289.229422] kvdo1:cpuQ0: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [54289.230502] kvdo1:logQ0: Completing read VIO for LBN 1610612990 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [54289.230527] kvdo1:cpuQ0: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO
> [54289.231126] kvdo1:logQ0: Completing read VIO for LBN 1610612987 with error after readData: kvdo: Compressed block fragment is invalid (2073)
> [54289.231147] kvdo1:cpuQ0: mapToSystemError: mapping internal status code 2073 (kvdo: VDO_INVALID_FRAGMENT: kvdo: Compressed block fragment is invalid) to EIO


-- 
Carlos

