Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60318 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfG3BRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 21:17:23 -0400
Date: Mon, 29 Jul 2019 18:17:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: lift the xfs writepage code into iomap v3
Message-ID: <20190730011705.GO1561054@magnolia>
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

On Mon, Jul 22, 2019 at 11:50:12AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series cleans up the xfs writepage code and then lifts it to
> fs/iomap.c so that it could be use by other file system.  I've been
> wanting to this for a while so that I could eventually convert gfs2
> over to it, but I never got to it.  Now Damien has a new zonefs
> file system for semi-raw access to zoned block devices that would
> like to use the iomap code instead of reinventing it, so I finally
> had to do the work.

I've posted a branch against -rc2 for us all to work from:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/log/?h=iomap-writeback

and will be emailing the patches shortly to the list for completeness.

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
