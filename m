Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39527 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbdBGJmW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 04:42:22 -0500
Date: Tue, 7 Feb 2017 10:42:20 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] xfs: don't fail xfs_extent_busy allocation
Message-ID: <20170207094220.GC15267@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-2-git-send-email-hch@lst.de> <20170203152052.GB45388@bfoster.bfoster> <20170204095040.GA18472@lst.de> <20170206164318.GF57865@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206164318.GF57865@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Feb 06, 2017 at 11:43:18AM -0500, Brian Foster wrote:
> I was thinking more about the repeated allocation/free of said
> structures than lifetime, particularly since we've converted an
> opportunistic allocation to a required/sleeping one.

The allocator is one and the same - the different is that kmalloc
does a trivial lookup of the cache to use first, while kmem_cache_alloc
specifies an exact cache.

> Just a thought though.. looking again, should we have KM_NOFS here as
> well?

xfs_extent_busy_insert is always called inside transaction context,
so we get implicit NOFS semantics.  The existing code already relies
on that.
