Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43326 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753824AbcLNTiE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 14:38:04 -0500
Date: Wed, 14 Dec 2016 20:38:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: don't rely on ->total in
        xfs_alloc_space_available
Message-ID: <20161214193802.GB12217@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de> <1481644767-9098-5-git-send-email-hch@lst.de> <20161214183017.GD24645@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214183017.GD24645@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Wed, Dec 14, 2016 at 01:30:18PM -0500, Brian Foster wrote:
> >  	/* do we have enough contiguous free space for the allocation? */
> > +	alloc_len = args->minlen + (args->alignment - 1)+ args->minalignslop;
> 
> Whitespace nit, missing space:				^
> 
> Also, is the addition of braces intentional? I believe it is possible
> for args->alignment == 0.

It's mostly for explaining the - 1 to the reader as it took me a while
to figure out what it was for.
