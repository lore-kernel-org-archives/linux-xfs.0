Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E4AC43461
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E212320C56
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIBRpV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:45:21 -0400
Received: from sandeen.net ([63.231.237.45]:45646 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgIBRpU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Sep 2020 13:45:20 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CC0A37BB4;
        Wed,  2 Sep 2020 12:44:55 -0500 (CDT)
Subject: Re: [PATCH v2] xfs: fix xfs_bmap_validate_extent_raw when checking
 attr fork of rt files
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        xfs <linux-xfs@vger.kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>
References: <20200902174248.GU6096@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dfd9cdf9-dce7-151c-67a9-128c33eede51@sandeen.net>
Date:   Wed, 2 Sep 2020 12:45:17 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.0
MIME-Version: 1.0
In-Reply-To: <20200902174248.GU6096@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/2/20 12:42 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The realtime flag only applies to the data fork, so don't use the
> realtime block number checks on the attr fork of a realtime file.
> 
> Fixes: 30b0984d9117 ("xfs: refactor bmap record validation")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>


Seems legit

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: send from stable tree, not dev tree
> ---
>  fs/xfs/libxfs/xfs_bmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9c40d5971035..1b0a01b06a05 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6226,7 +6226,7 @@ xfs_bmap_validate_extent(
>  
>  	isrt = XFS_IS_REALTIME_INODE(ip);
>  	endfsb = irec->br_startblock + irec->br_blockcount - 1;
> -	if (isrt) {
> +	if (isrt && whichfork == XFS_DATA_FORK) {
>  		if (!xfs_verify_rtbno(mp, irec->br_startblock))
>  			return __this_address;
>  		if (!xfs_verify_rtbno(mp, endfsb))
> 
