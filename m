Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC952C19F2D
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Aug 2022 02:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiHECXg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 22:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiHECXg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 22:23:36 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10A0632D86
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 19:23:35 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B42944C1502;
        Thu,  4 Aug 2022 21:22:34 -0500 (CDT)
Message-ID: <c633f5fc-1c19-7622-4759-fd5d916f92f6@sandeen.net>
Date:   Thu, 4 Aug 2022 21:23:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165826708900.3268805.5228849676662461141.stgit@magnolia>
 <165826709473.3268805.14134746462173901488.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/1] mkfs: complain about impossible log size constraints
In-Reply-To: <165826709473.3268805.14134746462173901488.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/19/22 4:44 PM, Darrick J. Wong wrote:
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

Thanks for the update.

Reviewed-by : Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b140b815..a5e2df76 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3413,6 +3413,13 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
>  	 * an AG.
>  	 */
>  	max_logblocks = libxfs_alloc_ag_max_usable(mp) - 1;
> +	if (max_logblocks < min_logblocks) {
> +		fprintf(stderr,
> +_("max log size %d smaller than min log size %d, filesystem is too small\n"),
> +				max_logblocks,
> +				min_logblocks);
> +		usage();
> +	}
>  
>  	/* internal log - if no size specified, calculate automatically */
>  	if (!cfg->logblocks) {
> 
