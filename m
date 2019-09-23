Return-Path: <SRS0=UWJz=XS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C8AC04EBF
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 13:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC8A920835
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Sep 2019 13:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407104AbfIWNLj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Sep 2019 09:11:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407069AbfIWNLj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Sep 2019 09:11:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 210DCA707;
        Mon, 23 Sep 2019 13:11:39 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD69E6017E;
        Mon, 23 Sep 2019 13:11:38 +0000 (UTC)
Date:   Mon, 23 Sep 2019 09:11:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/2] xfs: Limit total allocation request to maximum
 possible
Message-ID: <20190923131136.GA9071@bfoster>
References: <20190918082453.25266-1-cmaiolino@redhat.com>
 <20190918082453.25266-3-cmaiolino@redhat.com>
 <20190918122859.GB29377@bfoster>
 <20190923123934.6zigycei3nmwi54x@pegasus.maiolino.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923123934.6zigycei3nmwi54x@pegasus.maiolino.io>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 23 Sep 2019 13:11:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 23, 2019 at 02:39:34PM +0200, Carlos Maiolino wrote:
> On Wed, Sep 18, 2019 at 08:28:59AM -0400, Brian Foster wrote:
> > On Wed, Sep 18, 2019 at 10:24:53AM +0200, Carlos Maiolino wrote:
> > > The original allocation request may have a total value way beyond
> > > possible limits.
> > > 
> > > Trim it down to the maximum possible if needed
> > > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > 
> > Confused.. what was wrong with the original bma.total patch that it
> > needs to be replaced?
> 
> At this point in time, what you mean by the 'original' patch? :) Yours? Or
> Dave's?
> 

The original patch I posted..

> If you meant yours, I was just trying to find out a way to fix it without
> modifying the callers, nothing else than that.
> 
> If you meant regarding Dave's proposal, as he tagged his proposal as a /* Hack
> */, I was just looking for ways to change total, instead of cropping it to 0.
> 
> And giving the fact args.total > blen seems unreasonable, giving it will
> certainly tail here, I just thought it might be a reasonable way to change
> args.total value.
> 

I think the code is flaky, but I'm not sure why that's unreasonable. The
intent of args.total is to be larger than the mapping length.

> By no means this patchset was meant to supersede yours or Dave's idea though, I
> was just looking for a different approach, if feasible.
> 
> 
> > I was assuming we'd replace the allocation retry
> > patch with the minlen alignment fixups and combine those with the
> > bma.total patch to fix the problem. Hm?
> > 
> > >  fs/xfs/libxfs/xfs_bmap.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index 07aad70f3931..3aa0bf5cc7e3 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -3477,6 +3477,11 @@ xfs_bmap_btalloc(
> > >  			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
> > >  		else
> > >  			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
> > > +
> > > +		/* We can never have total larger than blen, so trim it now */
> > > +		if (args.total > blen)
> > > +			args.total = blen;
> > > +
> > 
> > I don't think this is safe. The reason the original patch only updated
> > certain callers is because those callers only used it for extra blocks
> > that are already incorported into bma.minleft by the bmap layer itself.
> > There are still other callers for which bma.total is specifically
> > intended to be larger than the map size.
> 
> Afaik, yes, but still, total is basically used to attempt an allocation of data
> + metadata on the same AG if possible, reducing args.total to match blen, the
> 'worst' case would be to have an allocation of data + metadata on different ags,
> which, if total is larger than blen, it will fall into that behavior anyway.
> 

Maybe..? There is no requirement that the additional blocks accounted by
args.total be contiguous with the allocation for the mapping, so I don't
see how you could reliably predict that.

Brian

> 
> > 
> > Brian
> > 
> > >  		if (error)
> > >  			return error;
> > >  	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
> > > -- 
> > > 2.20.1
> > > 
> 
> -- 
> Carlos
