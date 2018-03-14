Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40988 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751481AbeCNV1e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Mar 2018 17:27:34 -0400
Date: Thu, 15 Mar 2018 08:27:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic/127 failure on xfs with hacked fsx
Message-ID: <20180314212731.GD7000@dastard>
References: <CAJfpegs=RenwFojwAze_y7WF3hwiNu-+5qDw_wyT=o0M063HkQ@mail.gmail.com>
 <20180314211851.GW4865@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180314211851.GW4865@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Wed, Mar 14, 2018 at 02:18:51PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 14, 2018 at 04:50:02PM +0100, Miklos Szeredi wrote:
> > While testing overlayfs I found something which appears to be an
> > unwanted side effect of xfs_release().
> > 
> > Apply the attached patch to xfstests and run generic/127.
> > 
> > Result is:
> > 
> >     +ltp/fsx -q -l 262144 -o 65536 -S 191110531 -N 100000 fsx_std_mmap
> >     +Mapped Read: non-zero data past EOF (0x8aa1) page offset 0xaa2 is 0xa091
> >     +LOG DUMP (70315 total operations):
> > 
> > Thanks,
> > Miklos
> 
> Hmm.... so I applied this and ran generic/127 on xfs:
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 magnolia-mtr00 4.16.0-rc5-xfsx
> MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1, -i sparse=1, /dev/pmem4
> MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sda /opt
> 
> generic/127      53s
> Ran: generic/127
> Passed all 1 tests
> 
> Reran a couple of times without seeing any problems, so what am
> I missing?  Are you running xfstests atop overlayfs atop xfs?
> 
> /me confused. :/

I'm betting it's timing related. the close can run a filemap_flush()
call, so there's every chance the page is under IO during the
mapread operation after the openclose() call. On pmem, it won't
be under IO because the writeback IO is a synchronous memcpy....

CHeers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
