Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 536547F4E
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 21:18:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DBAF304032
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2014 19:18:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XWZ2opCi55QQBaZP for <xfs@oss.sgi.com>;
	Mon, 23 Jun 2014 19:18:38 -0700 (PDT)
Date: Tue, 24 Jun 2014 12:18:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Null pointer dereference while at ACL limit on v5 XFS
Message-ID: <20140624021835.GA9508@dastard>
References: <53A8A0AF.9070009@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53A8A0AF.9070009@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 23, 2014 at 05:48:31PM -0400, Michael L. Semon wrote:
> At the ACL limit of v5-superblock XFS--with a directory filled with both default 
> and access ACL entries--I'm getting a null pointer dereference on x86 after 
> creating the directory successfully.
> 
> Disclaimer:  There's some current issues on 32-bit x86 that, for instance, can 
> make badblocks see phantom bad blocks on a read test.  My apologies in advance 
> if this turns out to be a false alarm bug report.
> 
> My first encounter with this issue involved fsstress.  Here's part of a `crash` 
> session from the fsstress run.

Ok, I haven't been able to reproduce this on x86-64....

> # ### ran `fsstress -d $SCRATCH_MNT/test-dir -n 10000 -p 16`
> [ 1789.338622] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> [ 1789.338842] IP: [<c1263048>] xfs_ail_check+0x58/0xc0

Hmmm - xfs_ail_check()is
checking the LSN ordering of the items on the AIL, and it's crashed
trying to dereference one of the list pointers on the current log
item.


> [ 1789.339042]  [<c12630c3>] xfs_ail_delete+0x13/0x60
> [ 1789.339042]  [<c1263d1d>] xfs_trans_ail_update_bulk+0xad/0x3c0
> [ 1789.339042]  [<c11fbd35>] xfs_trans_committed_bulk+0x255/0x300
> [ 1789.339042]  [<c125dcac>] xlog_cil_committed+0x3c/0x160

And given that it is doing an update, I suspect a problem with
the XFS_LI_IN_AIL flag - that the item is not of the AIL, but has
that flag set.

Can you enable the xfs_ail* tracepoints, set
/proc/sys/kernel/ftrace_dump_on_oops and rerun the test? That should
dump the trace buffer into the kernel dmesg output showing AIL
operations just before the crash occurs. That might tell us what has
happened here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
