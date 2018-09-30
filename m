Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34077 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbeJAFZU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 01:25:20 -0400
Date: Mon, 1 Oct 2018 00:50:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] xfs: cancel COW blocks before swapext
Message-ID: <20180930225030.GB18893@lst.de>
References: <20180920144220.2181-1-hch@lst.de> <20180920144220.2181-2-hch@lst.de> <20180927150730.GA3743@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927150730.GA3743@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Sep 27, 2018 at 11:07:31AM -0400, Brian Foster wrote:
> On Thu, Sep 20, 2018 at 04:42:16PM +0200, Christoph Hellwig wrote:
> > We need to make sure we have no outstanding COW blocks before we swap
> > extents, as there is nothing preventing us from having COW preallocations
> > on an inode that swapext is called on.  That case can easily be
> > reproduced by the upcoming always_cow mode.
> > 
> 
> Why? Is the current code to swap the cow forks not sufficient or
> problematic in some way?

The code didn't seem happy with non-delalloc COW fork extents sticking
around over swapext, but I'd have to go back and look up why.

It seemed easiest to just cancel them as there is no reason to keep
these alive over a swapext.
