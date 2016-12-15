Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752070AbcLOMAE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 07:00:04 -0500
Date: Thu, 15 Dec 2016 07:00:02 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: don't rely on ->total in
 xfs_alloc_space_available
Message-ID: <20161215120002.GA29477@bfoster.bfoster>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <1481644767-9098-5-git-send-email-hch@lst.de>
 <20161214183017.GD24645@bfoster.bfoster>
 <20161214193802.GB12217@lst.de>
 <20161214215158.GB26688@bfoster.bfoster>
 <20161215085534.GB2864@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215085534.GB2864@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Thu, Dec 15, 2016 at 09:55:34AM +0100, Christoph Hellwig wrote:
> On Wed, Dec 14, 2016 at 04:51:58PM -0500, Brian Foster wrote:
> > On Wed, Dec 14, 2016 at 08:38:02PM +0100, Christoph Hellwig wrote:
> > > On Wed, Dec 14, 2016 at 01:30:18PM -0500, Brian Foster wrote:
> > > > >  	/* do we have enough contiguous free space for the allocation? */
> > > > > +	alloc_len = args->minlen + (args->alignment - 1)+ args->minalignslop;
> > > > 
> > > > Whitespace nit, missing space:				^
> > > > 
> > > > Also, is the addition of braces intentional? I believe it is possible
> > > > for args->alignment == 0.
> > > 
> > > It's mostly for explaining the - 1 to the reader as it took me a while
> > > to figure out what it was for.
> > 
> > Oh, care to elaborate? :)
> 
> the alignment is the boundary we want to align to, so we'll have to add
> alignment - 1 at max to achive it. 

Gotcha, so perhaps we should check that alignment != 0?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
