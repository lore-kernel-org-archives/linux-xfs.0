Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Jul 2007 17:50:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6A0oabm014866
	for <xfs@oss.sgi.com>; Mon, 9 Jul 2007 17:50:37 -0700
Date: Tue, 10 Jul 2007 10:50:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Fwd: xfs_fsr and null byte areas in files (REPOST) / file data checksumming
Message-ID: <20070710005030.GQ31489@sgi.com>
References: <200707092313.48876.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707092313.48876.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

On Mon, Jul 09, 2007 at 11:13:48PM +0200, Martin Steigerwald wrote:
> 
> Hello!
> 
> I am reposting this, cause I think its an very serious issue. What I 
> experienced here is quite randomly spread *silent* data corruption. Not 
> meta data, but data in files, but that actually doesn't make this less 
> severe.
......
> 
> I now also checked such a broken file - I still have those broken 
> repositories around for holes, and well these null bytes are for real:
> 
> ---------------------------------------------------------------------
> martin@shambala:~/.crm114> 
> head -c9183 .bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit |
> tail -c1000 | od -h
> 0000000 d46d 2b8b 9b50 5ce8 00f7 0000 0000 0000
> 0000020 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0001740 0000 0000 0000 0000
> 0001750

The corruption is not on block or sector boundaries. Given that
fsr uses direct I/O this does not really seem possible.

> shambala:/home/martin/.crm114> 
> xfs_bmap -v .bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit
> .bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit:
>  EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET          TOTAL
>    0: [0..23]:         32065584..32065607  5 (4599184..4599207)    24
> ---------------------------------------------------------------------

Can you use xfs_bmap -vvp <file> so we can see which of those blocks might
be unwritten?

I'm trying to reproduce this at the moment, but I haven't been
able to yet. I'll let you know if I do, but given that we've been
running fsr on machines for years without having seen this I'm not
hopeful that I will be able to reproduce it....

> I would like to reproduce it and have some questions on how to do that 
> efficiently. I have a spare 1GB on my notebook harddisk and also a spare 
> 10GB on an external USB drive that I could use for a test partition.

Copy the directory that regularly gets broken to the spare partition,
and run xfs_fsr over that to see if you can reproduce the problem.

> 1) Is there an XFS qa test available for xfs_fsr? If so I could use that 
> one. Are there some hints on how to get started on XFS qa?

Yes, test 042. Download it from CVS, build it (installing all the
bits it asks for ;), edit common.config to add your test and scratch
partitions (both volatile) and the 'check -l 042' to run test 042.

> 2) If not, what would be the most efficient scriptable way to produce 
> fragmented files? I would like to copy some directories to that test 
> partition in a way that produces lots of fragmented files, then run 
> xfs_fsr just on that partition and then compare the data with the 
> original data with rsync -acn. 

See test 042.

> For an xfsqa test it might be better to use md5sum (since it saves an 
> extra copy of the created data) tough. I strongly recommend to add a xfs 
> qa test for xfs_fsr. Is there a test that verifies file data integrity 
> after files have been shuffled around?

Test 042 uses checksums to determine the file contents are correct after
the defragmentation.


> And least but not least:
> 
> Are there any plans to put file data checksumming code into XFS at least 
> as an option that one can enable? 

Eventually, yes. But given that it is major surgery and requires format
changes to extent btrees, the write path, the read path, and so on, it's
not going to be avaialble any time soon.

Besides, this problem may not have anything to do with the kernel code
and hence checksums would not help find or detect the problem. i.e.
checksums don't help you find programming errors or bad data written
from userspace. Checksums are not the Holy Grail that prevent silent
data corruption.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
