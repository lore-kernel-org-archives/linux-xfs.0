Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56341 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933207AbdKBS51 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 14:57:27 -0400
Date: Thu, 2 Nov 2017 19:57:25 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/18] xfs: remove support for inlining data/extents
        into the inode fork
Message-ID: <20171102185725.GE4244@lst.de>
References: <20171031142230.11755-1-hch@lst.de> <20171031142230.11755-16-hch@lst.de> <20171031223508.GY4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031223508.GY4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 03:35:08PM -0700, Darrick J. Wong wrote:
> Do you see any secondary effects, such as increased slab fragmentation
> because of the extra kmem_allocs?  In general I think this should be ok,
> I just worry slightly that whatever reason we had for having
> if_inline_data is still around and will blow up in weird ways if we get
> rid of it.

Why would we get much slab fragmentation?  The small slabs (16 or 32
byte for those current users) have a huge turnover, so they generally
aren't a majr problem.
