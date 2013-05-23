Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F22CA7F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 18:42:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7FDAAAC001
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 16:42:18 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aOYspK0dqnUJBNJE for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 16:42:16 -0700 (PDT)
Date: Fri, 24 May 2013 09:42:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with &log->l_cilp->xc_ctx_lock semaphone
Message-ID: <20130523234214.GG24543@dastard>
References: <1369264363.10223.2994.camel@chandra-dt.ibm.com>
	<20130522234129.GN29466@dastard>
	<1369332542.10223.5271.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369332542.10223.5271.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Thu, May 23, 2013 at 01:09:02PM -0500, Chandra Seetharaman wrote:
> On Thu, 2013-05-23 at 09:41 +1000, Dave Chinner wrote:
> > On Wed, May 22, 2013 at 06:12:43PM -0500, Chandra Seetharaman wrote:
> > > Hello,
> > > 
> > > While testing and rearranging my pquota/gquota code, I stumbled on a
> > > xfs_shutdown() during a mount. But the mount just hung.
> > > 
> > > I debugged and found that it is in a code path where
> > > &log->l_cilp->xc_ctx_lock is first acquired in read mode and some levels
> > > down the same semaphore is being acquired in write mode causing a
> > > deadlock.
> > > 
> > > This is the stack:
> > > xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
> > >   xlog_print_tic_res
> > >     xfs_force_shutdown
> > >       xfs_log_force_umount
> > >         xlog_cil_force
> > >           xlog_cil_force_lsn
> > >             xlog_cil_push_foreground
> > >               xlog_cil_push - tries to acquire same semaphore in write mode
> > 
> > Which means you had a transaction reservation overrun. Is it
> > reproducable? iDo you have the output from xlog_print_tic_res()?
> > Because:
> 
> Here it is:
> 
> May 23 10:48:52 test46 kernel: [   77.500728] XFS (sdh8): xlog_write: reservation summary:
> May 23 10:48:52 test46 kernel: [   77.500728]   trans type  = QM_SBCHANGE (26)
> May 23 10:48:52 test46 kernel: [   77.500728]   unit res    = 2740 bytes
> May 23 10:48:52 test46 kernel: [   77.500728]   current res = -48 bytes
> May 23 10:48:52 test46 kernel: [   77.500728]   total reg   = 0 bytes (o/flow = 0 bytes)
> May 23 10:48:52 test46 kernel: [   77.500728]   ophdrs      = 0 (ophdr space = 0 bytes)
> May 23 10:48:52 test46 kernel: [   77.500728]   ophdr + reg = 0 bytes
> May 23 10:48:52 test46 kernel: [   77.500728]   num regions = 0
> May 23 10:48:52 test46 kernel: [   77.500728]
> 
> Yes. I can readily reproduce the problem, but it is with my mangled up
> patchsets :). There is a small change that makes this problem reproduce
> consistently.

Interesting. That implies that the CIL stole the reservation for the
checkpoint headers from this reservation, and then it overran by 48
bytes. An increase in the number of quotas should not affect this.

What is the xfs_info output on the filesystem that is triggering
this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
