Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18355 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932430AbcI3RyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 13:54:09 -0400
Date: Fri, 30 Sep 2016 10:53:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/63] xfs: adjust refcount of an extent of blocks in
 refcount btree
Message-ID: <20160930175341.GP14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520481871.29434.5402547811567251580.stgit@birch.djwong.org>
 <20160930071115.GE18305@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930071115.GE18305@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 12:11:15AM -0700, Christoph Hellwig wrote:
> > +#define RCNEXT(rc)	((rc).rc_startblock + (rc).rc_blockcount)
> 
> > +#define IS_VALID_RCEXT(ext)	((ext).rc_startblock != NULLAGBLOCK)
> 
> I would turn these into inline helpers with nice lower case names.
> Not critical for the merge, though, so:

It's a fairly easy change, so I'll make it anyway.

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
