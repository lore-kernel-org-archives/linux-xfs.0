Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DB4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Mar 2022 01:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbiC3BWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 21:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbiC3BWS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 21:22:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5624E4739F
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 18:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE53ECE1A5A
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 01:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8E8C340F0;
        Wed, 30 Mar 2022 01:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648603231;
        bh=VCpKXt3dP3HXRZplU5WWTgCtQwXLwjLV1A1KE16ewGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FCBEeMC/UbMa/f+LwVqvjjR7EzkEL5VFQdjwI3Q0vUXJbUyq/Y9tPTUnDDX9unJf3
         El8PIQ6VzVpvDCJ29+5rbiEtCfNYeG2vrK6tkPsWJHhwKikf/JrNzUoiriyiKRzlnl
         U4tOoXXXx82vupvq3MHPgA5al2vdIVhyfZL+yihp4NBzeSo4KYImxkW9isXadMlU5B
         EwJLKF5M7cSJc/t95j0qgmmG8brRek4lvwNPn/aA9+hX2ejB9vQ7SLB4/ux0uefTFk
         8I/3Cl4J+cJX/SdcMhSmYJepPeFfMV2V+tEk3rbg4v62Y9UTKXmn8tMr4OAYnT2QsG
         +3yzWRHLcHy3w==
Date:   Tue, 29 Mar 2022 18:20:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: aborting inodes on shutdown may need buffer lock
Message-ID: <20220330012030.GF27690@magnolia>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-2-david@fromorbit.com>
 <20220328224452.GA27690@magnolia>
 <20220328231109.GV1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328231109.GV1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 10:11:09AM +1100, Dave Chinner wrote:
> On Mon, Mar 28, 2022 at 03:44:52PM -0700, Darrick J. Wong wrote:
> > On Thu, Mar 24, 2022 at 11:20:58AM +1100, Dave Chinner wrote:
> > >  xfs_iflush_abort(
> > >  	struct xfs_inode	*ip)
> > >  {
> > >  	struct xfs_inode_log_item *iip = ip->i_itemp;
> > > -	struct xfs_buf		*bp = NULL;
> > > +	struct xfs_buf		*bp;
> > >  
> > > -	if (iip) {
> > > -		/*
> > > -		 * Clear the failed bit before removing the item from the AIL so
> > > -		 * xfs_trans_ail_delete() doesn't try to clear and release the
> > > -		 * buffer attached to the log item before we are done with it.
> > > -		 */
> > > -		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> > > -		xfs_trans_ail_delete(&iip->ili_item, 0);
> > > +	if (!iip) {
> > > +		/* clean inode, nothing to do */
> > > +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> > > +		return;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Remove the inode item from the AIL before we clear it's internal
> > 
> > Nit: "it's" is a contraction, "its" is possessive.
> > 
> > > +	 * state. Whilst the inode is in the AIL, it should have a valid buffer
> > > +	 * pointer for push operations to access - it is only safe to remove the
> > > +	 * inode from the buffer once it has been removed from the AIL.
> > > +	 *
> > > +	 * We also clear the failed bit before removing the item from the AIL
> > > +	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
> > > +	 * references the inode item owns and needs to hold until we've fully
> > > +	 * aborted the inode log item and detatched it from the buffer.
> > 
> > Nit: detached
> > 
> > > +	 */
> > > +	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> > 
> > I wonder, is there any chance the AIL will stumble onto the inode item
> > right here?
> 
> It can, but now it will fail to get the buffer lock because we
> currently hold it and so can't do anything writeback related with
> the inode item regardless of whether this bit is set or not.  i.e.
> This patch actually fixes the race you are refering to....

Ok.  I was thinking that these changes would eliminate that possibility,
but wasn't 100% sure.

> > > +	xfs_trans_ail_delete(&iip->ili_item, 0);
> > > +
> > > +	/*
> > > +	 * Capture the associated buffer and lock it if the caller didn't
> > > +	 * pass us the locked buffer to begin with.
> > 
> > I agree that we're capturing the buffer here, but this function is not
> > locking the buffer since the comment says that the caller has to hold
> > the buffer lock already, correct?  And AFAICT from looking at all the
> > callers, they all hold the buffer locked, like the comment requires.
> 
> I thought I killed that comment - you noted it was incorrect in
> the previous iteration. I'll kill it properly when I update the
> spulling misteaks above.

hehehe.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
