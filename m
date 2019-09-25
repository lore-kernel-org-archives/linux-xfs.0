Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C32DC432C1
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 11:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7929C21D7A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 11:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389351AbfIYLxN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 07:53:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388378AbfIYLxN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Sep 2019 07:53:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 461D2307D844;
        Wed, 25 Sep 2019 11:53:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3A0960C44;
        Wed, 25 Sep 2019 11:53:10 +0000 (UTC)
Date:   Wed, 25 Sep 2019 07:53:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Limit total allocation request to maximum
 possible
Message-ID: <20190925115308.GA21991@bfoster>
References: <20190918082453.25266-1-cmaiolino@redhat.com>
 <20190918082453.25266-3-cmaiolino@redhat.com>
 <20190924205029.GF16973@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924205029.GF16973@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 25 Sep 2019 11:53:13 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 25, 2019 at 06:50:29AM +1000, Dave Chinner wrote:
> On Wed, Sep 18, 2019 at 10:24:53AM +0200, Carlos Maiolino wrote:
> > The original allocation request may have a total value way beyond
> > possible limits.
> > 
> > Trim it down to the maximum possible if needed
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 07aad70f3931..3aa0bf5cc7e3 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3477,6 +3477,11 @@ xfs_bmap_btalloc(
> >  			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
> >  		else
> >  			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
> > +
> > +		/* We can never have total larger than blen, so trim it now */
> 
> Yes we can. blen is typically the largest contiguous extent in the
> filesystem or AG in question. It is not typically the total free
> space in the AG, which only occurs when the AG is empty. i.e. in
> normal situations, we can allocate both blen and the rest of the
> metadata from the same AG as there is more than one free extent in
> the AG.
> 

Right..

> I think that for the purposes of a single > AG size allocation, the
> total needs to be clamped to the free space in the AG that is
> selected, not the length of the allocation we are trying....
> 

As already noted, I do think args.total could use some work. But unless
I'm missing something about the set of callers modified in the original
patch, I'd rather not tweak a core bmap mechanism in service to callers
that have no reason to use said mechanism in the first place.

And I know that such a change would affect legitimate args.total users
too and so still might be appropriate, I just think that's something for
a separate patch (even if in the same series)...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
