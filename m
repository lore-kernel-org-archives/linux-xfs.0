Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A9FC4332F
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Dec 2022 13:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiLRNFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Dec 2022 08:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLRNF3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 08:05:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79D9B7E7
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 05:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671368681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=23p9C3s5IBOEFe7ZfWJa03TZhPZkxaps97i9IBLIT6c=;
        b=OT8U8uWSOkQNzGrzkumMp+rpzM/ixP89dQbDx9PFfrOVID4xKoffMDVI5iY3tTDJ9Otf5m
        n58a0Yp9UW+wfvhY7D7IBGcQElqwuTKj4uV0EitcRaTI4MymsyMwraHTxc1DVIhiRHSFXK
        bhR2dq98Zv7R5N12TxnELDICOIwE/L8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-Oz3ViTJ7Mm6KZs9Go87O_Q-1; Sun, 18 Dec 2022 08:04:40 -0500
X-MC-Unique: Oz3ViTJ7Mm6KZs9Go87O_Q-1
Received: by mail-pl1-f198.google.com with SMTP id i4-20020a17090332c400b0018f82951826so5136587plr.20
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 05:04:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=23p9C3s5IBOEFe7ZfWJa03TZhPZkxaps97i9IBLIT6c=;
        b=dAGlkKb05U5ooY0sKB1xCs1AA+ymluxdJC65fXAod0QyYOOk/5SAVfyI7Tc0kJDL8c
         fyg5fdieATkJPyYrtqzVPnUozu7ygRNIEo5PdmS8r6F4s3iJQYFWSuPXnxbO8n85OFnm
         gJgid7X7qXO24Mz0ThvGGcYu6QOZ5A7z9EVuJZQzYJwQ+KvOafkEu3AYLg3VAy+P649V
         y+uOiTeNqgYOE31b9VEJouYuTVUPo/HOam1SmKtMjV33cHPu24XwPG78Jxd1JZb6ItYq
         Mp6tpjS6A3oR9UzDJPVqocF/I7n2bzneZAD/iQ9ERvDRVfIQPP7vvWOx4ONhqT3Y6vfU
         mHMw==
X-Gm-Message-State: AFqh2ko0yEJEnq18Q+eHyp7IA2MXxUDx8AJCu7biEDMBubAHYUnVa+KL
        I+VPnUFjiTn2XiHgBRAceI4qLGsYoYG9w74sq3cFAxymyBK/IpfONGw6XEf9GjjFlPlLGEyLSfG
        5ozY9gPrjDPMmMRPPWh/v
X-Received: by 2002:a17:902:f607:b0:186:8d78:740c with SMTP id n7-20020a170902f60700b001868d78740cmr7292845plg.6.1671368679115;
        Sun, 18 Dec 2022 05:04:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsekAvHg2Wc7kbORIhmByY9jMGcFJmmXncBX1qPuPM+pXY/CI9A2l/lnwWbLSyiBIThvzSkiQ==
X-Received: by 2002:a17:902:f607:b0:186:8d78:740c with SMTP id n7-20020a170902f60700b001868d78740cmr7292811plg.6.1671368678674;
        Sun, 18 Dec 2022 05:04:38 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d9-20020a170903230900b00176dc67df44sm5026019plh.132.2022.12.18.05.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Dec 2022 05:04:37 -0800 (PST)
Date:   Sun, 18 Dec 2022 21:04:32 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
Subject: Re: Why fstests g/673 and g/683~687 suddently fail (on xfs, ext4...)
 on latest linux v6.1+ ?
Message-ID: <20221218130432.fgitgsn522shmpwi@zlang-mailbox>
References: <20221218103850.cbqdq3bmw7zl7iad@zlang-mailbox>
 <CAOQ4uxhmCgyorYVtD6=n=khqwUc=MPbZs+y=sqt09XbGoNm_tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhmCgyorYVtD6=n=khqwUc=MPbZs+y=sqt09XbGoNm_tA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Dec 18, 2022 at 02:11:01PM +0200, Amir Goldstein wrote:
> On Sun, Dec 18, 2022 at 1:06 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > Hi,
> >
> > fstests generic/673 and generic/683~687 are a series of test cases to
> > verify suid and sgid bits are dropped properly. xfs-list writes these
> > cases to verify xfs behavior follows vfs, e.g. [1]. And these cases
> > test passed on xfs and ext4 for long time. Even on my last regression
> > test on linux v6.1-rc8+, they were passed too.
> >
> > But now the default behavior looks like be changed again, xfs and ext4
> > start to fail [2] on latest linux v6.1+ (HEAD [0]), So there must be
> > changed. I'd like to make sure what's changed, and if it's expected?
> 
> I think that is expected and I assume Christian was planning to fix the tests.
> 
> See Christian's pull request:
> https://lore.kernel.org/linux-fsdevel/20221212112053.99208-1-brauner@kernel.org/
> 
> "Note, that some xfstests will now fail as these patches will cause the setgid
> bit to be lost in certain conditions for unprivileged users modifying a setgid
> file when they would've been kept otherwise. I think this risk is worth taking
> and I explained and mentioned this multiple times on the list:
> https://lore.kernel.org/linux-fsdevel/20221122142010.zchf2jz2oymx55qi@wittgenstein"

Hi Amir,

Thanks for your reply. Yes, these test cases were failed on overlayfs, passed on
xfs, ext4 and btrfs. Now it's reversed, overlayfs passed on this test, xfs and
ext4 failed.

Anyway, if this's an expected behavior change, and it's reviewed and accepted by
linux upstream, I don't have objection. Just to make sure if there's a regression.
Feel free to send patch to fstests@ to update the expected results, and show
details about why change them again :)

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 
> >
> > Thanks,
> > Zorro
> >
> > [0]
> > commit f9ff5644bcc04221bae56f922122f2b7f5d24d62
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Sat Dec 17 08:55:19 2022 -0600
> >
> >     Merge tag 'hsi-for-6.2' of git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-h
> >
> > [1]
> > commit e014f37db1a2d109afa750042ac4d69cf3e3d88e
> > Author: Darrick J. Wong <djwong@kernel.org>
> > Date:   Tue Mar 8 10:51:16 2022 -0800
> >
> >     xfs: use setattr_copy to set vfs inode attributes
> >
> > [2]
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/s390x ibm-z-510 6.1.0+ #1 SMP Sat Dec 17 13:23:59 EST 2022
> > MKFS_OPTIONS  -- -f -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1 -b size=1024 /dev/loop1
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR
> >
> > generic/673       - output mismatch (see /var/lib/xfstests/results//generic/673.out.bad)
> >     --- tests/generic/673.out   2022-12-17 13:57:40.336589178 -0500
> >     +++ /var/lib/xfstests/results//generic/673.out.bad  2022-12-18 00:00:53.627210256 -0500
> >     @@ -51,7 +51,7 @@
> >      310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> >      2666 -rw-rwSrw- SCRATCH_MNT/a
> >      3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> >     -2666 -rw-rwSrw- SCRATCH_MNT/a
> >     +666 -rw-rw-rw- SCRATCH_MNT/a
> >
> >      Test 10 - qa_user, group-exec file, only sgid
> >     ...
> >     (Run 'diff -u /var/lib/xfstests/tests/generic/673.out /var/lib/xfstests/results//generic/673.out.bad'  to see the entire diff)
> > Ran: generic/673
> > Failures: generic/673
> > Failed 1 of 1 tests
> >
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/s390x ibm-z-510 6.1.0+ #1 SMP Sat Dec 17 13:23:59 EST 2022
> > MKFS_OPTIONS  -- -f -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1 -b size=1024 /dev/loop1
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR
> >
> > generic/683       - output mismatch (see /var/lib/xfstests/results//generic/683.out.bad)
> >     --- tests/generic/683.out   2022-12-17 13:57:40.696589178 -0500
> >     +++ /var/lib/xfstests/results//generic/683.out.bad  2022-12-18 00:04:55.297220255 -0500
> >     @@ -33,7 +33,7 @@
> >
> >      Test 9 - qa_user, non-exec file falloc, only sgid
> >      2666 -rw-rwSrw- TEST_DIR/683/a
> >     -2666 -rw-rwSrw- TEST_DIR/683/a
> >     +666 -rw-rw-rw- TEST_DIR/683/a
> >
> >      Test 10 - qa_user, group-exec file falloc, only sgid
> >     ...
> >     (Run 'diff -u /var/lib/xfstests/tests/generic/683.out /var/lib/xfstests/results//generic/683.out.bad'  to see the entire diff)
> > Ran: generic/683
> > Failures: generic/683
> > Failed 1 of 1 tests
> >
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/s390x ibm-z-510 6.1.0+ #1 SMP Sat Dec 17 13:23:59 EST 2022
> > MKFS_OPTIONS  -- -f -m crc=1,finobt=1,reflink=1,rmapbt=0,bigtime=1,inobtcount=1 -b size=1024 /dev/loop1
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 /mnt/fstests/SCRATCH_DIR
> >
> > generic/684       - output mismatch (see /var/lib/xfstests/results//generic/684.out.bad)
> >     --- tests/generic/684.out   2022-12-17 13:57:40.766589178 -0500
> >     +++ /var/lib/xfstests/results//generic/684.out.bad  2022-12-18 00:05:27.597220255 -0500
> >     @@ -33,7 +33,7 @@
> >
> >      Test 9 - qa_user, non-exec file fpunch, only sgid
> >      2666 -rw-rwSrw- TEST_DIR/684/a
> >     -2666 -rw-rwSrw- TEST_DIR/684/a
> >     +666 -rw-rw-rw- TEST_DIR/684/a
> >
> >      Test 10 - qa_user, group-exec file fpunch, only sgid
> >     ...
> >     (Run 'diff -u /var/lib/xfstests/tests/generic/684.out /var/lib/xfstests/results//generic/684.out.bad'  to see the entire diff)
> > Ran: generic/684
> > Failures: generic/684
> > Failed 1 of 1 tests
> > ....
> > ....
> >
> >
> > Thanks,
> > Zorro
> >
> 

