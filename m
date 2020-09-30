Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F734C47428
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 16:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B73020759
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 16:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgI3QVc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 12:21:32 -0400
Received: from sandeen.net ([63.231.237.45]:54984 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgI3QVc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Sep 2020 12:21:32 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9D56714A11;
        Wed, 30 Sep 2020 11:20:44 -0500 (CDT)
Subject: Re: [PATCH v2] libxfs: disallow filesystems with reverse mapping and
 reflink and realtime
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20200930160112.GN49547@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f51fa326-a460-15f9-b821-b929594e4d85@sandeen.net>
Date:   Wed, 30 Sep 2020 11:21:31 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930160112.GN49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/30/20 11:01 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Neither the kernel nor the code in xfsprogs support filesystems that
> have (either reverse mapping btrees or reflink) enabled and a realtime
> volume configured.  The kernel rejects such combinations and mkfs
> refuses to format such a config, but xfsprogs doesn't check and can do
> Bad Things, so port those checks before someone shreds their filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, we already reject any other incompatibilities elsewehre, for any user
of the libxfs_mount callchain, so this is consistent.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: move code to rtmount_init where it belongs
> ---
>  libxfs/init.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index cb8967bc77d4..330c645190d9 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -428,6 +428,21 @@ rtmount_init(
>  	sbp = &mp->m_sb;
>  	if (sbp->sb_rblocks == 0)
>  		return 0;
> +
> +	if (xfs_sb_version_hasreflink(sbp)) {
> +		fprintf(stderr,
> +	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
> +				progname);
> +		return -1;
> +	}
> +
> +	if (xfs_sb_version_hasrmapbt(sbp)) {
> +		fprintf(stderr,
> +	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
> +				progname);
> +		return -1;
> +	}
> +
>  	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
>  		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
>  			progname);
> 
