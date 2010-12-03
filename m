Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB3IDi4H099887 for <xfs@oss.sgi.com>; Fri, 3 Dec 2010 12:13:45 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A6261C91433
	for <xfs@oss.sgi.com>; Fri,  3 Dec 2010 10:15:28 -0800 (PST)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id lrOSMBAjqamrdbsI for <xfs@oss.sgi.com>;
	Fri, 03 Dec 2010 10:15:28 -0800 (PST)
Date: Fri, 3 Dec 2010 13:15:20 -0500
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Message-ID: <20101203181520.GA26906@thunk.org>
References: <4CF7A539.1050206@shiftmail.org>
	<20101202141134.GA22012@infradead.org>
	<4CF7A9C4.2040607@shiftmail.org>
	<20101202141737.GA29799@infradead.org>
	<20101202212227.GA22703@redhat.com> <20101203171140.GA11889@amd>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101203171140.GA11889@amd>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, LVM general discussion and development <linux-lvm@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Spelic <spelic@shiftmail.org>

On Sat, Dec 04, 2010 at 04:11:40AM +1100, Nick Piggin wrote:
> > Alternatively, what about switching brd away from overloading BLKFLSBUF
> > to a real implementation of (overloaded) BLKDISCARD support in brd.c?
> > One that doesn't blindly nuke the entire device but that properly
> > processes the discard request.
> 
> Yeah the situation really sucks (mkfs.jfs doesn't work on ramdisk
> for the same reason).
> 
> I want to unfortunately keep ioctl for compatibility, but adding new
> saner ones would be welcome. Also, having a non-default config or
> load time parameter for brd, to skip the special case, if that would
> help testing on older userspace.

How many programs actually depend on BLKFLSBUF dropping the pages used
in /dev/ram?  The fact that it did this at all was a historical
accident of how the original /dev/ram was implemented (in the buffer
cache directly), and not anything that was intended.  I think that's
something that we should be able to fix, since the number of programs
that knowly operate on the ramdisk is quite small.  Just a few system
programs used by distributions in their early boot scripts....

So I would argue for dropping the "special" behavior of BLKFLSBUF for
/dev/ram.

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
