Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA5BC3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jul 2022 22:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiG0WGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 18:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiG0WGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jul 2022 18:06:06 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C25375142C;
        Wed, 27 Jul 2022 15:06:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-20-138.pa.nsw.optusnet.com.au [49.195.20.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 096F962CC03;
        Thu, 28 Jul 2022 08:06:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oGpAG-0064jy-Pn; Thu, 28 Jul 2022 08:06:00 +1000
Date:   Thu, 28 Jul 2022 08:06:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH] xfs/432: fix this test when external devices are in use
Message-ID: <20220727220600.GU3600936@dread.disaster.area>
References: <YuBFw4dheeSRHVQd@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuBFw4dheeSRHVQd@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62e1b6cc
        a=cxZHBGNDieHvTKNp/pucQQ==:117 a=cxZHBGNDieHvTKNp/pucQQ==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Zvv4j7n2k3Z61Foful8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 26, 2022 at 12:51:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This program exercises metadump and mdrestore being run against the
> scratch device.  Therefore, the test must pass external log / rt device
> arguments to xfs_repair -n to check the "restored" filesystem.  Fix the
> incorrect usage, and report repair failures, since this test has been
> silently failing for a while now.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/432 |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/432 b/tests/xfs/432
> index 86012f0b..5c6744ce 100755
> --- a/tests/xfs/432
> +++ b/tests/xfs/432
> @@ -89,7 +89,16 @@ _scratch_xfs_metadump $metadump_file -w
>  xfs_mdrestore $metadump_file $metadump_img
>  
>  echo "Check restored metadump image"
> -$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
> +repair_args=('-n')
> +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +	repair_args+=('-l' "$SCRATCH_LOGDEV")
> +
> +[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> +	repair_args+=('-r' "$SCRATCH_RTDEV")
> +
> +$XFS_REPAIR_PROG "${repair_args[@]}" $metadump_img >> $seqres.full 2>&1
> +res=$?
> +test $res -ne 0 && echo "xfs_repair on restored fs returned $res?"

I don't like open coding external device support into individual
tests.

i.e. Shouldn't this use a wrapper around check_xfs_filesystem()
similar to _check_xfs_test_fs()? Call it check_xfs_scratch_fs() that
uses SCRATCH_DEV by default, but if $1 is passed in use that as the
scratch device instead?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
