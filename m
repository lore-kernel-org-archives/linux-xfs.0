Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50647 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933120AbdKBQtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 12:49:23 -0400
Date: Thu, 2 Nov 2017 09:49:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: scrub: avoid uninitialized return code
Message-ID: <20171102164914.GV4911@magnolia>
References: <20171102111137.3062126-1-arnd@arndb.de>
 <20171102124359.GB16645@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102124359.GB16645@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org

On Thu, Nov 02, 2017 at 08:44:00AM -0400, Brian Foster wrote:
> On Thu, Nov 02, 2017 at 12:11:12PM +0100, Arnd Bergmann wrote:
> > The newly added xfs_scrub_da_btree_block() function has one code path
> > that returns the 'error' variable without initializing it first, as
> > shown by this compiler warning:
> > 
> > fs/xfs/scrub/dabtree.c: In function 'xfs_scrub_da_btree_block':
> > fs/xfs/scrub/dabtree.c:462:9: error: 'error' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> > 
> > Returning -EINVAL might be an appropriate return code in this case.
> > 
> > Fixes: 7c4a07a424c1 ("xfs: scrub directory/attribute btrees")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  fs/xfs/scrub/dabtree.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
> > index 4a93cf1753d3..971566388c9a 100644
> > --- a/fs/xfs/scrub/dabtree.c
> > +++ b/fs/xfs/scrub/dabtree.c
> > @@ -349,8 +349,10 @@ xfs_scrub_da_btree_block(
> >  
> >  	/* Check the pointer. */
> >  	blk->blkno = blkno;
> > -	if (!xfs_scrub_da_btree_ptr_ok(ds, level, blkno))
> > +	if (!xfs_scrub_da_btree_ptr_ok(ds, level, blkno)) {
> > +		error = -EINVAL;
> >  		goto out_nobuf;
> > +	}
> 
> Hmm.. is an error really the right thing to do here vs. setting the
> context corrupt and returning 0? (Darrick..?) If the latter, perhaps
> error should just be initialized to 0.

Yes, zero.  We return from this function with a NULL blks[level]->bp
(and the corrupt flag set) so the caller (xfs_scrub_da_btree) will
return.

--D

> 
> Brian
> 
> >  
> >  	/* Read the buffer. */
> >  	error = xfs_da_read_buf(dargs->trans, dargs->dp, blk->blkno, -2,
> > -- 
> > 2.9.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
