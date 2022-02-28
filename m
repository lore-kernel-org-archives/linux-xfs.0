Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C468FC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Feb 2022 21:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiB1VpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 16:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbiB1VpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 16:45:10 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07A3C32994
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 13:44:30 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 51763116E2;
        Mon, 28 Feb 2022 15:43:31 -0600 (CST)
Message-ID: <2476cebf-b383-9788-4222-be918aa7a077@sandeen.net>
Date:   Mon, 28 Feb 2022 15:44:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <20220226025450.GY8313@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
In-Reply-To: <20220226025450.GY8313@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/25/22 8:54 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>

...

> Hence we increase the ratio by 16x because there doesn't seem to be much
> improvement beyond that, and we don't want the log to grow /too/ large.
> This change does not affect filesystems larger than 4TB, nor does it
> affect formatting to older formats.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 96682f9a..7178d798 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3308,7 +3308,17 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
>  
>  	/* internal log - if no size specified, calculate automatically */
>  	if (!cfg->logblocks) {
> -		if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
> +		if (cfg->sb_feat.bigtime) {

I'm not very keen on conditioning this on bigtime; it seems very ad-hoc and
unexpected. Future maintainers will look at this and wonder why bigtime is
in any way related to log size...

If we make this change, why not just make it regardless of other features?
Is there some other risk to doing so?

Thanks,
-Eric

> +			/*
> +			 * Starting with bigtime, everybody gets a 256:1 ratio
> +			 * of fs size to log size unless they say otherwise.
> +			 * Larger logs reduce contention for log grant space,
> +			 * which is now a problem with the advent of small
> +			 * non-rotational storage devices.
> +			 */
> +			cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 256;
> +			cfg->logblocks = cfg->logblocks >> cfg->blocklog;
> +		} else if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
>  			/* tiny filesystems get minimum sized logs. */
>  			cfg->logblocks = min_logblocks;
>  		} else if (cfg->dblocks < GIGABYTES(16, cfg->blocklog)) {
> 
