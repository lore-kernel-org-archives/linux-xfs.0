Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA16CCA473
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 23:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiFAXot (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 19:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiFAXos (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 19:44:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A0AB23D563;
        Wed,  1 Jun 2022 16:44:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1284810E6C9F;
        Thu,  2 Jun 2022 09:44:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nwY15-001aEn-IY; Thu, 02 Jun 2022 09:44:43 +1000
Date:   Thu, 2 Jun 2022 09:44:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Zorro Lang <zlang@redhat.com>, Brian Foster <bfoster@redhat.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic/623: fix test for runing on overlayfs
Message-ID: <20220601234443.GI227878@dread.disaster.area>
References: <20220601123406.265475-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601123406.265475-1-amir73il@gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6297f9ed
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=epZAUZFAZdjw4BhAvwsA:9 a=CjuIK1q_8ugA:10 a=V0ZB0er3tgIA:10
        a=5ZtAvbtPDreVYrn1SqM_:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 01, 2022 at 03:34:06PM +0300, Amir Goldstein wrote:
> For this test to run on overlayfs we open a different file to perform
> shutdown while keeping the writeback target file open.
> 
> xfs_io -c fsync perform fsync also on the writeback target file, which
> is needed for triggering the write fault.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> Following your comment on v1, this version does not change the
> behavior of the test when running on non-overlayfs.
> 
> I tested that this test passes for both xfs and overlayfs+xfs on v5.18
> and tested that both configs fail with the same warning on v5.10.109.
> 
> Thanks,
> Amir.
> 
>  tests/generic/623 | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/623 b/tests/generic/623
> index ea016d91..5971717c 100755
> --- a/tests/generic/623
> +++ b/tests/generic/623
> @@ -24,10 +24,22 @@ _scratch_mount
>  # XFS had a regression where it failed to check shutdown status in the fault
>  # path. This produced an iomap warning because writeback failure clears Uptodate
>  # status on the page.
> +
> +# For this test to run on overlayfs we open a different file to perform
> +# shutdown while keeping the writeback target file open.
> +# xfs_io -c fsync post-shutdown performs fsync also on the writeback target file,
> +# which is critical for trigerring the writeback failure.
> +shutdown_cmd=()
> +shutdown_handle="$(_scratch_shutdown_handle)"
> +if [ "$shutdown_handle" != "$SCRATCH_MNT" ];then
> +	shutdown_cmd+=("-c" "open $shutdown_handle")
> +fi
> +shutdown_cmd+=("-c" "shutdown")

IMO, this is unnecessary complexity. The original patch with the
"fsync acts on all open files" comment above explains the xfs_io
fsync quirk that enables the test to do what it is supposed to be
doing without any of the this conditional command construction.

The less special case handling we need to splice into the test code,
the better.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
