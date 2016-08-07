Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B264B7CB6
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 18:11:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68BBB30405F
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 16:11:29 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	rVLl0G81VM1VzS5B for <xfs@oss.sgi.com>;
	Sun, 07 Aug 2016 16:11:22 -0700 (PDT)
Date: Mon, 8 Aug 2016 09:11:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests xfs fuzzers fail with DAX
Message-ID: <20160807231107.GB19025@dastard>
References: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
	<a23e895c-7d3e-bed2-9bc9-66e306df485e@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a23e895c-7d3e-bed2-9bc9-66e306df485e@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 10:00:09PM -0500, Eric Sandeen wrote:
> On 8/3/16 9:45 PM, Xiong Zhou wrote:
> > Hi,
> > 
> > A few xfs fuzzers in xfstests fail with dax mount option, pass without dax.
> > They are xfs/086 xfs/088 xfs/089 xfs/091.
> > 
> > xfstests to commit 4470ad4c7e  (Jul 26)
> > kernel   to commit dd95069545  (Jul 24)
> > 
> > + ./check xfs/091
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
> > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch
> > 
> > xfs/091	 104s
> > Ran: xfs/091
> > Passed all 1 tests
> > 
> > + echo 'MOUNT_OPTIONS="-o dax"'
> > + ./check xfs/091
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
> > MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch
> > 
> > xfs/091 104s ...  - output mismatch (see /root/xfstests/results//xfs/091.out.bad)
> >     --- tests/xfs/091.out	2016-07-18 02:57:47.670000000 -0400
> >     +++ /root/xfstests/results//xfs/091.out.bad	2016-08-03 22:38:14.948000000 -0400
> >     @@ -6,6 +6,70 @@
> >      + corrupt image
> >      + mount image
> >      + modify files
> >     +pwrite64: Structure needs cleaning
> >     +pwrite64: Structure needs cleaning
> >     +pwrite64: Structure needs cleaning
> >     +pwrite64: Structure needs cleaning
> 
> This means the filesystem has shut down, most likely, and more information about
> the error is in dmesg.
>
> Further, if the filesystem is corrupt, xfs_repair output would be interesting.
> 
> Can you provide that information?
> 
> This can probably be reproduced, but when reporting a bug it's always good to provide
> as many details as you can.

What it indicates to me is that DAX detects inode/freespace  metadata
related corruption sooner than non-DAX paths because we don't do
delayed allocation on DAX. i.e. we are doing direct allocation in
the syscall path and errors that would have been detected in the
writeback path and triggered until sync/unmount are now triggering
in the pwrite() syscall path.

Hence I think this is probably expected behaviour, and not a bug or
regression. We probably should just filter the pwrite errors out...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
