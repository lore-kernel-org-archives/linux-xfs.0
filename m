Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42108C47E49
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 15:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 161752086D
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 15:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iFXBL0eO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbfKCPZC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 10:25:02 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38661 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfKCPZC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 10:25:02 -0500
Received: by mail-pf1-f194.google.com with SMTP id c13so10436633pfp.5;
        Sun, 03 Nov 2019 07:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/l+CmnzZ7MsHxS7xlXF5o6727ZXCJYAbNgznqg2CIJE=;
        b=iFXBL0eOxRgRwl9B/glOlzBG/fDb6rn7pGRsMzPpNXQGzIrJp0qkkql5FJbGFroisb
         Rz05HzVOW4VR9ylcxENjgcZatlmf3zrgwSetfMaoO5if7oJIQYK2GLV3KWMbV6dEwuMj
         KOEra7D5H+NfAsZXPhhq3ArXW9CQao6exFekX4YEg3TG5h2H49hFQxmdsgv6z10hzrV7
         IbALARoaQmYXZm/hHduPUnt0hj7CFO4XLfGupYAZki5CL95i8bMfOJAMUM3rFQKMuGnS
         JUXm3HY82SgdJm9CbIeskY4//i8U/wSQVvqIc6vZbgB/P5Bm7X27Tmwb9FM8Xppv/kyd
         Yczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/l+CmnzZ7MsHxS7xlXF5o6727ZXCJYAbNgznqg2CIJE=;
        b=UhS9KsPlAyqvA0wEEL+2lKdUrGVgYaIk2+OMk8+WIPCMvTEmEiLMj29RO5xcGIm54+
         SN0QJhg1yXr5RM+yb2dK/G0WzDb3V48hi8BPtyv5ohBfI4rpHxBMUq3taEbq/tw7nxzh
         NO9hvvZHJSDxemI2A5jKZMAMH1jSkF1eXfcvhwYHIRHJo0SdDXIciT4u8/7BGB/SVNeE
         ZNGHy7DBDvEz61V58b89X5iRmt1Y/gY4mztTOD69PtuC2vT4aiIJqgGvR7ULRvCHJQ8L
         T22SODHgrZU7YE8NlR0Hmx1+W+Rfy0Bad37hYd/6+G6LkTfGwx7iHKZED8LceKc9lNaC
         0lwQ==
X-Gm-Message-State: APjAAAWyHdk6F8z4u6IL6jOKtsRoGrJ4jipwXMJyKAxrzLFuulRjzDiX
        sNPEvaH5nwTm+ML4SGkPpiJ94si5
X-Google-Smtp-Source: APXvYqw8Bf66lTUUB2B3IYHqwKNe8TrE3u4k3wXLNvvTHWLaDbMIGxst4GTBtsdvI5HCdOK4OZ7/4A==
X-Received: by 2002:aa7:82d7:: with SMTP id f23mr26645903pfn.141.1572794701118;
        Sun, 03 Nov 2019 07:25:01 -0800 (PST)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id 70sm14217901pfw.160.2019.11.03.07.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2019 07:24:59 -0800 (PST)
Date:   Sun, 3 Nov 2019 23:24:51 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] fstests: verify that xfs_growfs can operate on mounted
 device node
Message-ID: <20191103152446.GA8664@desktop>
References: <1253fd24-a0ef-26ca-6ff9-b3b7a451e78a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253fd24-a0ef-26ca-6ff9-b3b7a451e78a@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 12:53:48PM -0500, Eric Sandeen wrote:
> The ability to use a mounted device node as the primary argument
> to xfs_growfs will be added back in, because it was an undocumented
> behavior that some userspace depended on.  This test exercises that
> functionality.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/tests/xfs/148 b/tests/xfs/148
> new file mode 100755
> index 00000000..357ae01c
> --- /dev/null
> +++ b/tests/xfs/148
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 148
> +#
> +# Test to ensure xfs_growfs command accepts device nodes if & only
> +# if they are mounted.
> +# This functionality, though undocumented, worked until xfsprogs v4.12
> +# It was added back and documented after xfsprogs v5.2

I'm testing with xfsprogs from for-next branch, which is v5.3.0-rc1
based xfs_growfs, but I still see failures like

     === xfs_growfs - check device node ===
    +xfs_growfs: /dev/loop0 is not a mounted XFS filesystem
     === xfs_growfs - check device symlink ===
    +xfs_growfs: /mnt/test/loop_symlink.21781 is not a mounted XFS filesystem
     === unmount ===

If it's already fixed, would you please list the related commits in
commit log as well?

> +#
> +# Based on xfs/289
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    $UMOUNT_PROG $mntdir
> +    _destroy_loop_device $loop_dev
> +    rmdir $mntdir
> +    rm -f $loop_symlink
> +    rm -f $loopfile
> +}

'mntdir', 'loop_symlink' and 'loopfile' should be defined before
_cleanup, otherwise if we exit early, e.g. due to unmet requirement,
we'll see false failures.

And should check if 'loop_dev' is defined before destroy it.

> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +_require_test
> +_require_loop
> +
> +loopfile=$TEST_DIR/fsfile
> +mntdir=$TEST_DIR/mntdir
> +loop_symlink=$TEST_DIR/loop_symlink.$$
> +
> +mkdir -p $mntdir || _fail "!!! failed to create temp mount dir"
> +
> +echo "=== mkfs.xfs ==="
> +$MKFS_XFS_PROG -d file,name=$loopfile,size=16m -f >/dev/null 2>&1
> +
> +echo "=== truncate ==="
> +$XFS_IO_PROG -fc "truncate 256m" $loopfile
> +
> +echo "=== create loop device ==="
> +loop_dev=$(_create_loop_device $loopfile)
> +
> +echo "=== create loop device symlink ==="
> +ln -s $loop_dev $loop_symlink
> +
> +echo "loop device is $loop_dev"

This should be redirected to $seqres.full, as $loop_dev could be any
loop device.

> +
> +# These unmounted operations should fail
> +
> +echo "=== xfs_growfs - unmounted device, command should be rejected ==="
> +$XFS_GROWFS_PROG $loop_dev 2>&1 | sed -e s:$loop_dev:LOOPDEV:
> +
> +echo "=== xfs_growfs - check symlinked dev, unmounted ==="
> +$XFS_GROWFS_PROG $loop_symlink 2>&1 | sed -e s:$loop_symlink:LOOPSYMLINK:
> +
> +# These mounted operations should pass
> +
> +echo "=== mount ==="
> +$MOUNT_PROG $loop_dev $mntdir || _fail "!!! failed to loopback mount"
> +
> +echo "=== xfs_growfs - check device node ==="
> +$XFS_GROWFS_PROG -D 8192 $loop_dev > /dev/null
> +
> +echo "=== xfs_growfs - check device symlink ==="
> +$XFS_GROWFS_PROG -D 12288 $loop_symlink > /dev/null
> +
> +echo "=== unmount ==="
> +$UMOUNT_PROG $mntdir || _fail "!!! failed to unmount"
> +
> +echo "=== mount device symlink ==="
> +$MOUNT_PROG $loop_symlink $mntdir || _fail "!!! failed to loopback mount"
> +
> +echo "=== xfs_growfs - check device symlink ==="
> +$XFS_GROWFS_PROG -D 16384 $loop_symlink > /dev/null
> +
> +echo "=== xfs_growfs - check device node ==="
> +$XFS_GROWFS_PROG -D 20480 $loop_dev > /dev/null
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/148.out b/tests/xfs/148.out
> new file mode 100644
> index 00000000..d8e6f02d
> --- /dev/null
> +++ b/tests/xfs/148.out
> @@ -0,0 +1,17 @@
> +QA output created by 148
> +=== mkfs.xfs ===
> +=== truncate ===
> +=== create loop device ===
> +=== create loop device symlink ===
> +loop device is /dev/loop0

So this line should be removed as well.

Thanks,
Eryu

> +=== xfs_growfs - unmounted device, command should be rejected ===
> +xfs_growfs: LOOPDEV is not a mounted XFS filesystem
> +=== xfs_growfs - check symlinked dev, unmounted ===
> +xfs_growfs: LOOPSYMLINK is not a mounted XFS filesystem
> +=== mount ===
> +=== xfs_growfs - check device node ===
> +=== xfs_growfs - check device symlink ===
> +=== unmount ===
> +=== mount device symlink ===
> +=== xfs_growfs - check device symlink ===
> +=== xfs_growfs - check device node ===
> diff --git a/tests/xfs/group b/tests/xfs/group
> index f4ebcd8c..40a61b55 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -145,6 +145,7 @@
>  145 dmapi
>  146 dmapi
>  147 dmapi
> +148 quick auto growfs
>  150 dmapi
>  151 dmapi
>  152 dmapi
> 
