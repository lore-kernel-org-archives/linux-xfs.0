Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A47A7F72
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 16:35:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34C2C304043
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 14:35:31 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KO5xWrtoW9Sn2xLm for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 14:35:28 -0800 (PST)
Date: Mon, 3 Feb 2014 09:35:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfstests updated to 197f773
Message-ID: <20140202223525.GW2212@dastard>
References: <20140124025846.GL27606@dastard>
	<CAOcd+r1wUaMyrhvkq++WoswM1ND9+VZJNx0mZeC1Uiu663xbtg@mail.gmail.com>
	<52E95EB8.8080003@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E95EB8.8080003@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Wed, Jan 29, 2014 at 02:04:08PM -0600, Eric Sandeen wrote:
> On 1/29/14, 1:55 PM, Alex Lyakas wrote:
> > Hi Dave,
> > are all tests in xfstests (those relevant for XFS) in principle
> > supposed to pass on XFS?
> > I am running these tests on a pristine XFS from kernel 3.8.13
> > (srcversion 9862FA08CF42E06A4151111) and I get:
> > 
> > root@vc-13-12-1095-35-dev:/mnt/work/alex/xfstests# ./check tests/generic/013
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 vc-13-12-1095-35-dev 3.8.13-030813-generic
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> > MOUNT_OPTIONS -- /dev/vdb /mnt/SCRATCH_DIR
> > 
> > generic/013      34s
> > _check_xfs_filesystem: filesystem on /dev/vda is inconsistent (c) (see
> > /mnt/work/alex/xfstests/results//generic/013.full)
> 
> uh, so it failed
> 
> > Ran: generic/013
> > Passed all 1 tests
> 
> but it passed?  ;)

It passed the test, but failed the post test filesystem checks.

> The fact that you saw:
> 
> > generic/013      34s
> 
> and not:
> 
> > generic/013      34s ... 33s
> or
> > generic/013      34s ... output mismatch
> 
> or similar, makes me think the test did not even start, and /dev/vda was
> corrupted before you even started the test, but I'm not certain.

No, what that means is that there was no results/check.time file
that had previous runtime information in it. i.e. this is the first
time the test was run, or that it has always failed like this in the
past on this machine.

As it is:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
