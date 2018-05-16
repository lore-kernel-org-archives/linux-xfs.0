Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:56646 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbeEPP5D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 11:57:03 -0400
Date: Wed, 16 May 2018 08:56:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: don't allow holes in swapfiles
Message-ID: <20180516155638.GD23858@magnolia>
References: <e722c29f7291b9c31533fd8b2e84d7f469c3ac88.1526452889.git.osandov@fb.com>
 <20180516155000.GC23858@magnolia>
 <20180516155146.GA8294@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516155146.GA8294@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Aleksei Besogonov <cyberax@amazon.com>

On Wed, May 16, 2018 at 08:51:46AM -0700, Christoph Hellwig wrote:
> On Wed, May 16, 2018 at 08:50:00AM -0700, Darrick J. Wong wrote:
> > > Hey, Darrick, I noticed this while writing up a generic xfstest to test
> > > that the Btrfs swap support patches don't allow a swapfile with holes.
> > > It'd be nice if we were all consistent :) This is based on
> > > xfs-linux/for-next. Feel free to fold it in to your patch or apply it
> > > separately as you see fit. Thanks!
> > 
> > I sent a testcase of my own ("generic: test swapfile creation,
> > activation, and deactivation") a while back; would you mind sending out
> > yours so we can combine them into a single testcase?
> 
> Wasn't the desire to support holes the rationale for the Aleksei
> version of the iomap swapfile patch?

Ah, so it was.  FWIW I'm not sure why you'd /want/ a holey swapfile?

TBH my motivation for iomap swapfile is purely to remove bmap callers. :)

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
