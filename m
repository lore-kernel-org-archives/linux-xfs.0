Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30361 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753430AbdGLQaf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2017 12:30:35 -0400
Date: Wed, 12 Jul 2017 09:29:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: xfstests failures with current kernel/xfsprogs/xfstests
Message-ID: <20170712162954.GA4220@magnolia>
References: <20170712114433.GA2231@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170712114433.GA2231@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Wed, Jul 12, 2017 at 04:44:33AM -0700, Christoph Hellwig wrote:
> I see a few failures with a (hopefully) uptodate setup.  I'm pretty
> sure some of them have been around for a while, but I'd like to
> figure out how to get to a clean slate.
> 
> This is a 4k fs on x86-64, with reflink enabled for the test and
> scratch dev.
> 
> generic/204 seems to run out of space:
> 
>   @@ -1,2 +1,780 @@
>   QA output created by 204
> +./tests/generic/204: line 85: /mnt/scratch/20862: No space left on device
> +./tests/generic/204: line 86: /mnt/scratch/20862: No space left on device
> 
> maybe we need to key this off the device size better?  I can look into
> this.

Sure.

> generic/417 seems to fail to recover things on a r/o to r/w mount.
> 
> I thoght Eric had a fix for this, but it seems like it didn't get merge.

He did, but Dave wanted to know more about the side effects of recovering
unlinked inodes on the rootfs during the ro->rw mount and the thread died
after that.

> xfs/010 seems to have an unhappy extent state:
> 
>      Phase 4 - check for duplicate blocks...
>              - setting up duplicate extent list...
>     +unknown block state, ag 0, block 119
>              - check for inodes claiming duplicate blocks...
>      Phase 5 - rebuild AG headers and trees...
> 
> Might this be userspace not catching up to the various reflink
> and co updates?

Hmm, I'll have a look at that.

FWIW I'm half wondering if it's worth it to keep running xfs_check,
since it occasionally bombs out with ENOMEM (xfs_repair reports no
problems).  When I started working on reflink I had to update xfs_db
to support v5 at all, which made me wonder if anyone was testing v5.

> xfs/170  seems to not get the filestreams behavior it wants.

<nod>

> xfs/293 complains about undcoumented xfs_io commandsa:
> 
>     +cowextsize not documented in the xfs_io manpage
>     +dedupe not documented in the xfs_io manpage
>     +finsert not documented in the xfs_io manpage
>     +fsmap not documented in the xfs_io manpage
>     +funshare not documented in the xfs_io manpage

Works for me... but then I delibrately bindmount my dev tree's
xfs_io.8.gz to the appropriate place in /usr/share/man/ before running
xfstests. ;)

--D

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
