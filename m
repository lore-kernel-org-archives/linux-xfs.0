Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A71CC35DE1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 13:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17DF20658
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 13:26:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UuFUqYwU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgBYN0w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 08:26:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729155AbgBYN0w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 08:26:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582637211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HE2noCMnBCEFgoq1sIdLVBIRQx5ps1nMZ2wQZn5oShM=;
        b=UuFUqYwUInB/f3AzLc3O9Xl3yl0I5UgnyixBiFba9H085pwG62Ebs/mItj/4hONvCFdujt
        r3LHDxDz19ugZ97bzd1EQttwItgDX1qWJ5AgnUiIT00/qq4IDRXuvgAl7lhg0Ge4hh0zru
        idczI89Gj9wWr0eeSJUdcs35ip9Chqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-yhh2ZtCbP_WySGfS7o-3Gw-1; Tue, 25 Feb 2020 08:26:49 -0500
X-MC-Unique: yhh2ZtCbP_WySGfS7o-3Gw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C618107ACC7;
        Tue, 25 Feb 2020 13:26:48 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F05B45C13D;
        Tue, 25 Feb 2020 13:26:47 +0000 (UTC)
Date:   Tue, 25 Feb 2020 08:26:46 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 07/19] xfs: Factor out xfs_attr_leaf_addname helper
Message-ID: <20200225132646.GB21304@bfoster>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-8-allison.henderson@oracle.com>
 <20200225064207.GG10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225064207.GG10776@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 05:42:07PM +1100, Dave Chinner wrote:
> On Sat, Feb 22, 2020 at 07:05:59PM -0700, Allison Collins wrote:
> > Factor out new helper function xfs_attr_leaf_try_add. Because new delayed attribute
> > routines cannot roll transactions, we carve off the parts of xfs_attr_leaf_addname
> > that we can use, and move the commit into the calling function.
> 
> 68-72 columns :P
> 
> > 
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c | 88 +++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 57 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index cf0cba7..b2f0780 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -305,10 +305,30 @@ xfs_attr_set_args(
> >  		}
> >  	}
> >  
> > -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> > +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> >  		error = xfs_attr_leaf_addname(args);
> > -	else
> > -		error = xfs_attr_node_addname(args);
> > +		if (error != -ENOSPC)
> > +			return error;
> > +
> > +		/*
> > +		 * Commit that transaction so that the node_addname()
> > +		 * call can manage its own transactions.
> > +		 */
> > +		error = xfs_defer_finish(&args->trans);
> > +		if (error)
> > +			return error;
> > +
> > +		/*
> > +		 * Commit the current trans (including the inode) and
> > +		 * start a new one.
> > +		 */
> > +		error = xfs_trans_roll_inode(&args->trans, dp);
> > +		if (error)
> > +			return error;
> > +
> > +	}
> > +
> > +	error = xfs_attr_node_addname(args);
> >  	return error;
> 
> 	return xfs_attr_node_addname(args);
> 
> better yet:
> 
> 	if (!xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> 		return xfs_attr_node_addname(args);
> 
> 	error = xfs_attr_leaf_addname(args);
> 	if (error != -ENOSPC)
> 		return error;
> 	.....
> 
> BTW, I think I see the pattern now - isolate all the metadata
> changes from the mechanism of rolling the transactions, which means
> it can be converted to a set of operations connected by a generic
> transaction rolling mechanism. It's all starting to make more sense
> now :P
> 

Yeah.. IIRC the initial attempt at this was going down the path of
creating an entire separate xattr codepath for xattr intents. The
existing codepath has the issue of rolling transactions all over the
place, which makes it difficult to execute from dfops context. The goal
is then to try and take this thing apart such that it works in dfops
context for intents and at the same time can be driven by a high level
transaction rolling loop to support the traditional xattr codepath for
backwards compatibility.

The whole state/context thing fell out of that. I think most agree that
it's ugly, but it's a useful intermediate step for breaking down this
hunk of code into components that can be further evaluated for
simplification and reduction (while making functional progress as well).
E.g., perhaps the top-level states can be eliminated in favor of simply
looking at current xattr fork format. This gets hairier deeper down in
the set path, but I think we may eventually see some similar patterns
emerge when you consider that leaf and node adds follow a very similar
flow and make many of the same function calls with regard to handling
remote values, renames, etc. etc. All in all, I think it will be
interesting if we could come up with some abstractions that ultimately
facilitate removal of the state stuff. That's certainly not clear
enough to me at least right now, but something to keep in mind when
working through this code..

Brian

> > @@ -679,31 +700,36 @@ xfs_attr_leaf_addname(
> >  	retval = xfs_attr3_leaf_add(bp, args);
> >  	if (retval == -ENOSPC) {
> >  		/*
> > -		 * Promote the attribute list to the Btree format, then
> > -		 * Commit that transaction so that the node_addname() call
> > -		 * can manage its own transactions.
> > +		 * Promote the attribute list to the Btree format.
> > +		 * Unless an error occurs, retain the -ENOSPC retval
> >  		 */
> 
> Comments should use all 80 columns...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

