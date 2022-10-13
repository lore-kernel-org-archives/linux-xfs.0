Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E14C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 22:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiJMWux (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiJMWuw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 18:50:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEE7E6F6E
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 15:50:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD7D7B82160
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 22:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F73C433D6;
        Thu, 13 Oct 2022 22:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665701448;
        bh=LrXKgf+R9xCGhJgvdAmnLDEreFtSnaGP4+yvYuZs4tc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MiY0/450GxmT8gP3pkz11C6HKNrzh+u4E6ya+HQAT/vIvwD4K/BXJJoppCl0J13wA
         QfPrGRh7GqF0xzVKbr2cANBtKrDraZsenzs3m2npN2w3fxcMNII6r92IsBvcbC+pH8
         JJXJ8Q3eehASoa9ECdWo8ZbB85GEycP7OjvyPhc7ji4XUkINafqgcOFwxADIqbcLZA
         RhNxm+DJXh1He4dchOygACETeR0a0/xqlXZIYfZaVPJR3VcK0yqe6+9+qrZS2UKQ/N
         YPFSRH64+ONVibrdfQGNP04283/bAPf577/UX3eUAH4QpIP2oadpzBh/FH+ldQGmud
         klWMmrvID37TQ==
Date:   Thu, 13 Oct 2022 15:50:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: pivot online scrub away from kmem.[ch]
Message-ID: <Y0iWRxk8YPPt78l7@magnolia>
References: <166473479188.1083296.3778962206344152398.stgit@magnolia>
 <166473479220.1083296.3091934137369803342.stgit@magnolia>
 <20221013224220.GD3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013224220.GD3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 14, 2022 at 09:42:20AM +1100, Dave Chinner wrote:
> On Sun, Oct 02, 2022 at 11:19:52AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Convert all the online scrub code to use the Linux slab allocator
> > functions directly instead of going through the kmem wrappers.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> .....
> 
> > ---
> > diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> > index 2f4519590dc1..566a093b2cf3 100644
> > --- a/fs/xfs/scrub/btree.c
> > +++ b/fs/xfs/scrub/btree.c
> > @@ -431,10 +431,10 @@ xchk_btree_check_owner(
> >  	 * later scanning.
> >  	 */
> >  	if (cur->bc_btnum == XFS_BTNUM_BNO || cur->bc_btnum == XFS_BTNUM_RMAP) {
> > -		co = kmem_alloc(sizeof(struct check_owner),
> > -				KM_MAYFAIL);
> > +		co = kmalloc(sizeof(struct check_owner), XCHK_GFP_FLAGS);
> >  		if (!co)
> >  			return -ENOMEM;
> > +		INIT_LIST_HEAD(&co->list);
> 
> Fixes some other bug?
> 
> It's obvious that it should be initialised, so I'm not concerned
> about it being here, just checking that you intended to fix this
> here and it doesn't belong to some other patchset?

Yeah, it'll fix list debugging tripping over the unininitialized
list_head.  I probably should've made that a separate oneliner but...
eh.  There are already too many patches.

--D

> Otherwise:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -- 
> Dave Chinner
> david@fromorbit.com
