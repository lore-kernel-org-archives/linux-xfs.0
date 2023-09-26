Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5533E8181E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Sep 2023 05:21:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjIZFVy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 01:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjIZFVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 01:21:31 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD07116;
        Mon, 25 Sep 2023 22:21:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-27758c8f62aso2492261a91.0;
        Mon, 25 Sep 2023 22:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695705684; x=1696310484; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JQbtwDxMKM6WQxUu1SJX2YslaptoJGmmHz+KiHujnv8=;
        b=C03U8u08az6TKkBBAAiNEOpIo5RozdsbTbIQnqA12ztYi25E8XU2lPLsaCmAZVR7Ir
         SAj2H02Cj0rD5hQXSvozisMR1QdsAnj4WlW2SoV4RKNZNH29BxF39XyrAJvdYymgQmhu
         8Uwy6NQEVtw1LPzLIbb/k3NtP8tGeic1kJT3rJtd/05GZ445IdE9NSE3CVKcrxABg6yQ
         /jXi3Ldoywtn8wT7QKofI08A7cNT692bLH/lD5I2M9gq/KIbOAeYVZ3/FLpx9IE52HsN
         aAa6bnso5T7WMODHIXe/xyX1ptPOGTORuWH1dTANsb0lk/JKBaKZiARwKWQSq5SpQDUt
         PLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695705684; x=1696310484;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JQbtwDxMKM6WQxUu1SJX2YslaptoJGmmHz+KiHujnv8=;
        b=fe/uCtGFbXlwt+vQeFv/Ku6k25TW5Kg2c5UpuSYPnAYdzurhIp+ISYDb7fGuYyRzmT
         HJWIb3xbcHp7p+lcyGQNaaczrbym5yGa+9GCyQlUHwGpTGhbsB4uyglKe/O+VyNUwevv
         vA4DNHf8sFe0hRHRN2+Dv4nZj9fLZqk+sWPlr+7In1EOzivMuiHuKD3LplnN4Xq86kC4
         S5ivXLoNbJuU2ygrMRD3QNTvhJ08kq89Rs2+t1zIpRKI+x+d5MmztuJm9cnYd6Jtb6DC
         hngEb82bLfJfa+lh7Vdoh2MAPFFNxmE+ncZA/A5lBA77FHqNpmOZofveyOYNbPzbqS00
         8smQ==
X-Gm-Message-State: AOJu0Yz+pNK+fM0libCyqMxZMxSvNDt+3mQL0LhfFS4s4K7hNXXTREu3
        Uy+l2DTQ9RUj00YGaPy4UX/c1luSxFQ=
X-Google-Smtp-Source: AGHT+IHoSpPbhOM7CGS6c35kuLJhIjYgEQwJ/qBeHwDSvvSUcoHfJDz+chhWn6xa6INYUkBT7te7Jg==
X-Received: by 2002:a17:90b:3ec5:b0:269:5adb:993 with SMTP id rm5-20020a17090b3ec500b002695adb0993mr5563931pjb.22.1695705684382;
        Mon, 25 Sep 2023 22:21:24 -0700 (PDT)
Received: from dw-tp ([49.207.223.191])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a0ccb00b002635db431a0sm9863771pjt.45.2023.09.25.22.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 22:21:23 -0700 (PDT)
Date:   Tue, 26 Sep 2023 10:51:19 +0530
Message-Id: <87h6nh5x2o.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, djwong@kernel.org,
        zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        willy@infradead.org
Subject: Re: [PATCH 1/1] generic: test FALLOC_FL_UNSHARE when pagecache is not loaded
In-Reply-To: <169567819441.2270025.10851897053852323695.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <djwong@kernel.org> writes:

> From: Darrick J. Wong <djwong@kernel.org>
>
> Add a regression test for funsharing uncached files to ensure that we
> actually manage the pagecache state correctly.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/1936     |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1936.out |    4 ++
>  2 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/1936
>  create mode 100644 tests/xfs/1936.out
>
>
> diff --git a/tests/xfs/1936 b/tests/xfs/1936
> new file mode 100755
> index 0000000000..e07b8f4796
> --- /dev/null
> +++ b/tests/xfs/1936
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1936
> +#
> +# This is a regression test for the kernel commit noted below.  The stale
> +# memory exposure can be exploited by creating a file with shared blocks,
> +# evicting the page cache for that file, and then funshareing at least one
> +# memory page's worth of data.  iomap will mark the page uptodate and dirty
> +# without ever reading the ondisk contents.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick unshare clone
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $testdir
> +}
> +
> +# real QA test starts here
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr

We might as well remove above imports if we are not using those in this test.

> +. ./common/reflink
> +
> +_fixed_by_git_commit kernel XXXXXXXXXXXXX \
> +	"iomap: don't skip reading in !uptodate folios when unsharing a range"

Once I guess it is merged, we will have the commit-id. Ohh wait, we have
it already right? 

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=35d30c9cf12730a1e37053dfde4007c7cc452d1a

With that the testcode looks good to me. Thanks for finding an easy
reproducer. Please feel free to add - 

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

-ritesh
