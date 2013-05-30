Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F7607F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 08:42:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6B8EE8F8033
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 06:42:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TcLRldCNNPRbwHY4 for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 06:42:29 -0700 (PDT)
Message-ID: <51A75745.7090805@sandeen.net>
Date: Thu, 30 May 2013 08:42:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFStest suite problem
References: <51A708B2.2080701@oracle.com>
In-Reply-To: <51A708B2.2080701@oracle.com>
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
To: alexander.tsvetkov@oracle.com
Cc: xfs@oss.sgi.com

On 5/30/13 3:07 AM, alexander.tsvetkov@oracle.com wrote:
> I think the following code of "check" script incorrectly builds this exclude list:
> 
> "-X) xfile=$2; shift ;
> for d in $SRC_GROUPS $FSTYP; do
> [ -f $SRC_DIR/$d/$xfile ] || continue
> for f in `cat $SRC_DIR/$d/$xfile`; do
> echo $d/$f >> $tmp.xlist

Well, it is perhaps unexpected, but:

    -X file		exclude individual tests

I think it's designed to actually exclude tests contained in that file, not test numbers.  It's not very obvious.  :(

But from the commit log:

commit 0b1e8abd4a6dbce54bcc5d0467e58966e41e7eb8
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Mar 15 12:28:05 2013 +0000

    xfstests: Reintroduce configurable test expunging.
    
    It is definitely handy to be able to disabdle certain tests (e.g. tests that are
    known to hang or crash the test machine on certain kernels), so re-introducing
    the capability of avoiding certain tests just by placing them in a file is
    useful.
    
    Introduce a command line option to specify the expunged file name. The file will
    exist in each tests/* sub-directory so that only the testname is required, and
    can be managed independently. The use of a command line parameter allows
    multiple expunge files to exist simultaneously in the one xfstests tree which
    simplifies management of a source repository used for multiple versions of a
    distro.
    
    Typical usage:
    
    $ cat tests/generic/3.0-stable-avoid
    280
    $ sudo ./check -X 3.0-stable-avoid generic/280
    FSTYP         -- xfs (debug)
    PLATFORM      -- Linux/x86_64 test-1 3.0.39-dgc+
    MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
    MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
    
    generic/280     [expunged]
    Passed all 0 tests
    $



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
