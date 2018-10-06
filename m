Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37119 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbeJFQqI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 6 Oct 2018 12:46:08 -0400
Date: Sat, 6 Oct 2018 11:43:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/8] xfs: remove magic handling of unwritten extents in
 xfs_bmapi_allocate
Message-ID: <20181006094331.GA5845@lst.de>
References: <20181002174207.25275-1-hch@lst.de> <20181002174207.25275-4-hch@lst.de> <20181006093433.GA18095@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181006093433.GA18095@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Sat, Oct 06, 2018 at 07:34:34PM +1000, Dave Chinner wrote:
> I bisected the generic/127 rmap corruption down to this patch:

Heh, I just did so too this morning.  

> The corruption check that is failing is this:
> 
>         /* Make sure the unwritten flag matches. */
> 	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
> 			(rec->rm_flags & XFS_RMAP_UNWRITTEN), out);
> 
> So this patch does not appear to be doing the right thing with
> unwritten extent flagging in some case.

I suspect the asserts actually are what is incorrect.  But given
how late we are in the cycle I've just dropped the patch and kicked
off xfstests runs (now including rmap, sigh..).
