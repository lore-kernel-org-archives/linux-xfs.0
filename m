Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4FCv2bZ033750 for <xfs@oss.sgi.com>; Fri, 15 May 2009 07:57:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 20A3128B480
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 05:57:09 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 32RGDduxsONRHmQM for
	<xfs@oss.sgi.com>; Fri, 15 May 2009 05:57:09 -0700 (PDT)
Message-ID: <4A0D66A2.4090608@sandeen.net>
Date: Fri, 15 May 2009 07:57:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Questions about xfstests regarding porting it to test
	ext4	filesystems
References: <E1M4aRo-0000ri-0G@closure.thunk.org>	<20090514225329.GN16929@discord.disaster>
	<20090515112146.GE6816@mit.edu>
In-Reply-To: <20090515112146.GE6816@mit.edu>
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
To: Theodore Tso <tytso@mit.edu>
Cc: xfs@oss.sgi.com

Theodore Tso wrote:
> On Fri, May 15, 2009 at 08:53:29AM +1000, Dave Chinner wrote:
>>> 2)  Why is the TESTDIR have to be a persistent xfs volume?   I noticed
>>> that when testing UDF and NFS, the scratch volume is used (and $testdir
>>> is set to the point at the scratch directory).   Is there some
>>> fundamental reason why there must be an XFS volume mounted, even if the
>>> fundamental intention is to test some other filesystem type, whether
>>> it's UDF, NFS, or Ext4?
>> It is persistent because it ages the filesystem. If you run xfsqa
>> repeatedly on the same machine (e.g. for months on end), the TESTDIR
>> gets aged and so we exercise aged filesystems as well as a new fs'
>> (scratch). There is no reason it really needs to be XFS - it could
>> be ext4, UDF, etc - as long as it is persistent.
> 
> At the moment there is a test in common.rc that seems to force that
> TEST_DEV is a mounted xfs filesystem:
> 
> candygram:/host/usr/projects/e2fsprogs/xfstests# ./check 001
> common.rc: Error: $TEST_DEV (/dev/sdb) is not a MOUNTED xfs filesystem
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sdb      ext4    20642428    522392  19071460   3% /test
> 
> Sounds like removing that test would be the right thing to do?

Probably so.  I would hope that tests that require xfs would then be
skipped gracefully ...

>>> 3) How much latitude/interest is there in modifying xfstests to be a bit
>>> more filesystem independent?
>> Plenty, I think. While it has lots of XFS specific stuff, many of
>> the tests are generic and have no XFS dependence at all. And many
>> of the tests that rely on preallocation and block mapping could be
>> made generic quite easily now. ;)
> 
> What would people think about taking xfs_io, stripping out the
> xfs-specific bits, and creating an fs_testio program that would live
> in the xfstests tree?  Then the tests that don't need any of the XFS
> bits could simply use fs_testio and not need to build and install
> xfsprogs.

xfs_io is fairly tangled in with xfsprogs right now I _think_ ... I
dont' see much reason to strip xfs specific stuff out of it, I'd just
make sure the generic functionality is done in a generic way, and keep
adding more.  IOW, don't remove "resvsp" which calls the xfs ioctl, but
do add fallocate.

Installing xfsprogs shouldn't be -too- onerous.... xfs users have been
installing e2fsprogs for years to get libuuid for example.  :)

> Also, maybe we need to have an --disable-xfs option to configure?
> Right now for some reason a full make on blows up, probably because
> the xfsprogs/xfslibs-dev packages in Ubuntu 9.04 aren't new enough for
> whatever xfstests requires:

that was due to some header moves as I said on irc.  --disable-xfs might
be reasonable, to skip building & running the non-xfs tests.

-Eric

> make[2]: Entering directory `/usr/projects/e2fsprogs/xfstests/src'
> /usr/bin/libtool --tag=CC --mode=link gcc loggen.c -o loggen -g -O2 -g -O2 -DDEBUG  -I../include -DVERSION=\"1.0.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall      
> libtool: link: gcc loggen.c -o loggen -g -O2 -g -O2 -DDEBUG -I../include -DVERSION=\"1.0.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall 
> loggen.c: In function 'loggen_unmount':
> loggen.c:143: warning: implicit declaration of function 'xlog_assign_lsn'
> /tmp/ccey5aXu.o: In function `loggen_empty':
> /usr/projects/e2fsprogs/xfstests/src/loggen.c:211: undefined reference to `xlog_assign_lsn'
> /usr/projects/e2fsprogs/xfstests/src/loggen.c:263: undefined reference to `xlog_assign_lsn'
> /tmp/ccey5aXu.o: In function `loggen_unmount':
> /usr/projects/e2fsprogs/xfstests/src/loggen.c:143: undefined reference to `xlog_assign_lsn'
> /usr/projects/e2fsprogs/xfstests/src/loggen.c:160: undefined reference to `xlog_assign_lsn'
> collect2: ld returned 1 exit status
> distcc[9013] ERROR: compile loggen.c on localhost failed
> 
> 							- Ted
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
