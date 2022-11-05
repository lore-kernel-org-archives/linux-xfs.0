Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E44D4C43217
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Nov 2022 12:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKEMRS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Nov 2022 08:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiKEMRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Nov 2022 08:17:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D58E01F
        for <linux-xfs@vger.kernel.org>; Sat,  5 Nov 2022 05:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667650580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=00w/Nr2wAFdIbM9pPuZsqhVxq5/dSKQJn8ij8OejMkA=;
        b=HFUyoYaI3p9Ils8LngONX3UNGFH7JjwfPZQvgey5JLaubCDEzpSfxHPwUicmIiApq4GidX
        64gCwXmRtX0VkW6fzyPONws4OL5IGynBH/l+eHBFW80RfIZVnWB4XeTB6sN2PmGdoXKXTa
        M7JbKeaDd9+2o+cmA1vh7rgLFWJ+HjY=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-391-kq43xVcHMTq2NogX7xKVtg-1; Sat, 05 Nov 2022 08:16:19 -0400
X-MC-Unique: kq43xVcHMTq2NogX7xKVtg-1
Received: by mail-pg1-f200.google.com with SMTP id v18-20020a637a12000000b0046ed84b94efso3614408pgc.6
        for <linux-xfs@vger.kernel.org>; Sat, 05 Nov 2022 05:16:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00w/Nr2wAFdIbM9pPuZsqhVxq5/dSKQJn8ij8OejMkA=;
        b=lmNGZIaGd+jBPRiLNXMhfzMB9N52dFHKPOYvOY8oON/++h2Rctdc/Xdp5Fd2JNknWV
         ke48DTPXe5PqJqS0Vbf8IlG8hVwozE2ScOnV0bp7o3JbzZ6R6PRtrX633lZKKVHpFxYO
         5c1j07lwzI2f5LZGjJBsXBIe8H1f9cUmJuaqPtKI1DsCryjz3oi0tiuWXY2vRQHuw8O/
         r8dWXY3h8UfT+bciwIM25KIxZUMorOnzRlt1MNF94n3NdUIdnfeBQUbc40utZ9f4u9fu
         ZrpXusmsHmiPrrUf6+u4XwM4/Wtwa5lfm0OaNl3dgIViavAjJrZ4krFCMNtkKEgNwM+s
         oKOw==
X-Gm-Message-State: ACrzQf0AMjfmjmmlfttB2RGgoE7sfKGB3p5CZgbKx4PoZu4olHd2L5cw
        qbHfVa3gQqfB7qpYVop9zOOG7GJUlqSo1DPZEsessptQeawxu0Pcg5KjJWULwNlEbGjPWHnXcPN
        kfRPRvnbTYK/CXPZ04Wc+
X-Received: by 2002:a17:903:22cb:b0:186:a8ae:d107 with SMTP id y11-20020a17090322cb00b00186a8aed107mr24316680plg.119.1667650578050;
        Sat, 05 Nov 2022 05:16:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6A0ChFU9IcGvLLsIRSqct166Lj3lHOY9wrBPb4Q6ffjkKWMk+gOYE40ePrBZZjvys2WEgANw==
X-Received: by 2002:a17:903:22cb:b0:186:a8ae:d107 with SMTP id y11-20020a17090322cb00b00186a8aed107mr24316654plg.119.1667650577692;
        Sat, 05 Nov 2022 05:16:17 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j21-20020a170902c3d500b00186c9d17af2sm1561953plj.17.2022.11.05.05.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 05:16:16 -0700 (PDT)
Date:   Sat, 5 Nov 2022 20:16:11 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: shutdown might leave NULL files with nonzero
 di_size
Message-ID: <20221105121611.gsq2d4cmp5pasfqo@zlang-mailbox>
References: <20221104162002.1912751-1-zlang@kernel.org>
 <Y2U96BrOS2ixJAGh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2U96BrOS2ixJAGh@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 04, 2022 at 09:29:28AM -0700, Darrick J. Wong wrote:
> On Sat, Nov 05, 2022 at 12:20:02AM +0800, Zorro Lang wrote:
> > An old issue might cause on-disk inode sizes are logged prematurely
> > via the free eofblocks path on file close. Then fs shutdown might
> > leave NULL files but their di_size > 0.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > Hi,
> > 
> > There was an very old xfs bug on rhel-6.5, I'd like to share its reproducer to
> > fstests. I've tried generic/044~049, no one can reproduce this bug, so I
> > have to write this new one. It fails on rhel-6.5 [1], and test passed on
> > later kernel.
> > 
> > I hard to say which patch fix this issue exactly, it's fixed by a patchset
> > which does code improvement/cleanup.
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > # ./check generic/999
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch
> > 
> > generic/999 2s ... - output mismatch (see /root/xfstests-dev/results//generic/999.out.bad)
> >     --- tests/generic/999.out   2022-11-04 00:54:11.123353054 -0400
> >     +++ /root/xfstests-dev/results//generic/999.out.bad 2022-11-04 04:24:57.861673433 -0400
> >     @@ -1 +1,3 @@
> >      QA output created by 999
> >     + - /mnt/scratch/1 get no extents, but its di_size > 0
> >     +/mnt/scratch/1:
> >     ...
> >     (Run 'diff -u tests/generic/045.out /root/xfstests-dev/results//generic/999.out.bad'  to see the entire diff)
> > Ran: generic/999
> > Failures: generic/999
> > Failed 1 of 1 tests
> > 
> >  tests/generic/999     | 46 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/999.out |  5 +++++
> >  2 files changed, 51 insertions(+)
> >  create mode 100755 tests/generic/999
> >  create mode 100644 tests/generic/999.out
> > 
> > diff --git a/tests/generic/999 b/tests/generic/999
> > new file mode 100755
> > index 00000000..a2e662fc
> > --- /dev/null
> > +++ b/tests/generic/999
> > @@ -0,0 +1,46 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 999
> > +#
> > +# Test an issue in the truncate codepath where on-disk inode sizes are logged
> > +# prematurely via the free eofblocks path on file close.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick shutdown
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_io_command fiemap
> 
> /me would've thought you'd use the xfs_io stat/bmap commands to detect
> either nextents > 0 (stat) or actual mappings returned (bmap), but I
> guess if RHEL 6.5 xfsprogs has a fiemap command then this is fine with
> me.

Ah, you're right, rhel-6 xfs_io doesn't support fiemap :)

And yes, I wrote this case as a xfs specific case at first, by using xfs_bmap.
The original case (of us) uses xfs_bmap too. But I thought fiemap can help it
to be a generic case to cover more fs, so I turn to use fiemap.

> 
> If the answer to the above is "um, RHEL 6.5 xfsprogs *does* have FIEMAP",
> then there's little point in rewriting a stable regression test, so:

I don't worry about rhel6 testing, due to I keep our internal case (for rhel6
only). I'd like to see more generic cases, except fiemap can't help this test :)

Thanks,
Zorro

> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > +_require_scratch_shutdown
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +echo "Create many small files with one extent at least"
> > +for ((i=0; i<10000; i++));do
> > +	$XFS_IO_PROG -f -c "pwrite 0 4k" $SCRATCH_MNT/file.$i >/dev/null 2>&1
> > +done
> > +
> > +echo "Shutdown the fs suddently"
> > +_scratch_shutdown
> > +
> > +echo "Cycle mount"
> > +_scratch_cycle_mount
> > +
> > +echo "Check file's (di_size > 0) extents"
> > +for f in $(find $SCRATCH_MNT -type f -size +0);do
> > +	$XFS_IO_PROG -c "fiemap" $f > $tmp.fiemap
> > +	# Check if the file has any extent
> > +	grep -Eq '^[[:space:]]+[0-9]+:' $tmp.fiemap
> > +	if [ $? -ne 0 ];then
> > +		echo " - $f get no extents, but its di_size > 0"
> > +		cat $tmp.fiemap
> > +		break
> > +	fi
> > +done
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/999.out b/tests/generic/999.out
> > new file mode 100644
> > index 00000000..50008783
> > --- /dev/null
> > +++ b/tests/generic/999.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 999
> > +Create many small files with one extent at least
> > +Shutdown the fs suddently
> > +Cycle mount
> > +Check file's (di_size > 0) extents
> > -- 
> > 2.31.1
> > 
> 

