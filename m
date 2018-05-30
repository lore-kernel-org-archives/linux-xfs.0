Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36796 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbeE3QHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 12:07:38 -0400
Date: Wed, 30 May 2018 09:07:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: iomap SEEK_HOLE / SEEK_DATA cleanups and generalization
Message-ID: <20180530160721.GB837@magnolia>
References: <20180530100208.31490-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530100208.31490-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Wed, May 30, 2018 at 12:02:05PM +0200, Christoph Hellwig wrote:
> Refactor the seek pagecache helpers to work independent of buffer_heads,
> and clean up a few lose bits.
> 
> This is needed for the small blocksize buffered I/O support in iomap.

I added RVB tags to the previous version of this, but I guess they fell
off?  Have these three patches changed considerably since v3?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
