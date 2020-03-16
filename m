Return-Path: <SRS0=1m5L=5B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D795C0044D
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 23:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A6C820679
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Mar 2020 23:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbgCPXcs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 19:32:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47514 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732842AbgCPXcr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 19:32:47 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D09C73A64DA;
        Tue, 17 Mar 2020 10:32:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jDzDs-0005CL-LP; Tue, 17 Mar 2020 10:32:40 +1100
Date:   Tue, 17 Mar 2020 10:32:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     "Ober, Frank" <frank.ober@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: write atomicity with xfs ... current status?
Message-ID: <20200316233240.GR10776@dread.disaster.area>
References: <MW3PR11MB46974637E20D2ED949A7A47E8BF90@MW3PR11MB4697.namprd11.prod.outlook.com>
 <20200316215913.GV256767@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200316215913.GV256767@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=8nJEP1OIZ-IA:10 a=SS2py6AdgQ4A:10
        a=JfrnYn6hAAAA:8 a=07d9gI8wAAAA:8 a=7-415B0cAAAA:8 a=TlSev5KwptuUQvCB4x4A:9
        a=S4FlYU_zL-4PRN5f:21 a=dkQCIoaToDRUXOKD:21 a=wPNLvfGTeEIA:10
        a=1CNFftbPRP8L7MoqJWF3:22 a=e2CUPOnPG4QKp8I52DXD:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 02:59:13PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 16, 2020 at 08:59:54PM +0000, Ober, Frank wrote:
> > Hi, Intel is looking into does it make sense to take an existing,
> > popular filesystem and patch it for write atomicity at the sector
> > count level. Meaning we would protect a configured number of sectors
> > using parameters that each layer in the kernel would synchronize on.
> >  We could use a parameter(s) for this that comes from the NVMe
> > specification such as awun or awunpf
> 
> <gesundheit>
> 
> Oh, that was an acronym...
> 
> > that set across the (affected)
> > layers to a user space program such as innodb/MySQL which would
> > benefit as would other software. The MySQL target is a strong use
> > case, as its InnoDB has a double write buffer that could be removed if
> > write atomicity was protected at 16KiB for the file opens and with
> > fsync(). 
> 
> We probably need a better elaboration of the exact usecases of atomic
> writes since I haven't been to LSF in a couple of years (and probably
> not this year either).  I can think of a couple of access modes off the
> top of my head:
> 
> 1) atomic directio write where either you stay under the hardware atomic
> write limit and we use it, or...

We've plumbed RWF_DSYNC to use REQ_FUA IO for pure overwrites if the
hardware supports it. We can do exactly the same thing for
RWF_ATOMIC - it succeeds if:

- we can issue it as a single bio
- the lower layers can take the entire atomic bio without splitting
  it.
- we treat O_ATOMIC as O_DSYNC so that any metadata changes required
  also get synced to disk before signalling IO completion. If no
  metadata updates are required, then it's an open question as to
  whether REQ_FUA is also required with REQ_ATOMIC...

Anything else returns a "atomic write IO not possible" error.

> 2) software atomic writes where we use the xfs copy-on-write mechanism
> to stage the new blocks and later map them back into the inode, where
> "later" is either an explicit fsync or an O_SYNC write or something...

That's a possible fallback, but we can't guarantee that the write
will be atomic - partial write failure can still occur as page cache
writeback can be split into arbitrary IOs and transactions....

> 3) ...or a totally separate interface where userspace does something
> along the lines of:
> 
> 	write_fd = stage_writes(fd);
> 
> which creates an O_TMPFILE and reflinks all of fd's content to it
> 
> 	write(write_fd...);
> 
> 	err = commit_writes(write_fd, fd);
> 
> which then uses extent remapping to push all the changed blocks back to
> the original file if it hasn't changed.  Bonus: other threads don't see
> the new data until commit_writes() finishes, and we can introduce new
> log items to make sure that once we start committing we can finish it
> even if the system goes down.

Which is essentially userspace library code that runs multiple
syscalls to do the necessary work. commit_writes() is basically a
ranged swap-extents call. i.e.:

	write_fd = open(O_TMPFILE)
	clone_file_range(fd, writefd, /* overwrite range */)
	loop (overwrite range) {
		write(write_fd)
	}
	fsync(write_fd)
	swap_extents(fd, write_fd, /* overwrite range */)
	fsync(fd)

i.e. this is basically the same process as a partial file defrag
operation. Hence I don't think the kernel needs to be involved in
the software emulation of atomic writes at all. IOWs, if the kernel
returns an "cannot do an atomic write" error to RWF_ATOMIC,
userspace can simply do the slow atomic overwrite as per above
without needing any special kernel code at all...

> > My question is why hasn't xfs write atomicity advanced further, as it
> > seems in 3.x kernel time a few years ago this was tried but nothing
> > committed. as documented here:
> >
> >                http://git.infradead.org/users/hch/vfs.git/shortlog/refs/heads/O_ATOMIC
> > 
> > Is xfs write atomicity still being pursued , and with what design
> > objective. There is a long thread here,
> > https://lwn.net/Articles/789600/ on write atomicity, but with no
> > progress, lots of ideas in there but not any progress, but I am
> > unclear.
> > 
> > Is my design idea above simply too simplistic, to try and protect a
> > configured block size (sector count) through the filesystem and block
> > layers, and what really is not making it attainable?
> 
> Lack of developer time, AFAICT.

There's multiple other things, I think:

1. no hardware that provides usable atomic write semantics.
2. no device or block layer support for atomic write IOs; we need
   IO level infrastructure before the filesystems can do anything
   useful
3. no support in page cache for tracking atomic write ranges, so
   atomic writes via buffered IO rather difficult without using
   temporary files and extent swapping tricks...
4. emulation in userspace is easy if you have clone_file_range()
   support, even if it is slow. We aren't hearing from app
   developers emulating atomic writes for kernel side acceleration
   because it won't work on ext4.

Once we get 1. and 2., then we can support atomic direct IO writes
through XFS via RWF_ATOMIC with relative ease. 4) probably requires
some mods to XFS's swap_extent function to properly support file
ranges. The API supports ranges, the implementation ony supports
"full file range"...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
