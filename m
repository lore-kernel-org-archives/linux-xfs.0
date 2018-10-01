Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbeJARlQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 13:41:16 -0400
Date: Mon, 1 Oct 2018 07:03:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: cancel COW blocks before swapext
Message-ID: <20181001110359.GB53694@bfoster>
References: <20180920144220.2181-1-hch@lst.de>
 <20180920144220.2181-2-hch@lst.de>
 <20180927150730.GA3743@bfoster>
 <20180930225030.GB18893@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180930225030.GB18893@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 12:50:30AM +0200, Christoph Hellwig wrote:
> On Thu, Sep 27, 2018 at 11:07:31AM -0400, Brian Foster wrote:
> > On Thu, Sep 20, 2018 at 04:42:16PM +0200, Christoph Hellwig wrote:
> > > We need to make sure we have no outstanding COW blocks before we swap
> > > extents, as there is nothing preventing us from having COW preallocations
> > > on an inode that swapext is called on.  That case can easily be
> > > reproduced by the upcoming always_cow mode.
> > > 
> > 
> > Why? Is the current code to swap the cow forks not sufficient or
> > problematic in some way?
> 
> The code didn't seem happy with non-delalloc COW fork extents sticking
> around over swapext, but I'd have to go back and look up why.
> 

It would be nice to have at least a high level note in the commit log
for historical purposes, so we have a reference on what needs fixing if
we revisit it in the future.

> It seemed easiest to just cancel them as there is no reason to keep
> these alive over a swapext.

Seems reasonable to me. I'd just perhaps replace the cowblocks flag swap
code with asserts or something to be consistent, because it seems that
should never be set on either inode with this change in place.

Brian
