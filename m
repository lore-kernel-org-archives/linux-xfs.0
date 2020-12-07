Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71503C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 20:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5BF2332A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 20:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgLGUUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 15:20:00 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:39463 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgLGUUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 15:20:00 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 011681ADD6B;
        Tue,  8 Dec 2020 07:19:09 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kmMyS-001YlD-SD; Tue, 08 Dec 2020 07:19:08 +1100
Date:   Tue, 8 Dec 2020 07:19:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v3 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201207201908.GS3913616@dread.disaster.area>
References: <20201207001533.2702719-1-hsiangkao@redhat.com>
 <20201207001533.2702719-4-hsiangkao@redhat.com>
 <20201207134941.GD29249@lst.de>
 <20201207141948.GB2817641@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207141948.GB2817641@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=7-415B0cAAAA:8
        a=pwI_e6mPV07eg6EEn54A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 10:19:48PM +0800, Gao Xiang wrote:
> On Mon, Dec 07, 2020 at 02:49:41PM +0100, Christoph Hellwig wrote:
> > On Mon, Dec 07, 2020 at 08:15:30AM +0800, Gao Xiang wrote:
> > >  /*
> > > + * Initialise a newly allocated inode and return the in-core inode to the
> > > + * caller locked exclusively.
> > >   */
> > > -static int
> > > -xfs_ialloc(
> > > -	xfs_trans_t	*tp,
> > > -	xfs_inode_t	*pip,
> > > -	umode_t		mode,
> > > -	xfs_nlink_t	nlink,
> > > -	dev_t		rdev,
> > > -	prid_t		prid,
> > > -	xfs_buf_t	**ialloc_context,
> > > -	xfs_inode_t	**ipp)
> > > +static struct xfs_inode *
> > > +xfs_dir_ialloc_init(
> > 
> > This is boderline bikeshedding, but I would just call this
> > xfs_init_new_inode.
> 
> (See below...)
> 
> > 
> > >  int
> > >  xfs_dir_ialloc(
> > > @@ -954,83 +908,59 @@ xfs_dir_ialloc(
> > >  	xfs_inode_t	**ipp)		/* pointer to inode; it will be
> > >  					   locked. */
> > >  {
> > >  	xfs_inode_t	*ip;
> > >  	xfs_buf_t	*ialloc_context = NULL;
> > > +	xfs_ino_t	pino = dp ? dp->i_ino : 0;
> > 
> > Maybe spell out parent_inode?  pino reminds of some of the weird Windows
> > code that start all variable names for pointers with a "p".
> 
> Ok, yet pino is somewhat common, as I saw it in f2fs and jffs2 before.
> I know you mean 'Hungarian naming conventions'.
> 
> If you don't like pino. How about parent_ino? since parent_inode occurs me
> about "struct inode *" or something like this (a pointer around some inode),
> rather than an inode number.
> 
> > 
> > > +	/* Initialise the newly allocated inode. */
> > > +	ip = xfs_dir_ialloc_init(*tpp, dp, ino, mode, nlink, rdev, prid);
> > > +	if (IS_ERR(ip))
> > > +		return PTR_ERR(ip);
> > > +	*ipp = ip;
> > >  	return 0;
> > 
> > I wonder if we should just return the inode by reference from
> > xfs_dir_ialloc_init as well, as that nicely fits the calling convention
> > in the caller, i.e. this could become
> > 
> > 	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid, ipp);
> > 
> > Note with the right naming we don't really need the comment either,
> > as the function name should explain everything.
> 
> Okay, the name was from Dave to unify the prefix (namespace)... I think it'd
> be better to get Dave's idea about this as well. As of me, I'm fine with
> either way.

I'm fine with that.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
