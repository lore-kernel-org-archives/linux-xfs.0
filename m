Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBB8C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 22:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbiA1WN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:13:26 -0500
Received: from sandeen.net ([63.231.237.45]:42788 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230408AbiA1WNZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jan 2022 17:13:25 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 357D878FD;
        Fri, 28 Jan 2022 16:13:12 -0600 (CST)
Message-ID: <c874146d-00fb-e443-e4f8-0a7327e0917a@sandeen.net>
Date:   Fri, 28 Jan 2022 16:13:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263802468.860211.15737349840605006073.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 33/45] libxfs: replace xfs_sb_version checks with feature
 flag checks
In-Reply-To: <164263802468.860211.15737349840605006073.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the xfs_sb_version_hasfoo() to checks against mp->m_features.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   libxfs/init.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index adee90d5..8fe2f963 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -432,17 +432,17 @@ rtmount_init(
>   	xfs_daddr_t	d;	/* address of last block of subvolume */
>   	int		error;
>   
> -	if (mp->m_sb.sb_rblocks == 0)
> +	if (!xfs_has_realtime(mp))

This seems a little gratuitous, I think after this we still have several
checks of mp->m_sb.sb_rblocks [!=]= 0 elsewhere ... since this isn't a
conversion of sb_version, I'd like to be pedantic and drop this hunk,
and consider an intentional change to switch sb_rblocks checks to
xfs_has_realtime(mp) across all the tools?

Otherwise,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>   		return 0;
>   
> -	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +	if (xfs_has_reflink(mp)) {
>   		fprintf(stderr,
>   	_("%s: Reflink not compatible with realtime device. Please try a newer xfsprogs.\n"),
>   				progname);
>   		return -1;
>   	}
>   
> -	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +	if (xfs_has_rmapbt(mp)) {
>   		fprintf(stderr,
>   	_("%s: Reverse mapping btree not compatible with realtime device. Please try a newer xfsprogs.\n"),
>   				progname);
> 
