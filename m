Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A68807F51
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 06:52:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 771FE8F8033
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 04:52:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oDhQICQIFbTkfISI for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 04:52:30 -0700 (PDT)
Date: Mon, 9 Mar 2015 22:52:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hangs with XFS: possible memory allocation deadlock in
	kmem_alloc
Message-ID: <20150309115224.GE26657@destitution>
References: <54FAAE16.6090505@fau.de> <20150307140721.GA9098@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150307140721.GA9098@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Michael Meier <michael.meier@fau.de>, xfs@oss.sgi.com

On Sat, Mar 07, 2015 at 09:07:21AM -0500, Brian Foster wrote:
> On Sat, Mar 07, 2015 at 08:51:50AM +0100, Michael Meier wrote:
> > We've recently upgraded the OS on one of our servers, and since then
> > have been experiencing frequent stalls of the XFS filesystem on it.
> > Other filesystems on the machine seem to still respond fine while XFS
> > hangs. The stalls sometimes last for around 30 minutes, during which all
> > attempts to access that filesystem hang completely - after that, the
> > filesystem suddenly responds instantly again, as if there had never been
> > any problem. The dmesg is full of these messages while it stalls:
> >  XFS: possible memory allocation deadlock in kmem_alloc (mode:0x8250)
> > These also occour from time to time without the filesystem stalling (or
> > at least it's not noticeable) - the messages appear about once in two
> > hours, the stalls about once a day.
> > 
> > Google did point me to some reports of these messages occouring at the
> > end of 2013, but the kernels in question should all have had the fixes
> > proposed back then - although one message back then suggested there were
> > more places where this problem could occour that were not fixed yet.
> > 
> > Kernels used were:
> > - Ubuntu 3.13.0-44  - shows stalls, according to
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1382333 has the fix
> > - Ubuntu 3.16.0-31  - shows stalls
> > - Ubuntu 3.2.0-various - no stalls in more than 1 year
> > We can actually still boot the machine with the 3.2.0 kernel, and it
> > will run absolutely fine, but as that kernel will not be supported
> > forever, I do not consider that a permanent solution.
> > 
> > The machine should not be low on memory, the disk array far from its
> > limits, and the I/O-load is mostly reads with very little writes, as
> > this is a public FTP server.
> > 
> > I have tried to collect some information, available at
> > https://grid.rrze.uni-erlangen.de/~unrz191/syslog-with-xfs-hangs.log
> > 
> 
> Thanks for the data. Some notes from the backtraces in the first
> instance:
> 
> - xfsaild is down in xlog_cil_force_lsn()->flush_work(). So it's trying
>   to push the log, but the workqueue worker is already running.
> - The workqueue worker is here:
> 
> 	[298163.482697] Workqueue: xfs-cil/dm-0 xlog_cil_push_work [xfs]
> 
> ... and it appears to be blocked on the ctx lock. This means either a
> transaction is completing or somebody else is pushing the cil.
> - Writeback and one or two other transactions are backed up waiting on
>   the ctx lock.
> - rsync is running a transaction completion (e.g., holding ctx lock) and
>   blocked on memory allocation:

Yup, that's prety much it. I suspect that we can do better here; I
think we might be ale to hoist the item formatting and memory
allocation outside the ctx lock - I'll need to do a little more than
have a quick browse of the code to determine if it's safe as we are
replacing log vectors in the when we are doing the allocation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
