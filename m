Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfGZXiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jul 2019 19:38:09 -0400
Date: Fri, 26 Jul 2019 16:37:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: lift the xfs writepage code into iomap v3
Message-ID: <20190726233753.GD2166993@magnolia>
References: <20190722095024.19075-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722095024.19075-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 23, 2019 at 11:50:12AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up the xfs writepage code and then lifts it to
> fs/iomap.c so that it could be use by other file system.  I've been
> wanting to this for a while so that I could eventually convert gfs2
> over to it, but I never got to it.  Now Damien has a new zonefs
> file system for semi-raw access to zoned block devices that would
> like to use the iomap code instead of reinventing it, so I finally
> had to do the work.

Hmm... I don't like how there are xfs changes mixed in with the iomap
changes, because were I to take this series as-is then I'd have to
commit both to adding iomap writeback code /and/ converting xfs at the
same time.

I think I'd be more comfortable creating a branch to merge the changes
to list.h and fs/iomap/, and then gfs2/zonefs/xfs can sprout their own
branches from there to do whatever conversions are necessary.

To me what that means is splitting patch 7 into 7a which does the iomap
changes and 7b which does the xfs changes.  To get there, I'd create a
iomap-writeback branch containing:

1 7a 8 9 10 11 12

and then a new xfs-iomap-writeback branch containing:

2 4 7b

This eliminates the need for patches 3, 5, and 6, though the cost is
that it's less clear from the history that we did some reorganizing of
the xfs writeback code and then moved it over to iomap.  OTOH, I also
see this as a way to lower risk because if some patch in the
xfs-iomap-writeback branch shakes loose a bug that doesn't affect gfs2
or zonedfs we don't have to hold them up.

I'll try to restructure this series along those lines and report back
how it went.

--D

> 
> 
> Changes since v2:
>  - rebased to v5.3-rc1
>  - folded in a few changes from the gfs2 enablement series
> 
> Changes since v1:
>  - rebased to the latest xfs for-next tree
>  - keep the preallocated transactions for size updates
>  - rename list_pop to list_pop_entry and related cleanups
>  - better document the nofs context handling
>  - document that the iomap tracepoints are not a stable API
