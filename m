Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A89C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 16:09:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiKHQJs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 11:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiKHQJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 11:09:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2688B64EA
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 08:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667923729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RLvyKIxFNY8DsiVruV+VFcA1LJcU3E8nh6AgZzVWFOs=;
        b=ZjoV3C3B6dnx2/k5q2iCI1ZAwrwg6Xb6IP0izRWTmvIPvrIm5EOdpVUkvPVMNjW0LgrfbE
        Zsl2K297rVCOZIRwEKemw/q2fzuxbgPiGhyC1c6oAk2a293OjLk/iHK22c/MY7OOa7Ztuc
        lyTLz3efI8kRKa6Pcfo52YaP3kwH4+8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-106-1trUoS5tPXqh92ZY4dx4Ww-1; Tue, 08 Nov 2022 11:08:47 -0500
X-MC-Unique: 1trUoS5tPXqh92ZY4dx4Ww-1
Received: by mail-qk1-f198.google.com with SMTP id bl21-20020a05620a1a9500b006fa35db066aso13255664qkb.19
        for <linux-xfs@vger.kernel.org>; Tue, 08 Nov 2022 08:08:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLvyKIxFNY8DsiVruV+VFcA1LJcU3E8nh6AgZzVWFOs=;
        b=3BzB+7Mgh1XNdc707BndTBWruZoQ5QYlQ6Tcsg0nr8atw2EtPEH3xxE324XvRJRo3S
         BM6ZzGhjFZqOWNmS9MYN3ayQ+EjCXd9S17kMl3OJphLiJFMrtLtypEni7aRcDELjFX74
         EtAHKKVlg1woSwSigTg/sHILlji9KWUv7UAUElZ9BduAdfMVfiNLx1uKJr6XdHgy7nv5
         VO2EbDyKjp0ZfwReam/o6CU0Ze1Znbl94vmWl3Lz5Swqorw2L+8KEzulMQlds7a8l2uC
         apAkWDp91malYCiT4wKw9vzsk+HwlPIOqjR3HpYqozSo8IlLRusCnTTmWongUEpnIjnQ
         ee4g==
X-Gm-Message-State: ACrzQf2XAKGKGFzunBwuj35D5R5ErSjkt80tjyvjxhuf6zq0p6lp59+K
        v1ML4CHIFaplZERD2A4vEbkoPvPMlANg5+ONOERK/GQ8FuZQctMtZ5pfQddmQ+PHQQ31H+jHnnf
        cKkoze2SasZKhnB0Vu5Nx
X-Received: by 2002:a05:6214:b6b:b0:4bb:9fea:f53a with SMTP id ey11-20020a0562140b6b00b004bb9feaf53amr50511115qvb.7.1667923726821;
        Tue, 08 Nov 2022 08:08:46 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4g3dcc2XGYnXW+UE8Wuw3wOiL25+1qiqHi/nsk4XvpD+zx6CkU6aa1k9wXfCB/yWnAWHoG7g==
X-Received: by 2002:a05:6214:b6b:b0:4bb:9fea:f53a with SMTP id ey11-20020a0562140b6b00b004bb9feaf53amr50511091qvb.7.1667923726532;
        Tue, 08 Nov 2022 08:08:46 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w27-20020a05620a0e9b00b006fa63cc7affsm9347993qkm.34.2022.11.08.08.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 08:08:45 -0800 (PST)
Date:   Wed, 9 Nov 2022 00:08:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: shutdown might leave NULL files with nonzero
 di_size
Message-ID: <20221108160841.c4tuhsouuz5cltcv@zlang-mailbox>
References: <20221105152324.2233310-1-zlang@kernel.org>
 <Y2k1SzblcYRsSvzK@magnolia>
 <20221108060244.gixpw3v3cpwckkjq@zlang-mailbox>
 <Y2p7LnPOFXy4kitY@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2p7LnPOFXy4kitY@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 08, 2022 at 07:52:14AM -0800, Darrick J. Wong wrote:
> On Tue, Nov 08, 2022 at 02:02:44PM +0800, Zorro Lang wrote:
> > On Mon, Nov 07, 2022 at 08:41:47AM -0800, Darrick J. Wong wrote:
> > > On Sat, Nov 05, 2022 at 11:23:24PM +0800, Zorro Lang wrote:
> > > > An old issue might cause on-disk inode sizes are logged prematurely
> > > > via the free eofblocks path on file close. Then fs shutdown might
> > > > leave NULL files but their di_size > 0.
> > > > 
> > > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > > ---
> > > > 
> > > > V2 replace "fiemap" with "stat" command, to check if a file has extents.
> > > > That helps this case more common.
> > > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > >  tests/generic/999     | 42 ++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/999.out |  5 +++++
> > > >  2 files changed, 47 insertions(+)
> > > >  create mode 100755 tests/generic/999
> > > >  create mode 100644 tests/generic/999.out
> > > > 
> > > > diff --git a/tests/generic/999 b/tests/generic/999
> > > > new file mode 100755
> > > > index 00000000..8b4596e0
> > > > --- /dev/null
> > > > +++ b/tests/generic/999
> > > 
> > > Ugh sorry     ^^^^^^^ I didn't notice this part and wrote my previous
> > > response thinking this was an xfs-only test...
> > 
> > Oh, my bad, I forgot to change the "_supported_fs xfs" to "generic".
> > 
> > > 
> > > > @@ -0,0 +1,42 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 999
> > > > +#
> > > > +# Test an issue in the truncate codepath where on-disk inode sizes are logged
> > > > +# prematurely via the free eofblocks path on file close.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick shutdown
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs xfs
> > > > +_require_scratch
> > > > +_require_scratch_shutdown
> > > > +_scratch_mkfs > $seqres.full 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +echo "Create many small files with one extent at least"
> > > > +for ((i=0; i<10000; i++));do
> > > > +	$XFS_IO_PROG -f -c "pwrite 0 4k" $SCRATCH_MNT/file.$i >/dev/null 2>&1
> > > > +done
> > > > +
> > > > +echo "Shutdown the fs suddently"
> > > > +_scratch_shutdown
> > > > +
> > > > +echo "Cycle mount"
> > > > +_scratch_cycle_mount
> > > > +
> > > > +echo "Check file's (di_size > 0) extents"
> > > > +for f in $(find $SCRATCH_MNT -type f -size +0);do
> > > > +	# Check if the file has any extent
> > > > +	if [ "$(stat -c "%b" $f)" = "0" ];then
> > > > +		echo " - $f get no extents, but its di_size > 0"
> > > > +		break
> > > > +	fi
> > > > +done
> > > 
> > > ...so whereas I was trying to suggest that you could use the GETFSXATTR
> > > ioctl to return the extent count:
> > > 
> > > $XFS_IO_PROG -c stat $f | grep fsxattr.nextents | awk '{print $3}'
> > > 
> > > But that won't work outside of XFS.  To make this generic, I think you
> > > have to do something like:
> > > 
> > > $FILEFRAG_PROG -v $f | wc -l
> > 
> > I'm wondering if we must check extent is 0, how about check allocated block = 0?
> > I tried [ "$(stat -c "%b" $f)" = "0" ], it fails on old kernel without this bug
> > fix, and test passed on new kernel. Does that make sense for you?
> 
> What if an LSM (e.g. selinux) attach enough security attrs to push the
> xattr data into an external block?  I don't think that happens often for

Oh! You're right, I forgot the ablocks. Due to fstests always use
"-o context=system_u:object_r:root_t:s0" to mount, I thought there's not
selinux labels to take xattr space by default, so ablocks generally is 0 (I think:).

But I agree with you, "$(stat -c "%b" $f)" can be affected by ablocks, so
filefrag might be a better solution.

Thanks,
Zorro

> XFS, but I think it will for ext3 with 128byte inodes.
> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > to see if there are any extents.
> > > 
> > > --D
> > > 
> > > > +
> > > > +# success, all done
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/generic/999.out b/tests/generic/999.out
> > > > new file mode 100644
> > > > index 00000000..50008783
> > > > --- /dev/null
> > > > +++ b/tests/generic/999.out
> > > > @@ -0,0 +1,5 @@
> > > > +QA output created by 999
> > > > +Create many small files with one extent at least
> > > > +Shutdown the fs suddently
> > > > +Cycle mount
> > > > +Check file's (di_size > 0) extents
> > > > -- 
> > > > 2.31.1
> > > > 
> > > 
> > 
> 

