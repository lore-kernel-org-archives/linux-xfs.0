Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52024 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752405AbdKTU0K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 15:26:10 -0500
Date: Tue, 21 Nov 2017 07:26:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] iomap: report collisions between directio and
 buffered writes to userspace
Message-ID: <20171120202606.GN5858@dastard>
References: <20171117193925.GM5119@magnolia>
 <20171120161829.GA25991@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171120161829.GA25991@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, holger@applied-asynchrony.com, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Mon, Nov 20, 2017 at 08:18:29AM -0800, Matthew Wilcox wrote:
> On Fri, Nov 17, 2017 at 11:39:25AM -0800, Darrick J. Wong wrote:
> > If two programs simultaneously try to write to the same part of a file
> > via direct IO and buffered IO, there's a chance that the post-diowrite
> > pagecache invalidation will fail on the dirty page.  When this happens,
> > the dio write succeeded, which means that the page cache is no longer
> > coherent with the disk!
> 
> This seems like a good opportunity to talk about what I've been working
> on for solving this problem.  The XArray is going to introduce a set
> of entries which can be stored to locations in the page cache that I'm
> calling 'wait entries'.

What's this XArray thing you speak of?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
