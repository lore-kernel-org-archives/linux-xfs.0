Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47088 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751895AbdJTHCh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 03:02:37 -0400
Date: Fri, 20 Oct 2017 09:02:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/15] xfs: remove the never fully implemented UUID
        fork format
Message-ID: <20171020070235.GB11101@lst.de>
References: <20171019065942.18813-1-hch@lst.de> <20171019065942.18813-7-hch@lst.de> <20171019224813.GP4755@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019224813.GP4755@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 03:48:13PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 19, 2017 at 08:59:33AM +0200, Christoph Hellwig wrote:
> > Remove the dead code dealing with the UUID fork format that was never
> > implemented in Linux (and neither in IRIX as far as I know).
> 
> I think I need a little more context on this -- for what purpose was the
> UUID format created, and has it ever been used anywhere?  When I was
> working on the ifork verifiers/scrub I noticed that we'd never actually
> accept anything with that format.
> 
> (I'm ok with removing it, I just want to know what I'm killing before I
> commit to it.)

For that you'd need to find people that were around at SGI in the 90s..

Note that we already removed it briefly in 2008, but unlike my patch
that didn't keep the padding so broken log recovery.

relevant xfs-import commits:

Commit that adds the di_format values:
c049a3e8d776a76a1ba3adaf168a406a8ee52172

then various commits in early development add UUID inode format
bits, but none seems to actually ever generate it.

1st removal with minor comments on the history:
415c805b441845dfc2be7d887f995ea8875358e9

Revert of the above:
4ddd5953fad77a14f665fefa06899ef9f388b134
