Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdGLM3E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 08:29:04 -0400
Date: Wed, 12 Jul 2017 14:29:00 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfstests failures with current kernel/xfsprogs/xfstests
Message-ID: <20170712122900.l7ieyfmks5j74esg@eorzea.usersys.redhat.com>
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

Have you by any chance noticed test 81 locking up? Every time I run a complete
xfstests, it always get stuck on test 81.

I didn't check further to know what was going on tbh, just wanted to know if you
have seen this too.

Cheers

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
> 
> generic/417 seems to fail to recover things on a r/o to r/w mount.
> 
> I thoght Eric had a fix for this, but it seems like it didn't get merge.
> 
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
> 
> xfs/170  seems to not get the filestreams behavior it wants.
> 
> xfs/293 complains about undcoumented xfs_io commandsa:
> 
>     +cowextsize not documented in the xfs_io manpage
>     +dedupe not documented in the xfs_io manpage
>     +finsert not documented in the xfs_io manpage
>     +fsmap not documented in the xfs_io manpage
>     +funshare not documented in the xfs_io manpage
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
