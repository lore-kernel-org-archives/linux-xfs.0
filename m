Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB77beIw110659 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 01:37:42 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCFD31CCE47
	for <xfs@oss.sgi.com>; Mon,  6 Dec 2010 23:39:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6bCEHQveucwoZ16s for
	<xfs@oss.sgi.com>; Mon, 06 Dec 2010 23:39:27 -0800 (PST)
Date: Tue, 7 Dec 2010 02:39:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfs: remove all the inodes on a buffer from the AIL
	in bulk
Message-ID: <20101207073925.GA25617@infradead.org>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-7-git-send-email-david@fromorbit.com>
	<20101206143308.GA31100@infradead.org>
	<20101207034456.GB29856@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101207034456.GB29856@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Dec 07, 2010 at 02:44:56PM +1100, Dave Chinner wrote:
> On Mon, Dec 06, 2010 at 09:33:08AM -0500, Christoph Hellwig wrote:
> > While the patch looks good for the ail lock contetion removal, I don't
> > quite like the model with the double iteration over the log item list
> > on the buffer.  What do you think about the following plan:
> > 
> >  (1) merge xfs_istale_done into xfs_iflush_done by checking for
> >      XFS_ISTALE
> >  (2) convert not only the inode log item completion to your new scheme,
> >      but also the dquots
> >  (3) replace xfs_buf_do_callbacks with a callback in the buffer, which
> >      now points to the inode and dqout routines, or calls the completion
> >      for the only items in "normal" buf items.
> 
> Seems like a reasonable approach. However, what I'd prefer to do is
> make these changes as a separate set of changes on top of this patch
> series rather than try to integrate them into the existing series.
> If there are problems, that should make it more bisectable. Do you
> have any concerns with such an approach?

Sounds fine, although I think getting rid of xfs_istale_done might be
worth doing before this patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
