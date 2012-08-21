Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7L5PYOx040657 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 00:25:34 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	xwvKpsOlmp0cK0kF for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 22:25:32 -0700 (PDT)
Date: Tue, 21 Aug 2012 15:25:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 2/4] xfs: Introduce a helper routine to probe data or
	hole offset from page cache
Message-ID: <20120821052529.GO19235@dastard>
References: <5028FC2E.2010802@oracle.com> <5032583F.6050207@sgi.com>
	<5033149C.5090401@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5033149C.5090401@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, Aug 21, 2012 at 12:54:52PM +0800, Jie Liu wrote:
> On 08/20/12 23:31, Mark Tinguely wrote:
> > On 08/13/12 08:07, Jeff Liu wrote:
> >> helper routine to lookup data or hole offset from page cache for
> >> unwritten extents.
> >>
> >> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> >>
> >> ---
> >>   fs/xfs/xfs_file.c |  213
> >> +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>   1 files changed, 213 insertions(+), 0 deletions(-)
> >> +STATIC bool
> >> +xfs_find_get_desired_pgoff(
> >> +    struct inode        *inode,
> >> +    struct xfs_bmbt_irec    *map,
> >> +    unsigned int        type,
> >> +    loff_t            *offset)
> >> +{
> >
> > ...
> >
> >> +        for (i = 0; i<  nr_pages; i++) {
> >> +            struct page    *page = pvec.pages[i];
> >> +            loff_t        b_offset;
> >> +
> >> +            /*
> >> +             * Page index is out of range, searching done.
> >> +             * If the current offset is not reaches the end
> >> +             * of the specified search range, there should
> >> +             * be a hole between them.
> >> +             */
> >> +            if (page->index>  end) {
> >
> > Shouldn't this sample of the index also be locked?
> Thanks for the review.  Yes, it should be locked in concert with the
> sample of index below.
> 
> However, as I have mentioned at v6,
> http://oss.sgi.com/archives/xfs/2012-08/msg00028.html
> I really don't understand why page->index will be changed as those pages
> returned from pagevec_lookup() should
> have refcount > 0.  Hence,  those pages can not be removed out of VM
> cache upon memory reclaim IMHO.

Ah, true, you are right. It's been a while since I looked at the
reference count vs truncate vs page locks in detail, and I have
always tended to err on the side of caution. I'd suggest you need to
copy the comment from write_cache_pages() here to remind us why it
is safe to do the check unlocked, otherwise in a couple of years
time someone will be asking themselves why this is safe... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
