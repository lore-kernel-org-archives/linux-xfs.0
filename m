Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:59204 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753822AbdBEUNz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 5 Feb 2017 15:13:55 -0500
Date: Sun, 5 Feb 2017 21:13:53 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: allocate direct I/O COW blocks in iomap_begin
Message-ID: <20170205201353.GA12914@lst.de>
References: <1485985359-971-1-git-send-email-hch@lst.de> <1485985359-971-5-git-send-email-hch@lst.de> <20170203005523.GQ9134@birch.djwong.org> <20170203105359.GA30020@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203105359.GA30020@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 03, 2017 at 11:53:59AM +0100, Christoph Hellwig wrote:
> > I think this is incorrect -- we create an unwritten extent in the cow
> > fork above (BMAP_COWFORK | BMAP_PREALLOC) but we no longer convert the
> > part we're actually writing to a real extent.  This means that
> > _reflink_cow won't actually remap anything that we've written.
> 
> It's not correct and I messed up when rebasing - the version I tested
> still had it and worked.  Sigh..

Or rather I hadn't finished rebasing and the version I had was totally
b0rked.  Proper one in progress now..
