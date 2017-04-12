Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34462 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752095AbdDLR5p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 13:57:45 -0400
Date: Wed, 12 Apr 2017 10:57:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Deadlock between block allocation and block truncation
Message-ID: <20170412175744.GA20546@infradead.org>
References: <800468eb-3ded-9166-20a4-047de8018582@gmail.com>
 <20170412161017.GA16590@infradead.org>
 <3e0d4184-9d7a-9ca8-330c-727b183975a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e0d4184-9d7a-9ca8-330c-727b183975a6@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Wed, Apr 12, 2017 at 08:44:32PM +0300, Nikolay Borisov wrote:
> "
> djwong: either agf1 is clean and it needs to release that before going
> for agf0, or agf1 is dirty and thus it cannot go for agf0
> "

Yes.  Older kernels had some bugs in this area due to busy extent
tracking, where xfs_alloc_ag_vextent would fail despite
xfs_alloc_fix_freelist picking an AG and possibly dirtying the AGF.
My busy extent tracking changes for the asynchronous discard code in
4.11-rc should have fixed that.

But even with that in place I think that locking two AGFs in any
order in the truncate path is wrong.
