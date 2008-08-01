Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:54:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71JsgKN028830
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:54:42 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27313EEC4A1
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:55:54 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id urN8ecjl7BPmuyPE for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:55:54 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:55:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 21/21] clean up xfs_bmap_btree.c
Message-ID: <20080801195556.GL1263@lst.de>
References: <20080729193200.GV19104@lst.de> <20080730073245.GV13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730073245.GV13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 05:32:45PM +1000, Dave Chinner wrote:
> > +	ASSERT(nrecs == crecs);
> > +	kp = xfs_bmbt_key_addr(cur, 1, block);
> > +	ckp = xfs_bmbt_key_addr(cur, 1, cblock);
> > +	memcpy(kp, ckp, nrecs * sizeof(xfs_bmbt_key_t));
> 
> Should really be xfs_bmbt_copy_keys(), right?

Yes, fixed.

> > +	memcpy(pp, cpp, nrecs * sizeof(xfs_bmbt_key_t));
> 
> xfs_bmbt_copy_recs()?

Yes, fixed.
