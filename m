Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815F2FA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 02:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233600AbiJ0CZM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 22:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbiJ0CZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 22:25:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDB6317D2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 19:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666837508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJsfeXwdoFSS6tOF0MP6wdDmgjZxoiopVPF8fwOBgjs=;
        b=E+W8RpUPBdMYBO0tdEtYgWB7iLMk/0hs6kZwqDEwQBf6U28EVzUM00Mk1Mo8hnBrk5K/ir
        2UZEuEO9si9C7Aq8zytuMrK9dh1wAccpGHQE5lGL2SQs7+K2WUFCnjIyzNLQNTKrCLbq+v
        PaXIf+6mrPMSpDOG4JobIu6l6X0BZLo=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-356-jg2y1n__MCKWQIwFnMgTMg-1; Wed, 26 Oct 2022 22:25:06 -0400
X-MC-Unique: jg2y1n__MCKWQIwFnMgTMg-1
Received: by mail-pf1-f200.google.com with SMTP id s2-20020aa78282000000b00561ba8f77b4so59303pfm.1
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 19:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJsfeXwdoFSS6tOF0MP6wdDmgjZxoiopVPF8fwOBgjs=;
        b=KzEx4TA3Dwb+82fkK2oivdk2inJhR+JYhHIJ3rjrnBSYYmhfRW1pkdtx/5FVJinnT/
         A4qJRtzHizQ00tpYBgPygfAs9fnJuyMUwtLvSBXxyNHk6FLtmw+GVfT/kb2NDhxpP502
         Rp3CNx6c2w5dnzMkhdkmG6T9HHaseRwOb+j7GfF25UEtzWC2yfhuTQRnbFMmfBn0P7ke
         J42Sr7gzdOuR9WcQV5ftBBJtM3x9PUbVzenxZmfjbMmUU6fqxxYmuTophwpNuMtbxY3p
         4J8iVqVvyazWQHUM/c+koSkrZlxkVfSHRHVDzy/u03RZEIwoELGaLOoB8tNrzvimgYR7
         K1Hg==
X-Gm-Message-State: ACrzQf2IWnmP3cIdCCRreBvXaFRi6jGK5CXgxrIjiZX3fd9tJMg1vP+9
        1omr/v9NXvPf8Fno/LUM8oZegm54IRyM7a4S7vVvCw9P2nQmf1o1XFv4/qgfnq+5E8ahshVxPMR
        HtGfaLVbPpiz+m9ncEh+r
X-Received: by 2002:a05:6a00:8cb:b0:52c:6962:2782 with SMTP id s11-20020a056a0008cb00b0052c69622782mr47387780pfu.81.1666837505140;
        Wed, 26 Oct 2022 19:25:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM64nrCvBgiS7gxqCjmCoWO/yTi9FAkjNmEFk/TGognlgPYJKTtALH+dSU9TB3cl6XqR8CLSOQ==
X-Received: by 2002:a05:6a00:8cb:b0:52c:6962:2782 with SMTP id s11-20020a056a0008cb00b0052c69622782mr47387758pfu.81.1666837504683;
        Wed, 26 Oct 2022 19:25:04 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d13-20020a65588d000000b0046ec057243asm6663pgu.12.2022.10.26.19.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 19:25:03 -0700 (PDT)
Date:   Thu, 27 Oct 2022 10:24:59 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: new test to ensure xfs can capture IO errors
 correctly
Message-ID: <20221027022459.5ewhsm7gjq5iynra@zlang-mailbox>
References: <20221026165747.1146281-1-zlang@kernel.org>
 <Y1l8xRaTpeH3Nu0l@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1l8xRaTpeH3Nu0l@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 26, 2022 at 11:30:29AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 27, 2022 at 12:57:47AM +0800, Zorro Lang wrote:
> > There was a known xfs crash bug fixed by e001873853d8 ("xfs: ensure
> > we capture IO errors correctly"), so trys to cover this bug and make
> > sure xfs can capture IO errors correctly, won't panic and hang again.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > Hi,
> > 
> > When I tried to tidy up our internal test cases recently, I found a very
> > old case which trys to cover e001873853d8 ("xfs: ensure we capture IO errors
> > correctly") which fix by Dave. At that time, we didn't support xfs injection,
> > so we tested it by a systemtap script [1] to inject an ioerror.
> > 
> > Now this bug has been fixed long long time ago (9+ years), and that stap script
> > is already out of date, can't work with new kernel. But good news is we have xfs
> > injection now, so I try to resume this test case in fstests.
> > 
> > I didn't verify if this case can reproduce that bug on old rhel (which doesn't
> > support error injection). The original case tried to inject errno 11, I'm
> > not sure if it's worth trying more other errors. I searched "buf_ioerror" in
> > fstests, found nothing. So maybe this bug is old enough, but it's worth covering
> > this kind of test. So feel free to tell me if you have any suggestions :)
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > probe module("xfs").function("xfs_buf_bio_end_io")
> > {
> >         if ($error == 0) {
> >                 if ($bio->bi_rw & (1 << 4)) {
> >                         $error = -11;
> >                         printf("%s: comm %s, pid %d, setting error 11\n",
> >                                 probefunc(), execname(), pid());
> >                         print_stack(backtrace());
> >                 }
> >         }
> > }
> > 
> >  tests/xfs/554     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/554.out |  4 ++++
> >  2 files changed, 57 insertions(+)
> >  create mode 100755 tests/xfs/554
> >  create mode 100644 tests/xfs/554.out
> > 
> > diff --git a/tests/xfs/554 b/tests/xfs/554
> > new file mode 100755
> > index 00000000..6935bfc0
> > --- /dev/null
> > +++ b/tests/xfs/554
> > @@ -0,0 +1,53 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 YOUR NAME HERE.  All Rights Reserved.
> 
> Mr. YOUR HERE,
> 
> Please write your real name in the copyright statement.
> 
> > +#
> > +# FS QA Test 554
> > +#
> > +# There was a known xfs crash bug fixed by e001873853d8 ("xfs: ensure we
> > +# capture IO errors correctly"), so trys to cover this bug and make sure
> > +# xfs can capture IO errors correctly, won't panic and hang again.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto eio
> > +
> > +_cleanup()
> > +{
> > +	$KILLALL_PROG -q fsstress 2> /dev/null
> > +	# ensures all fsstress processes died
> > +	wait
> > +	# log replay, due to the buf_ioerror injection might leave dirty log
> > +	_scratch_cycle_mount
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +# Import common functions.
> > +. ./common/inject
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_command "$KILLALL_PROG" "killall"
> > +_require_scratch
> > +_require_xfs_debug
> > +_require_xfs_io_error_injection "buf_ioerror"
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +
> > +echo "Inject buf ioerror tag"
> > +_scratch_inject_error buf_ioerror 11
> > +
> > +echo "Random I/Os testing ..."
> > +$FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 50000 -p 100 >> $seqres.full &
> > +for ((i=0; i<5; i++));do
> > +	# Clear caches, then trys to use 'find' to trigger readahead
> 
> BUF_IOERROR only seems to apply to async writes:
> 
> static void
> xfs_buf_bio_end_io(
> 	struct bio		*bio)
> {
> 	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
> 
> 	if (!bio->bi_status &&
> 	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
> 	    XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
> 		bio->bi_status = BLK_STS_IOERR;
> 
> So I don't see how this would reproduce the problem of b_error not being
> cleared after a failed readahead and re-read?

Oh, "bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC)" ... so I don't
have chance to cover this bug? I have to abandon this patch, or we'd like to
change it to be a general async ioerror injection test.

Thanks,
Zorro

> 
> --D
> 
> > +	echo 3 > /proc/sys/vm/drop_caches
> > +	find $SCRATCH_MNT >/dev/null 2>&1
> > +	sleep 3
> > +done
> > +
> > +echo "No hang or panic"
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> > new file mode 100644
> > index 00000000..26910daa
> > --- /dev/null
> > +++ b/tests/xfs/554.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 554
> > +Inject buf ioerror tag
> > +Random I/Os testing ...
> > +No hang or panic
> > -- 
> > 2.31.1
> > 
> 

