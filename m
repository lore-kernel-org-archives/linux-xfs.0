Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D22EC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 22:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJMWmY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJMWmX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 18:42:23 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00CE014638B
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 15:42:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 00A218AD572;
        Fri, 14 Oct 2022 09:42:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oj6uC-001eZI-O7; Fri, 14 Oct 2022 09:42:20 +1100
Date:   Fri, 14 Oct 2022 09:42:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: pivot online scrub away from kmem.[ch]
Message-ID: <20221013224220.GD3600936@dread.disaster.area>
References: <166473479188.1083296.3778962206344152398.stgit@magnolia>
 <166473479220.1083296.3091934137369803342.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473479220.1083296.3091934137369803342.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6348944e
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=smh-geK6vG3HFp9fG54A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:19:52AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert all the online scrub code to use the Linux slab allocator
> functions directly instead of going through the kmem wrappers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

.....

> ---
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 2f4519590dc1..566a093b2cf3 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -431,10 +431,10 @@ xchk_btree_check_owner(
>  	 * later scanning.
>  	 */
>  	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
> -		co = kmem_alloc(sizeof(struct check_owner),
> -				KM_MAYFAIL);
> +		co = kmalloc(sizeof(struct check_owner), XCHK_GFP_FLAGS);
>  		if (!co)
>  			return -ENOMEM;
> +		INIT_LIST_HEAD(&co->list);

Fixes some other bug?

It's obvious that it should be initialised, so I'm not concerned
about it being here, just checking that you intended to fix this
here and it doesn't belong to some other patchset?

Otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
