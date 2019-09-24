Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC46C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 20:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D17721655
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 20:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbfIXUuc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 16:50:32 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46206 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726528AbfIXUuc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 16:50:32 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DDD20361CFE;
        Wed, 25 Sep 2019 06:50:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iCrlV-0005Dl-A1; Wed, 25 Sep 2019 06:50:29 +1000
Date:   Wed, 25 Sep 2019 06:50:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 2/2] xfs: Limit total allocation request to maximum
 possible
Message-ID: <20190924205029.GF16973@dread.disaster.area>
References: <20190918082453.25266-1-cmaiolino@redhat.com>
 <20190918082453.25266-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918082453.25266-3-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=Cqzt7GXRoRXrTWOJTgAA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 10:24:53AM +0200, Carlos Maiolino wrote:
> The original allocation request may have a total value way beyond
> possible limits.
> 
> Trim it down to the maximum possible if needed
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 07aad70f3931..3aa0bf5cc7e3 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3477,6 +3477,11 @@ xfs_bmap_btalloc(
>  			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
>  		else
>  			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
> +
> +		/* We can never have total larger than blen, so trim it now */

Yes we can. blen is typically the largest contiguous extent in the
filesystem or AG in question. It is not typically the total free
space in the AG, which only occurs when the AG is empty. i.e. in
normal situations, we can allocate both blen and the rest of the
metadata from the same AG as there is more than one free extent in
the AG.

I think that for the purposes of a single > AG size allocation, the
total needs to be clamped to the free space in the AG that is
selected, not the length of the allocation we are trying....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
