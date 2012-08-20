Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KN8b7h011832 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 18:08:37 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NVBxEK4NGCcW11qX for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 16:08:35 -0700 (PDT)
Date: Tue, 21 Aug 2012 09:08:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 2/4] xfs: Introduce a helper routine to probe data or
	hole offset from page cache
Message-ID: <20120820230833.GI19235@dastard>
References: <5028FC2E.2010802@oracle.com>
 <5032583F.6050207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5032583F.6050207@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: jeff.liu@oracle.com, xfs@oss.sgi.com

On Mon, Aug 20, 2012 at 10:31:11AM -0500, Mark Tinguely wrote:
> On 08/13/12 08:07, Jeff Liu wrote:
> >helper routine to lookup data or hole offset from page cache for unwritten extents.
> >
> >Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> >
> >---
> >  fs/xfs/xfs_file.c |  213 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 213 insertions(+), 0 deletions(-)
> >+STATIC bool
> >+xfs_find_get_desired_pgoff(
> >+	struct inode		*inode,
> >+	struct xfs_bmbt_irec	*map,
> >+	unsigned int		type,
> >+	loff_t			*offset)
> >+{
> 
> ...
> 
> >+		for (i = 0; i<  nr_pages; i++) {
> >+			struct page	*page = pvec.pages[i];
> >+			loff_t		b_offset;
> >+
> >+			/*
> >+			 * Page index is out of range, searching done.
> >+			 * If the current offset is not reaches the end
> >+			 * of the specified search range, there should
> >+			 * be a hole between them.
> >+			 */
> >+			if (page->index>  end) {
> 
> Shouldn't this sample of the index also be locked?

You can check it before the page is locked for being beyond EOF, but
it still needs to be checked again after the page is locked as it
can change between this check and the page being locked.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
