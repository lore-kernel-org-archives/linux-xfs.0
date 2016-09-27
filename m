Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50881 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932573AbcI0U0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 16:26:12 -0400
Date: Tue, 27 Sep 2016 13:25:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 58/71] xfs: garbage collect old cowextsz reservations
Message-ID: <20160927202541.GL14092@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
 <147216829394.867.16281333542262043955.stgit@birch.djwong.org>
 <20160924194234.GA1878@infradead.org>
 <20160926215209.GE14092@birch.djwong.org>
 <20160927201501.GA19796@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160927201501.GA19796@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 27, 2016 at 01:15:01PM -0700, Christoph Hellwig wrote:
> On Mon, Sep 26, 2016 at 02:52:09PM -0700, Darrick J. Wong wrote:
> > On Sat, Sep 24, 2016 at 12:42:34PM -0700, Christoph Hellwig wrote:
> > > On Thu, Aug 25, 2016 at 04:38:14PM -0700, Darrick J. Wong wrote:
> > > > Trim CoW reservations made on behalf of a cowextsz hint if they get too
> > > > old or we run low on quota, so long as we don't have dirty data awaiting
> > > > writeback or directio operations in progress.
> > > 
> > > FYI, at least in your latest tree we only ever seem to set
> > > xfs_inode_set_cowblocks_tag in xfs_swap_extents, so this effectively
> > > isn't used during normal fs usage.
> > 
> > The tag should be set at the end of __xfs_iomap_write_delay if we're
> > creating a DA reservation in the CoW fork. 
> 
> We'll need to add that call then, as your current tree still doesn't
> have it.

Aha, it snuck out the back door during the iomap rewrite. :)

Good catch!

--D
