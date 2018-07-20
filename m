Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:41518 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731305AbeGTSsB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jul 2018 14:48:01 -0400
Date: Fri, 20 Jul 2018 10:58:37 -0700
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: XFS long delays on disk full
Message-ID: <20180720175837.wuxhlzhp6e6423cl@two.firstfloor.org>
References: <20180718212240.vxl33543lrh7vgzz@two.firstfloor.org>
 <20180718232533.GC4813@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180718232533.GC4813@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 04:25:33PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 18, 2018 at 02:22:40PM -0700, Andi Kleen wrote:
> > Hi,
> > 
> > I was doing some testing on a 4.18-rc1 kernel, and a single threaded
> > test wrote a fairly large file to a XFS file system, causing it to
> > fill up.
> > 
> > After that the process hung in D state for a long time, and only
> > recovered after several minutes. Here's the backtrace during
> > the hang:
> > 
> > [<0>] wb_wait_for_completion+0x5e/0x90
> > [<0>] sync_inodes_sb+0xc9/0x290
> 
> Hmm, these two:
> 
> > [<0>] xfs_flush_inodes+0x25/0x30 [xfs]
> > [<0>] xfs_file_buffered_aio_write+0x2be/0x300 [xfs]
> 
> Offhand I'd guess (while awayish at OSCON) that the fs hit ENOSPC while
> trying to write() the file so now we're scanning the fs like mad trying
> to free up space preallocations from any open file in the fs.
> 
> How big is the fs, how big is the file, how many inodes, how many are
> open, which kernel?

Kernel 2.18-rc1

/dev/sdb1       233G  211G   23G  91% /data
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sdb1         90M   59K   89M    1% /data

Very few files were open. The file was ~23G as it filled up
the file (I now deleted it)

-Andi

