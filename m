Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FECC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 06:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiKHGDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 01:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiKHGDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 01:03:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23809317D8
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 22:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667887372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2wi2cYOuCOjTRffHxFSHZytdUsNobPtQGapWaktS8Hs=;
        b=JUnLbHtrfQdv3k/PeWJpxd12ZNijXnX2OImWHg6Az8NNdaj3hzii7hfyOyXYJEVQ74QaG+
        Ye7++ay8fi899PnR3y7jSNQle2xYapc7hil0mmGbTFGPwGHsYUyZ/t9xTyyoweRVnrPmLX
        tgZSgmV9Od9EL9nTXP95kzRM4hHsboQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-299-2KnOtJ_qPPS9hPPhDkeypA-1; Tue, 08 Nov 2022 01:02:50 -0500
X-MC-Unique: 2KnOtJ_qPPS9hPPhDkeypA-1
Received: by mail-qk1-f199.google.com with SMTP id bm2-20020a05620a198200b006fa6eeee4a9so12066756qkb.14
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 22:02:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wi2cYOuCOjTRffHxFSHZytdUsNobPtQGapWaktS8Hs=;
        b=siBq3TdSq7yCPnjpTqFrCTP1/Ymv+FU9A9IZ80kQW8yr57ObbCt2IRie5W538WLFHQ
         r4RIRPlsVBFLKGZtHPrs6ZxyihqZOz3wz0IwVZ/OYViNUB36cbOfEnjYWUS0njt1+57k
         tFeotWkVYTBnHY64/issNpJ6FRHwRKbeVawcP3KXGsHVR0ioX5oKwmksxEM76YNY9B3s
         lfrlaRdf6DbQgRlAsijOlel0stM289LQ4nrNIVnECkXkuAP/aZkXPYPm7TVktG+/9OGQ
         AH9pbtLLFLPQuPRLLHssD9P9ilNooor3pL/jCtI6wDWZ1JuvvlAg7BLd0h+AFZOliIJI
         INaA==
X-Gm-Message-State: ACrzQf3gWxbwLKWPNXFIl8eeVwkNFhnlTq+gJgl1Dec7QIZHPhfFIZMd
        IzffH878uondhzSz0rPnkYES8vvyKy67NPGO+AUk+n7XklVvv7w1u2DlQe9qn7pDwS37CYLsLSD
        q5KDNs5YuL53Gt3LLO6pU
X-Received: by 2002:a05:6214:21ed:b0:4bb:e947:c59a with SMTP id p13-20020a05621421ed00b004bbe947c59amr43020737qvj.46.1667887369968;
        Mon, 07 Nov 2022 22:02:49 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5VAf4+XKtbUbip6PzHrK5mLxiVeGAC9fqCDYNntMvhULNQOLUThIlEMaYtT8bN6c20bfBiVw==
X-Received: by 2002:a05:6214:21ed:b0:4bb:e947:c59a with SMTP id p13-20020a05621421ed00b004bbe947c59amr43020701qvj.46.1667887369299;
        Mon, 07 Nov 2022 22:02:49 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r2-20020a05622a034200b003995f6513b9sm7680930qtw.95.2022.11.07.22.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 22:02:48 -0800 (PST)
Date:   Tue, 8 Nov 2022 14:02:44 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: shutdown might leave NULL files with nonzero
 di_size
Message-ID: <20221108060244.gixpw3v3cpwckkjq@zlang-mailbox>
References: <20221105152324.2233310-1-zlang@kernel.org>
 <Y2k1SzblcYRsSvzK@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2k1SzblcYRsSvzK@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 07, 2022 at 08:41:47AM -0800, Darrick J. Wong wrote:
> On Sat, Nov 05, 2022 at 11:23:24PM +0800, Zorro Lang wrote:
> > An old issue might cause on-disk inode sizes are logged prematurely
> > via the free eofblocks path on file close. Then fs shutdown might
> > leave NULL files but their di_size > 0.
> > 
> > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > ---
> > 
> > V2 replace "fiemap" with "stat" command, to check if a file has extents.
> > That helps this case more common.
> > 
> > Thanks,
> > Zorro
> > 
> >  tests/generic/999     | 42 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/999.out |  5 +++++
> >  2 files changed, 47 insertions(+)
> >  create mode 100755 tests/generic/999
> >  create mode 100644 tests/generic/999.out
> > 
> > diff --git a/tests/generic/999 b/tests/generic/999
> > new file mode 100755
> > index 00000000..8b4596e0
> > --- /dev/null
> > +++ b/tests/generic/999
> 
> Ugh sorry     ^^^^^^^ I didn't notice this part and wrote my previous
> response thinking this was an xfs-only test...

Oh, my bad, I forgot to change the "_supported_fs xfs" to "generic".

> 
> > @@ -0,0 +1,42 @@
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
> > +	# Check if the file has any extent
> > +	if [ "$(stat -c "%b" $f)" = "0" ];then
> > +		echo " - $f get no extents, but its di_size > 0"
> > +		break
> > +	fi
> > +done
> 
> ...so whereas I was trying to suggest that you could use the GETFSXATTR
> ioctl to return the extent count:
> 
> $XFS_IO_PROG -c stat $f | grep fsxattr.nextents | awk '{print $3}'
> 
> But that won't work outside of XFS.  To make this generic, I think you
> have to do something like:
> 
> $FILEFRAG_PROG -v $f | wc -l

I'm wondering if we must check extent is 0, how about check allocated block = 0?
I tried [ "$(stat -c "%b" $f)" = "0" ], it fails on old kernel without this bug
fix, and test passed on new kernel. Does that make sense for you?

Thanks,
Zorro

> 
> to see if there are any extents.
> 
> --D
> 
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

