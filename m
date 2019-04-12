Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:52452 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfDLGai (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 02:30:38 -0400
Date: Thu, 11 Apr 2019 23:30:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: use struct_size() helper
Message-ID: <20190412063023.GI1019523@magnolia>
References: <20190411233758.GA19031@embeddedor>
 <20190412001941.GV15524@magnolia>
 <51407603-d144-ece9-6cd5-edea72374527@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51407603-d144-ece9-6cd5-edea72374527@embeddedor.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 11, 2019 at 08:57:14PM -0500, Gustavo A. R. Silva wrote:
> 
> 
> On 4/11/19 7:19 PM, Darrick J. Wong wrote:
> > [fixing linux-xfs cc]
> > 
> 
> Thanks for this.
> 
> > On Thu, Apr 11, 2019 at 06:37:58PM -0500, Gustavo A. R. Silva wrote:
> >> Make use of the struct_size() helper instead of an open-coded  version
> >> in order to avoid any potential type mistakes, in particular in the
> >> context in which this code is being used.
> >>
> >> So, replace code of the following form:
> >>
> >> sizeof(*alist) + context->count * sizeof(alist->al_offset[0]
> >>
> >> with:
> >>
> >> struct_size(alist, al_offset, context->count)
> >>
> >> and remove unnecessary variable arraytop.
> >>
> >> This code was detected with the help of Coccinelle.
> >>
> >> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> > 
> > Has this been run through xfstests?
> > 
> 
> No.  Is this a requirement?

Yes, since this is a change to core functionality (and my eyes aren't so
good at digging through preprocessor macros...)

--D

> Thanks
> --
> Gustavo
> 
> > --D
> > 
> >>  fs/xfs/xfs_attr_list.c | 5 +----
> >>  1 file changed, 1 insertion(+), 4 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> >> index 3d213a7394c5..05e03348553e 100644
> >> --- a/fs/xfs/xfs_attr_list.c
> >> +++ b/fs/xfs/xfs_attr_list.c
> >> @@ -553,7 +553,6 @@ xfs_attr_put_listent(
> >>  {
> >>  	struct attrlist *alist = (struct attrlist *)context->alist;
> >>  	attrlist_ent_t *aep;
> >> -	int arraytop;
> >>  
> >>  	ASSERT(!context->seen_enough);
> >>  	ASSERT(!(context->flags & ATTR_KERNOVAL));
> >> @@ -572,10 +571,8 @@ xfs_attr_put_listent(
> >>  	    ((flags & XFS_ATTR_ROOT) == 0))
> >>  		return;
> >>  
> >> -	arraytop = sizeof(*alist) +
> >> -			context->count * sizeof(alist->al_offset[0]);
> >>  	context->firstu -= ATTR_ENTSIZE(namelen);
> >> -	if (context->firstu < arraytop) {
> >> +	if (context->firstu < struct_size(alist, al_offset, context->count)) {
> >>  		trace_xfs_attr_list_full(context);
> >>  		alist->al_more = 1;
> >>  		context->seen_enough = 1;
> >> -- 
> >> 2.21.0
> >>
