Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 23:44:18 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6G6iDbm017407
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 23:44:15 -0700
Date: Mon, 16 Jul 2007 08:44:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix format string warnings in xfsidbg
Message-ID: <20070716064415.GA8848@lst.de>
References: <20070715171948.GA6894@lst.de> <20070716033148.GL12413810@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716033148.GL12413810@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Jul 16, 2007 at 01:31:48PM +1000, David Chinner wrote:
> On Sun, Jul 15, 2007 at 07:19:48PM +0200, Christoph Hellwig wrote:
> > @@ -6818,7 +6818,7 @@ xfsidbg_xihash(xfs_mount_t *mp)
> >  
> >  	kdb_printf("\n");
> >  
> > -	kdb_printf("total inodes = %d, average length = %ld, adjusted average = %ld \n",
> > +	kdb_printf("total inodes = %zu, average length = %zu, adjusted average = %zu\n",
> >  		total, total / mp->m_ihsize,
> >  		total / (mp->m_ihsize - numzeros));
> 
> ia64 build gives:
> 
> fs/xfs/xfsidbg.c:6826: warning: format ?%zu? expects type ?size_t?, but
> argument 2 has type ?int?
> 
> total is declared as an int - I'll change it back to %d....

Hmm, I wonder why I got the warnings here and %zu fixed them.  
