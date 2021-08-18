Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72724C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 05:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B81D6108E
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 05:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbhHRFzg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 01:55:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237788AbhHRFzg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 01:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629266101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HGibj+bekp5G7aUKRNN9LikgLkfxr5xk/F8FQJV5DvM=;
        b=ikBhEhjKeUVaHDkQkS4blXeCT/+tSliWfexecwN4FZnPLrDb4abNG9w1oZwDxnToNsJAeU
        r3HxD0jra2vd3nopqraeldHXIoM8ykXGkuvNKboTPormQ0NATS6bFeLUB2y/oVuGHmOsWk
        4MM2APFyZVEP+uQ9vNO9ZXUJ5JBe7JU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-wzmAaayZOB2_68WN9-UJGA-1; Wed, 18 Aug 2021 01:54:57 -0400
X-MC-Unique: wzmAaayZOB2_68WN9-UJGA-1
Received: by mail-pg1-f199.google.com with SMTP id t10-20020a63eb0a000000b0025243699e3cso790916pgh.2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Aug 2021 22:54:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=HGibj+bekp5G7aUKRNN9LikgLkfxr5xk/F8FQJV5DvM=;
        b=RKNGAoXRQylTL4FsvXT1tmyzhfxQvwOTPM74WLZq9rnfF3G5H5Vl30FKTg6hS+mMl1
         b69Q6bm9xy+Tfs62AArGnacTbXGGIrCbCvScHt6cKb2AFmFl4ON16uckw4hOM4DnA1wu
         lgDistBl6WoFnHYa/n0dIFestbmGnylXZqeBRO658t8sUuw6yYXKdnfuRFGbx0//asNW
         N0Yn6Yqy9wTFvjQE7F2zsv1pabmHWzciYnrOEgKfUnVTnKBaVClABIFEOtmsdUoxszPL
         dGmI9JEb7/3e/4aX/+8se4TYRgEeE29A4swNxHSQ7EK9ujAm9Vj8rO6LXU3CnfxLvhdw
         N5+Q==
X-Gm-Message-State: AOAM530xnIOo60Ij11NCj7Z5eBibFYHCUYfddFQC22+teDC3D4tysOZg
        pqiIVrfudTP/TZ4lvrA+yO/EHB789gdn3Q64x+cBj2NtdE69Ra8LMea9MFcVllm3YYoELLpo/9f
        d/5wmTXHiBTjrBOo3tDU4
X-Received: by 2002:a17:90b:360a:: with SMTP id ml10mr7488563pjb.134.1629266096402;
        Tue, 17 Aug 2021 22:54:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4dOy0ERRSyzRdKCMkQImcrOcNLWhRyXu1/P3hHtG8q4zNiwGDoaqm+J/yqluWYPLGyBw0XA==
X-Received: by 2002:a17:90b:360a:: with SMTP id ml10mr7488541pjb.134.1629266096092;
        Tue, 17 Aug 2021 22:54:56 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t30sm5443161pgl.47.2021.08.17.22.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 22:54:55 -0700 (PDT)
Date:   Wed, 18 Aug 2021 14:07:37 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] generic: fsstress with cpu offlining
Message-ID: <20210818060737.bi5ulz43robj3i7v@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162924439425.779465.16029390956507261795.stgit@magnolia>
 <162924439973.779465.13771500926240153773.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924439973.779465.13771500926240153773.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:53:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Exercise filesystem operations when we're taking CPUs online and offline
> throughout the test.

Just ask, is this test cover something (commits)?

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/726     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/726.out |    2 +
>  2 files changed, 73 insertions(+)
>  create mode 100755 tests/generic/726
>  create mode 100644 tests/generic/726.out
> 
> 
> diff --git a/tests/generic/726 b/tests/generic/726
> new file mode 100755
> index 00000000..4b072b7f
> --- /dev/null
> +++ b/tests/generic/726
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 726
> +#
> +# Run an all-writes fsstress run with multiple threads while exercising CPU
> +# hotplugging to shake out bugs in the write path.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1

At least there's "exercise_cpu_hotplug &", should we wait at here? Even we removed
$tmp.hotplug, can't make sure the process is over.

> +	for i in "$sysfs_cpu_dir/"cpu*/online; do
> +		echo 1 > "$i" 2>/dev/null
> +	done
> +}
> +
> +exercise_cpu_hotplug()
> +{
> +	while [ -e $sentinel_file ]; do
> +		local idx=$(( RANDOM % nr_hotplug_cpus ))
> +		local cpu="${hotplug_cpus[idx]}"
> +		local action=$(( RANDOM % 2 ))
> +
> +		echo "$action" > "$sysfs_cpu_dir/cpu$cpu/online" 2>/dev/null
> +		sleep 0.5
> +	done
> +}
> +
> +# Import common functions.
> +
> +# Modify as appropriate.

Two useless comments at here?

> +_supported_fs generic
> +
> +sysfs_cpu_dir="/sys/devices/system/cpu"
> +
> +# Figure out which CPU(s) support hotplug.
> +nrcpus=$(getconf _NPROCESSORS_CONF)
> +hotplug_cpus=()
> +for ((i = 0; i < nrcpus; i++ )); do
> +	test -e "$sysfs_cpu_dir/cpu$i/online" && hotplug_cpus+=("$i")
> +done
> +nr_hotplug_cpus="${#hotplug_cpus[@]}"
> +test "$nr_hotplug_cpus" -gt 0 || _notrun "CPU hotplugging not supported"

Is that worth being a helper?

> +
> +_require_scratch
> +_require_command "$KILLALL_PROG" "killall"
> +
> +echo "Silence is golden."
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +sentinel_file=$tmp.hotplug
> +touch $sentinel_file
> +exercise_cpu_hotplug &
> +
> +nr_cpus=$((LOAD_FACTOR * 4))
> +nr_ops=$((10000 * nr_cpus * TIME_FACTOR))
> +$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
> +rm -f $sentinel_file
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/726.out b/tests/generic/726.out
> new file mode 100644
> index 00000000..6839f8ce
> --- /dev/null
> +++ b/tests/generic/726.out
> @@ -0,0 +1,2 @@
> +QA output created by 726
> +Silence is golden.
> 

