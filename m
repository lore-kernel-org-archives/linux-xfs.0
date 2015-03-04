Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D7CC17F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 16:27:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52DE7AC003
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 14:27:13 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id urybQINqdfGGrzXB for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 14:27:11 -0800 (PST)
Date: Wed, 4 Mar 2015 17:27:09 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150304222709.GI1627@fieldses.org>
References: <20150303221033.GB19439@fieldses.org>
	<20150303224456.GV4251@dastard>
	<20150304020826.GD19439@fieldses.org>
	<20150304155421.GE1627@fieldses.org>
	<20150304220900.GX18360@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304220900.GX18360@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Mar 05, 2015 at 09:09:00AM +1100, Dave Chinner wrote:
> On Wed, Mar 04, 2015 at 10:54:21AM -0500, J. Bruce Fields wrote:
> > On Tue, Mar 03, 2015 at 09:08:26PM -0500, J. Bruce Fields wrote:
> > > On Wed, Mar 04, 2015 at 09:44:56AM +1100, Dave Chinner wrote:
> > > > On Tue, Mar 03, 2015 at 05:10:33PM -0500, J. Bruce Fields wrote:
> > > > > I'm getting mysterious crashes on a server exporting an xfs filesystem.
> > > > > 
> > > > > Strangely, I've reproduced this on
> > > > > 
> > > > > 	93aaa830fc17 "Merge tag 'xfs-pnfs-for-linus-3.20-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs
> > > > > 
> > > > > but haven't yet managed to reproduce on either of its parents
> > > > > (24a52e412ef2 or 781355c6e5ae).  That might just be chance, I'll try
> > > > > again.
> > > > 
> > > > I think you'll find that the bug is only triggered after that XFS
> > > > merge because it's what enabled block layout support in the server,
> > > > i.e.  nfsd4_setup_layout_type() is now setting the export type to
> > > > LAYOUT_BLOCK_VOLUME because XFS has added the necessary functions to
> > > > it's export ops.
> > > 
> > > Doh--after all the discussion I didn't actually pay attention to what
> > > happened in the end.  OK, I see, you're right, it's all more-or-less
> > > dead code till that merge.
> > > 
> > > Christoph's code was passing all my tests before that, so maybe we
> > > broke something in the merge process.
> > > 
> > > Alternatively, it could be because I've added more tests--I'll rerun my
> > > current tests on his original branch....
> > 
> > The below is on Christoph's pnfsd-for-3.20-4 (at cd4b02e).  Doesn't look
> > very informative.  I'm running xfstests over NFSv4.1 with client and
> > server running the same kernel, the filesystem in question is xfs, but
> > isn't otherwise available to the client (so the client shouldn't be
> > doing pnfs).
> > 
> > --b.
> > 
> > BUG: unable to handle kernel paging request at 00000000757d4900
> > IP: [<ffffffff810b59af>] cpuacct_charge+0x5f/0xa0
> > PGD 0 
> > Thread overran stack, or stack corrupted
> 
> Hmmmm. That is not at all informative, especially as it's only
> dumped the interrupt stack and not the stack or the task that it
> has detected as overrun or corrupted.
> 
> Can you turn on all the stack overrun debug options? Maybe even
> turn on the stack tracer to get an idea of whether we are recursing
> deeply somewhere we shouldn't be?

Digging around under "Kernel hacking".... I already have
DEBUG_STACK_USAGE, DEBUG_STACKOVERFLOW, and STACK_TRACER, and I can try
turning on the latter.  (Will I be able to get information out of it
before the panic?)

I guess I'll also try SCHED_STACK_END_CHECK.  Anything else I'm missing?

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
