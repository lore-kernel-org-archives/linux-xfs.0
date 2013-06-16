Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DFEE7F37
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 17:06:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE464AC002
	for <xfs@oss.sgi.com>; Sun, 16 Jun 2013 15:06:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	L8HazYMQ9EZ51jpC for <xfs@oss.sgi.com>;
	Sun, 16 Jun 2013 15:06:51 -0700 (PDT)
Date: Mon, 17 Jun 2013 08:06:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: definitions for /proc/fs/xfs/stat
Message-ID: <20130616220648.GG29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

On Sun, Jun 16, 2013 at 08:58:58AM -0400, Mark Seger wrote:
> ok, I have a simple reproducer.  try out the following, noting you'll
> obviously have to change the directory pointed to by dname:
> 
> libc=ctypes.CDLL(ctypes.util.find_library('c'), use_errno=True)
> falloc=getattr(libc, 'fallocate')
> 
> fb#!/usr/bin/python -u
> 
> import os
> import sys
> import time
> import ctypes
> import ctypes.util
> from tempfile import mkstemp
> 
> dname = '/srv/node/disk0/mjs'
> fname = 'foo'
> fsize = 1024
> nfiles = 1000
> 
> body = ' ' * fsize
> 
> time0 = time.time()
> for i in range(nfiles):
>     file_name = '%s/%s-%s' % (dname, fname, i)
>     fd, tmppath = mkstemp(dir=dname)
>     falloc(fd, 1, 0, fsize)
>     os.rename(tmppath, file_name)
> 
> elapsed = time.time() - time0
> tbytes = fsize * nfiles
> rate = tbytes/elapsed/1024/1024
> 
> print "DName: %s" % dname
> print "Bytes: %d" % (tbytes/1024/1024)
> print "Time:  %.2f secs" % elapsed
> print "Rate:  %.2f/sec" % rate
> 
> when I run it I see this:
> 
> segerm@az1-sw-object-0006:~$ sudo ./falloc.py
> DName: /srv/node/disk0/mjs
> Bytes: 9
> Time:  5.84 secs
> Rate:  1.67/sec

Running on my 3.11 branch, python 2.7.3, 100TB XFS filesystem, there
is no IO to speak of:

$ tests/falloc.py 
DName: /mnt/scratch/
Bytes: 0
Time:  0.21 secs
Rate:  4.60/sec

> #<----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
> #cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut
>  PktOut
>    0   0   110    113      0      0      0      0      0      5      0
>   3
>    1   0  1576   2874      0      0 170240    665      0      3      0
>   2
>    4   3  2248   6623      0      0 406585   1596      0      1      0
>   1
>    4   3  2145   7680      0      0 473600   1850      0      1      0
>   1
>    2   1  2200   7406      0      0 456633   1875      0      2      0
>   1
>    4   3  3696   7401      0      0 454606   1823      0      1      0
>   1
>    3   2  3877   7354      0      0 453537   1806      0      1      0
>   1
>    1   0  1610   2764      0      0 163793    684      0      3      0
>   3

There is no way that fallocate() of 1000x1k files should be causing
450MB/s of IO for 5 seconds.

However, I still have no idea what you are running this test on - as
I asked in another email, can you provide some information about
the system your are seeing this problem on so we can try to work out
what might be causing this?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> This is the same behavior I'm seeing on swift.  10K 1KB files X 4kb minimal
> block size still comes out to a lot less than the multiple GB of writes
> being reported.  Actually since these whole thing only takes a few seconds
> and I know a single disk can't write that fast maybe it's just a bug in the
> way the kernel is reported allocated preallocated blocks and nothing to do
> with XFS?  Or iis xfs responsible for the stats?

I don't know what stats you are getting your information from. XFS
is only responsible for what is in /proc/fs/xfs/,,,

> If I remove the fallocate call I see the expected amount of disk traffic.

Have you run strace to confirm that your python script is actually
calling fallocate(), and it's not being emulated by python or libc?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
