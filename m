Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55759 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755367AbdIHHhS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 03:37:18 -0400
Date: Fri, 8 Sep 2017 00:37:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: report zeroed or not correctly in
 xfs_zero_range()
Message-ID: <20170908073717.GB26110@infradead.org>
References: <20170907034254.7180-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907034254.7180-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 11:42:53AM +0800, Eryu Guan wrote:
> The 'did_zero' param of xfs_zero_range() was not passed to
> iomap_zero_range() correctly. This was introduced by commit
> 7bb41db3ea16 ("xfs: handle 64-bit length in xfs_iozero"), and found
> by code inspection.

Looks good.  Although this makes me wonder why we pass the
argument at all, given that it doesn't seem to matter :)

Joking aside: xfs_setattr_size seems to care to write out
the buffer cache zeroed byes, so this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
