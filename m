Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 21:19:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G4JeoQ031390
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:19:41 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B49CD44572F
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:21:11 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id Vgmvqs02D0LOW9QK for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:21:11 -0700 (PDT)
Date: Tue, 16 Sep 2008 14:21:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] XFS: Make use of the init-once slab optimisation.
Message-ID: <20080916042105.GP5811@disturbed>
References: <1221314627-29065-1-git-send-email-david@fromorbit.com> <1221314627-29065-3-git-send-email-david@fromorbit.com> <20080915211117.GA29743@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915211117.GA29743@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 05:11:17PM -0400, Christoph Hellwig wrote:
> On Sun, Sep 14, 2008 at 12:03:46AM +1000, Dave Chinner wrote:
> > To avoid having to initialise some fields of the XFS inode
> > on every allocation, we can use the slab init-once feature
> > to initialise them. All we have to guarantee is that when
> > we free the inode, all it's entries are in the initial state.
> > Add asserts where possible to ensure debug kernels check this
> > initial state before freeing and after allocation.
> 
> This looks like it's already in:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xaiki/xfs-linux-2.6-xfs-cvs/.git;a=commitdiff;h=12efb888674600ce73a64f8c6f4a20ea5e1ce4f1

<sigh>

Which means that some of the patches won't apply. SGI folks,
can you please get the master tree updated so I can rediff all
the patches and repost them again?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
