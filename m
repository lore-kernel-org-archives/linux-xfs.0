Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8841C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Jul 2022 01:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiGNBR0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jul 2022 21:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGNBRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 21:17:24 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B347420F62
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 18:17:23 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0BCB54435;
        Wed, 13 Jul 2022 20:17:02 -0500 (CDT)
Message-ID: <ce55b1b4-53a2-a620-a2f8-d601fd48bfa9@sandeen.net>
Date:   Wed, 13 Jul 2022 20:17:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 3/4] mkfs: complain about impossible log size constraints
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165767457703.891854.2108521135190969641.stgit@magnolia>
 <165767459394.891854.2338822152912053034.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <165767459394.891854.2338822152912053034.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/12/22 8:09 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs/042 trips over an impossible fs geometry when nrext64 is enabled.
> The minimum log size calculation comes out to 4287 blocks, but the mkfs
> parameters specify an AG size of 4096 blocks.  This eventually causes
> mkfs to complain that the autoselected log size doesn't meet the minimum
> size, but we could be a little more explicit in pointing out that the
> two size constraints make for an impossible geometry.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index db322b3a..61ac1a4a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3401,6 +3401,13 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
>  	 * an AG.
>  	 */
>  	max_logblocks = libxfs_alloc_ag_max_usable(mp) - 1;
> +	if (max_logblocks < min_logblocks) {
> +		fprintf(stderr,
> +_("max log size %d smaller than min log size %d\n"),

And when the user sees this, they will know that they should ___________ ?

> +				max_logblocks,
> +				min_logblocks);
> +		usage();
> +	}
>  
>  	/* internal log - if no size specified, calculate automatically */
>  	if (!cfg->logblocks) {
> 
