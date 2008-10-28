Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 02:15:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S9Ekgm008956
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:14:47 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB22B550D02
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:14:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id KFYvrGGelncRHsuv for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:14:46 -0700 (PDT)
Date: Tue, 28 Oct 2008 05:14:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] split up xlog_recover_process_iunlinks
Message-ID: <20081028091446.GB1662@infradead.org>
References: <20081027133938.GH1109@infradead.org> <20081028071750.GV4985@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028071750.GV4985@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> > +	error = xfs_iget(mp, NULL, ino, 0, 0, &ip, 0);
> > +	if (error)
> > +		goto fail;
> > +
> > +	/*
> > +	 * Get the on disk inode to find the next inode in the bucket.
> > +	 */
> > +	ASSERT(ip != NULL);
> > +	error = xfs_itobp(mp, NULL, ip, &dip, &ibp, 0, 0, XFS_BUF_LOCK);
> > +	if (error)
> > +		goto fail;
> 
> Jumping to 'fail' at this point leaks the xfs_inode returned from
> xfs_iget(). Hmmmm - it appears the original code leaked too....
> 
> Also, I don't think we need the assert for ip, either.  If it's NULL
> then we'll panic immediately on entering xfs_itobp().

Yeah.  I'll fix this in a separate patch as this one is just suposed to
be purely refactoring.
