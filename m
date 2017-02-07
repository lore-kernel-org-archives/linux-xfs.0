Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753651AbdBGQyy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 11:54:54 -0500
Date: Tue, 7 Feb 2017 11:54:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 1/2] mm, vmscan: account the number of isolated pages
 per zone
Message-ID: <20170207165451.GE7512@bfoster.bfoster>
References: <201702031957.AGH86961.MLtOQVFOSHJFFO@I-love.SAKURA.ne.jp>
 <20170203145009.GB19325@dhcp22.suse.cz>
 <20170203172403.GG45388@bfoster.bfoster>
 <201702061529.ABC60444.FFFJOOHLVQSMtO@I-love.SAKURA.ne.jp>
 <20170206143533.GC57865@bfoster.bfoster>
 <201702071930.EJJ69255.SQOMVLJOFtOHFF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201702071930.EJJ69255.SQOMVLJOFtOHFF@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mhocko@kernel.org, david@fromorbit.com, dchinner@redhat.com, hch@lst.de, mgorman@suse.de, viro@ZenIV.linux.org.uk, linux-mm@kvack.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Tue, Feb 07, 2017 at 07:30:54PM +0900, Tetsuo Handa wrote:
> Brian Foster wrote:
> > > The workload is to write to a single file on XFS from 10 processes demonstrated at
> > > http://lkml.kernel.org/r/201512052133.IAE00551.LSOQFtMFFVOHOJ@I-love.SAKURA.ne.jp
> > > using "while :; do ./oom-write; done" loop on a VM with 4CPUs / 2048MB RAM.
> > > With this XFS_FILBLKS_MIN() change applied, I no longer hit assertion failures.
> > > 
> > 
> > Thanks for testing. Well, that's an interesting workload. I couldn't
> > reproduce on a few quick tries in a similarly configured vm.
> 
> It takes 10 to 15 minutes. Maybe some size threshold involved?
> 
> > /tmp/file _is_ on an XFS filesystem in your test, correct? If so and if
> > you still have the output file from a test that reproduced, could you
> > get the 'xfs_io -c "fiemap -v" <file>' output?
> 
> Here it is.
> 
> [  720.199748] 0 pages HighMem/MovableOnly
> [  720.199749] 150524 pages reserved
> [  720.199749] 0 pages cma reserved
> [  720.199750] 0 pages hwpoisoned
> [  722.187335] XFS: Assertion failed: oldlen > newlen, file: fs/xfs/libxfs/xfs_bmap.c, line: 2867
> [  722.201784] ------------[ cut here ]------------
...
> 
> # ls -l /tmp/file
> -rw------- 1 kumaneko kumaneko 43426648064 Feb  7 19:25 /tmp/file
> # xfs_io -c "fiemap -v" /tmp/file
> /tmp/file:
>  EXT: FILE-OFFSET          BLOCK-RANGE            TOTAL FLAGS
>    0: [0..262015]:         358739712..359001727  262016   0x0
...
>  187: [84810808..84901119]: 110211736..110302047   90312   0x1

Ok, from the size of the file I realized that I missed you were running
in a loop the first time around. I tried playing with it some more and
still haven't been able to reproduce.

Anyways, the patch intended to fix this has been reviewed[1] and queued
for the next release, so it's probably not a big deal since you've
already verified it. Thanks again.

Brian

[1] http://www.spinics.net/lists/linux-xfs/msg04083.html
