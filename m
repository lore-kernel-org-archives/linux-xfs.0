Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p92Fh2UO135109 for <xfs@oss.sgi.com>; Sun, 2 Oct 2011 10:43:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6ADD143A615
	for <xfs@oss.sgi.com>; Sun,  2 Oct 2011 08:49:26 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EV9VM3h8CZPcgKHO for <xfs@oss.sgi.com>;
	Sun, 02 Oct 2011 08:49:26 -0700 (PDT)
Date: Sun, 2 Oct 2011 11:42:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Message-ID: <20111002154259.GA14543@infradead.org>
References: <4E887D7F.2010306@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E887D7F.2010306@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Sun, Oct 02, 2011 at 11:04:31PM +0800, Jeff Liu wrote:
> Dear developer,
> 
> Does anyone already worked on SEEK_DATA/SEEK_HOLE for XFS? I'd like to
> implement it if not. :)

Dave mentioned he had a basic implementation, he might have some code
that you can improve on.

Did we get consensus about the the semantics of them for unwritten
extents?  If we want them to be exact in the fact of unwritten extents
that is going to be the most work, e.g. if we find an unwritten extent
we'll then have to do a pagecache lookup and check if pages are dirty
and in that case not treat them as a hole.

The rest of the implementation should be easy, e.g. doing something like
the following pseudo-code which missed all the proper error codes and
conversions from the lseek arguments to filesystem blocks and the
required locking around it:


seek_hole()
{
	xfs_bmap_search_extents(ip, bno, XFS_DATA_FORK, &eof, &lastx, &got,
			&prev);

	for (;;) {
		if (eof) {
			/* past the file, nothing do here */
			return;
		}

		if (got.br_startoff > bno)
			/* found hole, return it */
			return;
		}

		if (++lastx == ifp->if_bytes / sizeof(xfs_bmbt_rec_t)) {
			/* reached EOF */
			return;
		}
		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx), &got);
	}
}

seek_data()
{
	xfs_bmap_search_extents(ip, bno, XFS_DATA_FORK, &eof, &lastx, &got,
			&prev);

	for (;;) {
		if (eof) {
			/* past the file, nothing do here */
			return;
		}

		/* next data extent */
		return got.br_startoff < bno ? bno : got.br_startof;
	}
}

	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
