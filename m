Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD96CC636CC
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Feb 2023 13:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjBENFJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Feb 2023 08:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBENFI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Feb 2023 08:05:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D355AC640
        for <linux-xfs@vger.kernel.org>; Sun,  5 Feb 2023 05:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675602261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z2ZWByRLgjcSLB/HS+AvGjWxosL4LxGH2i/VRn14BNU=;
        b=PiwzbYtxRMnNGBeTcgrrGHGL1N2LLmZKapuPNJRICd5fEjrlQektxrmGJAhsBM90TNRxAF
        mgLrbS8wiOfgLL7hISv5InpqPiYp74LdfnGbsdstSZ3oo0B2yH6Q4zHZhNZERcTfjcZBAx
        J8btBdmHG8+XIHPlup1/iOAphQWGfBA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-35-XKI1uhfwPGKwR4bhpqpazw-1; Sun, 05 Feb 2023 08:04:19 -0500
X-MC-Unique: XKI1uhfwPGKwR4bhpqpazw-1
Received: by mail-pg1-f199.google.com with SMTP id g31-20020a63111f000000b004bbc748ca63so4019459pgl.3
        for <linux-xfs@vger.kernel.org>; Sun, 05 Feb 2023 05:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2ZWByRLgjcSLB/HS+AvGjWxosL4LxGH2i/VRn14BNU=;
        b=ABO35bGqhDUUhA2MERV1JrnfGIpeumb8dKtgRn6m0OdLfb0bqgxJ1UfE58VYE1/jqv
         xQDSWAQpp8M7zUSvkbmASkaA4oDfYQZ5F0uZyjtsg8mtWmrY36O1NAtJ3k4YVMdi5hWR
         Iy7EX5qH/laFKfQkjO9fj/f6LTO0EC6PFGQVBrp0/cJS8MaJ6y3AJfTSKNGiq7OLSJuK
         8Tki5SuoikNxRyL+IhaQCYo7hGU0EuSbQAzpErRdESR+EMldrDqJF4EBx1DpSKjy9+sY
         UmbJzzS4NwI7hvbx6f6AREDFUFQGLjrr5YDrgyqixirX7nFhOeJm0CoVegjynrDt2eKr
         7ajg==
X-Gm-Message-State: AO0yUKUCzHeB9YYWaV82bZm/MpeQ05pvNMz5Bc5NuLCvjZrO4W+m+A+/
        l6i5wpm3QjxLCyYP9MdoeE1/9VvSUr7XUxlJ6MKKBWoeQdf/wd9PIkLSfRvDzRb8Me0SaE3Fjig
        8uIDBx3iNSwld7nKUQOXP
X-Received: by 2002:a17:90b:4f8e:b0:22c:4dd3:5c4b with SMTP id qe14-20020a17090b4f8e00b0022c4dd35c4bmr18248540pjb.19.1675602258197;
        Sun, 05 Feb 2023 05:04:18 -0800 (PST)
X-Google-Smtp-Source: AK7set8rJcjalt1FjZ8nghShuUFvyAof1ZxarCJeIZtW+8Pa7OM3c7cTnKdyHle2MJe3G8qRWoxz/g==
X-Received: by 2002:a17:90b:4f8e:b0:22c:4dd3:5c4b with SMTP id qe14-20020a17090b4f8e00b0022c4dd35c4bmr18248502pjb.19.1675602257566;
        Sun, 05 Feb 2023 05:04:17 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gz10-20020a17090b0eca00b00230a3b016fcsm1124757pjb.10.2023.02.05.05.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Feb 2023 05:04:17 -0800 (PST)
Date:   Sun, 5 Feb 2023 21:04:12 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: race fsstress with online scrubbers for AG and
 fs metadata
Message-ID: <20230205130412.ksbvasc5ih4tr4a2@zlang-mailbox>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
 <167243874639.722028.9759938995780056273.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243874639.722028.9759938995780056273.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For each XFS_SCRUB_TYPE_* that looks at AG or filesystem metadata,
> create a test that runs that scrubber in the foreground and fsstress in
> the background.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/quota        |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  doc/group-names.txt |    1 +

[snip]

> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index ac219e05b3..771ce937ae 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -35,6 +35,7 @@ dangerous_fuzzers	fuzzers that can crash your computer
>  dangerous_norepair	fuzzers to evaluate kernel metadata verifiers
>  dangerous_online_repair	fuzzers to evaluate xfs_scrub online repair
>  dangerous_fsstress_repair	race fsstress and xfs_scrub online repair
> +dangerous_fsstress_scrub	race fsstress and xfs_scrub checking

We've added this group name, so this patch will hit conflict. But I think I
can use `git am --3way ...` to apply this patch forcibly :)

Thanks,
Zorro

>  dangerous_repair	fuzzers to evaluate xfs_repair offline repair
>  dangerous_scrub		fuzzers to evaluate xfs_scrub checking
>  data			data loss checkers
> diff --git a/tests/xfs/782 b/tests/xfs/782
> new file mode 100755
> index 0000000000..4801eda4bd
> --- /dev/null
> +++ b/tests/xfs/782
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 782
> +#
> +# Race fsstress and superblock scrub for a while to see if we crash or livelock.
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub sb %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/782.out b/tests/xfs/782.out
> new file mode 100644
> index 0000000000..6e378f0e53
> --- /dev/null
> +++ b/tests/xfs/782.out
> @@ -0,0 +1,2 @@
> +QA output created by 782
> +Silence is golden
> diff --git a/tests/xfs/783 b/tests/xfs/783
> new file mode 100755
> index 0000000000..379a9369e5
> --- /dev/null
> +++ b/tests/xfs/783
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 783
> +#
> +# Race fsstress and AGF scrub for a while to see if we crash or livelock.
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub agf %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/783.out b/tests/xfs/783.out
> new file mode 100644
> index 0000000000..2522395956
> --- /dev/null
> +++ b/tests/xfs/783.out
> @@ -0,0 +1,2 @@
> +QA output created by 783
> +Silence is golden
> diff --git a/tests/xfs/784 b/tests/xfs/784
> new file mode 100755
> index 0000000000..2b89361c36
> --- /dev/null
> +++ b/tests/xfs/784
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 784
> +#
> +# Race fsstress and AGFL scrub for a while to see if we crash or livelock.
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub agfl %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/784.out b/tests/xfs/784.out
> new file mode 100644
> index 0000000000..48d9b24dd0
> --- /dev/null
> +++ b/tests/xfs/784.out
> @@ -0,0 +1,2 @@
> +QA output created by 784
> +Silence is golden
> diff --git a/tests/xfs/785 b/tests/xfs/785
> new file mode 100755
> index 0000000000..34a13b058d
> --- /dev/null
> +++ b/tests/xfs/785
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 785
> +#
> +# Race fsstress and AGI scrub for a while to see if we crash or livelock.
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub agi %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/785.out b/tests/xfs/785.out
> new file mode 100644
> index 0000000000..6ecb0c61b3
> --- /dev/null
> +++ b/tests/xfs/785.out
> @@ -0,0 +1,2 @@
> +QA output created by 785
> +Silence is golden
> diff --git a/tests/xfs/786 b/tests/xfs/786
> new file mode 100755
> index 0000000000..157200ea8c
> --- /dev/null
> +++ b/tests/xfs/786
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 786
> +#
> +# Race fsstress and freespace by block btree scrub for a while to see if we
> +# crash or livelock.
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub bnobt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/786.out b/tests/xfs/786.out
> new file mode 100644
> index 0000000000..ccb9167df9
> --- /dev/null
> +++ b/tests/xfs/786.out
> @@ -0,0 +1,2 @@
> +QA output created by 786
> +Silence is golden
> diff --git a/tests/xfs/787 b/tests/xfs/787
> new file mode 100755
> index 0000000000..91eaf5a7af
> --- /dev/null
> +++ b/tests/xfs/787
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 787
> +#
> +# Race fsstress and free space by length btree scrub for a while to see if we
> +# crash or livelock.
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub cntbt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/787.out b/tests/xfs/787.out
> new file mode 100644
> index 0000000000..fa7f038120
> --- /dev/null
> +++ b/tests/xfs/787.out
> @@ -0,0 +1,2 @@
> +QA output created by 787
> +Silence is golden
> diff --git a/tests/xfs/788 b/tests/xfs/788
> new file mode 100755
> index 0000000000..f1369e5309
> --- /dev/null
> +++ b/tests/xfs/788
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 788
> +#
> +# Race fsstress and inode btree scrub for a while to see if we crash or
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -x 'dir' -s "scrub inobt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/788.out b/tests/xfs/788.out
> new file mode 100644
> index 0000000000..5ddd661113
> --- /dev/null
> +++ b/tests/xfs/788.out
> @@ -0,0 +1,2 @@
> +QA output created by 788
> +Silence is golden
> diff --git a/tests/xfs/789 b/tests/xfs/789
> new file mode 100755
> index 0000000000..550ff2c690
> --- /dev/null
> +++ b/tests/xfs/789
> @@ -0,0 +1,39 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 789
> +#
> +# Race fsstress and free inode btree scrub for a while to see if we crash or
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" finobt
> +_scratch_xfs_stress_scrub -x 'dir' -s "scrub finobt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/789.out b/tests/xfs/789.out
> new file mode 100644
> index 0000000000..da88fc99cb
> --- /dev/null
> +++ b/tests/xfs/789.out
> @@ -0,0 +1,2 @@
> +QA output created by 789
> +Silence is golden
> diff --git a/tests/xfs/790 b/tests/xfs/790
> new file mode 100755
> index 0000000000..c4e5779ef7
> --- /dev/null
> +++ b/tests/xfs/790
> @@ -0,0 +1,39 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 790
> +#
> +# Race fsstress and reverse mapping btree scrub for a while to see if we crash
> +# or livelock.
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" rmapbt
> +_scratch_xfs_stress_scrub -s "scrub rmapbt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/790.out b/tests/xfs/790.out
> new file mode 100644
> index 0000000000..7102c590f0
> --- /dev/null
> +++ b/tests/xfs/790.out
> @@ -0,0 +1,2 @@
> +QA output created by 790
> +Silence is golden
> diff --git a/tests/xfs/791 b/tests/xfs/791
> new file mode 100755
> index 0000000000..6939d910c9
> --- /dev/null
> +++ b/tests/xfs/791
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 791
> +#
> +# Race fsstress and reference count btree scrub for a while to see if we crash
> +# or livelock.
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
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" reflink
> +_scratch_xfs_stress_scrub -s "scrub refcountbt %agno%"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/791.out b/tests/xfs/791.out
> new file mode 100644
> index 0000000000..758905371d
> --- /dev/null
> +++ b/tests/xfs/791.out
> @@ -0,0 +1,2 @@
> +QA output created by 791
> +Silence is golden
> diff --git a/tests/xfs/798 b/tests/xfs/798
> new file mode 100755
> index 0000000000..c5bdfad50a
> --- /dev/null
> +++ b/tests/xfs/798
> @@ -0,0 +1,44 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 798
> +#
> +# Race fsstress and fscounter scrub on the realtime device for a while to see
> +# if we crash or livelock.
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_realtime
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> +
> +# Force all files to be allocated on the realtime device
> +_xfs_force_bdev realtime $SCRATCH_MNT
> +
> +_scratch_xfs_stress_scrub -s 'scrub fscounters'
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/798.out b/tests/xfs/798.out
> new file mode 100644
> index 0000000000..216d6e93f4
> --- /dev/null
> +++ b/tests/xfs/798.out
> @@ -0,0 +1,2 @@
> +QA output created by 798
> +Silence is golden
> diff --git a/tests/xfs/800 b/tests/xfs/800
> new file mode 100755
> index 0000000000..cbcfb5f5a6
> --- /dev/null
> +++ b/tests/xfs/800
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 800
> +#
> +# Race fsstress and realtime bitmap scrub for a while to see if we crash or
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_realtime
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> +_scratch_xfs_stress_scrub -s "scrub rtbitmap"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/800.out b/tests/xfs/800.out
> new file mode 100644
> index 0000000000..bdfaa2cecd
> --- /dev/null
> +++ b/tests/xfs/800.out
> @@ -0,0 +1,2 @@
> +QA output created by 800
> +Silence is golden
> diff --git a/tests/xfs/801 b/tests/xfs/801
> new file mode 100755
> index 0000000000..a51fab523b
> --- /dev/null
> +++ b/tests/xfs/801
> @@ -0,0 +1,47 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 801
> +#
> +# Race fsstress and realtime summary scrub for a while to see if we crash or
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_realtime
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_xfs_has_feature "$SCRATCH_MNT" realtime
> +
> +# XXX the realtime summary scrubber isn't currently implemented upstream.
> +# Don't bother trying to test it on those kernels
> +$XFS_IO_PROG -c 'scrub rtsummary' -c 'scrub rtsummary' "$SCRATCH_MNT" 2>&1 | \
> +	grep -q 'Scan was not complete' && \
> +	_notrun "rtsummary scrub is incomplete"
> +
> +_scratch_xfs_stress_scrub -s "scrub rtsummary"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/801.out b/tests/xfs/801.out
> new file mode 100644
> index 0000000000..39481b38e2
> --- /dev/null
> +++ b/tests/xfs/801.out
> @@ -0,0 +1,2 @@
> +QA output created by 801
> +Silence is golden
> diff --git a/tests/xfs/802 b/tests/xfs/802
> new file mode 100755
> index 0000000000..1f3b83882e
> --- /dev/null
> +++ b/tests/xfs/802
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 802
> +#
> +# Race fsstress and user quota scrub for a while to see if we crash or
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
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" usrquota
> +_scratch_xfs_stress_scrub -s "scrub usrquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/802.out b/tests/xfs/802.out
> new file mode 100644
> index 0000000000..a69c05391f
> --- /dev/null
> +++ b/tests/xfs/802.out
> @@ -0,0 +1,2 @@
> +QA output created by 802
> +Silence is golden
> diff --git a/tests/xfs/803 b/tests/xfs/803
> new file mode 100755
> index 0000000000..b2bb85672d
> --- /dev/null
> +++ b/tests/xfs/803
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 803
> +#
> +# Race fsstress and group quota scrub for a while to see if we crash or
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
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" grpquota
> +_scratch_xfs_stress_scrub -s "scrub grpquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/803.out b/tests/xfs/803.out
> new file mode 100644
> index 0000000000..38ba741d0f
> --- /dev/null
> +++ b/tests/xfs/803.out
> @@ -0,0 +1,2 @@
> +QA output created by 803
> +Silence is golden
> diff --git a/tests/xfs/804 b/tests/xfs/804
> new file mode 100755
> index 0000000000..129724eb11
> --- /dev/null
> +++ b/tests/xfs/804
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 804
> +#
> +# Race fsstress and project quota scrub for a while to see if we crash or
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
> +_require_xfs_quota_acct_enabled "$SCRATCH_DEV" prjquota
> +_scratch_xfs_stress_scrub -s "scrub prjquota"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/804.out b/tests/xfs/804.out
> new file mode 100644
> index 0000000000..5e0cb437e7
> --- /dev/null
> +++ b/tests/xfs/804.out
> @@ -0,0 +1,2 @@
> +QA output created by 804
> +Silence is golden
> diff --git a/tests/xfs/805 b/tests/xfs/805
> new file mode 100755
> index 0000000000..aca9b9cdf4
> --- /dev/null
> +++ b/tests/xfs/805
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 805
> +#
> +# Race fsstress and summary counters scrub for a while to see if we crash or
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_scrub
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_scrub -s "scrub fscounters"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/805.out b/tests/xfs/805.out
> new file mode 100644
> index 0000000000..ac324c5874
> --- /dev/null
> +++ b/tests/xfs/805.out
> @@ -0,0 +1,2 @@
> +QA output created by 805
> +Silence is golden
> 

