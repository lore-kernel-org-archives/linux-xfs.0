Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44456 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdIRPnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 11:43:31 -0400
Date: Mon, 18 Sep 2017 16:43:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [linux-next][XFS][trinity] WARNING: CPU: 32 PID: 31369 at
 fs/iomap.c:993
Message-ID: <20170918154328.GA32076@ZenIV.linux.org.uk>
References: <1505746565.6990.18.camel@abdul.in.ibm.com>
 <20170918152706.GA11482@lst.de>
 <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
 <20170918153947.GA12635@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918153947.GA12635@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, chandan <chandan@linux.vnet.ibm.com>

On Mon, Sep 18, 2017 at 05:39:47PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 18, 2017 at 09:28:55AM -0600, Jens Axboe wrote:
> > If it's expected, why don't we kill the WARN_ON_ONCE()? I get it all
> > the time running xfstests as well.
> 
> Dave insisted on it to decourage users/applications from mixing
> mmap and direct I/O.
> 
> In many ways a tracepoint might be the better way to diagnose these.

sysctl suppressing those two, perhaps?
