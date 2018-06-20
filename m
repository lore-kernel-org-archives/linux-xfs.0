Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754485AbeFTIfa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 04:35:30 -0400
Date: Wed, 20 Jun 2018 00:31:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: transactionless xfs_bunmapi shouldn't do format
 conversion
Message-ID: <20180620073142.GA5257@infradead.org>
References: <20180619024128.22669-1-david@fromorbit.com>
 <20180619024128.22669-2-david@fromorbit.com>
 <20180619045405.GI8128@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619045405.GI8128@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Mon, Jun 18, 2018 at 09:54:05PM -0700, Darrick J. Wong wrote:
> ...it's also weird that xfs_bmap_punch_delalloc_range calls xfs_bunmapi
> with no transaction and a xfs_defer that we dump on the ground.
> 
> So yes, I think the patch does fix the crash, but it's kinda gross.
> 
> Thoughts?

I've got an alternative solution:

http://git.infradead.org/users/hch/xfs.git/commitdiff/a1c0685b2085b448cbe02f0f9ff0c8771e3f4496

The only bit that is missing is removing the now unused support for
a NULL tp in __xfs_bunmapi..
