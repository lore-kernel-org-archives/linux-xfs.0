Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B30C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 06:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C8460FDA
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 06:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbhHRGVD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 02:21:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238480AbhHRGUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 02:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629267612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N0yHZUb2T6WsjKUs8iXTq9knWaGQwHJZeQECUOJFj3s=;
        b=bWVfp6FPaF3tSzvBg8QTUX+MPSFd3ladRd8m+GZ0Ec9/pfn5PW4jeOEOC32IdH79uVL+8u
        M/It5y8AWWMIjFPHFHvpf6IAwBmuvyEY6GA7uq3jW8vgqP9Mk3fYwUsKtsa1IzSR3285Ga
        OfMKNW+dE4tt5gvUy4ZSaiKWhqz/G5U=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-Kf5H4bYEPsiqlsQrL_Lm5A-1; Wed, 18 Aug 2021 02:20:10 -0400
X-MC-Unique: Kf5H4bYEPsiqlsQrL_Lm5A-1
Received: by mail-pg1-f199.google.com with SMTP id r21-20020a63d9150000b029023ccd23c20cso827919pgg.19
        for <linux-xfs@vger.kernel.org>; Tue, 17 Aug 2021 23:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=N0yHZUb2T6WsjKUs8iXTq9knWaGQwHJZeQECUOJFj3s=;
        b=fKYtnftpk6elXc78n4oA4XCiR2srQP3DxNlii3tzVFy8TTuhoHgCCeZ9uSc1xRtiwB
         O8u9x8d0JNGQXQ2TG7zz3ZrW/9MOOAIc7647pCqu8qc8EsAjpIDX8Ot7J0t4U5odIU9p
         j5ZXHc4GVqBCE3re8LJlfKJDL8ijdh5pypvT/jFhGYIm+b9vya9OHR2jjJN3KkNCNVtJ
         A64XlG6+/RddU73N9A7M0MVIqBm9R6GhxayT902OPrc3Xc+xL+Jyhs8jLEmkqPHp89Vl
         euXrFJvPsYu5nX/RbZelZqTxwxwzB8Az9301XRltnyJ5AlLhBb+EBCcv/73NznsNU/Fj
         yz+g==
X-Gm-Message-State: AOAM532PzXZhse4XJ/8c3r92OYrbTYxNkDQaa/2Jduc5GBClibh8mInm
        3qqprLyPLCZ5Qzf5icYZKLThOty8q/xTOvVgkyGCy8J0mFSBW2/RkxljZcm6ZygV2APst6EXO0Z
        fOFN0vwjldVf3Nc3F8fnO
X-Received: by 2002:a17:90b:1102:: with SMTP id gi2mr7652439pjb.43.1629267608988;
        Tue, 17 Aug 2021 23:20:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwp0DYQ+mCM+gLdN6r6Sme1T7Nsu+npPVo/MPngypIZWIw3u6kLGO2Ml8UhrLJxJ7e3fTxNZg==
X-Received: by 2002:a17:90b:1102:: with SMTP id gi2mr7652416pjb.43.1629267608684;
        Tue, 17 Aug 2021 23:20:08 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o1sm4692953pfd.129.2021.08.17.23.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:20:08 -0700 (PDT)
Date:   Wed, 18 Aug 2021 14:32:49 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] generic: fsstress with cpu offlining
Message-ID: <20210818063249.box2au5yz2afvszi@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162924439425.779465.16029390956507261795.stgit@magnolia>
 <162924439973.779465.13771500926240153773.stgit@magnolia>
 <20210818060737.bi5ulz43robj3i7v@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818060737.bi5ulz43robj3i7v@fedora>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 02:07:37PM +0800, Zorro Lang wrote:
> On Tue, Aug 17, 2021 at 04:53:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Exercise filesystem operations when we're taking CPUs online and offline
> > throughout the test.
> 
> Just ask, is this test cover something (commits)?
> 
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/726     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/726.out |    2 +
> >  2 files changed, 73 insertions(+)
> >  create mode 100755 tests/generic/726
> >  create mode 100644 tests/generic/726.out
> > 
> > 
> > diff --git a/tests/generic/726 b/tests/generic/726
> > new file mode 100755
> > index 00000000..4b072b7f
> > --- /dev/null
> > +++ b/tests/generic/726
> > @@ -0,0 +1,71 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 726
> > +#
> > +# Run an all-writes fsstress run with multiple threads while exercising CPU
> > +# hotplugging to shake out bugs in the write path.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto rw

Oh, I think it can be in 'stress' group, due to it's a fsstress random test, and
it really takes long time on my system (with 24 cpus):

generic/726      1041s

And might take more time :)

Thanks,
Zorro

> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> 
> At least there's "exercise_cpu_hotplug &", should we wait at here? Even we removed
> $tmp.hotplug, can't make sure the process is over.
> 
> > +	for i in "$sysfs_cpu_dir/"cpu*/online; do
> > +		echo 1 > "$i" 2>/dev/null
> > +	done
> > +}
> > +
> > +exercise_cpu_hotplug()
> > +{
> > +	while [ -e $sentinel_file ]; do
> > +		local idx=$(( RANDOM % nr_hotplug_cpus ))
> > +		local cpu="${hotplug_cpus[idx]}"
> > +		local action=$(( RANDOM % 2 ))
> > +
> > +		echo "$action" > "$sysfs_cpu_dir/cpu$cpu/online" 2>/dev/null
> > +		sleep 0.5
> > +	done
> > +}
> > +
> > +# Import common functions.
> > +
> > +# Modify as appropriate.
> 
> Two useless comments at here?
> 
> > +_supported_fs generic
> > +
> > +sysfs_cpu_dir="/sys/devices/system/cpu"
> > +
> > +# Figure out which CPU(s) support hotplug.
> > +nrcpus=$(getconf _NPROCESSORS_CONF)
> > +hotplug_cpus=()
> > +for ((i = 0; i < nrcpus; i++ )); do
> > +	test -e "$sysfs_cpu_dir/cpu$i/online" && hotplug_cpus+=("$i")
> > +done
> > +nr_hotplug_cpus="${#hotplug_cpus[@]}"
> > +test "$nr_hotplug_cpus" -gt 0 || _notrun "CPU hotplugging not supported"
> 
> Is that worth being a helper?
> 
> > +
> > +_require_scratch
> > +_require_command "$KILLALL_PROG" "killall"
> > +
> > +echo "Silence is golden."
> > +
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount >> $seqres.full 2>&1
> > +
> > +sentinel_file=$tmp.hotplug
> > +touch $sentinel_file
> > +exercise_cpu_hotplug &
> > +
> > +nr_cpus=$((LOAD_FACTOR * 4))
> > +nr_ops=$((10000 * nr_cpus * TIME_FACTOR))
> > +$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
> > +rm -f $sentinel_file
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/726.out b/tests/generic/726.out
> > new file mode 100644
> > index 00000000..6839f8ce
> > --- /dev/null
> > +++ b/tests/generic/726.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 726
> > +Silence is golden.
> > 

