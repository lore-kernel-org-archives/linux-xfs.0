Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D99AC43215
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 19:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E613D215E5
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 19:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="Oaa2Ww02"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfLBTY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 14:24:27 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38782 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfLBTY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 14:24:27 -0500
Received: by mail-pl1-f193.google.com with SMTP id o8so355681pls.5
        for <linux-xfs@vger.kernel.org>; Mon, 02 Dec 2019 11:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jQBHOyBQMALu1xUt5LSXgCIP2vbABLa0pScxXLK5aTI=;
        b=Oaa2Ww02j2IrEITVFCeYRWXdRMHrdU3wp76+mk6BjbnHfsdPQ3G/nG7MYq//2R1OSO
         TM8WLrlf2hJcxKNfZ1BPFxQcT/GFDjxs7/zNUm/YzYIYPcv6avf5zYdWugoxPed1rNIP
         EcKU1bzAiS+6FRAVe7m9WIMNUmKSsUBNb9KQsr11uNUq57s7lv09+5F45ha4dVKWWKrJ
         X+9ydptC4o04SoP6DkKQCi9OiAqKa3KyiVuSvi+gQtMPJoK8AJDZu7Bc2W2j+V9SX+tD
         uJRY2JCtBQ7MnF9Wpnkyvqmk4Ku1bxrqmTb0SVK5rkJatmIzSLkduJXlzpQ4tRY8cptt
         SVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jQBHOyBQMALu1xUt5LSXgCIP2vbABLa0pScxXLK5aTI=;
        b=hQ+OkE9mwtvtoKERUkTsaU9r9cLGWWuSqERWhOi2tS/a1xeABeb7K4rjdHrzZOWGgY
         euPxw32TiXw3jqj0B/whgLQq+fyHf9uTrmH39khxSqDpHV54B/t7ZyDFxwuISzumUslq
         /MXa1ad8r0HWWyyPS130njkI7nzR9HYfN/7pXK8Q/3bhPoH7TvNsoLlHaIWNCIy9nt8n
         xAEppq7gpzK17+SZnASAC1jTVDV+DjUkh8Pl4vnMgDL2BtIwSG9n1j83QGDuJj8XouVt
         XmT0gCEPoGCq1LfnHFB9ufpP8Cki4HCdIjMvHOxAPmRI8Y7sTDSzQtIh00kgUxbRI33y
         jtfw==
X-Gm-Message-State: APjAAAV9iNuzyX5OSP5UH8+MQdaiSVLKkGCzSj6iyswzo7CTRg1JYb5J
        SwUJo+xMwDj+EtnKyvhqNY2k1g==
X-Google-Smtp-Source: APXvYqzxXTNGyNm+MZjXrXFxtViFo9lfEpI37r7d+Rgj9cb+/GKVRzY/5FGTE7jyFXim3KK70p1BIA==
X-Received: by 2002:a17:90a:7781:: with SMTP id v1mr737022pjk.93.1575314666009;
        Mon, 02 Dec 2019 11:24:26 -0800 (PST)
Received: from vader ([2620:10d:c090:200::3:4fcf])
        by smtp.gmail.com with ESMTPSA id u4sm125506pjb.31.2019.12.02.11.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 11:24:25 -0800 (PST)
Date:   Mon, 2 Dec 2019 11:24:24 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, kernel-team@fb.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: test truncating mixed written/unwritten XFS
 realtime extent
Message-ID: <20191202192424.GA809204@vader>
References: <2512a38027e5286eae01d4aa36726f49a94e523d.1574799173.git.osandov@fb.com>
 <20191127012646.GR6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127012646.GR6219@magnolia>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 26, 2019 at 05:26:46PM -0800, Darrick J. Wong wrote:
> On Tue, Nov 26, 2019 at 12:13:56PM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > The only XFS-specific part of this test is the setup, so we can make the
> > rest a generic test. It's slow, though, as it needs to write 8GB to
> > convert a big unwritten extent to written.
> > 
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  tests/generic/586     | 59 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/586.out |  2 ++
> >  tests/generic/group   |  1 +
> >  3 files changed, 62 insertions(+)
> >  create mode 100755 tests/generic/586
> >  create mode 100644 tests/generic/586.out
> > 
> > diff --git a/tests/generic/586 b/tests/generic/586
> > new file mode 100755
> > index 00000000..5bcad68b
> > --- /dev/null
> > +++ b/tests/generic/586
> > @@ -0,0 +1,59 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2019 Facebook.  All Rights Reserved.
> > +#
> > +# FS QA Test 586
> > +#
> > +# Test "xfs: fix realtime file data space leak" and "xfs: don't check for AG
> > +# deadlock for realtime files in bunmapi". On XFS without the fix, rm will hang
> > +# forever. On other filesystems, this just tests writing into big fallocates.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +rm -f $seqres.full
> > +
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch
> > +
> > +maxextlen=$((0x1fffff))
> 
> /me wonders if we ought to move this to common/xfs and hoist the other
> place (xfs/507) where we define this.
> 
> > +bs=4096
> > +rextsize=4
> > +
> > +extra_options=""
> > +if [[ $FSTYP = xfs && $USE_EXTERNAL = yes && -n $SCRATCH_RTDEV ]]; then
> > +	extra_options="$extra_options -bsize=$bs"
> 
> Hm.  Could you rework this to _require_realtime, and if the caller
> didn't set SCRATCH_RTDEV, create a file on the test device so that we
> can always do the realtime test if the kernel supports it?  That will
> ensure that this gets more testing that it does now...

Sorry, I don't follow. _require_realtime checks that SCRATCH_RTDEV was
set. Did you mean something like this?

if [[ $USE_EXTERNAL = yes && -n $SCRATCH_RTDEV ]]; then
	use the configured rtdev
else
	_require_test
	_require_scratch
	set up a loop device on the test filesystem as the rtdev
fi

> > +	extra_options="$extra_options -r extsize=$((bs * rextsize))"
> > +	extra_options="$extra_options -d agsize=$(((maxextlen + 1) * bs / 2)),rtinherit=1"
> 
> ...particularly because I don't think very many people actually run
> fstests with rt enabled /and/ rtinherit set to stress the realtime
> allocator.
> 
> (I did a year ago and out came a torrent of bugs such that someone could
> probably write themselves a nice year end bonus just fixing all that,
> software is terrible :()
> 
> > +fi
> > +_scratch_mkfs $extra_options >>$seqres.full 2>&1
> > +_scratch_mount
> > +_require_fs_space "$SCRATCH_MNT" "$(((maxextlen + 1) * bs / 1024))"
> > +
> > +fallocate -l $(((maxextlen + 1 - rextsize) * bs)) "$SCRATCH_MNT/file"
> > +sync
> 
> $XFS_IO_PROG -c "falloc 0 <math expression>" -c fsync $SCRATCH_MNT/file

Will fix.

> (Hm ok, fallocate the first 2097148 blocks of the file...)

Oops, I'll add some explanations for all of this stuff.

Thanks for taking a look!

> > +fallocate -o $(((maxextlen + 1 - rextsize) * bs)) -l $((rextsize * bs)) "$SCRATCH_MNT/file"
> > +sync
> 
> $XFS_IO_PROG -c "falloc <the -o expression> <the -l expression>" -c fsync $SCRATCH_MNT/file
> 
> (now fallocate blocks 2097148 to 2097152)
> 
> (Not sure why you do the last rtext separately...)
> 
> > +dd if=/dev/zero of="$SCRATCH_MNT/file" bs=$bs count=$((maxextlen + 2 - rextsize)) conv=notrunc status=none
> > +sync
> 
> $XFS_IO_PROG -c "pwrite <count= expression> $bs" -c fsync $SCRATCH_MNT/file
> 
> (and finally write to block 2097149?)
> 
> --D
