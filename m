Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38220 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751629AbdIUQBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 12:01:23 -0400
Date: Thu, 21 Sep 2017 09:01:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/19] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170921160117.GH7112@magnolia>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-13-hch@lst.de>
 <20170920220314.GT7112@magnolia>
 <20170921132826.GB13541@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921132826.GB13541@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 03:28:26PM +0200, Christoph Hellwig wrote:
> [fullquote of a fullquote removed, sigh..]
> 
> > > +		temp = PREV.br_blockcount - new->br_blockcount;
> > > +		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
> > > +			startblockval(PREV.br_startblock));
> > 
> > Needs another indent?
> 
> 
> What for?

I thought the second line of a continued statement was indented ether
twice more or up to the paren, e.g.:

	da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
			startblockval(PREV.br_startblock));

or:

	da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
				 startblockval(PREV.br_startblock));

but never a single tab:

	da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
		startblockval(PREV.br_startblock));

The 'startblockval' line only has one more tab indent than the
'da_new =' line.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
