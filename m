Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC108C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 04:20:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiF2EUt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 00:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiF2EUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 00:20:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB6201FCCD;
        Tue, 28 Jun 2022 21:20:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E68FA10E7D17;
        Wed, 29 Jun 2022 14:20:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6PC1-00CKoi-TK; Wed, 29 Jun 2022 14:20:45 +1000
Date:   Wed, 29 Jun 2022 14:20:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/9] xfs: test xfs_copy doesn't do cached read before
 libxfs_mount
Message-ID: <20220629042045.GQ1098723@dread.disaster.area>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644770013.1045534.5572366430392518217.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644770013.1045534.5572366430392518217.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62bbd31f
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=QKBp_38T88UDMcyabBIA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:21:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for an xfs_copy fix that ensures that it
> doesn't perform a cached read of an XFS filesystem prior to initializing
> libxfs, since the xfs_mount (and hence the buffer cache) isn't set up
> yet.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/844     |   33 +++++++++++++++++++++++++++++++++
>  tests/xfs/844.out |    3 +++
>  2 files changed, 36 insertions(+)
>  create mode 100755 tests/xfs/844
>  create mode 100644 tests/xfs/844.out
> 
> 
> diff --git a/tests/xfs/844 b/tests/xfs/844
> new file mode 100755
> index 00000000..688abe33
> --- /dev/null
> +++ b/tests/xfs/844
> @@ -0,0 +1,33 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 844
> +#
> +# Regression test for xfsprogs commit:
> +#
> +# XXXXXXXX ("xfs_copy: don't use cached buffer reads until after libxfs_mount")
> +#

This needs more of an explanation of why empty files are being
copied here, because it's not obvious why we'd run xfs_copy on
them...

> +. ./common/preamble
> +_begin_fstest auto copy

Wouldn't this also be quick?

Otherwise looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
