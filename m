Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4BKF6mU011623 for <xfs@oss.sgi.com>; Mon, 11 May 2009 15:15:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A3FC27A6F9
	for <xfs@oss.sgi.com>; Mon, 11 May 2009 13:15:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LUF2D7TPkmxj0QfK for
	<xfs@oss.sgi.com>; Mon, 11 May 2009 13:15:12 -0700 (PDT)
Date: Mon, 11 May 2009 16:15:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: fix xfs_quiesce_data
Message-ID: <20090511201511.GB14195@infradead.org>
References: <20090426140305.113371000@bombadil.infradead.org>
	<20090426140708.279368000@bombadil.infradead.org>
	<4A071F06.8040106@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A071F06.8040106@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, May 10, 2009 at 01:37:58PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> 
> > We need to do a synchronous xfs_sync_fsdata to make sure the superblock
> > actually is on disk when we return.  While we're at it also remove the
> > superflous SYNC_BDFLUSH flag to xfs_sync_inodes, and move the xfs_filestream_flush
> > call later [hch: why?  seems unrelated].
> 
> What makes SYNC_BDFLUSH "superfluous?" ... oh ... because nothing in
> that callchain below ever looks for it.  Could we make that more obvious
> in the changelog?

Ok.

> I guess I too would like a reason for the filestream_flush move
> somewhere in the changelog...

Hehe, maybe Dave can chime in.  Or I can test if it actually affects
anything and maybe move it out to another patch.  The lack of
reliability of the filesystreams tests doesn't make this any easier to
test.

> 
> Adding the SYNC_WAIT looks good to me though :)
> 
> -Eric
> 
> > 
> > Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
> > ===================================================================
> > --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-04-26 10:46:17.112949525 +0200
> > +++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2009-04-26 10:48:19.713979813 +0200
> > @@ -323,16 +323,16 @@ xfs_quiesce_data(
> >  	int error;
> >  
> >  	/* push non-blocking */
> > -	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_BDFLUSH);
> > +	xfs_sync_inodes(mp, SYNC_DELWRI);
> >  	XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
> > -	xfs_filestream_flush(mp);
> >  
> > -	/* push and block */
> > +	/* push and block till complete */
> >  	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
> >  	XFS_QM_DQSYNC(mp, SYNC_WAIT);
> > +	xfs_filestream_flush(mp);
> >  
> >  	/* write superblock and hoover up shutdown errors */
> > -	error = xfs_sync_fsdata(mp, 0);
> > +	error = xfs_sync_fsdata(mp, SYNC_WAIT);
> >  
> >  	/* flush data-only devices */
> >  	if (mp->m_rtdev_targp)
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
