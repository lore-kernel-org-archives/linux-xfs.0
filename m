Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B4E1029DFD
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 16:08:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B430AC002
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 14:08:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y9FbnMjbH1I3ppZ0 for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 14:08:38 -0700 (PDT)
Date: Mon, 5 May 2014 17:08:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: fold xfs_attr_remove_int into xfs_attr_remove
Message-ID: <20140505210832.GA13973@laptop.bfoster>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
	<1399130415-5382-4-git-send-email-hch@lst.de>
	<20140505202127.GD12448@laptop.bfoster>
	<20140505205653.GY26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140505205653.GY26353@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, May 06, 2014 at 06:56:53AM +1000, Dave Chinner wrote:
> On Mon, May 05, 2014 at 04:21:28PM -0400, Brian Foster wrote:
> > On Sat, May 03, 2014 at 05:20:13PM +0200, Christoph Hellwig wrote:
> > > Also remove a useless ilock roundtrip for the first attr fork check, it's
> > > racy anyway and we redo it later under the ilock before we start the removal.
> > > 
> > > Plus various minor style fixes to the new xfs_attr_remove.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> .....
> > > @@ -487,35 +497,26 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
> > >  	 */
> > >  	xfs_trans_ijoin(args.trans, dp, 0);
> > >  
> > > -	/*
> > > -	 * Decide on what work routines to call based on the inode size.
> > > -	 */
> > >  	if (!xfs_inode_hasattr(dp)) {
> > >  		error = XFS_ERROR(ENOATTR);
> > 
> > I suppose we probably want to nuke the XFS_ERROR() while we're here..?
> > Otherwise, it looks good.
> 
> No need, I'll do that at the end of the dev cycle for everything.
> 

Sounds good.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
