Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AE8C61DA4
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 06:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBRGNq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 01:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBRGNq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 01:13:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A895454E
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676700784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DlhZHif87k19Wtyw3lzpfAlaCH1LATq/sslPtMpHTBM=;
        b=BL8l29vw/HbYte/7OSuSC3e7Zucmh+RR5OV5f3F/IQALzrsIq0fGJHUYK0uLqpNTzXYMjJ
        C/jpNVeHjF2OB5sFTWRZ3X2bhGwZI7WTYOObe8BFRuR9aV4nO6yUVeoteBOlb8PC5b1Uqk
        REQUWKBGhUI8ExVKfbTFOTVZ2fdlmi4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-463-sSocd2gaNIS3ckVUW7SKYg-1; Sat, 18 Feb 2023 01:13:02 -0500
X-MC-Unique: sSocd2gaNIS3ckVUW7SKYg-1
Received: by mail-pf1-f199.google.com with SMTP id n43-20020a056a000d6b00b005a98bc9e79dso44901pfv.0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:13:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlhZHif87k19Wtyw3lzpfAlaCH1LATq/sslPtMpHTBM=;
        b=jJNJk9GaVIYZHa7Hz/Ry5ilYdTLPfe/jTV+0/30t7ZV/mZy59q5Wui4s5a8qXk5Otf
         y8sDzWXBjbDkHgxNXZHi4/Ea2GHPq1aph0MWgPQwvsRDzcQto+cXY8zWVMhiOimPC1JC
         dPfoyNSC7fCfcbyjr00/NErC0Ofr3UZTAkyO1OdYvw1kXqGZcj+udV4pM6FfvI8oVP4F
         0HDNnvedP4NMybFkNflusFUX/V3xf/20Q2EMPGPkbPJ1wMgSIEOhdC9tNh7Q5EbYal2t
         eTMMm6GzxQzBIGFz+KsKLrgW/Cli8qLZp3YJn4eKFehHFxPfglhhR4XdWXOXdyIyskIH
         HXGQ==
X-Gm-Message-State: AO0yUKVAP61Pe5Mrs6zY+VKP1NWI84P1UwI0xXMuOe72LeJb95Hp/lno
        Gg9AVf8m4bQxMPsz8GXEGzjkY+ectCIG1/sHFWyf+yQdgo4kyzdPxOnf3tYQWGNvYi1u6CCn2PU
        m+LE19R+KanPa3qTrD1cONGc/719D
X-Received: by 2002:a62:190a:0:b0:5a8:abd2:2beb with SMTP id 10-20020a62190a000000b005a8abd22bebmr3741131pfz.30.1676700781542;
        Fri, 17 Feb 2023 22:13:01 -0800 (PST)
X-Google-Smtp-Source: AK7set/ZfShrd7Qw1U/ei83DMpg4KvM8qa/HqNPzPMTMln8YlYHP0gBKfP0qCUb0VZCEaYnDwuEiLQ==
X-Received: by 2002:a62:190a:0:b0:5a8:abd2:2beb with SMTP id 10-20020a62190a000000b005a8abd22bebmr3741117pfz.30.1676700781154;
        Fri, 17 Feb 2023 22:13:01 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 3-20020aa79203000000b005931a44a239sm3942166pfo.112.2023.02.17.22.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 22:13:00 -0800 (PST)
Date:   Sat, 18 Feb 2023 14:12:56 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: race fsstress with online scrub and repair for
 quotacheck
Message-ID: <20230218061256.dqolmvai4b2ugegr@zlang-mailbox>
References: <167243876462.727185.1053988846654244651.stgit@magnolia>
 <167243876474.727185.6330332863953257231.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243876474.727185.6330332863953257231.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create tests to race fsstress with quota count check and repair while
> running fsstress in the background.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/715     |   40 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/715.out |    2 ++
>  tests/xfs/812     |   40 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/812.out |    2 ++
>  4 files changed, 84 insertions(+)
>  create mode 100755 tests/xfs/715
>  create mode 100644 tests/xfs/715.out
>  create mode 100755 tests/xfs/812
>  create mode 100644 tests/xfs/812.out
> 
> 
> diff --git a/tests/xfs/715 b/tests/xfs/715
> new file mode 100755
> index 0000000000..eca979b297
> --- /dev/null
> +++ b/tests/xfs/715
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 715
> +#
> +# Race fsstress and quotacheck repair for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest online_repair dangerous_fsstress_repair
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_online_repair
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" any
> +_scratch_xfs_stress_online_repair -s "repair quotacheck"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/715.out b/tests/xfs/715.out
> new file mode 100644
> index 0000000000..b5947d898b
> --- /dev/null
> +++ b/tests/xfs/715.out
> @@ -0,0 +1,2 @@
> +QA output created by 715
> +Silence is golden
> diff --git a/tests/xfs/812 b/tests/xfs/812
> new file mode 100755
> index 0000000000..f84494e392
> --- /dev/null
> +++ b/tests/xfs/812
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 812
> +#
> +# Race fsstress and quotacheck scrub for a while to see if we crash or
> +# livelock.
> +#
> +. ./common/preamble
> +_begin_fstest scrub dangerous_fsstress_scrub
> +
> +_cleanup() {
> +	_scratch_xfs_stress_scrub_cleanup &> /dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +_register_cleanup "_cleanup" BUS
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/fuzzy
> +. ./common/inject
> +. ./common/xfs
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" any
> +_scratch_xfs_stress_scrub -s "scrub quotacheck"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/812.out b/tests/xfs/812.out
> new file mode 100644
> index 0000000000..d8dbb15dc7
> --- /dev/null
> +++ b/tests/xfs/812.out
> @@ -0,0 +1,2 @@
> +QA output created by 812
> +Silence is golden
> 

