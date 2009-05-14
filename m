Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4EMrRRv254925 for <xfs@oss.sgi.com>; Thu, 14 May 2009 17:53:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B544419C55B7
	for <xfs@oss.sgi.com>; Thu, 14 May 2009 15:53:33 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	agsoeDvSbjB0Dxd3 for <xfs@oss.sgi.com>;
	Thu, 14 May 2009 15:53:33 -0700 (PDT)
Date: Fri, 15 May 2009 08:53:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Questions about xfstests regarding porting it to test ext4
	filesystems
Message-ID: <20090514225329.GN16929@discord.disaster>
References: <E1M4aRo-0000ri-0G@closure.thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E1M4aRo-0000ri-0G@closure.thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com

On Thu, May 14, 2009 at 08:54:04AM -0400, Theodore Ts'o wrote:
> 
> I've been playing around with xfstests (aka xfsqa) and have some
> questions:
> 
> 1)  What is the best mailing list to use for discussions about xfstests? 
> I'm *not* subscribed to xfs@oss.sgi.com, since I'm concerned about
> traffic levels... I'm on too many high-volume mailing lists already.

Just send email here for the moment, no need to subscribe.

I think if we move down the road of making xfstests generic and it
works out for everyone, traffic would move to a more general list
(e.g fsdevel) as more ppl use it.

> 2)  Why is the TESTDIR have to be a persistent xfs volume?   I noticed
> that when testing UDF and NFS, the scratch volume is used (and $testdir
> is set to the point at the scratch directory).   Is there some
> fundamental reason why there must be an XFS volume mounted, even if the
> fundamental intention is to test some other filesystem type, whether
> it's UDF, NFS, or Ext4?

It is persistent because it ages the filesystem. If you run xfsqa
repeatedly on the same machine (e.g. for months on end), the TESTDIR
gets aged and so we exercise aged filesystems as well as a new fs'
(scratch). There is no reason it really needs to be XFS - it could
be ext4, UDF, etc - as long as it is persistent.

> 3) How much latitude/interest is there in modifying xfstests to be a bit
> more filesystem independent?

Plenty, I think. While it has lots of XFS specific stuff, many of
the tests are generic and have no XFS dependence at all. And many
of the tests that rely on preallocation and block mapping could be
made generic quite easily now. ;)

> I understand the primary purpose of
> xfstests has to be to support XFS development, but looking at the
> scripts, there is a *huge* amount of XFS-specific assumptions all over
> the shell scripts.

A lot of them are relatively easy to fix, I think.

> As a result I'm still of two minds whether it will
> be less work to start from scratch to develop a test suite for ext4 (and
> from the beginning try to make it filesystem independent) or to try to
> hack xfstests and try to make it more filesystem indpendent.  A lot of
> this depends on the time/interest with the xfstests upstream in working
> with me.

I don't see any problem with that - I think xfstests is a better
place to start because of all the knowledge already encoded in
the test suite.

Note that xfsqa also requires some functionality to be implemented
in filesystems to enable more compelte test coverage - e.g.  a
shutdown mechanism so that the test suite can simulate crashes for
it's sync/recovery tests. Ideally, if we are going to make this
a generic test uite, we should also develop generic methods
of doing this sort of shutdown (e.g. via the blockdev) so the
tests will no longer be XFS specific....

> (And assuming we get the licensing issues dealt with --- hence
> my interest and time spent in trying to clarify the licensing situation
> with the fsx program.)   

*nod*

> If there isn't a whole lot of interest in trying to make xfstests more
> portable, that's fine.  It may be that I'm better off starting from
> scratch.  There does seem to be a lot of work and experience represented
> in the xfstest suite, though, so I would like to try exploring the
> possibility of expanding its scope to also support testing other
> filesystems (such as ext4, btrfs, etc.)

Agreed.

The other advantages I see of supporting multiple filesystems in the
one test suite is that we can implement new interfaces in the test
suite and know that they work across multiple filesystems before
integration. i.e. less arguing on mailing lists because working,
useful code can be demonstrated and tested easily.  It would also
mean that new filesystems have something that can be used to test
generic functionality prior to review and merge....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
