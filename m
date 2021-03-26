Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D9BC433C1
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 03:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22FBB61A27
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 03:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhCZDbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 23:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhCZDbZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 23:31:25 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A635C06174A;
        Thu, 25 Mar 2021 20:31:25 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q5so3946210pfh.10;
        Thu, 25 Mar 2021 20:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=uIkzGtlKyWdgPWPMx2vm8GZnXoZ761TXVD5hULRHSfs=;
        b=ThHKhVqzYPdPNwKznVdBTtp0U+r+D5JFcAtx8cWTueHKps0SfbdVRbLriMVZLVanRO
         SrXRhxNFw2IjJNrrB0mxXChoXqHfcrKOLJ7/w0dRSXY17Nqhak+C7SRWpGLAs3Zhzwzk
         JRpjGHRDk0LzoHZiVRM+JYC2q5bE4gZA7A79X2/wpmNekMbNCNw68LsQuERxhMoW/15N
         5LaLjhI31j+Vzcc0Glf1LwXHujjl9oKOY9BvKVYNcBBV7RB11TJCk/s1Y1RCx2+qvyA7
         9a+W1wLEE+FQqzAMNcw0pU9mLEN63SKx+3VkRMrtCoTDvF2W1rlW2ZgvI4oULChbmgMm
         xXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=uIkzGtlKyWdgPWPMx2vm8GZnXoZ761TXVD5hULRHSfs=;
        b=jyiPb+IZlfoDwPDJtMEQHLE3r/PEmCrl3O/y6r562mPR/Dn3fcJZzdR9oA9KZ8GCVJ
         nLNySBh38eq3MAheDlZKcBM3FasPaFKTUlRYJbJe9Gp3a1FVaCMd3EXllHEjHfAd1+GH
         fWamgRgQLB5nwqxFgAfCGqwpcXywTQiXw9E3nbIo1MAEXO6dkRiVZiYMaho9aB+CXPyk
         oInC73Hlz4FYO8PevUiPdfDyJrLFEM/sqwSW6iBumRuawPdrHQFrhSYdZkeWH7lzho1B
         /hzBV3Sfgf2uaB1jScz/upR2287vXsnPG0KNh+CkTg+5DyConwysbHRwdjdHn38hLR0A
         Aesg==
X-Gm-Message-State: AOAM531MuoL7YxNKdgBXGiggOteStycV9b+pa88ghien113wPewLEGQ5
        amN8OU9eBa2jXPd09zo9tp4=
X-Google-Smtp-Source: ABdhPJxigKOpegcjcPZFCdGV3fRPuaVBooXuK1sJ7jDsTeFNPMzhBRmI3MZpBROIMiNqhUxXlOQZiA==
X-Received: by 2002:a63:ce48:: with SMTP id r8mr10268148pgi.62.1616729484478;
        Thu, 25 Mar 2021 20:31:24 -0700 (PDT)
Received: from garuda ([122.179.126.69])
        by smtp.gmail.com with ESMTPSA id fh19sm6583411pjb.33.2021.03.25.20.31.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Mar 2021 20:31:24 -0700 (PDT)
References: <161647321880.3430916.13415014495565709258.stgit@magnolia> <161647322430.3430916.12437291741320143904.stgit@magnolia> <87mturo9wl.fsf@garuda> <20210325163321.GG4090233@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs: test the xfs_db path command
In-reply-to: <20210325163321.GG4090233@magnolia>
Date:   Fri, 26 Mar 2021 09:01:20 +0530
Message-ID: <875z1er3p3.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Mar 2021 at 22:03, Darrick J. Wong wrote:
> On Thu, Mar 25, 2021 at 03:03:14PM +0530, Chandan Babu R wrote:
>> On 23 Mar 2021 at 09:50, Darrick J. Wong wrote:
>> > From: Darrick J. Wong <djwong@kernel.org>
>> >
>> > Add a new test to make sure the xfs_db path command works the way the
>> > author thinks it should.
>> >
>> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> > ---
>> >  tests/xfs/917     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  tests/xfs/917.out |   19 ++++++++++
>> >  tests/xfs/group   |    1 +
>> >  3 files changed, 118 insertions(+)
>> >  create mode 100755 tests/xfs/917
>> >  create mode 100644 tests/xfs/917.out
>> >
>> >
>> > diff --git a/tests/xfs/917 b/tests/xfs/917
>> > new file mode 100755
>> > index 00000000..bf21b290
>> > --- /dev/null
>> > +++ b/tests/xfs/917
>> > @@ -0,0 +1,98 @@
>> > +#! /bin/bash
>> > +# SPDX-License-Identifier: GPL-2.0-or-later
>> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
>> > +#
>> > +# FS QA Test No. 917
>> > +#
>> > +# Make sure the xfs_db path command works the way the author thinks it does.
>> > +# This means that it can navigate to random inodes, fails on paths that don't
>> > +# resolve.
>> > +#
>> > +seq=`basename $0`
>> > +seqres=$RESULT_DIR/$seq
>> > +echo "QA output created by $seq"
>> > +
>> > +here=`pwd`
>> > +tmp=/tmp/$$
>> > +status=1    # failure is the default!
>> > +trap "_cleanup; exit \$status" 0 1 2 3 15
>> > +
>> > +_cleanup()
>> > +{
>> > +	cd /
>> > +	rm -f $tmp.*
>> > +}
>> > +
>> > +# get standard environment, filters and checks
>> > +. ./common/rc
>> > +. ./common/filter
>> > +
>> > +# real QA test starts here
>> > +_supported_fs xfs
>> > +_require_xfs_db_command "path"
>> > +_require_scratch
>> > +
>> > +echo "Format filesystem and populate"
>> > +_scratch_mkfs > $seqres.full
>> > +_scratch_mount >> $seqres.full
>> > +
>> > +mkdir $SCRATCH_MNT/a
>> > +mkdir $SCRATCH_MNT/a/b
>> > +$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
>> > +ln -s -f c $SCRATCH_MNT/a/d
>> > +mknod $SCRATCH_MNT/a/e b 8 0
>> > +ln -s -f b $SCRATCH_MNT/a/f
>> 
>> Later in the test script, there are two checks corresponding to accessibility
>> of file symlink and dir symlink. However, $SCRATCH_MNT/a/d and
>> $SCRATCH_MNT/a/f are actually referring to non-existant files since current
>> working directory at the time of invocation of ln command is the xfstests
>> directory.
>> 
>> i.e. 'c' and 'b' arguments to 'ln' command above must be qualified with
>> $SCRATCH_MNT/a/.
>
> Hm?  d and f look fine to me:
>
> $ ./check xfs/917
> $ mount /dev/sdf /opt
> $ cd /opt/a
> $ ls
> total 4
> drwxr-xr-x 2 root root    6 Mar 25 09:25 b/
> -rw------- 1 root root   61 Mar 25 09:25 c
> lrwxrwxrwx 1 root root    1 Mar 25 09:25 d -> c
> brw-r--r-- 1 root root 8, 0 Mar 25 09:25 e
> lrwxrwxrwx 1 root root    1 Mar 25 09:25 f -> b/
>
> The link target is copied verbatim into the symlink, so I don't see why
> they need to be qualified?
>
> (FWIW the path command doesn't resolve symlinks, so it really only
> checks that /a/d and /a/f exist and are of type symlink.)

Sorry, I got confused. The patch looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
