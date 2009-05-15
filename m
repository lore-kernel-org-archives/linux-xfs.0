Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4FBLhI9028902 for <xfs@oss.sgi.com>; Fri, 15 May 2009 06:21:44 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA97328AECA
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 04:21:50 -0700 (PDT)
Received: from thunker.thunk.org (thunk.org [69.25.196.29]) by cuda.sgi.com
	with ESMTP id hWaYrun89TTtQu8h for <xfs@oss.sgi.com>;
	Fri, 15 May 2009 04:21:50 -0700 (PDT)
Date: Fri, 15 May 2009 07:21:46 -0400
From: Theodore Tso <tytso@mit.edu>
Subject: Re: Questions about xfstests regarding porting it to test ext4
	filesystems
Message-ID: <20090515112146.GE6816@mit.edu>
References: <E1M4aRo-0000ri-0G@closure.thunk.org>
	<20090514225329.GN16929@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090514225329.GN16929@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, May 15, 2009 at 08:53:29AM +1000, Dave Chinner wrote:
> > 2)  Why is the TESTDIR have to be a persistent xfs volume?   I noticed
> > that when testing UDF and NFS, the scratch volume is used (and $testdir
> > is set to the point at the scratch directory).   Is there some
> > fundamental reason why there must be an XFS volume mounted, even if the
> > fundamental intention is to test some other filesystem type, whether
> > it's UDF, NFS, or Ext4?
> 
> It is persistent because it ages the filesystem. If you run xfsqa
> repeatedly on the same machine (e.g. for months on end), the TESTDIR
> gets aged and so we exercise aged filesystems as well as a new fs'
> (scratch). There is no reason it really needs to be XFS - it could
> be ext4, UDF, etc - as long as it is persistent.

At the moment there is a test in common.rc that seems to force that
TEST_DEV is a mounted xfs filesystem:

candygram:/host/usr/projects/e2fsprogs/xfstests# ./check 001
common.rc: Error: $TEST_DEV (/dev/sdb) is not a MOUNTED xfs filesystem
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdb      ext4    20642428    522392  19071460   3% /test

Sounds like removing that test would be the right thing to do?

> > 3) How much latitude/interest is there in modifying xfstests to be a bit
> > more filesystem independent?
> 
> Plenty, I think. While it has lots of XFS specific stuff, many of
> the tests are generic and have no XFS dependence at all. And many
> of the tests that rely on preallocation and block mapping could be
> made generic quite easily now. ;)

What would people think about taking xfs_io, stripping out the
xfs-specific bits, and creating an fs_testio program that would live
in the xfstests tree?  Then the tests that don't need any of the XFS
bits could simply use fs_testio and not need to build and install
xfsprogs.

Also, maybe we need to have an --disable-xfs option to configure?
Right now for some reason a full make on blows up, probably because
the xfsprogs/xfslibs-dev packages in Ubuntu 9.04 aren't new enough for
whatever xfstests requires:

make[2]: Entering directory `/usr/projects/e2fsprogs/xfstests/src'
/usr/bin/libtool --tag=CC --mode=link gcc loggen.c -o loggen -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.0.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall      
libtool: link: gcc loggen.c -o loggen -g -O2 -g -O2 -DDEBUG -I../include -DVERSION=\"1.0.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall 
loggen.c: In function 'loggen_unmount':
loggen.c:143: warning: implicit declaration of function 'xlog_assign_lsn'
/tmp/ccey5aXu.o: In function `loggen_empty':
/usr/projects/e2fsprogs/xfstests/src/loggen.c:211: undefined reference to `xlog_assign_lsn'
/usr/projects/e2fsprogs/xfstests/src/loggen.c:263: undefined reference to `xlog_assign_lsn'
/tmp/ccey5aXu.o: In function `loggen_unmount':
/usr/projects/e2fsprogs/xfstests/src/loggen.c:143: undefined reference to `xlog_assign_lsn'
/usr/projects/e2fsprogs/xfstests/src/loggen.c:160: undefined reference to `xlog_assign_lsn'
collect2: ld returned 1 exit status
distcc[9013] ERROR: compile loggen.c on localhost failed

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
