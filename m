Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3EA417F82
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 14:33:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D737304039
	for <xfs@oss.sgi.com>; Sun, 10 Nov 2013 12:33:42 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5ansDHeuVpWd3xOP for <xfs@oss.sgi.com>;
	Sun, 10 Nov 2013 12:33:40 -0800 (PST)
Date: Mon, 11 Nov 2013 07:33:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest failures
Message-ID: <20131110203331.GO6188@dastard>
References: <20131106105451.GA31283@infradead.org>
	<20131106161825.GU1935@sgi.com> <527A887F.2030807@sandeen.net>
	<20131107081710.GC25157@infradead.org>
	<527B948C.9060905@sandeen.net>
	<20131107132739.GA16608@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131107132739.GA16608@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Nov 07, 2013 at 05:27:39AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 07, 2013 at 07:24:28AM -0600, Eric Sandeen wrote:
> > On 11/7/13, 2:17 AM, Christoph Hellwig wrote:
> > > On Wed, Nov 06, 2013 at 12:20:47PM -0600, Eric Sandeen wrote:
> > >> that's right, it's a known bug w/ a testcase but no fix yet.
> > >>
> > >> I looked a bit, but ugh, xfsdump.
> > > 
> > > Maybe it's time you come up with an xfail mechanism at least?
> > 
> > What's the proposal there, a "fail" group for things known to still
> > fail everywhere?
> > 
> > so i.e. ./check -x fail ?  I can easily send a patch for that if
> > that's what folks want.
> 
> A mechnism to annotate a test as xfail, so that check would output them
> at the end ala:
> 
> Expected failures:  common/263
> Unexpected successes: reiser4/001

If you have a test that fails in your test environment and you don't
want to run it, use the expunged test mechanism. You can maintain it
yourself for your own test environment.

$ cat tests/xfs/expunged
078
$ sudo MKFS_OPTIONS="-m crc=1" ./check -X expunged xfs/078
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test2 3.12.0-rc7-dgc+
MKFS_OPTIONS  -- -f -m crc=1 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

xfs/078       [expunged]
Passed all 0 tests

If we really want to, we can add default expunged files for
different distros so they don't run tests that are known to fail and
are not likely to be fixed automatically.

That handles the "test doesn't fail everywhere" problem that xfail
has....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
