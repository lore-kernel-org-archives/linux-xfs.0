Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB2MM23Z045777 for <xfs@oss.sgi.com>; Wed, 2 Dec 2009 16:22:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C80F1911BCB
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2009 14:22:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	sIuvhToST0y2Ez2P for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2009 14:22:31 -0800 (PST)
Date: Thu, 3 Dec 2009 09:22:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [XFS] Free buffer pages array unconditionally
Message-ID: <20091202222228.GN30608@discord.disaster>
References: <1259734333-20581-1-git-send-email-david@fromorbit.com>
	<20091202151742.GA1263@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091202151742.GA1263@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Dec 02, 2009 at 10:17:42AM -0500, Christoph Hellwig wrote:
> On Wed, Dec 02, 2009 at 05:12:13PM +1100, Dave Chinner wrote:
> > The code in xfs_free_buf() only attempts to free the b_pages array if t=
he
> > buffer is a page cache backed or page allocated buffer. The extra log b=
uffer
> > that is used when the log wraps uses pages that are allocated to a diff=
erent
> > log buffer, but it still has a b_pages array allocated when those pages
> > are associated to with the extra buffer in xfs_buf_associate_memory.
> > =

> > Hence we need to always attempt to free the b_pages array when tearing
> > down a buffer, not just on buffers that are explicitly marked as page b=
earing
> > buffers. This fixes a leak detected by the kernel memory leak code.
> > =

> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > =

> > diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> > index 4ddc973..4b84bbc 100644
> > --- a/fs/xfs/linux-2.6/xfs_buf.c
> > +++ b/fs/xfs/linux-2.6/xfs_buf.c
> > @@ -316,7 +316,7 @@ STATIC void
> >  _xfs_buf_free_pages(
> >  	xfs_buf_t	*bp)
> >  {
> > -	if (bp->b_pages !=3D bp->b_page_array) {
> > +	if (bp->b_pages && bp->b_pages !=3D bp->b_page_array) {
> >  		kmem_free(bp->b_pages);
> =

> kmem_free happily takes a NULL pointer, so this is unessecary.

Yes, it does, but I wanted to make sure that b_pages had been
assigned before doing the comparison because this is now
called unconditionally. I=B4ll remove the check and retest.

Hmmm - I suspect that this function needs to NULL b_pages
in case it _xfs_buf_free_pages() is called prior to calling
xfs_buf_free()...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
