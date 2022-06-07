Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22582C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jun 2022 01:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350130AbiFHBMU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588282AbiFGXyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 19:54:24 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C39A820188;
        Tue,  7 Jun 2022 16:02:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E867C5EC626;
        Wed,  8 Jun 2022 09:01:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nyiCs-003wPA-W3; Wed, 08 Jun 2022 09:01:51 +1000
Date:   Wed, 8 Jun 2022 09:01:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] common/xfs: Add helper to check if nrext64 option is
 supported
Message-ID: <20220607230150.GQ1098723@dread.disaster.area>
References: <20220606124101.263872-1-chandan.babu@oracle.com>
 <20220606124101.263872-3-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606124101.263872-3-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=629fd8e8
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=3aXqCYULcEE8ljHi-yoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 06:10:59PM +0530, Chandan Babu R wrote:
> This commit adds a new helper to allow tests to check if xfsprogs and xfs
> kernel module support nrext64 option.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  common/xfs | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 2123a4ab..dca7af57 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1328,3 +1328,16 @@ _xfs_filter_mkfs()
>  		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
>  	}'
>  }
> +
> +_require_scratch_xfs_nrext64()
> +{
> +	_require_scratch

Not needed - caller should be doing that first.

> +
> +	_scratch_mkfs -i nrext64=1 &>/dev/null || \
> +		_notrun "mkfs.xfs doesn't support nrext64 feature"

_scratch_mkfs_xfs_supported -i nrext64=1

see for example:

_require_xfs_mkfs_crc

> +	_try_scratch_mount || \
> +		_notrun "kernel doesn't support xfs nrext64 feature"
> +	$XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "nrext64=1" || \
> +		_notrun "nrext64 feature not advertised on mount?"

This seems unnecessary - if mkfs supports the feature bit, and the
kernel supports is, this should just work. We don't do checks like
this in any other feature bit test. e.g:

_require_xfs_finobt
_require_xfs_sparse_inodes

etc.

Also, you should put this in the same region of the file as all the
other feature checks, not right down the bottom by itself.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
