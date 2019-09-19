Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68865C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 11:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A53621924
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 11:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388795AbfISLzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 07:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388771AbfISLzV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 07:55:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 27AE93082138;
        Thu, 19 Sep 2019 11:55:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91F3A5D6B0;
        Thu, 19 Sep 2019 11:55:15 +0000 (UTC)
Date:   Thu, 19 Sep 2019 07:55:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH REPOST 2/2] xfs: don't set bmapi total block req where
 minleft is sufficient
Message-ID: <20190919115513.GC33863@bfoster>
References: <20190912143223.24194-1-bfoster@redhat.com>
 <20190912143223.24194-3-bfoster@redhat.com>
 <20190918215516.GB568270@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918215516.GB568270@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 19 Sep 2019 11:55:21 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 02:55:16PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 12, 2019 at 10:32:23AM -0400, Brian Foster wrote:
> > xfs_bmapi_write() takes a total block requirement parameter that is
> > passed down to the block allocation code and is used to specify the
> > total block requirement of the associated transaction. This is used
> > to try and select an AG that can not only satisfy the requested
> > extent allocation, but can also accommodate subsequent allocations
> > that might be required to complete the transaction. For example,
> > additional bmbt block allocations may be required on insertion of
> > the resulting extent to an inode data fork.
> > 
> > While it's important for callers to calculate and reserve such extra
> > blocks in the transaction, it is not necessary to pass the total
> > value to xfs_bmapi_write() in all cases. The latter automatically
> > sets minleft to ensure that sufficient free blocks remain after the
> > allocation attempt to expand the format of the associated inode
> > (i.e., such as extent to btree conversion, btree splits, etc).
> > Therefore, any callers that pass a total block requirement of the
> > bmap mapping length plus worst case bmbt expansion essentially
> > specify the additional reservation requirement twice. These callers
> > can pass a total of zero to rely on the bmapi minleft policy.
> > 
> > Beyond being superfluous, the primary motivation for this change is
> > that the total reservation logic in the bmbt code is dubious in
> > scenarios where minlen < maxlen and a maxlen extent cannot be
> > allocated (which is more common for data extent allocations where
> > contiguity is not required). The total value is based on maxlen in
> > the xfs_bmapi_write() caller. If the bmbt code falls back to an
> > allocation between minlen and maxlen, that allocation will not
> > succeed until total is reset to minlen, which essentially throws
> > away any additional reservation included in total by the caller. In
> 
> Hm, are you talking about lowmode allocations and the "retry with fewer
> constraints" behavior in xfs_bmap_btalloc?
> 

This isn't related to low space mode. Consider a simple example of
xfs_alloc_file_space() calling xfs_bmapi_write() with a total param of
the maxlen + bmbt reservation. xfs_bmapi_write() assigns bma.total, this
makes its way to args.total and the allocation code thus won't pick an
AG with less space available than specified in args.total (see
xfs_alloc_space_available()). If args.total is what prevents AG
selection for a particular allocation, the allocation retries in
xfs_bmap_btalloc() are going to fail until we get to the one that does:

	args.total = ap->minlen;

... which basically means we're now free to select an AG that satisfies
minlen without any consideration for the "+ bmbt reservation" part that
was added to bma.total in the first place.

This is separate from the observation that the bmap code already assigns
[bma|args].minleft (xfs_bmapi_minleft()) to a value that considers that
additional bmbt blocks might be required for btree splits due to the
extent allocation/mapping. With that, my understanding was that a
bma.total of maxlen + bmbt res is unnecessary because the bmap code
already takes the bmbt res into consideration itself.

> > addition, the total value is not reset until after alignment is
> > dropped, which means that such callers drop alignment far too
> > aggressively than necessary.
> 
> Does that need fixing?
> 

That was the intent of the first patch. :)

> > Update all callers of xfs_bmapi_write() that pass a total block
> > value of the mapping length plus bmbt reservation to instead pass
> > zero and rely on xfs_bmapi_minleft() to enforce the bmbt reservation
> > requirement. This trades off slightly less conservative AG selection
> > for the ability to preserve alignment in more scenarios.
> > xfs_bmapi_write() callers that incorporate unrelated or additional
> > reservations in total beyond what is already included in minleft
> > must continue to use the former.
> 
> Does doing this affect the outcome of where bmbt blocks get allocated
> with respect to whichever data extent allocation triggered the reshaping
> of the bmbt?  I would imagine that it /could/ result in somewhat better
> allocation decisions?  But that the primary outcome of these two patches
> is that a large fallocate on a filesystem with alignment hints and small
> AGs (relative to the fallocate request size) are more likely to spit out
> aligned extents?
> 

Yeah, the intent is to try and honor alignment in more cases. I don't
think this affects bmbt block allocation because of the minleft bits
mentioned above. Rather, this just means that if we _did_ have some
subset of AGs where bma.total (maxlen+bmbt res) could be satisfied,
we're no longer restricting ourselves to those AGs over others where
minlen+minleft+alignment might be possible. IOW, this takes into
consideration the behavior change from the previous patch (or Carlos'
variant thereof).

> The code changes look ok, but at the same time I wonder if there's a
> bigger picture I'm missing?  FWIW that might just be due to Dave and
> Carlos discussing something resulting in the "A small improvement in the
> allocation algorithm" series and just a gut feeling that better
> coordination (or maintainer soothing :P) is needed.
> 

Yeah, I think what fell out of that ends up replacing the first patch.
AFAICT, this patch is still necessary to prevent bma.total from getting
in the way, though some discussion over Carlos' series is still in
progress. Either way, it probably makes sense for us to work things out
in that series first..

Brian

> --D
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 1 -
> >  fs/xfs/xfs_bmap_util.c   | 4 ++--
> >  fs/xfs/xfs_dquot.c       | 4 ++--
> >  fs/xfs/xfs_iomap.c       | 4 ++--
> >  fs/xfs/xfs_reflink.c     | 4 ++--
> >  fs/xfs/xfs_rtalloc.c     | 3 +--
> >  6 files changed, 9 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index eaa965920a03..c2f0afdf2f65 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -4505,7 +4505,6 @@ xfs_bmapi_convert_delalloc(
> >  	bma.wasdel = true;
> >  	bma.offset = bma.got.br_startoff;
> >  	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
> > -	bma.total = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
> >  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
> >  	if (whichfork == XFS_COW_FORK)
> >  		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 0910cb75b65d..079aedade656 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -962,8 +962,8 @@ xfs_alloc_file_space(
> >  		xfs_trans_ijoin(tp, ip, 0);
> >  
> >  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
> > -					allocatesize_fsb, alloc_type, resblks,
> > -					imapp, &nimaps);
> > +					allocatesize_fsb, alloc_type, 0, imapp,
> > +					&nimaps);
> >  		if (error)
> >  			goto error0;
> >  
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index aeb95e7391c1..b924dbd63a7d 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -305,8 +305,8 @@ xfs_dquot_disk_alloc(
> >  	/* Create the block mapping. */
> >  	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
> >  	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
> > -			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
> > -			XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
> > +			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
> > +			&nmaps);
> >  	if (error)
> >  		return error;
> >  	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index f780e223b118..27f2030690e2 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -277,8 +277,8 @@ xfs_iomap_write_direct(
> >  	 * caller gave to us.
> >  	 */
> >  	nimaps = 1;
> > -	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> > -				bmapi_flags, resblks, imap, &nimaps);
> > +	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flags, 0,
> > +				imap, &nimaps);
> >  	if (error)
> >  		goto out_res_cancel;
> >  
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 0f08153b4994..3aa56cac1a47 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -410,8 +410,8 @@ xfs_reflink_allocate_cow(
> >  	/* Allocate the entire reservation as unwritten blocks. */
> >  	nimaps = 1;
> >  	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
> > -			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
> > -			resblks, imap, &nimaps);
> > +			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, imap,
> > +			&nimaps);
> >  	if (error)
> >  		goto out_unreserve;
> >  
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 4a48a8c75b4f..d42b5a2047e0 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -792,8 +792,7 @@ xfs_growfs_rt_alloc(
> >  		 */
> >  		nmap = 1;
> >  		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
> > -					XFS_BMAPI_METADATA, resblks, &map,
> > -					&nmap);
> > +					XFS_BMAPI_METADATA, 0, &map, &nmap);
> >  		if (!error && nmap < 1)
> >  			error = -ENOSPC;
> >  		if (error)
> > -- 
> > 2.20.1
> > 
