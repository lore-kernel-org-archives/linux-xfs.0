Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DBFC47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CBE36120F
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhFGXBQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 19:01:16 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:51419 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230410AbhFGXBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 19:01:16 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 5C18080B3EF;
        Tue,  8 Jun 2021 08:59:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lqOD4-00AAm1-3E; Tue, 08 Jun 2021 08:59:06 +1000
Date:   Tue, 8 Jun 2021 08:59:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 1/9] xfs: refactor the inode recycling code
Message-ID: <20210607225906.GF664593@dread.disaster.area>
References: <162310469340.3465262.504398465311182657.stgit@locust>
 <162310469929.3465262.17904743035514961089.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162310469929.3465262.17904743035514961089.stgit@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=z1fYhlYM5umAOpIMaGgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 07, 2021 at 03:24:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Hoist the code in xfs_iget_cache_hit that restores the VFS inode state
> to an xfs_inode that was previously vfs-destroyed.  The next patch will
> add a new set of state flags, so we need the helper to avoid
> duplication.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |  139 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 81 insertions(+), 58 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 4e4682879bbd..4d4aa61fbd34 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -350,19 +350,19 @@ xfs_inew_wait(
>   * need to retain across reinitialisation, and rewrite them into the VFS inode
>   * after reinitialisation even if it fails.
>   */
> -static int
> +static inline int
>  xfs_reinit_inode(
>  	struct xfs_mount	*mp,
>  	struct inode		*inode)

Don't use inline here as it's a pretty big function - it's a static
function so let the compiler decide if inlining is worth it.

Otherwise looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
