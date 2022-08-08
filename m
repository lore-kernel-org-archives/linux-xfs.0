Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5087C25B0C
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Aug 2022 15:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiHHPOM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Aug 2022 11:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243008AbiHHPOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Aug 2022 11:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9408DEC5
        for <linux-xfs@vger.kernel.org>; Mon,  8 Aug 2022 08:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659971649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CWS5lr0dtSTOC1UPZzz4U7wmq6O5TUNS8THJlD5Vdho=;
        b=AQJLgfH8LtfxsRZvKdJB9GhCfx2rbo8JGhn9x5xbFjXIQcTK/VWSM9UuaGM4OJ+rEQV0jo
        RJfOufo5TfrncE5pOF3mItWtsDPUhRr7plBQuXErRpxrOpvJl4jrbHhqRskPTDjT57pUOF
        E1Cx4prq1Y40rKnyYAiuTNmRMQrk26A=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-bjEf-8hdMbubCC4pExx1Vg-1; Mon, 08 Aug 2022 11:14:08 -0400
X-MC-Unique: bjEf-8hdMbubCC4pExx1Vg-1
Received: by mail-qk1-f200.google.com with SMTP id x22-20020a05620a259600b006b552a69231so8059144qko.18
        for <linux-xfs@vger.kernel.org>; Mon, 08 Aug 2022 08:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CWS5lr0dtSTOC1UPZzz4U7wmq6O5TUNS8THJlD5Vdho=;
        b=oFjiuTgV/2AWuqLeKmk2UGCTf3gyGufa+XWLOtNS+3m9SbZSj7l7H7IA/pCZZXnf11
         9XqSE1zJ5gIT1+MWrMLkIGUBL8GbTKxoec6zv2kTQv32Gt0b2K/wuXYg6eDDPqMfmPzP
         sGBzbozcrfVnE++HNsi6TBKJ1PsGCP9hy9U+7ESCTdN73zeWeZnjxuPSG3UdWL2lpdhM
         oelkjRwiJiV78CV6o5pxiFdd6R8hfIbw0n8QelXDqVdiKnEHRUycGwHQsrSSlRnbTjne
         gLSu7g/oRqJebtDoBbrVlPhgg+i2pn+emOSZiPW5vJ2dz2KkJ/DFA+H6pKkNSPLUvods
         WIXg==
X-Gm-Message-State: ACgBeo2BtiRlhGSPgm+bLTqjw5aZc8L7lrMMQ/5Wf5FBmX2tokOzELbr
        hyrvTKS198J+q9XuyKIRCIRHfQES/XIlOPkAO4S88Y1lLQ/IyiiLVME4ZxltVR0lt3kJZA4vLM/
        3bo3NItryxz50NsD8NPUG
X-Received: by 2002:a05:620a:414c:b0:6b5:cd90:6d27 with SMTP id k12-20020a05620a414c00b006b5cd906d27mr14552873qko.238.1659971647472;
        Mon, 08 Aug 2022 08:14:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR55mhsnYcUTBIV3q5mFdNhg2SA0THgd0xWf4Km0TyqR3lKgKIl7qgFlTWnvs97tWrMZHSaVRg==
X-Received: by 2002:a05:620a:414c:b0:6b5:cd90:6d27 with SMTP id k12-20020a05620a414c00b006b5cd906d27mr14552837qko.238.1659971647139;
        Mon, 08 Aug 2022 08:14:07 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s13-20020a05622a178d00b0031eeefd896esm8478355qtk.3.2022.08.08.08.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 08:14:06 -0700 (PDT)
Date:   Mon, 8 Aug 2022 23:13:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCHSET 0/3] fstests: refactor ext4-specific code
Message-ID: <20220808151359.4e3ydlznmdx4vmgn@zlang-mailbox>
References: <165950050051.198922.13423077997881086438.stgit@magnolia>
 <20220806143606.kd7ikbdjntugcpp4@zlang-mailbox>
 <Yu/opJBYTkgbiIPJ@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yu/opJBYTkgbiIPJ@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 07, 2022 at 09:30:28AM -0700, Darrick J. Wong wrote:
> On Sat, Aug 06, 2022 at 10:36:06PM +0800, Zorro Lang wrote:
> > On Tue, Aug 02, 2022 at 09:21:40PM -0700, Darrick J. Wong wrote:
> > > Hi all,
> > > 
> > > This series aims to make it so that fstests can install device mapper
> > > filters for external log devices.  Before we can do that, however, we
> > > need to change fstests to pass the device path of the jbd2 device to
> > > mount and mkfs.  Before we can do /that/, refactor all the ext4-specific
> > > code out of common/rc into a separate common/ext4 file.
> > > 
> > > If you're going to start using this mess, you probably ought to just
> > > pull from my git trees, which are linked below.
> > > 
> > > This is an extraordinary way to destroy everything.  Enjoy!
> > > Comments and questions are, as always, welcome.
> > > 
> > > --D
> > > 
> > > fstests git tree:
> > > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=refactor-ext4-helpers
> > > ---
> > 
> > Hi Darrick,
> > 
> > There're 3 failures[1] if test ext4 with external logdev, after merging this
> > patchset.
> > The g/629 is always failed with or without this patchset, it fails if test
> > with external logdev.
> > The g/250 and g/252 fail due to _scratch_mkfs_sized doesn't use common ext4
> > mkfs helper, so can't deal with SCRATCH_LOGDEV well.
> 
> Totally different helper, but yes, I'll add that to my list if nothing
> else than to get this patchset moving.

Yes, just due to you try to help common/dmerror to support external logdev,
and these two eio test cases use _scratch_mkfs_sized, it's not compatible
with your new change on dmerror, but it's not regression :)

I think we can fix visible errors at first, then improve ext4 external logdev
supporting bit by bit.

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > [1]
> > SECTION       -- logdev
> > FSTYP         -- ext4
> > PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 5.19.0-0.rc2.21.fc37.x86_64+debug #1 SMP PREEMPT_DYNAMIC Mon Jun 13 14:55:18 UTC 2022
> > MKFS_OPTIONS  -- -F -J device=/dev/loop0 /dev/sda3
> > MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 -o journal_path=/dev/loop0 /dev/sda3 /mnt/scratch
> > 
> > generic/250 2s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/250.out.bad)
> >     --- tests/generic/250.out   2022-04-29 23:07:23.262498285 +0800
> >     +++ /root/git/xfstests/results//logdev/generic/250.out.bad  2022-08-06 22:26:45.179294149 +0800
> >     @@ -1,9 +1,19 @@
> >      QA output created by 250
> >      Format and mount
> >     +umount: /mnt/scratch: not mounted.
> >     +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
> >     +       dmesg(1) may have more information after failed mount system call.
> >      Create the original files
> >     +umount: /mnt/scratch: not mounted.
> >     ...
> >     (Run 'diff -u /root/git/xfstests/tests/generic/250.out /root/git/xfstests/results//logdev/generic/250.out.bad'  to see the entire diff)
> > generic/252 2s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/252.out.bad)
> >     --- tests/generic/252.out   2022-04-29 23:07:23.264498308 +0800
> >     +++ /root/git/xfstests/results//logdev/generic/252.out.bad  2022-08-06 22:26:48.495330525 +0800
> >     @@ -1,10 +1,19 @@
> >      QA output created by 252
> >      Format and mount
> >     +umount: /mnt/scratch: not mounted.
> >     +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
> >     +       dmesg(1) may have more information after failed mount system call.
> >      Create the original files
> >     +umount: /mnt/scratch: not mounted.
> >     ...
> >     (Run 'diff -u /root/git/xfstests/tests/generic/252.out /root/git/xfstests/results//logdev/generic/252.out.bad'  to see the entire diff)
> > generic/629 3s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/629.out.bad)
> >     --- tests/generic/629.out   2022-04-29 23:07:23.545501491 +0800
> >     +++ /root/git/xfstests/results//logdev/generic/629.out.bad  2022-08-06 22:26:50.810355920 +0800
> >     @@ -1,4 +1,5 @@
> >      QA output created by 629
> >     +mke2fs 1.46.5 (30-Dec-2021)
> >      test o_sync write
> >      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/0
> >      test unaligned copy range o_sync
> >     ...
> >     (Run 'diff -u /root/git/xfstests/tests/generic/629.out /root/git/xfstests/results//logdev/generic/629.out.bad'  to see the entire diff)
> > Ran: generic/250 generic/252 generic/629
> > Failures: generic/250 generic/252 generic/629
> > Failed 3 of 3 tests
> > 
> > 
> > >  common/config |    4 +
> > >  common/ext4   |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  common/rc     |  177 ++-------------------------------------------------------
> > >  common/xfs    |   23 +++++++
> > >  4 files changed, 208 insertions(+), 172 deletions(-)
> > >  create mode 100644 common/ext4
> > > 
> > 
> 

