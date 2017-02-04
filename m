Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52715 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753811AbdBDJ4J (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 4 Feb 2017 04:56:09 -0500
Date: Sat, 4 Feb 2017 10:56:06 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/4] xfs: improve handling of busy extents in the
        low-level allocator
Message-ID: <20170204095606.GC18472@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-3-git-send-email-hch@lst.de> <20170203162243.GF45388@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203162243.GF45388@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 03, 2017 at 11:22:43AM -0500, Brian Foster wrote:
> I didn't catch this until looking through everything after the next
> patch, but I think there's a problem with the wakeup here as well. If we
> have a busy extent with XFS_EXTENT_BUSY_SKIP_DISCARD set, we immediately
> issue a wake from the first xfs_extent_busy_clear() in the cil committed
> handler, regardless of whether !SKIP_DISCARD extents exist as well
> under the current gen value. I think that means we'd get a premature
> wake any time a busy_list has at least one of each type..?

We'll need to wake as soon as a previously busy extent in the AG
becomes available, and that includes  XFS_EXTENT_BUSY_SKIP_DISCARD
ones.  Otherwise e.g. a transaction only containing
XFS_EXTENT_BUSY_SKIP_DISCARD will never wake at all.

