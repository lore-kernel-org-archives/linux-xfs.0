Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:45:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JjAMj026682
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:45:10 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D79DEECEAF
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:46:22 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id HeRMpGKsBZpdtR9O for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:46:22 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:46:24 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/21] implement generic xfs_btree_update
Message-ID: <20080801194624.GG1263@lst.de>
References: <20080729193116.GN19104@lst.de> <20080730052959.GN13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730052959.GN13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 03:29:59PM +1000, Dave Chinner wrote:
> Oh, it's be moved inside the update code itself. So, why always call
> the update function and then check the ptr? Why not the way it was
> originally done?

Because all three callers do different checks, and I could not proof
that they are either identical or hamrless for the other cases.
We can clean this mess up later in small standalone patches.

> > +	/* updated last record information */
> > +	void	(*update_lastrec)(struct xfs_btree_cur *,
> > +				  struct xfs_btree_block *,
> > +				  union xfs_btree_rec *, int, int);
> 
> Can you add the variable names to the prototype parameters?

Done.
