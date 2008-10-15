Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 17:57:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F0uxPB030105
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 17:57:00 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86F4EA8BB5C
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 17:58:41 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id wnHj9Jvl4GpCaMve for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 17:58:41 -0700 (PDT)
Date: Wed, 15 Oct 2008 11:54:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fw: [PATCH] fix instant oops with tracing enabled
Message-ID: <20081015005441.GR10716@disturbed>
References: <20081013223932.GE10716@disturbed> <48F3EA6F.9000209@sgi.com> <20081014131140.GB17351@lst.de> <48F546ED.6050702@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F546ED.6050702@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Mark Goodwin <markgw@sgi.com>, xfs@oss.sgi.com

On Wed, Oct 15, 2008 at 11:27:09AM +1000, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
>> On Tue, Oct 14, 2008 at 10:40:15AM +1000, Mark Goodwin wrote:
>>> Lachlan also saw some regressions after merging these patchsets :
>>> . replace the mount inode list with radix tree traversals
>>> . clean up sync code
>>
>> What exactly?  I saw some softlookup in 042, but when applying Dave's
>> xfs_sync_inodeS_ag fix (or the hal of it applying without the del inodes
>> tracking in the radix tree) it goes away.
>
> I saw this panic but I don't think it's related to the above patches:
>
> [252921.307588] BUG: unable to handle kernel <3>BUG: scheduling while atomic: dd/16976/0xf101da90

Isn't there another line with this ouutput that looks like:

	atomic = 1 in_interrupt = 0

To indicate the "atomic" reason?

> [252921.307908] Modules linked in:
> [252921.307911] Pid: 16976, comm: dd Not tainted 2.6.27-rc8 #183
> [252921.307913] [252921.307913] Call Trace:

[ snip exceedingly deep stack that'll blow a 4k ia32 stack
completely ]

In summary, the stack is:

	write
	  balance_dirty_pages
	    xfs_iomap_write_allocate
	      <enter memory reclaim>
	      try_to_free_pages
	        xfs_iomap_write_allocate
		   _xfs_trans_commit
		     xlog_write
		       xlog_state_get_iclog_space
		         <sleep>

The question is what is the reason for running in atomic mode?
The only place I can see a sleep happening in this function is
the call to sv_wait(), which means the atomic state must have come
from higher up.... Seems very strange.

> I saw sync get stuck in an infinite loop running test 042 - maybe the same
> problem you saw.

Yes, that's the lockup that the later patch I posted fixes.

> I saw the panic in _xfs_itrace_exit() which has now been fixed.
>
> And I also saw this assertion:
>
> <4>[34770.626472] Assertion failed: (index >= 0) && (index < ktp->kt_nentries), file: fs/xfs/support/ktrace.c, line: 173
> <0>[34770.626511] ------------[ cut here ]------------
> <2>[34770.627419] kernel BUG at fs/xfs/support/debug.c:81!

I can't see how that is related to the changes - it's a trace
buffer index overrun. That kind of implies that the ktrace_t
has been corrupted. Memory corruption of some kind?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
