Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Aug 2006 14:18:49 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7NLIWDW024689
	for <linux-xfs@oss.sgi.com>; Wed, 23 Aug 2006 14:18:33 -0700
Received: from e3.ny.us.ibm.com ([192.168.1.103])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7NJAdkg006818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Wed, 23 Aug 2006 15:10:52 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e3.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7NJAJtt003942
	for <linux-xfs@oss.sgi.com>; Wed, 23 Aug 2006 15:10:19 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7NJ9YHP250018
	for <linux-xfs@oss.sgi.com>; Wed, 23 Aug 2006 13:09:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7NJ9Ypn008122
	for <linux-xfs@oss.sgi.com>; Wed, 23 Aug 2006 13:09:34 -0600
Subject: Re: Infinite loop in xfssyncd on full file system
From: Luciano Chavez <lnx1138@us.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
References: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal>
	 <20060823040218.GC807872@melbourne.sgi.com>
	 <20060823044829.GD807872@melbourne.sgi.com>
	 <Pine.LNX.4.64.0608231056370.3139@madrid.max-t.internal>
Content-Type: text/plain
Date: Wed, 23 Aug 2006 14:10:59 -0500
Message-Id: <1156360259.5368.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: David Chinner <dgc@sgi.com>, linux-xfs@oss.sgi.com

On Wed, 2006-08-23 at 11:00 -0400, Stephane Doyon wrote:
> On Wed, 23 Aug 2006, David Chinner wrote:
> 
> > On Wed, Aug 23, 2006 at 02:02:18PM +1000, David Chinner wrote:
> >> On Tue, Aug 22, 2006 at 04:01:10PM -0400, Stephane Doyon wrote:
> >>> I'm seeing what appears to be an infinite loop in xfssyncd. It is
> >>> triggered when writing to a file system that is full or nearly full. I
> >>> have pinpointed the change that introduced this problem: it's
> >>>
> >>>     "TAKE 947395 - Fixing potential deadlock in space allocation and
> >>>     freeing due to ENOSPC"
> >>>
> >>> git commit d210a28cd851082cec9b282443f8cc0e6fc09830.
> >>
> >> Thanks for tracking that down - I've been trying to isolate a test case
> >> for another report of this looping in xfssyncd.
> >>
> >> [Luciano - this is the same problem we've been trying to track down.]
> >>
> >>> I hope you XFS experts see what might be wrong with that bug fix. It's
> >>> ironic but for me, this (apparent) infinite loop seems much easier to hit
> >>> than the out-of-order locking problem that the commit in question was
> >>> supposed to fix. Let me know if I can get you any more info.
> >>
> >> Now we know what patch introduces the problem, we know where to look.
> >> Stay tuned...
> >
> > I've had a quick look at the above commit. I'm not yet certain that
> > everything is correct in terms of the semantics laid down in the
> > change or that enough blocks are reserved for btree splits , but I
> 
> I actually tried, naively, to bump up SET_ASIDE_BLOCKS from 8 to 32. I 
> won't claim to understand half of what's going on but I wondered whether 
> that might make the problem noticeably harder to reproduce at least, but 
> it had no effect ;-).
> 
> > can see a hole in the implementation on multiprocessor machines.
> >
> > Stephane/Luciano - can you test the following patch (note: compile
> > tested only) and see if it fixes the problem?
> 
> I just tried it, unfortunately no effect. Stil went into a loop, on the 
> second attempt.
> 

Yes, unfortunetly it had no effect here either.

> Thanks
> 
-- 
Luciano Chavez <lnx1138@us.ibm.com>
IBM
