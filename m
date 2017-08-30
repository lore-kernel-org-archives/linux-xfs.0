Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24495 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbdH3QJO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 12:09:14 -0400
Date: Wed, 30 Aug 2017 09:09:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: cleanup the page fault path V2
Message-ID: <20170830160904.GL4757@magnolia>
References: <20170829162613.27270-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170829162613.27270-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz

On Tue, Aug 29, 2017 at 06:26:11PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> these two patches simplify the xfs/iomap page fault path.  They came up in
> the context of MAP_SYNC support, but are useful on their own, and might be
> good to get into 4.14 before the real MAP_SYNC work starts hitting the
> tree in some form.

Seems to have passed a testing cycle, will queue for next...

--D

> 
> Changes since V1:
>  - drop the incorrect pfn consolidation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
