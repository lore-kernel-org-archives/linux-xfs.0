Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2D6C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 04:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiF2EYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 00:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiF2EYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 00:24:00 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F396229CA0;
        Tue, 28 Jun 2022 21:23:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3ADE710E7E48;
        Wed, 29 Jun 2022 14:23:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o6PF8-00CKqz-MQ; Wed, 29 Jun 2022 14:23:58 +1000
Date:   Wed, 29 Jun 2022 14:23:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 8/9] xfs/166: fix golden output failures when multipage
 folios enabled
Message-ID: <20220629042358.GT1098723@dread.disaster.area>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644772249.1045534.3583119178643533811.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644772249.1045534.3583119178643533811.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62bbd3df
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=ZMF_gKmEGW5fp1xaa3sA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:22:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Beginning with 5.18, some filesystems support creating large folios for
> the page cache.  A system with 64k pages can create 256k folios, which
> means that with the old file size of 1M, the last half of the file is
> completely converted from unwritten to written by page_mkwrite.  The
> test encodes a translated version of the xfs_bmap output in the golden
> output, which means that the test now fails on 64k pages.  Fixing the
> 64k page case by increasing the file size to 2MB broke fsdax because
> fsdax uses 2MB PMDs, hence 12MB.
> 
> Increase the size to prevent this from happening.  This may require
> further revision if folios get larger or fsdax starts supporting PMDs
> that are larger than 2MB.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/166 |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/tests/xfs/166 b/tests/xfs/166
> index 42379961..d45dc5e8 100755
> --- a/tests/xfs/166
> +++ b/tests/xfs/166
> @@ -16,12 +16,12 @@ _begin_fstest rw metadata auto quick
>  # the others are unwritten.
>  _filter_blocks()
>  {
> -	$AWK_PROG '
> +	$AWK_PROG -v file_size=$FILE_SIZE '
>  /^ +[0-9]/ {
>  	if (!written_size) {
>  		written_size = $6
> -		unwritten1 = ((1048576/512) / 2) - written_size
> -		unwritten2 = ((1048576/512) / 2) - 2 * written_size
> +		unwritten1 = ((file_size/512) / 2) - written_size
> +		unwritten2 = ((file_size/512) / 2) - 2 * written_size
>  	}
>  
>  	# is the extent unwritten?
> @@ -58,7 +58,18 @@ _scratch_mount
>  
>  TEST_FILE=$SCRATCH_MNT/test_file
>  TEST_PROG=$here/src/unwritten_mmap
> -FILE_SIZE=1048576
> +
> +# Beginning with 5.18, some filesystems support creating large folios for the
> +# page cache.  A system with 64k pages can create 256k folios, which means
> +# that with the old file size of 1M, the last half of the file is completely
> +# converted from unwritten to written by page_mkwrite.  The test will fail on
> +# the golden output when this happens, so increase the size from the original
> +# 1MB file size to at least (6 * 256k == 1.5MB) prevent this from happening.
> +#
> +# However, increasing the file size to around 2MB causes regressions when fsdax
> +# is enabled because fsdax will try to use PMD entries for the mappings.  Hence
> +# we need to set the file size to (6 * 2MB == 12MB) to cover all cases.
> +FILE_SIZE=$((12 * 1048576))

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
