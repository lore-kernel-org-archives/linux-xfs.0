Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF05DC4167B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Dec 2022 04:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiLSEMk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 23:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiLSEMi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 23:12:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB7762F2
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 20:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671423113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A0AB2ImfmpGTbJT2hjx7MPlfSDg/2sQoTphheKvNM0Y=;
        b=bhJ+agef5GcPgdTtq9Zp9nZzBfBASfBQz0VQMY6RFV0sbKSHRaSP9jC43LD6rvVjjVhSgY
        1Otano50xHwXZu831ZzbUQRs0fBefpQsLWc1ZSnhV7VMOjR1WbAhJC6QOZIqtq1EEZFWa5
        58RJK4014MK3Ixsd7X8Zcdlw1gE+WjU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-213-iqJ7iSrOOlyDKPOgyFHnPA-1; Sun, 18 Dec 2022 23:11:51 -0500
X-MC-Unique: iqJ7iSrOOlyDKPOgyFHnPA-1
Received: by mail-pg1-f200.google.com with SMTP id r22-20020a63ce56000000b00478f1cfb0fbso4819860pgi.0
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 20:11:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0AB2ImfmpGTbJT2hjx7MPlfSDg/2sQoTphheKvNM0Y=;
        b=MRYjHbOAgr3lFIJ5OvAi+J6J3xzNXRaa8NbfRgMwr8G5PEpFo/VrlvT53ef+AhzqsC
         kITqlltU8sKoIx+fCibOcReoMmJ+Ws0sjO5yvNmA3XCuTsPkliVcFmlDwFCUx9/UPY8p
         PmevvsBFssZWaXsQS4Kgqz3twwkqxnJnVtk8OOA1Z3QwY4HntAtYxe8QZxnyeKSNyPpM
         5m5DcNNueLvEqeNcDnQg8XFZuoUzG7XHjG1ngnK+N9WffLcUDwLM/Lei3iyQxtG6EjL4
         KBHvTTTnVTSowqo1+476qR8thP6fNPcKbsNSYS6cJQjP2y0YYfTWWYLfN7/fAFLYyEge
         Rayw==
X-Gm-Message-State: ANoB5pkQyg1KRaoRYD7e5XhIkcX9C/ZRKKyUhceq+OFoPZ89vFF0xcSN
        qG+MtM5movrofYHOzQExKx2VZOGsmVM/kav+jZJ13cnGnKNHi0Tch9iQnT5FqHWi9iHIDqw0YCX
        70cQhBT+DeaS1F9VWbK5k
X-Received: by 2002:a62:e119:0:b0:576:ebde:78fa with SMTP id q25-20020a62e119000000b00576ebde78famr38331764pfh.9.1671423110687;
        Sun, 18 Dec 2022 20:11:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf720nHMfb68bj8qiOJnzbnzU1AcmZyjuyDAjZEpoMMzhPYNyukYDVHp7TzjrKXGaXWE2ePS8A==
X-Received: by 2002:a62:e119:0:b0:576:ebde:78fa with SMTP id q25-20020a62e119000000b00576ebde78famr38331742pfh.9.1671423110283;
        Sun, 18 Dec 2022 20:11:50 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i62-20020a62c141000000b0057737e403d9sm5353225pfg.209.2022.12.18.20.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Dec 2022 20:11:49 -0800 (PST)
Date:   Mon, 19 Dec 2022 12:11:44 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Subject: Re: Why fstests g/673 and g/683~687 suddently fail (on xfs, ext4...)
 on latest linux v6.1+ ?
Message-ID: <20221219041144.fc4gj5bdw3dgobhp@zlang-mailbox>
References: <20221218103850.cbqdq3bmw7zl7iad@zlang-mailbox>
 <CAOQ4uxhmCgyorYVtD6=n=khqwUc=MPbZs+y=sqt09XbGoNm_tA@mail.gmail.com>
 <20221218130432.fgitgsn522shmpwi@zlang-mailbox>
 <Y59YkDch8b6v/KfD@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y59YkDch8b6v/KfD@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 18, 2022 at 10:14:40AM -0800, Darrick J. Wong wrote:
> On Sun, Dec 18, 2022 at 09:04:32PM +0800, Zorro Lang wrote:
> > On Sun, Dec 18, 2022 at 02:11:01PM +0200, Amir Goldstein wrote:
> > > On Sun, Dec 18, 2022 at 1:06 PM Zorro Lang <zlang@redhat.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > fstests generic/673 and generic/683~687 are a series of test cases to
> > > > verify suid and sgid bits are dropped properly. xfs-list writes these
> > > > cases to verify xfs behavior follows vfs, e.g. [1]. And these cases
> > > > test passed on xfs and ext4 for long time. Even on my last regression
> > > > test on linux v6.1-rc8+, they were passed too.
> > > >
> > > > But now the default behavior looks like be changed again, xfs and ext4
> > > > start to fail [2] on latest linux v6.1+ (HEAD [0]), So there must be
> > > > changed. I'd like to make sure what's changed, and if it's expected?
> > > 
> > > I think that is expected and I assume Christian was planning to fix the tests.
> > > 
> > > See Christian's pull request:
> > > https://lore.kernel.org/linux-fsdevel/20221212112053.99208-1-brauner@kernel.org/
> > > 
> > > "Note, that some xfstests will now fail as these patches will cause the setgid
> > > bit to be lost in certain conditions for unprivileged users modifying a setgid
> > > file when they would've been kept otherwise. I think this risk is worth taking
> > > and I explained and mentioned this multiple times on the list:
> > > https://lore.kernel.org/linux-fsdevel/20221122142010.zchf2jz2oymx55qi@wittgenstein"
> > 
> > Hi Amir,
> > 
> > Thanks for your reply. Yes, these test cases were failed on overlayfs, passed on
> > xfs, ext4 and btrfs. Now it's reversed, overlayfs passed on this test, xfs and
> > ext4 failed.
> 
> Odd, I'll have to look into why things work here ... maybe it's the
> selinux contexts?
> 
> > Anyway, if this's an expected behavior change, and it's reviewed and accepted by
> > linux upstream, I don't have objection. Just to make sure if there's a regression.
> > Feel free to send patch to fstests@ to update the expected results, and show
> > details about why change them again :)
> 
> Somewhat unrelated, but are you going to merge
> https://lore.kernel.org/fstests/20220816121551.88407-1-glass@fydeos.io/

Hi Darrick,

This change has been done by another patch:

commit 7c7a73c43be8e41a324eed01e3f5aa69860b0ddf
Author: Christian Brauner <brauner@kernel.org>
Date:   Tue Sep 20 10:35:22 2022 +0200

    idmapped-mounts: account for EOVERFLOW

Thanks,
Zorro

> 
> ?
> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > Thanks,
> > > Amir.
> > > 
> > > >
> > > > Thanks,
> > > > Zorro
> > > >
> > > > [0]
> > > > commit f9ff5644bcc04221bae56f922122f2b7f5d24d62
> > > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Date:   Sat Dec 17 08:55:19 2022 -0600
> > > >
> > > >     Merge tag 'hsi-for-6.2' of git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-h
> > > >
> > > > [1]
> > > > commit e014f37db1a2d109afa750042ac4d69cf3e3d88e
> > > > Author: Darrick J. Wong <djwong@kernel.org>
> > > > Date:   Tue Mar 8 10:51:16 2022 -0800
> > > >
> > > >     xfs: use setattr_copy to set vfs inode attributes
> > > >
> > > > [2]
> > > > FSTYP         -- xfs (debug)
> > > > PLATFORM      -- Linux/s390x ibm-z-510 6.1.0+ #1 SMP Sat Dec 17 13:23:59 EST 2022
> > > > MKFS_OPTIONS  -- -f -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1 -b size=1024 /dev/loop1
> > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR
> > > >
> > > > generic/673       - output mismatch (see /var/lib/xfstests/results//generic/673.out.bad)
> > > >     --- tests/generic/673.out   2022-12-17 13:57:40.336589178 -0500
> > > >     +++ /var/lib/xfstests/results//generic/673.out.bad  2022-12-18 00:00:53.627210256 -0500
> > > >     @@ -51,7 +51,7 @@
> > > >      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > >      2666 -rw-rwSrw- SCRATCH_MNT/a
> > > >      3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > >     -2666 -rw-rwSrw- SCRATCH_MNT/a
> > > >     +666 -rw-rw-rw- SCRATCH_MNT/a
> > > >
> > > >      Test 10 - qa_user, group-exec file, only sgid
> > > >     ...
> > > >     (Run 'diff -u /var/lib/xfstests/tests/generic/673.out /var/lib/xfstests/results//generic/673.out.bad'  to see the entire diff)
> > > > Ran: generic/673
> > > > Failures: generic/673
> > > > Failed 1 of 1 tests
> > > >
> > > > FSTYP         -- xfs (debug)
> > > > PLATFORM      -- Linux/s390x ibm-z-510 6.1.0+ #1 SMP Sat Dec 17 13:23:59 EST 2022
> > > > MKFS_OPTIONS  -- -f -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1 -b size=1024 /dev/loop1
> > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR
> > > >
> > > > generic/683       - output mismatch (see /var/lib/xfstests/results//generic/683.out.bad)
> > > >     --- tests/generic/683.out   2022-12-17 13:57:40.696589178 -0500
> > > >     +++ /var/lib/xfstests/results//generic/683.out.bad  2022-12-18 00:04:55.297220255 -0500
> > > >     @@ -33,7 +33,7 @@
> > > >
> > > >      Test 9 - qa_user, non-exec file falloc, only sgid
> > > >      2666 -rw-rwSrw- TEST_DIR/683/a
> > > >     -2666 -rw-rwSrw- TEST_DIR/683/a
> > > >     +666 -rw-rw-rw- TEST_DIR/683/a
> > > >
> > > >      Test 10 - qa_user, group-exec file falloc, only sgid
> > > >     ...
> > > >     (Run 'diff -u /var/lib/xfstests/tests/generic/683.out /var/lib/xfstests/results//generic/683.out.bad'  to see the entire diff)
> > > > Ran: generic/683
> > > > Failures: generic/683
> > > > Failed 1 of 1 tests
> > > >
> > > > FSTYP         -- xfs (debug)
> > > > PLATFORM      -- Linux/s390x ibm-z-510 6.1.0+ #1 SMP Sat Dec 17 13:23:59 EST 2022
> > > > MKFS_OPTIONS  -- -f -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1 -b size=1024 /dev/loop1
> > > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR
> > > >
> > > > generic/684       - output mismatch (see /var/lib/xfstests/results//generic/684.out.bad)
> > > >     --- tests/generic/684.out   2022-12-17 13:57:40.766589178 -0500
> > > >     +++ /var/lib/xfstests/results//generic/684.out.bad  2022-12-18 00:05:27.597220255 -0500
> > > >     @@ -33,7 +33,7 @@
> > > >
> > > >      Test 9 - qa_user, non-exec file fpunch, only sgid
> > > >      2666 -rw-rwSrw- TEST_DIR/684/a
> > > >     -2666 -rw-rwSrw- TEST_DIR/684/a
> > > >     +666 -rw-rw-rw- TEST_DIR/684/a
> > > >
> > > >      Test 10 - qa_user, group-exec file fpunch, only sgid
> > > >     ...
> > > >     (Run 'diff -u /var/lib/xfstests/tests/generic/684.out /var/lib/xfstests/results//generic/684.out.bad'  to see the entire diff)
> > > > Ran: generic/684
> > > > Failures: generic/684
> > > > Failed 1 of 1 tests
> > > > ....
> > > > ....
> > > >
> > > >
> > > > Thanks,
> > > > Zorro
> > > >
> > > 
> > 
> 

