Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53899 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753055AbcLNVwB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 16:52:01 -0500
Date: Wed, 14 Dec 2016 16:51:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/4] xfs: don't rely on ->total in
 xfs_alloc_space_available
Message-ID: <20161214215158.GB26688@bfoster.bfoster>
References: <1481644767-9098-1-git-send-email-hch@lst.de>
 <1481644767-9098-5-git-send-email-hch@lst.de>
 <20161214183017.GD24645@bfoster.bfoster>
 <20161214193802.GB12217@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214193802.GB12217@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Wed, Dec 14, 2016 at 08:38:02PM +0100, Christoph Hellwig wrote:
> On Wed, Dec 14, 2016 at 01:30:18PM -0500, Brian Foster wrote:
> > >  	/* do we have enough contiguous free space for the allocation? */
> > > +	alloc_len = args->minlen + (args->alignment - 1)+ args->minalignslop;
> > 
> > Whitespace nit, missing space:				^
> > 
> > Also, is the addition of braces intentional? I believe it is possible
> > for args->alignment == 0.
> 
> It's mostly for explaining the - 1 to the reader as it took me a while
> to figure out what it was for.

Oh, care to elaborate? :)

Brian
