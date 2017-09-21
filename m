Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50144 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbdIUN21 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 09:28:27 -0400
Date: Thu, 21 Sep 2017 15:28:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/19] xfs: refactor xfs_bmap_add_extent_delay_real
Message-ID: <20170921132826.GB13541@lst.de>
References: <20170918152422.24345-1-hch@lst.de> <20170918152422.24345-13-hch@lst.de> <20170920220314.GT7112@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920220314.GT7112@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

[fullquote of a fullquote removed, sigh..]

> > +		temp = PREV.br_blockcount - new->br_blockcount;
> > +		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
> > +			startblockval(PREV.br_startblock));
> 
> Needs another indent?


What for?
