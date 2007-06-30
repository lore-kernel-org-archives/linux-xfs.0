Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 30 Jun 2007 03:26:44 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5UAQetL001939
	for <xfs@oss.sgi.com>; Sat, 30 Jun 2007 03:26:41 -0700
Date: Sat, 30 Jun 2007 11:26:38 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070630102638.GC23568@infradead.org>
References: <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626231431.GO31489@sgi.com> <20070627034915.GR6652@schatzie.adilger.int> <20070627133657.GQ989688@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627133657.GQ989688@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com

On Wed, Jun 27, 2007 at 11:36:57PM +1000, David Chinner wrote:
> > This
> > would seem to be the only impediment from using fallocated files
> > for swap files.  Maybe if FIEMAP was used by mkswap to get an
> > "UNWRITTEN" flag back instead of "HOLE" it wouldn't be a problem.
> 
> Probably. If we taught do_mpage_readpage() about unwritten mappings,
> then would could map them on read if and then sys_swapon can remain
> blissfully unaware of unwritten extents.

Except for reading the swap header in the first page sys_swapon will
never end up in  do_mpage_readpage.  It rather uses ->bmap to build
it's own extent list and issues bios directly.

Now this is everything but nice and we should rather refactor the direct
I/O code to work on kernel pages without looking at their fields so this
can be done properly.  Alternatively ->bmap would grow a BMAP_SWAP flag
so the filesystem could do the right thing.

But despite not beeing useful for swap the patch below looks very nice
to me.  doing things correctly in core code is always better than hacking
around it in the filesystem, especially as XFS won't stay the only filesystem
using unwritten extents.
