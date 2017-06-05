Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40384 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751112AbdFEOho (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Jun 2017 10:37:44 -0400
Date: Mon, 5 Jun 2017 16:37:42 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/25] xfs: rework the inline directory verifiers
Message-ID: <20170605143742.GA28589@lst.de>
References: <20170603131836.26661-1-hch@lst.de> <20170603131836.26661-3-hch@lst.de> <20170605140600.GA25917@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170605140600.GA25917@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Mon, Jun 05, 2017 at 04:06:00PM +0200, Greg KH wrote:
> On Sat, Jun 03, 2017 at 03:18:13PM +0200, Christoph Hellwig wrote:
> > From: "Darrick J. Wong" <darrick.wong@oracle.com>
> > 
> > The inline directory verifiers should be called on the inode fork data,
> > which means after iformat_local on the read side, and prior to
> > ifork_flush on the write side.  This makes the fork verifier more
> > consistent with the way buffer verifiers work -- i.e. they will operate
> > on the memory buffer that the code will be reading and writing directly.
> > 
> > Furthermore, revise the verifier function to return -EFSCORRUPTED so
> > that we don't flood the logs with corruption messages and assert
> > notices.  This has been a particular problem with xfs/348, which
> > triggers the XFS_WANT_CORRUPTED_RETURN assertions, which halts the
> > kernel when CONFIG_XFS_DEBUG=y.  Disk corruption isn't supposed to do
> > that, at least not in a verifier.
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Commit 78420281a9d74014af7616958806c3aba056319e, right?

Yes.  Sorry for not including it.
