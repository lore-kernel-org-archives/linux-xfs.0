Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59655 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdGMHRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 03:17:47 -0400
Date: Thu, 13 Jul 2017 00:17:43 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests failures with current kernel/xfsprogs/xfstests
Message-ID: <20170713071743.GB2433@infradead.org>
References: <20170712114433.GA2231@infradead.org>
 <20170712162954.GA4220@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170712162954.GA4220@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Wed, Jul 12, 2017 at 09:29:54AM -0700, Darrick J. Wong wrote:
> > Might this be userspace not catching up to the various reflink
> > and co updates?
> 
> Hmm, I'll have a look at that.
> 
> FWIW I'm half wondering if it's worth it to keep running xfs_check,
> since it occasionally bombs out with ENOMEM (xfs_repair reports no
> problems).  When I started working on reflink I had to update xfs_db
> to support v5 at all, which made me wonder if anyone was testing v5.

Yeah, it might be better to drop it.

> > xfs/293 complains about undcoumented xfs_io commandsa:
> > 
> >     +cowextsize not documented in the xfs_io manpage
> >     +dedupe not documented in the xfs_io manpage
> >     +finsert not documented in the xfs_io manpage
> >     +fsmap not documented in the xfs_io manpage
> >     +funshare not documented in the xfs_io manpage
> 
> Works for me... but then I delibrately bindmount my dev tree's
> xfs_io.8.gz to the appropriate place in /usr/share/man/ before running
> xfstests. ;)

I just did a make install of the latest xfsprogs before the run.
