Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB94C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 23:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3801D217F5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 23:15:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfHZXP6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 19:15:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47939 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726584AbfHZXP6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 19:15:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8D09743D9B7;
        Tue, 27 Aug 2019 09:15:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2ODL-0000lT-4V; Tue, 27 Aug 2019 09:15:55 +1000
Date:   Tue, 27 Aug 2019 09:15:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 4/4] xfs: fix sign handling problem in
 xfs_bmbt_diff_two_keys
Message-ID: <20190826231555.GP1119@dread.disaster.area>
References: <156685612356.2853532.10960947509015722027.stgit@magnolia>
 <156685614992.2853532.4191470495720238021.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156685614992.2853532.4191470495720238021.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=b9pknNGrLveNnpvs3tkA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 26, 2019 at 02:49:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xfs_bmbt_diff_two_keys, we perform a signed int64_t subtraction with
> two unsigned 64-bit quantities.  If the second quantity is actually the
> "maximum" key (all ones) as used in _query_all, the subtraction
> effectively becomes addition of two positive numbers and the function
> returns incorrect results.  Fix this with explicit comparisons of the
> unsigned values.  Nobody needs this now, but the online repair patches
> will need this to work properly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap_btree.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index fbb18ba5d905..3c1a805b3775 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -400,8 +400,20 @@ xfs_bmbt_diff_two_keys(
>  	union xfs_btree_key	*k1,
>  	union xfs_btree_key	*k2)
>  {
> -	return (int64_t)be64_to_cpu(k1->bmbt.br_startoff) -
> -			  be64_to_cpu(k2->bmbt.br_startoff);
> +	uint64_t		a = be64_to_cpu(k1->bmbt.br_startoff);
> +	uint64_t		b = be64_to_cpu(k2->bmbt.br_startoff);
> +
> +	/*
> +	 * Note: This routine previously casted a and b to int64 and subtracted
> +	 * them to generate a result.  This lead to problems if b was the
> +	 * "maximum" key value (all ones) being signed incorrectly, hence this
> +	 * somewhat less efficient version.
> +	 */
> +	if (a > b)
> +		return 1;
> +	else if (b > a)
> +		return -1;

No need for an else here, but otherwise OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
