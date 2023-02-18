Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB014C6379F
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 06:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBRGLX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 01:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjBRGLW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 01:11:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB68B25E02
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676700635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJ2UNpwUhKlTpkBny6N3Ttv/bcvyUY8/AGG3V8QUGWU=;
        b=RfMVCcmt78JsAZqYVz9fulhar2uc+m9FYHz1z9bgxwsTd9Mn2qgGICF5EjWkBzQBIxm8U6
        IFgeyY/Od76fzGr/Bbiv62d6CfJ7zZQ9+f0M3Dv6hdaevs2jcj3QhLy6u0l9208hV9NdF0
        T4EtL9deFNL4ocX2r4IY0BP4P0VlD+0=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-144-pyce1mYsNk-PSmaMboPZ_w-1; Sat, 18 Feb 2023 01:10:33 -0500
X-MC-Unique: pyce1mYsNk-PSmaMboPZ_w-1
Received: by mail-pf1-f198.google.com with SMTP id j10-20020a056a00130a00b0059085684b50so155030pfu.16
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:10:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJ2UNpwUhKlTpkBny6N3Ttv/bcvyUY8/AGG3V8QUGWU=;
        b=DPjrqIKH9/i2eh3kFLe+fYFu8pCLAIDenhRN8AOmgZw+PT2Ik7P3F9C2sWVsLJguEy
         zUFFV5jNgpA+nwTa623CQ817BNknLZKpUS6jeuUWC7VF2gBsqxNHl0agyPDgwz1FNTt4
         V8mbkpC1apxzN1sYwYk76kMed9c5PkAkGk/Blm6IoWRnmAlVtagNhRskC3kR4TJ/xMkl
         ZUw/fqzKhN39FHGb5lhTT9LgZ8hO7+mz/G2mzZm3ANikGy63Wds+kbzDi6ohR2E4v6YL
         bKY5toMM6SV/qS/d9BRpTgEEz8EEJU1qS0QdTNYNIMc72SxsN0h2Vq+AW5EvTeFWa7Gp
         551w==
X-Gm-Message-State: AO0yUKWbNniaRgcPhkZAkqZ3QtHLcebJDycW5mb/83YU6pxWYGBjFlSO
        znsI1k0l8AfeRo80SFNj9NoyUa9gsb0xgqrdtlXkaRalbGUNuDU++ek9C1B3JKGiNhLwo1p2h7f
        LuxMforbrIjRL9OpkL377
X-Received: by 2002:a17:902:ec90:b0:199:527d:42c3 with SMTP id x16-20020a170902ec9000b00199527d42c3mr2875635plg.24.1676700632296;
        Fri, 17 Feb 2023 22:10:32 -0800 (PST)
X-Google-Smtp-Source: AK7set9FHXK22J49eyJQRgwk93aWLXUA4bvzpvCUpWzCIE35qTAY/ccIdpBgRZrVisdzVFMDE8r9vA==
X-Received: by 2002:a17:902:ec90:b0:199:527d:42c3 with SMTP id x16-20020a170902ec9000b00199527d42c3mr2875622plg.24.1676700631929;
        Fri, 17 Feb 2023 22:10:31 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090341c900b0019c33ee4730sm556456ple.146.2023.02.17.22.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 22:10:31 -0800 (PST)
Date:   Sat, 18 Feb 2023 14:10:27 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: race fsstress with online scrub and repair for
 quota metadata
Message-ID: <20230218061027.t3sf6fstrqv2hdcf@zlang-mailbox>
References: <167243876170.726678.17872891128076933126.stgit@magnolia>
 <167243876182.726678.5993728572164871488.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243876182.726678.5993728572164871488.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create tests to race fsstress with dquot repair while running fsstress
> in the background.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/809     |   40 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/809.out |    2 ++
>  tests/xfs/810     |   40 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/810.out |    2 ++
>  tests/xfs/811     |   40 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/811.out |    2 ++
>  6 files changed, 126 insertions(+)
>  create mode 100755 tests/xfs/809
>  create mode 100644 tests/xfs/809.out
>  create mode 100755 tests/xfs/810
>  create mode 100644 tests/xfs/810.out
>  create mode 100755 tests/xfs/811
>  create mode 100644 tests/xfs/811.out
> 
> 
> diff --git a/tests/xfs/809 b/tests/xfs/809
> new file mode 100755
> index 0000000000..35ac02ff85
> --- /dev/null
> +++ b/tests/xfs/809
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 809
> +#
> +# Race fsstress and user quota repair for a while to see if we crash or
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
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" usrquota
> +_scratch_xfs_stress_online_repair -s "repair usrquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/809.out b/tests/xfs/809.out
> new file mode 100644
> index 0000000000..e90865ca8f
> --- /dev/null
> +++ b/tests/xfs/809.out
> @@ -0,0 +1,2 @@
> +QA output created by 809
> +Silence is golden
> diff --git a/tests/xfs/810 b/tests/xfs/810
> new file mode 100755
> index 0000000000..7387910504
> --- /dev/null
> +++ b/tests/xfs/810
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 810
> +#
> +# Race fsstress and group quota repair for a while to see if we crash or
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
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" grpquota
> +_scratch_xfs_stress_online_repair -s "repair grpquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/810.out b/tests/xfs/810.out
> new file mode 100644
> index 0000000000..90f12fdd21
> --- /dev/null
> +++ b/tests/xfs/810.out
> @@ -0,0 +1,2 @@
> +QA output created by 810
> +Silence is golden
> diff --git a/tests/xfs/811 b/tests/xfs/811
> new file mode 100755
> index 0000000000..1e13940b46
> --- /dev/null
> +++ b/tests/xfs/811
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 811
> +#
> +# Race fsstress and project quota repair for a while to see if we crash or
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
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" prjquota
> +_scratch_xfs_stress_online_repair -s "repair prjquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/811.out b/tests/xfs/811.out
> new file mode 100644
> index 0000000000..cf30f69bdc
> --- /dev/null
> +++ b/tests/xfs/811.out
> @@ -0,0 +1,2 @@
> +QA output created by 811
> +Silence is golden
> 

