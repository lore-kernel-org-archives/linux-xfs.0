Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF05C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 09:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF0A64F4D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 09:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhCKJce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 04:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhCKJcF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 04:32:05 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF00C061574;
        Thu, 11 Mar 2021 01:32:05 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b23so5460384pfo.8;
        Thu, 11 Mar 2021 01:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=fyf/jTsBwPxc414eZgdjG/VRoF1S3dVfps3c9J8pv40=;
        b=KrhDfCHUQFLZExXO3sMD7nqIUjiDFgA8tw4D3iXXS+KvIollTkmyJrfmuroL8nPidp
         2qiPeX6WILk8er2SaShNM8J6kRP7RR/w3ARe7oIQz/KhsyzeInhClXiDOYptSyuOhsXs
         BKqU+HzUDpGnKb9qx+l/IB4g7iqa9PslmAYj1al7YCDNWaAggs/vzuLyOAaqCGCLVlSR
         48lOse/MdgaYWoL5+qBOTz7hFCJuuPSnQSUdrwE8jYjIDRD/EyB/bi2tSdAsjv+a+4Km
         GorxOdPbcLJj0kVF+g4Faf1qb3EQg0Pp2LqBfPzRD5IenZCwQ/RJGziMwPqdPj85WIEn
         uFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=fyf/jTsBwPxc414eZgdjG/VRoF1S3dVfps3c9J8pv40=;
        b=nlPwfuUc97NGIMO+GkHJ4IwFOH2rGu0NB0Ewe0KB9cyK1t6jrQvZh+NhpHYbQi5fyf
         pOiC/QeI6xQWqt9Zcup68kM8BDgMX+KSlzWlYhS6r/W+1ykcgVo6yDx1kk5ba1m0tZ2M
         TY1BLwdCcRAJcR2P0S6GEi7TXW/nAat49CUs9fuKM68CehKgbPa8ERATUNdGUA9CXFxQ
         emxXfj/nMK6yc5AKNP/QAwI/G2KXKx8VbrcVggfjhLbwEhNpBWW8PhcGnkpmsPZi0hm6
         1nV/xf0EBvz5fv9iWoAOSOK9kVel6Bin8wnItJObOHRAZqObEz1n9lG23Zc37pNnNykD
         aaxQ==
X-Gm-Message-State: AOAM5332Hv+05Q5DpzaAqB6uvVTIQFbq1acc4byQAYAcATccl0HXoYdT
        jH0+H3XhvEoYfZ5lt1segYLHj8HNMUs=
X-Google-Smtp-Source: ABdhPJwsgrdqprApbvmTyEw5nCwo8jNysQmdVkWsYToPijMk2Rw2yd4NccTLDfAjQKxyVLIp4J7TgA==
X-Received: by 2002:a63:6982:: with SMTP id e124mr6651458pgc.46.1615455125149;
        Thu, 11 Mar 2021 01:32:05 -0800 (PST)
Received: from garuda ([122.171.53.181])
        by smtp.gmail.com with ESMTPSA id w2sm1964657pgh.54.2021.03.11.01.32.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 01:32:04 -0800 (PST)
References: <161526480371.1214319.3263690953532787783.stgit@magnolia> <161526482563.1214319.7317631500409765514.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 04/10] xfs: test mkfs min log size calculation w/ rt volumes
In-reply-to: <161526482563.1214319.7317631500409765514.stgit@magnolia>
Date:   Thu, 11 Mar 2021 15:02:01 +0530
Message-ID: <87lfauc9ym.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Mar 2021 at 10:10, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> In "mkfs: set required parts of the realtime geometry before computing
> log geometry" we made sure that mkfs set up enough of the fs geometry to
> compute the minimum xfs log size correctly when formatting the
> filesystem.  This is the regression test for that issue.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/761     |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/761.out |    1 +
>  tests/xfs/group   |    1 +
>  3 files changed, 47 insertions(+)
>  create mode 100755 tests/xfs/761
>  create mode 100644 tests/xfs/761.out
>
>
> diff --git a/tests/xfs/761 b/tests/xfs/761
> new file mode 100755
> index 00000000..b9770d90
> --- /dev/null
> +++ b/tests/xfs/761
> @@ -0,0 +1,45 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 761
> +#
> +# Make sure mkfs sets up enough of the rt geometry that we can compute the
> +# correct min log size for formatting the fs.
> +#
> +# This is a regression test for the xfsprogs commit 31409f48 ("mkfs: set
> +# required parts of the realtime geometry before computing log geometry").
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_realtime
> +
> +rm -f $seqres.full
> +
> +# Format a tiny filesystem to force minimum log size, then see if it mounts
> +_scratch_mkfs -r size=1m -d size=100m > $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/761.out b/tests/xfs/761.out
> new file mode 100644
> index 00000000..8c9d9e90
> --- /dev/null
> +++ b/tests/xfs/761.out
> @@ -0,0 +1 @@
> +QA output created by 761
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 318468b5..87badd56 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -503,4 +503,5 @@
>  758 auto quick rw attr realtime
>  759 auto quick rw realtime
>  760 auto quick rw collapse punch insert zero prealloc
> +761 auto quick realtime

Maybe "mount" should be added to the above list. Rest looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
