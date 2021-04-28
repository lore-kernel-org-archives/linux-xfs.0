Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFECC43460
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF9F8613F1
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 04:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhD1EMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 00:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhD1EMD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C776660720;
        Wed, 28 Apr 2021 04:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619583079;
        bh=n1x7CgsfjHYAGCaF5zUASNnYcaVuDJghp8uTn9lczVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eqO1UO88y4sURSpYa/HVn7l40gwCuHGj/h2T+lhh7xdxdAi1LgYhCz8CNg9PtDjOo
         PpXAgC4+DU6Sy8h0OBXxp9YwZ2amOUmTXDbl093BmWEod+22UHXItVVFx/MCXmDUBa
         sBzfIxgDUCKk4K3dwGa8Nh8SCvfYVJdhenwg8OQWCRnSB8qmf0T9QxY8pw7o9yWFen
         fQFxPzvuzfVQu2sY4ylGI9OFbeqrSABa0e+aCFOrAxC6OVvFRMDij1D/jka2pqLv4c
         8WNjSOgo9gJmZAkakeXrAOWZu2sz6OCYRwm2A+LP/UtWWUczqXZzHeY9dMzaPNE/WI
         3HXyVRxZdYdGw==
Date:   Tue, 27 Apr 2021 21:11:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] rc: check dax mode in _require_scratch_swapfile
Message-ID: <20210428041118.GF1251862@magnolia>
References: <161958296906.3452499.12678290296714187590.stgit@magnolia>
 <161958298115.3452499.907986597475080875.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958298115.3452499.907986597475080875.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It turns out that the mm refuses to swapon() files that don't have a
> a_ops->readpage function, because it wants to be able to read the swap
> header.  S_DAX files don't have a readpage function (though oddly both
> ext4 and xfs link to a swapfile activation function in their aops) so
> they fail.  The recent commit 725feeff changed this from a _notrun to
> _fail on xfs and ext4, so amend this not to fail on pmem test setups.
> 
> Fixes: 725feeff ("common/rc: swapon should not fail for given FS in _require_scratch_swapfile()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Note that XiaoLi Feng's patch "common/rc: not run swapfile test for
DAX" is perfectly adequate too, and that patch was sent first.

--D

> ---
>  common/rc |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/common/rc b/common/rc
> index 6752c92d..429cc24d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2490,6 +2490,10 @@ _require_scratch_swapfile()
>  	# Minimum size for mkswap is 10 pages
>  	_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10))
>  
> +	# swapfiles cannot use cpu direct access mode (STATX_ATTR_DAX) for now
> +	statx_attr="$($XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT/swap 2>/dev/null | grep 'stat.attributes = ' | awk '{print $3}')"
> +	test "$((statx_attr & 0x200000))" -gt 0 && _notrun "swapfiles not supported on DAX"
> +
>  	# ext* and xfs have supported all variants of swap files since their
>  	# introduction, so swapon should not fail.
>  	case "$FSTYP" in
> 
