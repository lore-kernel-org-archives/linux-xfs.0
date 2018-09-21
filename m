Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35874 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbeIULKX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Sep 2018 07:10:23 -0400
Date: Fri, 21 Sep 2018 07:23:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] xfs: introduce an always_cow mode
Message-ID: <20180921052314.GA12825@lst.de>
References: <20180920144220.2181-1-hch@lst.de> <20180920144220.2181-6-hch@lst.de> <20180920201702.GN20086@magnolia> <20180920212357.GN27618@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180920212357.GN27618@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Sep 21, 2018 at 07:23:57AM +1000, Dave Chinner wrote:
> sys/fs/xfs/debug/always_cow is the place for this if it is truly a
> global debug option. However, that's probably not the best way to
> enable this sort of debug for people with XFS root filesystems
> trying to test XFS filesystems. I suspect it should be a per-mount
> configuration (i.e. /sys/fs/xfs/<dev>/debug/always_cow)

True.

> However, this mode of operation seems like it is going to form the
> basis of other per-filesystem features, so it would be good to know
> how/if those features make use of this always_cow mode or are
> controlled by some other set of knobs first.

The current atomic write support is a per-inode fcntl based flag.
(used to be an O_ATOMIC per open file flag, but that had all kinds
of issues).

The zoned device support doesn't really existing for a bit of prototype
write path code, but the current assumption is that all files in
ѕequential write only zones have the RT bit set, and will get this
behavior on that an a per-subperblock flag.

In other words - the know here is supposed to remain a debug build
only debug nob.
