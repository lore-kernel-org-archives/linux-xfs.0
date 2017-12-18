Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25684 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933574AbdLRVls (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 16:41:48 -0500
Date: Tue, 19 Dec 2017 08:41:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to get disk-location from "metadata I/O error"?
Message-ID: <20171218214144.GE4094@dastard>
References: <002e01d377f1$a986be00$fc943a00$@163.com>
 <20171218154149.ijynq53b446vlmfm@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171218154149.ijynq53b446vlmfm@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vaughan <cxt9401@163.com>, linux-xfs@vger.kernel.org

On Mon, Dec 18, 2017 at 04:41:50PM +0100, Carlos Maiolino wrote:
> On Mon, Dec 18, 2017 at 07:16:33PM +0800, Vaughan wrote:
> > Hi All,
> > 
> > 
> > I encounter the following output from time to time. Since xfs is built on
> > our own virtual disk, it's more likely that our vdisk is buggy.
> > Can anyone tell me how to figure out the on-disk location given the block
> > number? Does it follow the following formula?
> > On-disk location = <block number from metadata I/O error> * <bsize of data
> > section of xfs_info>
> > However, the result from the above formula suggests the metadata is out of
> > range of my disk, confused...
> 
> No, your formula is not correct. XFS filesystem blocks are not exactly
> sequentially arranged as your formula suggests. It depends on the number of
> blocks in each Allocation Group, and the Log2 number used to make calculations
> regarding disk addresses.
> 
> Easier answer: Use xfs_db to convert it:
> 
> xfs_db> fsblock 0x1e8ffa08
> xfs_db> daddr
> current daddr is 2639245888

One little, important detail is wrong here: metadata block numbers
are reported as daddrs, not fsblocks. daddrs are units of basic
blocks and are a linear offset from the start of the device. Basic
blocks are always 512 bytes. i.e. neither the OP or the above is
correct. :/

XFS (md_d27): metadata I/O error: block 0x1e8ffa08 ("xfs_trans_read_buf_map") error 117 numblks 8 

Hence this is an error from a read at daddr 0x1e8ffa08 for 8 basic
blocks (4096 bytes). Looks like something has overwritten the AGF
with crap...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
