Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6059C433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Sep 2021 10:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E0026113E
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Sep 2021 10:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhILKmj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Sep 2021 06:42:39 -0400
Received: from out20-27.mail.aliyun.com ([115.124.20.27]:36204 "EHLO
        out20-27.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbhILKmi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Sep 2021 06:42:38 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07448935|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0241558-0.00320454-0.97264;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.LJ6v2zF_1631443282;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.LJ6v2zF_1631443282)
          by smtp.aliyun-inc.com(10.147.41.137);
          Sun, 12 Sep 2021 18:41:22 +0800
Date:   Sun, 12 Sep 2021 18:41:22 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: regresion test for fsmap problems with realtime
Message-ID: <YT3ZUiH7uANwHoRW@desktop>
References: <163045512451.771394.12554760323831932499.stgit@magnolia>
 <163045514640.771394.1779112875987604476.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045514640.771394.1779112875987604476.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:12:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for:
> 
> xfs: make xfs_rtalloc_query_range input parameters const
> xfs: fix off-by-one error when the last rt extent is in use
> xfs: make fsmap backend function key parameters const
> 
> In which we synthesize an XFS with a realtime volume and a special
> realtime volume to trip the bugs fixed by all three patches that
> resulted in incomplete fsmap output.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/922     |  183 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/922.out |    2 +
>  2 files changed, 185 insertions(+)
>  create mode 100755 tests/xfs/922
>  create mode 100644 tests/xfs/922.out
> 
> 
> diff --git a/tests/xfs/922 b/tests/xfs/922
> new file mode 100755
> index 00000000..95304d57
> --- /dev/null
> +++ b/tests/xfs/922
> @@ -0,0 +1,183 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 922
> +#
> +# Regression test for commits:
> +#
> +# c02f6529864a ("xfs: make xfs_rtalloc_query_range input parameters const")
> +# 9ab72f222774 ("xfs: fix off-by-one error when the last rt extent is in use")
> +# 7e1826e05ba6 ("xfs: make fsmap backend function key parameters const")
> +#
> +# These commits fix a bug in fsmap where the data device fsmap function would
> +# corrupt the high key passed to the rt fsmap function if the data device
> +# number is smaller than the rt device number and the data device itself is
> +# smaller than the rt device.
> +#
> +. ./common/preamble
> +_begin_fstest auto fsmap
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	_scratch_unmount
> +	test -n "$ddloop" && _destroy_loop_device "$ddloop"
> +	test -n "$rtloop" && _destroy_loop_device "$rtloop"
> +	test -n "$ddfile" && rm -f "$ddfile"
> +	test -n "$rtfile" && rm -f "$rtfile"
> +	test -n "$old_use_external" && USE_EXTERNAL="$old_use_external"
> +}
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic

_supported_fs xfs

> +_require_test

Also need the following _require rules

_require_loop
_require_xfs_io_command "falloc"
_require_xfs_io_command "fpunch"
_require_xfs_io_command "fsmap"

I've fixed them all on commit.

Thanks,
Eryu
