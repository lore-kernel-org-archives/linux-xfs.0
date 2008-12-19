Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBJLiGbn022037 for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 15:44:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E66C1767EA3
	for <xfs@oss.sgi.com>; Fri, 19 Dec 2008 13:44:12 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gXOY0ui2gFdTGXyF for
	<xfs@oss.sgi.com>; Fri, 19 Dec 2008 13:44:12 -0800 (PST)
Date: Fri, 19 Dec 2008 16:44:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests tests not in the auto group; do we know why?
Message-ID: <20081219214411.GA18003@infradead.org>
References: <49473616.1020307@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49473616.1020307@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Dec 15, 2008 at 11:01:10PM -0600, Eric Sandeen wrote:
> Of the tests that are not in the auto group, do we know why they are not?
> 
> 022: # Test out a level 0 dump/restore to a tape of a subdir
> 023: # To test xfsdump/restore to tape using a directory with
> 024: # Test out incremental dumps
> 025: # Test dump/restore using -m option (min strategy)
> 036: # Test xfsdump/restore minrmt to a remote IRIX tape
> 037: # Test xfsdump/restore minrmt to a remote linux tape
> 038: # Test xfsdump/restore to a remote linux tape
> 039: # Test xfsdump/restore to a remote IRIX tape
> 043: # Test out xfsdump/restore but rmv inventory prior to restore.
> 055: # Test xfsdump/restore to a remote IRIX tape using RMT user

all these won't run without a tape, but I don't see any reason not
to put them into the default group.

> 059: # place holder for IRIX 059 test for xfsdump/xfsrestore multi streams
> 060: # place holder for IRIX 060 test for xfsdump/xfsrestore multi streams

These obviously don't matter right now.  Just curious, does anyone know
what the multi-streams were and if there's any chance we might ever seen
them on Linux?

> 080: # rwtest (iogen|doio)

Doesn't run under Linux anyway.  Not sure why.

> 071: # Exercise IO at large file offsets.

Fails for me with a not really large enough FS..

> 064: # test multilevel dump and restores with hardlinks
> 085: # To test log replay by shutdown of file system
> 086: # To test log replay with version 2 logs
> 087: # like 086 but want to create more/different kinds of metadata
> 098: # simple attr tests for EAs:

All these are pretty quick and seem useful.

> 106: # Exercise basic xfs_quota functionality (user/group/project quota)
> 107: # Project quota.
> 108: # Simple quota accounting test for direct/buffered/mmap IO.

We should run all these.  Although 108 currently claims that my kernel
doesn't support project quotas for some reason.

> 109: # ENOSPC deadlock case from Asano Masahiro.
> 110: # Incorrect dir2 freetab warning case from Masanori Tsuda.

These take long time, but seems useful.

> 111: # Infinite xfs_bulkstat bad-inode loop case from Roger Willcocks.

This trips over an assert in xfs_imap_to_bp very quickly for me.
Another one on the todo list..

> 113: # aio-stress

Very quick one, should be default.  Also simply gets skipped without
libaio installed.

> 115: # Test out xfs_repair_ipaths

Well, claims to not run on Linux.  Probably needs parent pointers, too.

> 116: # Test out resetting of sb_qflags when mounting with no quotas
> after having mounted with quotas.
> 118: # To test out pv#940675 crash in xfs_trans_brelse + quotas
> 119: # Leaking reservation space in the GRH

All pretty quick ones, no reason to skip them AFAIK.

> 133: # Concurrent I/O to same file to ensure no deadlocks

Also a nice one.

> 136: # Test the attr2 code

Takes quite long, but seems useful.  And I need to update it for my
latest libxfs resync :)

> udf tests are probably not auto out of principle? :)
> 071 fails/hangs on some platforms IIRC

depends on the size of the filesystem I think.  Shouldn't hang.

> 104 hangs ...

Yeah, we should fix this eventually :) 

> "parent" requires code not committed(?)
> "tape" group requires... tape so not auto?
> 
> # auto - tests to be run as part of nightly qa
> 
> I'm not sure what that means; is this group always supposed to pass?  If
> so there are filestreams tests that don't, for example.  Maybe "tests
> that don't hang?"
> 
> I wonder if it'd be worth documenting this a bit, and have a group which
> should always run & pass on the core architectures.  (and for those that
> don't pass, do a bit of documentation on why they don't?)

I think that would be auto.  I'm all for a slight reshuffling of the
groups:

	auto - stuff that should succeed everywhere
	large - stuff that needs a large enough machine / fs to succeed
		(for whatever defintion of large)
	xfail - expected to fail
	xhang - expected to hang
		(should be empty normally, only for new testcases)

And we might want to document which ones will not be run for some fairly
standard conditions (OS mismatch and lack of tapes are the two thinks I
can think of right now).  Or we make the above check per-OS.  Or should
we just declare IRIX dead officially?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
