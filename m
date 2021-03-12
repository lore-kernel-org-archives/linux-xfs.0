Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18165C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 16:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF25565024
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 16:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhCLQ6t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:58:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231670AbhCLQ6r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 11:58:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615568327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SmTuKWtsjq23beIZH37+kqREC1Iv+KTONba5NhvEiTo=;
        b=cavCagqH00PhUKUbrp+xSO+5DZ2J2q9FPyo7aQ+7s8jYy4zYxumZeOfs9MXub/LOowK4Se
        AbSYZClFSAkxxuTh9pk0tq8xSl6+zz+3VZSzm3eeedUW7Uzr+emBCynNpMiUkenZnACv0M
        KRxbvehy9zy8bizl7bySJ//3ZLua2nQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-I4o5A2AsNcGwrKviG8pomA-1; Fri, 12 Mar 2021 11:58:45 -0500
X-MC-Unique: I4o5A2AsNcGwrKviG8pomA-1
Received: by mail-pl1-f198.google.com with SMTP id q11so12239876plx.22
        for <linux-xfs@vger.kernel.org>; Fri, 12 Mar 2021 08:58:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SmTuKWtsjq23beIZH37+kqREC1Iv+KTONba5NhvEiTo=;
        b=E7lKjWrtbd0Le4uMfC9wjOWcspJiX2rIMl9T/rjywi40KN6RxlRAxTRxhocvoKH5XC
         GLbUCMakdvHebKxZZ9jrICwlK5dx52pargwW6zz1kKD6tndXyOcUXJRLKLRnhu3H85Xx
         1xH8lwm7tzJAgi1LD6UHY6DrfzE4bJUNgpf52N9j1M88GmbG0ZOvKI1NTPYw5T9aCy8b
         Kl+D/GkVGoHgZBrbvABpmSCT8xwiaIQl/6nMiHLAqrFJcU2S3KcZ7dOXMX0V+id4RfCu
         f8MIUKqfQtE3xKolYgG/J0w0La/9HOnYeWF38PGCFBLj0D+9dtqssl3sqa2KpcuYzpK5
         yxug==
X-Gm-Message-State: AOAM5304p7BagEnrCujSNwhrWUFU39kkExYLs7O5h6pnYRqNegzM568y
        AUkm5reDzxcB+x/+hf/SG2gzQEyMu/CkgMv06gYOrcNX4Y+XQpppod52q90IC80LcOvCgZ7cYIm
        LpHDByNKB6Nc6dU4Q9sWw
X-Received: by 2002:a63:5807:: with SMTP id m7mr12442515pgb.73.1615568323373;
        Fri, 12 Mar 2021 08:58:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSWYw8vKBzh6kYPywiStOyIva/t6wA7doRAV92PG3eD63Yn5/KPjMrUhiJjpJWwEXrMlTT9w==
X-Received: by 2002:a63:5807:: with SMTP id m7mr12442502pgb.73.1615568323069;
        Fri, 12 Mar 2021 08:58:43 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h23sm6007266pfn.118.2021.03.12.08.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:58:42 -0800 (PST)
Date:   Sat, 13 Mar 2021 00:58:32 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] xfs: stress test for shrinking free space in
 the last AG
Message-ID: <20210312165832.GA287066@xiangao.remote.csb>
References: <20210312132300.259226-1-hsiangkao@redhat.com>
 <20210312132300.259226-4-hsiangkao@redhat.com>
 <20210312161755.GL3499219@localhost.localdomain>
 <20210312161744.GB276830@xiangao.remote.csb>
 <20210312163713.GC8425@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210312163713.GC8425@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 12, 2021 at 08:37:13AM -0800, Darrick J. Wong wrote:
> On Sat, Mar 13, 2021 at 12:17:44AM +0800, Gao Xiang wrote:
> > On Sat, Mar 13, 2021 at 12:17:55AM +0800, Zorro Lang wrote:
> > > On Fri, Mar 12, 2021 at 09:23:00PM +0800, Gao Xiang wrote:
> > > > This adds a stress testcase to shrink free space as much as
> > > > possible in the last AG with background fsstress workload.
> > > > 
> > > > The expectation is that no crash happens with expected output.
> > > > 
> > > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > > ---
> > > > Note that I don't use _fill_fs instead, since fill_scratch here mainly to
> > > > eat 125M to make fsstress more effectively, rather than fill data as
> > > > much as possible.
> > > 
> > > As Darrick had given lots of review points to this case, I just have
> > > 2 picky questions as below:)
> > > 
> > > > 
> > > >  tests/xfs/991     | 121 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/991.out |   8 +++
> > > >  tests/xfs/group   |   1 +
> > > >  3 files changed, 130 insertions(+)
> > > >  create mode 100755 tests/xfs/991
> > > >  create mode 100644 tests/xfs/991.out
> > > > 
> > > > diff --git a/tests/xfs/991 b/tests/xfs/991
> > > > new file mode 100755
> > > > index 00000000..22a5ac81
> > > > --- /dev/null
> > > > +++ b/tests/xfs/991
> > > > @@ -0,0 +1,121 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2020-2021 Red Hat, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test 991
> > > > +#
> > > > +# XFS online shrinkfs stress test
> > > > +#
> > > > +# This test attempts to shrink unused space as much as possible with
> > > > +# background fsstress workload. It will decrease the shrink size if
> > > > +# larger size fails. And totally repeat 2 * TIME_FACTOR times.
> > > > +#
> > > > +seq=`basename $0`
> > > > +seqres=$RESULT_DIR/$seq
> > > > +echo "QA output created by $seq"
> > > > +
> > > > +here=`pwd`
> > > > +tmp=/tmp/$$
> > > > +status=1	# failure is the default!
> > > > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > > > +
> > > > +# get standard environment, filters and checks
> > > > +. ./common/rc
> > > > +. ./common/filter
> > > > +
> > > > +create_scratch()
> > > > +{
> > > > +	_scratch_mkfs_xfs $@ | tee -a $seqres.full | \
> > > > +		_filter_mkfs 2>$tmp.mkfs >/dev/null
> > > > +	. $tmp.mkfs
> > > > +
> > > > +	if ! _try_scratch_mount 2>/dev/null; then
> > > > +		echo "failed to mount $SCRATCH_DEV"
> > > > +		exit 1
> > > > +	fi
> > > > +
> > > > +	# fix the reserve block pool to a known size so that the enospc
> > > > +	# calculations work out correctly.
> > > > +	_scratch_resvblks 1024 > /dev/null 2>&1
> > > > +}
> > > > +
> > > > +fill_scratch()
> > > > +{
> > > > +	$XFS_IO_PROG -f -c "resvsp 0 ${1}" $SCRATCH_MNT/resvfile
> > > > +}
> > > > +
> > > > +stress_scratch()
> > > > +{
> > > > +	procs=3
> > > > +	nops=$((1000 * LOAD_FACTOR))
> > > > +	# -w ensures that the only ops are ones which cause write I/O
> > > > +	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
> > > > +	    -n $nops $FSSTRESS_AVOID`
> > > > +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
> > > > +}
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs xfs
> > > > +_require_scratch
> > > > +_require_xfs_shrink
> > > > +_require_xfs_io_command "falloc"
> > > 
> > > Do I miss something? I only found you use xfs_io "resvsp", why you need "falloc" cmd?
> > 
> > As I mentioned before, the testcase was derived from xfs/104 with some
> > modification.
> > 
> > At a quick glance, this line was added by commit 09e94f84d929 ("xfs: don't
> > assume preallocation is always supported on XFS"). I have no more background
> > yet.
> 
> Why not use xfs_io falloc in the test?  fallocate is the successor to
> resvsp.

Yeah, general falloc seems better, and it seems _require_xfs_io_command here is
used for always_cow inode feature. Will update it. Thanks!

Thanks,
Gao Xiang

> 
> --D

