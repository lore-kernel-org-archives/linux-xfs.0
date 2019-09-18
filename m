Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29C7C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 12:27:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFCAD205F4
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 12:27:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfIRM1b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 08:27:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbfIRM1b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 08:27:31 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C04188980E1;
        Wed, 18 Sep 2019 12:27:30 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54C731048134;
        Wed, 18 Sep 2019 12:27:27 +0000 (UTC)
Date:   Wed, 18 Sep 2019 08:27:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/2] xfs: cap longest free extent to maximum allocatable
Message-ID: <20190918122726.GA29377@bfoster>
References: <20190918082453.25266-1-cmaiolino@redhat.com>
 <20190918082453.25266-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918082453.25266-2-cmaiolino@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Wed, 18 Sep 2019 12:27:30 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 10:24:52AM +0200, Carlos Maiolino wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Cap longest extent to the largest we can allocate based on limits
> calculated at mount time. Dynamic state (such as finobt blocks)
> can result in the longest free extent exceeding the size we can
> allocate, and that results in failure to align full AG allocations
> when the AG is empty.
> 
> Result:
> 
> xfs_io-4413  [003]   426.412459: xfs_alloc_vextent_loopfailed: dev 8:96 agno 0 agbno 32 minlen 243968 maxlen 244000 mod 0 prod 1 minleft 1 total 262148 alignment 32 minalignslop 0 len 0 type NEAR_BNO otype START_BNO wasdel 0 wasfromfl 0 resv 0 datatype 0x5 firstblock 0xffffffffffffffff
> 
> minlen and maxlen are now separated by the alignment size, and
> allocation fails because args.total > free space in the AG.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---

Seems fine, but what about the bma.minlen alignment fix (in
xfs_bmap_btalloc()) Dave suggested in the previous thread?

Brian

>  fs/xfs/libxfs/xfs_alloc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 372ad55631fc..35b39fc863a0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1989,7 +1989,8 @@ xfs_alloc_longest_free_extent(
>  	 * reservations and AGFL rules in place, we can return this extent.
>  	 */
>  	if (pag->pagf_longest > delta)
> -		return pag->pagf_longest - delta;
> +		return min_t(xfs_extlen_t, pag->pag_mount->m_ag_max_usable,
> +				pag->pagf_longest - delta);
>  
>  	/* Otherwise, let the caller try for 1 block if there's space. */
>  	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
> -- 
> 2.20.1
> 
