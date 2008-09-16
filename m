Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Sep 2008 10:28:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8GHRx4X026137
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 10:28:00 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3DEC448F1F
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 10:29:30 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id 2kWR0FIC83IwCAvC for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 10:29:30 -0700 (PDT)
Date: Tue, 16 Sep 2008 19:29:28 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/6] cleanup maxrecs calculation
Message-ID: <20080916172928.GA26187@lst.de>
References: <20080915004648.GD12213@lst.de> <20080916053641.GV5811@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916053641.GV5811@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Sep 16, 2008 at 03:36:41PM +1000, Dave Chinner wrote:
> On Mon, Sep 15, 2008 at 02:46:48AM +0200, Christoph Hellwig wrote:
> > +	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
> > +	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
> 
> That's kind of strange - index 0 gets configured with a leaf (?)
> value of 1, and index 1 with a value of 0. Can we change the order
> of one of these so that the function and the variables match?
> 
> Would a define for what the function parameter means make sense?
> That way the code would document itself....

Yeah, probably should do this, currently the patch just keeps the
calling conventions of the previous macros.
