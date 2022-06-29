Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7ED4C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 18:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiF2Snf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 14:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiF2Snf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 14:43:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC1E24BE7
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 11:43:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2005B82654
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 932E9C341C8;
        Wed, 29 Jun 2022 18:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656528211;
        bh=xXM8cXHwQ/tBnBgljJA5+LIp1VWk6lPq6xOA2ahntAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sEDDlIhZcwS/gRMojqyTO42k14aDeOwPf1PvhACAZX/ULvh9whzUgpRrXl25s056C
         x/oPA73lvgW8hGWqtiku0+jTfFD2w0PjSu9KgCcXEP3xVAPZKYLGYqE9Sdbihs7n9l
         DdR1rWJmZPuek/8jA15VRjbf+HMkqSH8OaxVGrDlwFnE9moVO24Bsv1u/a+ZHyoSPF
         LKoiMrTL++xDB/0SXfV2fefKnbpZmIuq6Pt37sqnurYwTfKKYzzFRJ+Ih6PMBPD3Ww
         It4cQxNNaHQBB2lPMVKdPKAxSuD8y6vXZrb/4v1ucTtE5ZJVycvphFbiU569bXMtN5
         7n4QNzfS7KzYw==
Date:   Wed, 29 Jun 2022 11:43:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 16/17] xfs: Increase  XFS_DEFER_OPS_NR_INODES to 4
Message-ID: <YrydU/1ePnAmzUWm@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
 <20220611094200.129502-17-allison.henderson@oracle.com>
 <20220616215437.GF227878@dread.disaster.area>
 <a3b5a1eac6287e6faf8ec253f903bcfdd554e9b3.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3b5a1eac6287e6faf8ec253f903bcfdd554e9b3.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 17, 2022 at 05:32:45PM -0700, Alli wrote:
> On Fri, 2022-06-17 at 07:54 +1000, Dave Chinner wrote:
> > On Sat, Jun 11, 2022 at 02:41:59AM -0700, Allison Henderson wrote:
> > > Renames that generate parent pointer updates will need to 2 extra
> > > defer
> > > operations. One for the rmap update and another for the parent
> > > pointer
> > > update
> > 
> > Not sure I follow this - defer operation counts are something
> > tracked in the transaction reservations, whilst this is changing the
> > number of inodes that are joined and held across defer operations.
> > 
> > These rmap updates already occur on the directory inodes in a rename
> > (when the dir update changes the dir shape), so I'm guessing that
> > you are now talking about changing parent attrs for the child inodes
> > may require attr fork shape changes (hence rmap updates) due to the
> > deferred parent pointer xattr update?
> > 
> > If so, this should be placed in the series before the modifications
> > to the rename operation is modified to join 4 ops to it, preferably
> > at the start of the series....
> 
> I see, sure, I can move this patch down to the beginning of the set
> > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_defer.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > > index 114a3a4930a3..0c2a6e537016 100644
> > > --- a/fs/xfs/libxfs/xfs_defer.h
> > > +++ b/fs/xfs/libxfs/xfs_defer.h
> > > @@ -70,7 +70,7 @@ extern const struct xfs_defer_op_type
> > > xfs_attr_defer_type;
> > >  /*
> > >   * Deferred operation item relogging limits.
> > >   */
> > > -#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
> > > +#define XFS_DEFER_OPS_NR_INODES	4	/* join up to four inodes
> > > */
> > 
> > The comment is not useful  - it should desvribe what operation
> > requires 4 inodes to be joined. e.g.
> > 
> > /*
> >  * Rename w/ parent pointers requires 4 indoes with defered ops to
> >  * be joined to the transaction.
> >  */
> Sure, will update
> 
> > 
> > Then, if we are changing the maximum number of inodes that are
> > joined to a deferred operation, then we need to also update the
> > locking code such as in xfs_defer_ops_continue() that has to order
> > locking of multiple inodes correctly.
> Ok, I see it, I will take a look at updating that
> 
> > 
> > Also, rename can lock and modify 5 inodes, not 4, so the 4 inodes
> > that get joined here need to be clearly documented somewhere. 
> Ok, I think its src dir, target dir, src inode, target inode, and then
> wip.  Do we want the documenting in xfs_defer_ops_continue?  Or just
> the commit description?
> 
> > Also,
> > xfs_sort_for_rename() that orders all the inodes in rename into
> > correct locking order in an array, and xfs_lock_inodes() that does
> > the locking of the inodes in the array.
> Yes, I see it.  You want a comment in xfs_defer_ops_continue referring
> to the order?

I wouldn't mind one somewhere, though it could probably live with the
parent pointer helper functions or buried in xfs_rename somewhere.

--D

> 
> Thanks!
> Allison
> 
> > 
> > Cheers,
> > 
> > Dave.
> 
