Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 491FD7FB4
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 07:20:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 32022304039
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:20:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cgLr0aSDSuRJ81nA for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 05:20:30 -0700 (PDT)
Date: Thu, 10 Apr 2014 08:19:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 2/2] xfs: fold xfs_create_tmpfile() into xfs_create()
Message-ID: <20140410121956.GB14124@bfoster.bfoster>
References: <1397071311-28371-1-git-send-email-bfoster@redhat.com>
	<1397071311-28371-3-git-send-email-bfoster@redhat.com>
	<20140410102901.GB17641@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140410102901.GB17641@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Apr 10, 2014 at 03:29:01AM -0700, Christoph Hellwig wrote:
> > -	struct xfs_trans_res	tres;
> > +	struct xfs_trans_res	*tres;
> >  	uint			resblks;
> >  
> >  	trace_xfs_create(dp, name);
> > @@ -1181,14 +1181,21 @@ xfs_create(
> >  	if (is_dir) {
> >  		rdev = 0;
> >  		resblks = XFS_MKDIR_SPACE_RES(mp, name->len);
> > -		tres.tr_logres = M_RES(mp)->tr_mkdir.tr_logres;
> > -		tres.tr_logcount = XFS_MKDIR_LOG_COUNT;
> > +		tres = &M_RES(mp)->tr_mkdir;
> 
> The (nice) reservation cleanup should be a patch of it's own. 
> 

Ok.

> > +	} else {
> > +		/*
> > +		 * If we don't have a name, we're in the ->tmpfile() path. We
> > +		 * have a unique transaction here since we modify the unlinked
> > +		 * list rather than create a directory entry.
> > +		 */
> 
> How is that transaction more "uniqueue" than the others?  Seems like
> this comment generally doesn't add a whole lot of value.
> 

It's just as unique as the others. ;) I wasn't intending to call out
this transaction as special in any way. Rather, I was just trying to
document why there is a separate transaction depending on the existence
of the name. I can drop the comment.

> > +	if (name) {
> > +		xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> > +		unlock_dp_on_error = true;
> > +
> > +		error = xfs_dir_canenter(tp, dp, name, resblks);
> > +		if (error)
> > +			goto out_trans_cancel;
> > +	}
> 
> So we get another special case in this function.  Can't say I like that
> too much, on the other hand I don't really like the duplicate code
> either.  So I'm not excited about this, but also not strongly against it.
> 

Indeed. I debated whether it would be reasonable to make this function
slightly longer and more complex on its own. When I realized
xfs_create_tmpfile() was 90% duplicate, it seemed worth the tradeoff for
a 100+ line function.

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
