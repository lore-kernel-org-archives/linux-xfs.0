Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34786 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752130AbdICVEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 17:04:54 -0400
Date: Sun, 3 Sep 2017 14:04:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC][PATCH] fstests: regression test for xfs leftover CoW
 extent error
Message-ID: <20170903210427.GJ4073@magnolia>
References: <1504451271-29202-1-git-send-email-amir73il@gmail.com>
 <20170903174513.GI4073@magnolia>
 <20170903182133.GA1757@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903182133.GA1757@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Amir Goldstein <amir73il@gmail.com>, Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 08:21:33PM +0200, Christoph Hellwig wrote:
> > So basically there are two bugs here -- the fcollapse/finsert code needs
> > to shift the CoW fork extents down and up;
> 
> Or make sure that we don't have any extents in the COW fork?

It's a big hammer approach, but yes that'd work.

We're already forcing all the dirty pages out anyway so I guess it's no
big deal.

> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 9207d61..ae3b18f 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1625,7 +1625,7 @@ xfs_itruncate_extents(
> >         /*
> >          * Clear the reflink flag if we truncated everything.
> >          */
> > -       if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
> > +       if (ip->i_d.di_nblocks == 0 && ip->i_cnextents == 0 && xfs_is_reflink_inode(ip)) {
> 
> Btw, it seems like we should generally clear the reflink flag and
> tag if ip->i_cnextents is zero and not even bother looking at di_nblocks.

We can't -- imagine shortening to 8k a reflinked 12k file that hasn't been
written to.  It has no cow extents, but we cannot drop the reflink flag.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
