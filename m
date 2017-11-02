Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30424 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934065AbdKBT0s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 15:26:48 -0400
Date: Thu, 2 Nov 2017 12:26:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 15/18] xfs: remove support for inlining data/extents into
 the inode fork
Message-ID: <20171102192634.GZ4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-16-hch@lst.de>
 <20171031223508.GY4911@magnolia>
 <20171102185725.GE4244@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102185725.GE4244@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 07:57:25PM +0100, Christoph Hellwig wrote:
> On Tue, Oct 31, 2017 at 03:35:08PM -0700, Darrick J. Wong wrote:
> > Do you see any secondary effects, such as increased slab fragmentation
> > because of the extra kmem_allocs?  In general I think this should be ok,
> > I just worry slightly that whatever reason we had for having
> > if_inline_data is still around and will blow up in weird ways if we get
> > rid of it.
> 
> Why would we get much slab fragmentation?  The small slabs (16 or 32
> byte for those current users) have a huge turnover, so they generally
> aren't a majr problem.

I don't think they will be a serious problem either; this is just me
wondering why we had if_inline_data in the first place (now that we're
removing it).

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
