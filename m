Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55114 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753054AbdIRPjt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 11:39:49 -0400
Date: Mon, 18 Sep 2017 17:39:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [linux-next][XFS][trinity] WARNING: CPU: 32 PID: 31369 at
        fs/iomap.c:993
Message-ID: <20170918153947.GA12635@lst.de>
References: <1505746565.6990.18.camel@abdul.in.ibm.com> <20170918152706.GA11482@lst.de> <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8abed401-1634-760f-6543-4652fa495315@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, chandan <chandan@linux.vnet.ibm.com>

On Mon, Sep 18, 2017 at 09:28:55AM -0600, Jens Axboe wrote:
> If it's expected, why don't we kill the WARN_ON_ONCE()? I get it all
> the time running xfstests as well.

Dave insisted on it to decourage users/applications from mixing
mmap and direct I/O.

In many ways a tracepoint might be the better way to diagnose these.
