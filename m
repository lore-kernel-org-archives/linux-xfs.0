Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4421C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 03:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241733AbiD1DF6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 23:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241737AbiD1DF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 23:05:56 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC90B25587
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 20:02:42 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 566A014948B;
        Wed, 27 Apr 2022 22:02:17 -0500 (CDT)
Message-ID: <cbd04b3a-801b-27c5-86b4-9d82c45fbc84@sandeen.net>
Date:   Wed, 27 Apr 2022 22:02:40 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 24/48] xfs_db: fix metadump level comparisons
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
 <164263832432.865554.12949672536622727220.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <164263832432.865554.12949672536622727220.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:25 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It's not an error if metadump encounters a btree with the maximal
> height, so don't print warnings.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Gonna pull these in before the maxlevel computation patches since
(I think) they tighten up the range.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/metadump.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 057a3729..cc7a4a55 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -487,7 +487,7 @@ copy_free_bno_btree(
>  					"root in agf %u", root, agno);
>  		return 1;
>  	}
> -	if (levels >= XFS_BTREE_MAXLEVELS) {
> +	if (levels > XFS_BTREE_MAXLEVELS) {
>  		if (show_warnings)
>  			print_warning("invalid level (%u) in bnobt root "
>  					"in agf %u", levels, agno);
> @@ -515,7 +515,7 @@ copy_free_cnt_btree(
>  					"root in agf %u", root, agno);
>  		return 1;
>  	}
> -	if (levels >= XFS_BTREE_MAXLEVELS) {
> +	if (levels > XFS_BTREE_MAXLEVELS) {
>  		if (show_warnings)
>  			print_warning("invalid level (%u) in cntbt root "
>  					"in agf %u", levels, agno);
> @@ -587,7 +587,7 @@ copy_rmap_btree(
>  					"root in agf %u", root, agno);
>  		return 1;
>  	}
> -	if (levels >= XFS_BTREE_MAXLEVELS) {
> +	if (levels > XFS_BTREE_MAXLEVELS) {
>  		if (show_warnings)
>  			print_warning("invalid level (%u) in rmapbt root "
>  					"in agf %u", levels, agno);
> @@ -659,7 +659,7 @@ copy_refcount_btree(
>  					"root in agf %u", root, agno);
>  		return 1;
>  	}
> -	if (levels >= XFS_BTREE_MAXLEVELS) {
> +	if (levels > XFS_BTREE_MAXLEVELS) {
>  		if (show_warnings)
>  			print_warning("invalid level (%u) in refcntbt root "
>  					"in agf %u", levels, agno);
> @@ -2650,7 +2650,7 @@ copy_inodes(
>  					"root in agi %u", root, agno);
>  		return 1;
>  	}
> -	if (levels >= XFS_BTREE_MAXLEVELS) {
> +	if (levels > XFS_BTREE_MAXLEVELS) {
>  		if (show_warnings)
>  			print_warning("invalid level (%u) in inobt root "
>  					"in agi %u", levels, agno);
> 
