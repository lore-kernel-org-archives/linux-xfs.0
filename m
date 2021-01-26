Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7927C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DBD720663
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbhAZXDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729683AbhAZSYX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 13:24:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 015B3207A9;
        Tue, 26 Jan 2021 18:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611685415;
        bh=6poH3TGjlpb1a0ctBuqFL7VNcSof9v1aPlqNrEKttaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rDVw7MjUvU8qn51RwVli/bxJwMoNKqTP6XNx6/c7kvVnVuY9NgfBlrs3CpL1TCtJ+
         AmdcbNyBWGRap9V4HbQwkFl4CLpvqag98zZQK+qZhi3ZPa8uiotWcEmbP2YAq9vBqY
         XGusMn0rMkHu3jZk9dpUlbU0k5iv4BNMJcRFH2w4gYSxN014g3QicwxtlKgARpnBze
         hmjy1MkEAFKp8NDwzHp7BqqkCzgeQbSy3wsBRxL0ien7hiP+4FR2wWpEeiesXKrl5D
         WXAE71UGBqrHNtuCSr+MP25pwRYDF8TKE2w7+21yqjuzO8si+4GNSrai/yE1sPK2XX
         R8epP4RcflZuw==
Date:   Tue, 26 Jan 2021 10:23:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 4/4] xfs: clean up icreate quota reservation calls
Message-ID: <20210126182334.GY7698@magnolia>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
 <161142791730.2170981.16295389347749875438.stgit@magnolia>
 <20210125151722.GF2047559@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125151722.GF2047559@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 25, 2021 at 10:17:22AM -0500, Brian Foster wrote:
> On Sat, Jan 23, 2021 at 10:51:57AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a proper helper so that inode creation calls can reserve quota
> > with a dedicated function.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_inode.c       |    8 ++++----
> >  fs/xfs/xfs_quota.h       |   15 +++++++++++----
> >  fs/xfs/xfs_symlink.c     |    4 ++--
> >  fs/xfs/xfs_trans_dquot.c |   21 +++++++++++++++++++++
> >  4 files changed, 38 insertions(+), 10 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index 28b8ac701919..3315498a6fa1 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -804,6 +804,27 @@ xfs_trans_reserve_quota_nblks(
> >  						nblks, ninos, flags);
> >  }
> >  
> > +/* Change the quota reservations for an inode creation activity. */
> > +int
> > +xfs_trans_reserve_quota_icreate(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*dp,
> > +	struct xfs_dquot	*udqp,
> > +	struct xfs_dquot	*gdqp,
> > +	struct xfs_dquot	*pdqp,
> > +	int64_t			nblks)
> > +{
> > +	struct xfs_mount	*mp = dp->i_mount;
> > +
> > +	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> > +		return 0;
> > +
> > +	ASSERT(!xfs_is_quota_inode(&mp->m_sb, dp->i_ino));
> > +
> > +	return xfs_trans_reserve_quota_bydquots(tp, dp->i_mount, udqp, gdqp,
> > +			pdqp, nblks, 1, XFS_QMOPT_RES_REGBLKS);
> 
> Considering we can get mp from tp (and it looks like we always pass tp),
> is it worth even passing in dp for an (unlikely) assert? That seems a
> little odd anyways since nothing down in this path actually uses or
> cares about the parent inode. Also, no need to pass dp->i_mount above if
> we've already defined mp, at least.

You're correct, we can drop the *dp parameter entirely.

--D

> Brian
> 
> > +}
> > +
> >  /*
> >   * This routine is called to allocate a quotaoff log item.
> >   */
> > 
> 
