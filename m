Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36717 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965526AbcKADj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2016 23:39:29 -0400
Received: by mail-pf0-f174.google.com with SMTP id 189so34324400pfz.3
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2016 20:39:29 -0700 (PDT)
Date: Tue, 1 Nov 2016 14:39:18 +1100
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161101143918.4f154154@roar.ozlabs.ibm.com>
In-Reply-To: <20161031030853.GK22126@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
        <20161027214244.GO14023@dastard>
        <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
        <20161028160218.1af40906@roar.ozlabs.ibm.com>
        <20161031030853.GK22126@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Mon, 31 Oct 2016 14:08:53 +1100
Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Oct 28, 2016 at 04:02:18PM +1100, Nicholas Piggin wrote:
> > Okay, the XFS crc sizes indeed don't look too so bad, so it's more the
> > crc implementation I suppose. I was seeing a lot of small calls to crc,
> > but as a fraction of the total number of bytes, it's not as significant
> > as I thought. That said, there is some improvement you may be able to
> > get even from x86 implementation.
> > 
> > I took an ilog2 histogram of frequency and total bytes going to XFS  
> 
> Which means ilog2 = 3 is 8-15 bytes and 9 is 512-1023 bytes? 

Yes.

> > checksum, with total, head, and tail lengths. I'll give as percentages
> > of total for easier comparison (total calls were around 1 million and
> > 500MB of data):  
> 
> Does this table match the profile you showed with all the overhead
> being through the fsync->log write path?

Yes.

[snip interesting summary]

> Full sector, no head, no tail (i.e. external crc store)? I think
> only log buffers (the extended header sector CRCs) can do that.
> That implies a large log buffer (e.g. 256k) is configured and
> (possibly) log stripe unit padding is being done. What is the
> xfs_info and mount options from the test filesystem?

See the end of the mail.

[snip]

> > Keep in mind you have to sum the number of bytes for head and tail to
> > get ~100%.
> > 
> > Now for x86-64, you need to be at 9-10 (depending on configuration) or
> > greater to exceed the breakeven point for their fastest implementation.
> > Split crc implementation will use the fast algorithm for about 85% of
> > bytes in the best case, 12% at worst. Combined gets there for 85% at
> > worst, and 100% at best. The slower x86 implementation still uses a
> > hardware instruction, so it doesn't do too badly.
> > 
> > For powerpc, the breakeven is at 512 + 16 bytes (9ish), but it falls
> > back to generic implementation for bytes below that.  
> 
> Which means for the most common objects we won't be able to reach
> breakeven easily simply because of the size of the objects we are
> running CRCs on. e.g. sectors and inodes/dquots by default are all
> 512 bytes or smaller. THere's only so much that can be optimised
> here...

Well for this workload at least, the full checksum size seems always
>= 512. The small heads cut it down and drag a lot of crc32c calls
from 1024-2047 range (optimal for Intel) to 512-1023. I don't *think*
I've done the wrong thing here, but if it looks odd to you, I'll go
back and double check.

> 
> > I think we can
> > reduce the break even point on powerpc slightly and capture most of
> > the rest, so it's not so bad.
> > 
> > Anyway at least that's a data point to consider. Small improvement is
> > possible.  
> 
> Yup, but there's no huge gain to be made here - these numbers say to
> me that the problem may not be the CRC overhead, but instead is the
> amount of CRC work being done. Hence my request for mount options
> + xfs_info to determine if what you are seeing is simply a bad fs
> configuration for optimal small log write performance. CRC overhead
> may just be a symptom of a filesystem config issue...

Yes sorry, I forgot to send an xfs_info sample. mkfs.xfs is 4.3.0 from
Ubuntu 16.04.

npiggin@fstn3:/etc$ sudo mkfs.xfs -f /dev/ram0
specified blocksize 4096 is less than device physical sector size 65536
switching to logical sector size 512
meta-data=/dev/ram0              isize=512    agcount=4, agsize=4194304 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=16777216, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=8192, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Mount options are standard:
/dev/ram0 on /mnt type xfs (rw,relatime,attr2,inode64,noquota)

xfs_info sample:
extent_alloc 64475 822567 74740 1164625
abt 0 0 0 0
blk_map 1356685 1125591 334183 64406 227190 2816523 0
bmbt 0 0 0 0
dir 79418 460612 460544 5685160
trans 0 3491960 0
ig 381191 378085 0 3106 0 2972 153329
log 89045 2859542 62 132145 143932
push_ail 3491960 24 619 53860 0 6433 13135 284324 0 445
xstrat 64342 0
rw 951375 2937203
attr 0 0 0 0
icluster 47412 38985 221903
vnodes 5294 0 0 0 381123 381123 381123 0
buf 4497307 6910 4497106 1054073 13012 201 0 0 0
abtb2 139597 675266 27639 27517 0 0 0 0 0 0 0 0 0 0 1411718
abtc2 240942 1207277 120532 120410 0 0 0 0 0 0 0 0 0 0 4618844
bmbt2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
ibt2 762383 3048311 69 67 0 0 0 0 0 0 0 0 0 0 263
fibt2 1114420 2571311 143583 143582 0 0 0 0 0 0 0 0 0 0 1232534
rmapbt 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
refcntbt 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
qm 0 0 0 0 0 0 0 0
xpc 3366711296 24870568605 34799779740
debug 0

Thanks,
Nick
