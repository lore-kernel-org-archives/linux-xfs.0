Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8749EC6379F
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 06:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBRGNQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 01:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBRGNP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 01:13:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DC21114E
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676700747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qJ2UNpwUhKlTpkBny6N3Ttv/bcvyUY8/AGG3V8QUGWU=;
        b=YD5CEne9ciIt/aixQtCUGfTTfoEAqlL7Fy/2ykwFV3sCK6Lgxb3Y3g8pw13TVcL4eOPnPh
        nWKvvnvDbdcQ0+JHH7N5bnI0sNJls8iMThCa7s4xRswH/qGhKrmwdjwzW0e4Slbvr6wuR3
        SfwWzyAg/ePKZ5K/Sh8hw/4iJ1bukoI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-XxQMGz1CMGOBOXinq1ndZg-1; Sat, 18 Feb 2023 01:12:26 -0500
X-MC-Unique: XxQMGz1CMGOBOXinq1ndZg-1
Received: by mail-pl1-f198.google.com with SMTP id u15-20020a17090341cf00b0019a8c8a13dfso74469ple.16
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:12:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJ2UNpwUhKlTpkBny6N3Ttv/bcvyUY8/AGG3V8QUGWU=;
        b=bMkGTR95wRzdsXAoWXXUqzW7s16tqAPofebB5byO0Yw33UeMthLmmrnMy04Xq7iYNG
         2aQy96iPpwur2D1A7veAXLLbkI8KMcu3DP1K8p/zyuD1Qjzzqb9j2Jxe48EV2khVCuuw
         4W+D6hXnqk3FwtDGWiasKfaBBlonb95fAlmHKsQMjpCNVqyZJMO70xD1mJfHlBgXUoG9
         zMFa4WCNBjQcEoNwQrYGF3jDxJF/x5CwnUH0qLjEyLWX0AHo3KiedTxs3+4rw9M01O+a
         cMVFFIkJuD/cVv8ycfdQeaY6nH6P7DEniJ7XIwlVGBmX3S+3EYwcZPdOchLIoK2zWuuV
         IbEg==
X-Gm-Message-State: AO0yUKVXgnJSMNN44suBKFAcqigpE/7mravJF90WiWB/8abc5E0g3Q1x
        8qzwNxmp8y99h3fmQsagbcUI9gn6/M/asRPPyH/mtmBQknkx4c7kYoD3ye8fMS0/u5qEU6L7/Y0
        FVytw1V3exizI3X0vDPG2
X-Received: by 2002:a17:902:7845:b0:19b:2332:18cb with SMTP id e5-20020a170902784500b0019b233218cbmr295583pln.1.1676700744554;
        Fri, 17 Feb 2023 22:12:24 -0800 (PST)
X-Google-Smtp-Source: AK7set/PeyCZw+lPD/qnB1SDtCuAuak2cMXPyEbMEzgOpor5sik1avB6A6EHw2DUmm/kh38IMx/XYg==
X-Received: by 2002:a17:902:7845:b0:19b:2332:18cb with SMTP id e5-20020a170902784500b0019b233218cbmr295571pln.1.1676700744129;
        Fri, 17 Feb 2023 22:12:24 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id r6-20020a170902be0600b00198b0fd363bsm4022720pls.45.2023.02.17.22.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 22:12:23 -0800 (PST)
Date:   Sat, 18 Feb 2023 14:12:20 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: race fsstress with online scrub and repair for
 quota metadata
Message-ID: <20230218061220.4vhtu5mw7yemwi52@zlang-mailbox>
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

