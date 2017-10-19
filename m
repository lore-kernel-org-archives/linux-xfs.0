Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750939AbdJSXwN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 19:52:13 -0400
Date: Fri, 20 Oct 2017 07:52:02 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v3 41/49] xfs: convert to bio_for_each_segment_all_sp()
Message-ID: <20171019235201.GE27130@ming.t460p>
References: <20170808084548.18963-1-ming.lei@redhat.com>
 <20170808084548.18963-42-ming.lei@redhat.com>
 <20170808163232.GO24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170808163232.GO24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Huang Ying <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org

On Tue, Aug 08, 2017 at 09:32:32AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 08, 2017 at 04:45:40PM +0800, Ming Lei wrote:
> 
> Sure would be nice to have a changelog explaining why we're doing this.
> 
> > Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> > Cc: linux-xfs@vger.kernel.org
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  fs/xfs/xfs_aops.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 6bf120bb1a17..94df43dcae0b 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -139,6 +139,7 @@ xfs_destroy_ioend(
> >  	for (bio = &ioend->io_inline_bio; bio; bio = next) {
> >  		struct bio_vec	*bvec;
> >  		int		i;
> > +		struct bvec_iter_all bia;
> >  
> >  		/*
> >  		 * For the last bio, bi_private points to the ioend, so we
> > @@ -150,7 +151,7 @@ xfs_destroy_ioend(
> >  			next = bio->bi_private;
> >  
> >  		/* walk each page on bio, ending page IO on them */
> > -		bio_for_each_segment_all(bvec, bio, i)
> > +		bio_for_each_segment_all_sp(bvec, bio, i, bia)
> 
> It's confusing that you're splitting the old bio_for_each_segment_all
> into multipage and singlepage variants, but bio_for_each_segment_all
> continues to exist?

No, it shouldn't, will remove it in V4.

> 
> Hmm, the new multipage variant aliases the name bio_for_each_segment_all,
> so clearly the _all function's sematics have changed a bit, but its name
> and signature haven't, which seems likely to trip up someone who didn't
> notice the behavioral change.

bio_for_each_segment_all_mp() is introduced for providing previous
sematics of bio_for_each_segment_all(), and there is few cases in
which bvec table need to be updated.

> 
> Is it still valid to call bio_for_each_segment_all?  I get the feeling

No, bio_for_each_segment_all_mp() should be used instead. But my plan is
to rename bio_for_each_segment_all_mp() into bio_for_each_segment_all()
and bio_for_each_segment_all_sp() into bio_for_each_page() once this
patchset is merged.

> from this patchset that you're really supposed to decide whether you
> want one page at a time or more than one page at a time and choose _sp
> or _mp?

Yeah.

> 
> (And, seeing how this was the only patch sent to this list, the chances
> are higher of someone missing out on these subtle changes...)

OK, will CC you the cover letter next time.

-- 
Ming
