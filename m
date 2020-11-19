Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77853C388F9
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 23:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2294C22240
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 23:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgKSXo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Nov 2020 18:44:29 -0500
Received: from sandeen.net ([63.231.237.45]:45544 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgKSXo3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Nov 2020 18:44:29 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F1C20B50;
        Thu, 19 Nov 2020 17:43:59 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20201119233943.GG9695@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: revert "xfs: fix rmap key and record comparison
 functions"
Message-ID: <e4ffbd0f-24d9-49dd-3ef3-62957087082d@sandeen.net>
Date:   Thu, 19 Nov 2020 17:44:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201119233943.GG9695@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/19/20 5:39 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This reverts commit 6ff646b2ceb0eec916101877f38da0b73e3a5b7f.
> 
> Your maintainer committed a major braino in the rmap code by adding the
> attr fork, bmbt, and unwritten extent usage bits into rmap record key
> comparisons.  While XFS uses the usage bits *in the rmap records* for
> cross-referencing metadata in xfs_scrub and xfs_repair, it only needs
> the owner and offset information to distinguish between reverse mappings
> of the same physical extent into the data fork of a file at multiple
> offsets.  The other bits are not important for key comparisons for index
> lookups, and never have been.
> 
> Eric Sandeen reports that this causes regressions in generic/299, so
> undo this patch before it does more damage.
> 
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> Fixes: 6ff646b2ceb0 ("xfs: fix rmap key and record comparison functions")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_rmap_btree.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 577a66381327..beb81c84a937 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -243,8 +243,8 @@ xfs_rmapbt_key_diff(
>  	else if (y > x)
>  		return -1;
>  
> -	x = be64_to_cpu(kp->rm_offset);
> -	y = xfs_rmap_irec_offset_pack(rec);
> +	x = XFS_RMAP_OFF(be64_to_cpu(kp->rm_offset));
> +	y = rec->rm_offset;
>  	if (x > y)
>  		return 1;
>  	else if (y > x)
> @@ -275,8 +275,8 @@ xfs_rmapbt_diff_two_keys(
>  	else if (y > x)
>  		return -1;
>  
> -	x = be64_to_cpu(kp1->rm_offset);
> -	y = be64_to_cpu(kp2->rm_offset);
> +	x = XFS_RMAP_OFF(be64_to_cpu(kp1->rm_offset));
> +	y = XFS_RMAP_OFF(be64_to_cpu(kp2->rm_offset));
>  	if (x > y)
>  		return 1;
>  	else if (y > x)
> @@ -390,8 +390,8 @@ xfs_rmapbt_keys_inorder(
>  		return 1;
>  	else if (a > b)
>  		return 0;
> -	a = be64_to_cpu(k1->rmap.rm_offset);
> -	b = be64_to_cpu(k2->rmap.rm_offset);
> +	a = XFS_RMAP_OFF(be64_to_cpu(k1->rmap.rm_offset));
> +	b = XFS_RMAP_OFF(be64_to_cpu(k2->rmap.rm_offset));
>  	if (a <= b)
>  		return 1;
>  	return 0;
> @@ -420,8 +420,8 @@ xfs_rmapbt_recs_inorder(
>  		return 1;
>  	else if (a > b)
>  		return 0;
> -	a = be64_to_cpu(r1->rmap.rm_offset);
> -	b = be64_to_cpu(r2->rmap.rm_offset);
> +	a = XFS_RMAP_OFF(be64_to_cpu(r1->rmap.rm_offset));
> +	b = XFS_RMAP_OFF(be64_to_cpu(r2->rmap.rm_offset));
>  	if (a <= b)
>  		return 1;
>  	return 0;
> 
