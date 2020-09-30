Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AF6C4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 574ED20759
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgI3PbX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:31:23 -0400
Received: from sandeen.net ([63.231.237.45]:52498 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgI3PbX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Sep 2020 11:31:23 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 798A21913D;
        Wed, 30 Sep 2020 10:30:35 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20200930145840.GL49547@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] libxfs: disallow filesystems with reverse mapping and
 reflink and realtime
Message-ID: <bf8fbe05-fea9-9571-0584-04be70c2d3dd@sandeen.net>
Date:   Wed, 30 Sep 2020 10:31:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930145840.GL49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/30/20 9:58 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Neither the kernel nor the code in xfsprogs support filesystems that
> have (either reverse mapping btrees or reflink) enabled and a realtime
> volume configured.  The kernel rejects such combinations and mkfs
> refuses to format such a config, but xfsprogs doesn't check and can do
> Bad Things, so port those checks before someone shreds their filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

seems fine in general but a couple thoughts...

> ---
>  libxfs/init.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index cb8967bc77d4..1a966084ffea 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -724,6 +724,20 @@ libxfs_mount(
>  		exit(1);
>  	}
>  
> +	if (xfs_sb_version_hasreflink(sbp) && sbp->sb_rblocks) {

Hm, we really don't use xfs_sb_version_hasrealtime() very consistently, but it might
be worth doing here?

I wish we had a feature flag to cross-ref against, a corruption in sb_rblocks will lead
to an untouchable filesystem, but I guess there's nothing we can do about that.

Actually, would it help to cross-check against the rtdev arg as well?  Should we do anything
different if the user actually specified a realtime device on the commandline?

I mean, I suppose 

> +		fprintf(stderr,
> +	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),

I like this optimism.  ;)


> +				progname);
> +		exit(1);
> +	}
> +
> +	if (xfs_sb_version_hasrmapbt(sbp) && sbp->sb_rblocks) {
> +		fprintf(stderr,
> +	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
> +				progname);
> +		exit(1);
> +	}
> +
>  	xfs_da_mount(mp);
>  
>  	if (xfs_sb_version_hasattr2(&mp->m_sb))
> 
