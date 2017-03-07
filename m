Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47658 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752477AbdCGFr4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 00:47:56 -0500
Date: Tue, 7 Mar 2017 06:00:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: only reclaim unwritten COW extents periodically
Message-ID: <20170307050002.GA14000@lst.de>
References: <20170228004910.9495-1-hch@lst.de> <20170228052651.GD5297@birch.djwong.org> <20170307001702.GH5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307001702.GH5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Mar 06, 2017 at 04:17:02PM -0800, Darrick J. Wong wrote:
> > Could we have a comment here about what CC_UNWRITTEN means?
> > 
> > I /think/ it means "don't remove real extents", since when it's specified
> > delalloc reservations still get removed by _reflink_cancel_cow_*, correct?
> > 
> > Somewhere we ought to record the fact that flags == 0 removes everything.
> 
> It's been a week; ping?  (Or: did anyone receive this reply at all?)

I've been travelling and fairly busy.  But I'll try to prepare a new
version ASAP, especially as this something that should go into 4.11,
unlike the rest of the series.
