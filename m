Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3D8FC64ED6
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 06:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBRGOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 01:14:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBRGOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 01:14:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C730E56EC2
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676700812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bsr+sO51R/lQSQ21dm/CQGaMy59u8vOfATe3UnBS+i8=;
        b=G7n7dYaes8Hg8LoadqQC0d2P39r+dqfG0DQhGq0UGmE5UM4yi3FHhh3CiaDSrvmG4cWS/I
        mCPaiPBESSmIEu/5ef8ZI6i4zM4KGpjiwpy9D+DO1dFWVAOnZ5xz3GexuQ0zG/PX4I8h5G
        mwkGMJWHf9f8C+yAtVDaTn66mL0+a8g=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-Qti1t1_KPp23jWmnw_VZXw-1; Sat, 18 Feb 2023 01:13:30 -0500
X-MC-Unique: Qti1t1_KPp23jWmnw_VZXw-1
Received: by mail-pl1-f197.google.com with SMTP id d18-20020a170902729200b0019ac5d9fdb3so110388pll.9
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:13:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bsr+sO51R/lQSQ21dm/CQGaMy59u8vOfATe3UnBS+i8=;
        b=irduvty4UhNcWVsVDjsEu+s5Ai5hEma3xMkpgIToIqkbSiofB1hUm6m7hcOQSsJo2E
         pogurUTzokrO+fEGFoAyMiUxwBfUcGAoGK0kwkCMRq/kA7Vb6w9HS1oTowmOS06E7nkB
         miPz0ZgEwTeUpqs5gBxBqUO40U10BAscpqeaSMGNSwcax+F075l3B4myiN7f+KK5TUu+
         pMspr+pxsXbNg500reExN6XfKMRiqmBJTbRaAOQzRCwkM4h4ItPf1YK6YVqcUQ/HVzE1
         DSIwKO7hUItRTY2OymstuO/mr1UOwKDnsSvowDXID8vDqPiJTrEm2mWxxRU2XNGcvnLh
         4Ywg==
X-Gm-Message-State: AO0yUKU+jfK/s6JWJ86Y/ixgA3URvO867dIu1lv0c7Q3j1rZFL1RuPJ5
        IyAMbT4WWBbtnCNUJLmbQ9twUGY+FVE1Nm3NSJIvMJ11NblXMWy7FhCPRk2+qcNV6DBlXJqP+3u
        WT1agIk9InC0AZW5zCrgS
X-Received: by 2002:a17:902:e492:b0:19b:3549:1eb with SMTP id i18-20020a170902e49200b0019b354901ebmr4698847ple.48.1676700809529;
        Fri, 17 Feb 2023 22:13:29 -0800 (PST)
X-Google-Smtp-Source: AK7set++zuzSIeW6nOfPJo7T5sEz0ZInytQKfHBzoP31XtUYsWp9td0aRZpdxEnJj4Lfzvde5PxeqA==
X-Received: by 2002:a17:902:e492:b0:19b:3549:1eb with SMTP id i18-20020a170902e49200b0019b354901ebmr4698836ple.48.1676700809167;
        Fri, 17 Feb 2023 22:13:29 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ff0200b0019a7f493151sm4007165plj.212.2023.02.17.22.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 22:13:28 -0800 (PST)
Date:   Sat, 18 Feb 2023 14:13:25 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: race fsstress with inode link count check and
 repair
Message-ID: <20230218061325.3pl6vpzr53bht2t4@zlang-mailbox>
References: <167243876754.727436.356658000575058711.stgit@magnolia>
 <167243876766.727436.7268075677833351349.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243876766.727436.7268075677833351349.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:27PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Race fsstress with inode link count checking and repair.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/772     |   38 ++++++++++++++++++++++++++++++++++++++
>  tests/xfs/772.out |    2 ++
>  tests/xfs/820     |   37 +++++++++++++++++++++++++++++++++++++
>  tests/xfs/820.out |    2 ++
>  4 files changed, 79 insertions(+)
>  create mode 100755 tests/xfs/772
>  create mode 100644 tests/xfs/772.out
>  create mode 100755 tests/xfs/820
>  create mode 100644 tests/xfs/820.out
> 
> 
> diff --git a/tests/xfs/772 b/tests/xfs/772
> new file mode 100755
> index 0000000000..a00c2796c5
> --- /dev/null
> +++ b/tests/xfs/772
> @@ -0,0 +1,38 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 772
> +#
> +# Race fsstress and inode link count repair for a while to see if we crash or
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
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_stress_online_repair
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_scratch_xfs_stress_online_repair -x "dir" -s "repair nlinks"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/772.out b/tests/xfs/772.out
> new file mode 100644
> index 0000000000..98c1396896
> --- /dev/null
> +++ b/tests/xfs/772.out
> @@ -0,0 +1,2 @@
> +QA output created by 772
> +Silence is golden
> diff --git a/tests/xfs/820 b/tests/xfs/820
> new file mode 100755
> index 0000000000..58a5d4cc91
> --- /dev/null
> +++ b/tests/xfs/820
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 820
> +#
> +# Race fsstress and nlinks scrub for a while to see if we crash or livelock.
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
> +_scratch_xfs_stress_scrub -x "dir" -s "scrub nlinks"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/820.out b/tests/xfs/820.out
> new file mode 100644
> index 0000000000..29ab2e2d8c
> --- /dev/null
> +++ b/tests/xfs/820.out
> @@ -0,0 +1,2 @@
> +QA output created by 820
> +Silence is golden
> 

