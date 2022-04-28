Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1543FC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 03:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241706AbiD1DG1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 23:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241759AbiD1DGU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 23:06:20 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C45BE255A6
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 20:03:06 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4969A14948B;
        Wed, 27 Apr 2022 22:02:42 -0500 (CDT)
Message-ID: <f18dea5c-a723-6317-9835-c1731bfe8b08@sandeen.net>
Date:   Wed, 27 Apr 2022 22:03:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 27/48] xfs_repair: fix AG header btree level comparisons
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
 <164263834099.865554.12607282164360768854.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <164263834099.865554.12607282164360768854.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:25 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's not an error if repair encounters a btree with the maximal
> height, so don't print warnings.  Also, we don't allow zero-height
> btrees.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/scan.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 909c4494..e2d281a2 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -2297,7 +2297,7 @@ validate_agf(
>  		priv.nr_blocks = 0;
>  
>  		levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
> -		if (levels >= XFS_BTREE_MAXLEVELS) {
> +		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
>  			do_warn(_("bad levels %u for rmapbt root, agno %d\n"),
>  				levels, agno);
>  			rmap_avoid_check();
> @@ -2323,7 +2323,7 @@ validate_agf(
>  		unsigned int	levels;
>  
>  		levels = be32_to_cpu(agf->agf_refcount_level);
> -		if (levels >= XFS_BTREE_MAXLEVELS) {
> +		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
>  			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
>  				levels, agno);
>  			refcount_avoid_check();
> 
